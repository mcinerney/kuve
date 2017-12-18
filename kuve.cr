require "json"

# Have a command for a namespace
# Have a command for a project (eg kubectl get pods --all-namespaces)
# kubectl get events --namespace=balh

class Runner
  def initialize
    @data = Array(String).new
  end

  def contexts
    # [
    #   "gcloud container clusters get-credentials poc-environment --zone us-west1-a --project poc-tier1",
    #   "gcloud container clusters get-credentials integration-environment --zone us-west1-a --project integration-tier1",
    #   "gcloud container clusters get-credentials staging-environment --zone us-west1-a --project staging-tier1",
    #   "gcloud container clusters get-credentials sandbox-environment --zone us-west1-b --project sandbox-tier1",
    #   "gcloud container clusters get-credentials performance-environment --zone us-west1-a --project performance-tier1",
    #   "gcloud container clusters get-credentials production-environment --zone us-west1-a --project production-tier1",
    # ]

    # If no context flag is supplied just use default
    JSON.parse(File.open("/usr/local/bin/kuve_conf"))["contexts"]["default"]
  end

  def get_deployed_sha
    deployment_json = `kubectl get deployment -o=json #{namespace}`
    deployment = JSON.parse(deployment_json)
    deployment["items"].first["spec"]["template"]["spec"]["containers"].first["image"]
  end

  def get_events
    deployment_json = `kubectl get events -o=json #{namespace}`
    deployment = JSON.parse(deployment_json)
    deployment["items"].each do |item|
      if item["type"] == "Warning" || item["type"] == "Error"
        puts "!!!!!!!!  #{item["type"]} EVENT !!!!!!!!"
        puts "Count: #{item["count"]}"
        puts "Message: #{item["message"]}"
        puts "Source: #{item["source"]["component"]}"
        puts ""
      end
    end
  end

  def get_all_pods_all_namespaces_all_envs
    contexts.each do |con|
      `#{con} 2>&1 > /dev/null`
      puts "---------------------------------------------- #{get_deployed_sha} ----------------------------------------------"
      puts ""
      system "kubectl get pods -o wide #{namespace}"
      @data << "#{get_deployed_sha.to_s.split(":").last}"
      puts ""
      puts ""
      get_events
      puts ""
      puts ""
    end

    puts @data
  end

  def namespace
    "--namespace=#{ARGV[0]}"
  end
end

run = Runner.new
run.get_all_pods_all_namespaces_all_envs

class Namespace
  def initialize
    @data = Array(String).new
  end

  def contexts
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

class Namespace
  def initialize
    @data = Array(String).new
  end

  def contexts
    # If no context flag is supplied just use default
    JSON.parse(File.open("/usr/local/bin/kuve_conf"))["contexts"]["default"]
  end

  def rawcontexts
    # If no context flag is supplied just use default
    JSON.parse(File.open("/usr/local/bin/kuve_conf"))["rawcontexts"]["default"]
  end

  def get_deployed_sha(context)
    deployment_json = `kubectl get deployment -o=json #{namespace} --context=#{context}`
    deployment = JSON.parse(deployment_json)
    deployment["items"].first["spec"]["template"]["spec"]["containers"].first["image"]
  end

  def get_events(context)
    deployment_json = `kubectl get events -o=json #{namespace} --context=#{context}`
    deployment = JSON.parse(deployment_json)
    str = String.build do |str|
      deployment["items"].each do |item|
        if item["type"] == "Warning" || item["type"] == "Error"
          str << "!!!!!!!!  #{item["type"]} EVENT !!!!!!!!\n"
          str << "Count: #{item["count"]}\n"
          str << "Message: #{item["message"]}\n"
          str << "Source: #{item["source"]["component"]}\n"
          str << "\n"
        end
      end
    end

    str
  end

  def get_all_pods_all_namespaces_all_envs
    channel = Channel(String).new

    rawcontexts.each do |ctx|
      spawn do
        str = String.build do |str|
          str << "---------------------------------------------- #{get_deployed_sha ctx} ----------------------------------------------\n\n"

          output = IO::Memory.new
          Process.run "kubectl",
            ["get", "pods", "-o", "wide", "#{namespace}", "--context", "#{ctx}"], output: output
          output.close
          str << output.to_s

          @data << "#{get_deployed_sha(ctx).to_s.split(":").last}"
          str << "\n\n"
          str << get_events ctx
          str << "\n\n"
        end

        # send the results async to the receiver below
        channel.send str
      end
    end

    # as each sub-task completes, output its results
    contexts.each do
      puts channel.receive
    end

    puts @data
  end

  def namespace
    "--namespace=#{ARGV[0]}"
  end
end

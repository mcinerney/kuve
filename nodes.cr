class Nodes
  def initialize
    @data = Array(String).new
  end

  def contexts
    # If no context flag is supplied just use default
    JSON.parse(File.open("/usr/local/bin/kuve_conf.json"))["contexts"]["default"]
  end

  def get_project_name(con)
    con.to_s.split(" ").last
  end

  def get_all_nodes
    contexts.each do |con|
      `#{con} 2>&1 > /dev/null`
      puts "Checking Nodes in: #{get_project_name(con)}"
      nodes_data = `kubectl get nodes -o=json`
      nodes = JSON.parse(nodes_data)
      nodes["items"].each do |node|
        get_node_conditions(node)
      end
    end
  end

  def get_node_conditions(node)
    node_name = node["metadata"]["name"]
    node["status"]["conditions"].each do |c|
      if c["type"] == "KernelDeadlock" && c["status"] != "False"
        puts "POSSIBLE ISSUE: KernelDeadlock on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      elsif c["type"] == "NetworkUnavailable" && c["status"] != "False"
        puts "POSSIBLE ISSUE: NetworkUnavailable on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      elsif c["type"] == "OutOfDisk" && c["status"] != "False"
        puts "POSSIBLE ISSUE: OutOfDisk on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      elsif c["type"] == "MemoryPressure" && c["status"] != "False"
        puts "POSSIBLE ISSUE: MemoryPressure on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      elsif c["type"] == "DiskPressure" && c["status"] != "False"
        puts "POSSIBLE ISSUE: DiskPressure on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      elsif c["type"] == "KubeletReady" && c["status"] != "True"
        puts "POSSIBLE ISSUE: KubeletReady on #{node_name}"
        puts "$ kubectl describe node #{node_name}"
      end
    end
  end
end

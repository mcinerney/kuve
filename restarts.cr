class Restarts
  def initialize
    @data = Array(String).new
  end

  def contexts
    # If no context flag is supplied just use default
    JSON.parse(File.open("/usr/local/bin/kuve_conf"))["contexts"]["default"]
  end

  def get_project_name(con)
    con.to_s.split(" ").last
  end

  def show_all_restarts
    contexts.each do |con|
      `#{con} 2>&1 > /dev/null`
      puts "---------------------------- Checking Restarts in: #{get_project_name(con)} ----------------------------"
      puts ""
      all_data = `kubectl get pods --all-namespaces -o=json`
      data = JSON.parse(all_data)
      app_data = get_app_restarts(data)
      node_data = get_node_restarts(data)
      print_all_node_data(node_data)
      print_all_app_data(app_data)
    end
  end

  def get_node_restarts(data)
    node_to_restarts = Hash(String, Int32).new
    data["items"].each do |app|
      node = app["spec"]["nodeName"]
      if node_to_restarts[node.to_s]?
        old = node_to_restarts[node.to_s]

        pro_new = app["status"]["containerStatuses"].first["restartCount"].to_s.to_i
        new_value = pro_new + old

        node_to_restarts[node.to_s] = new_value
      else
        # Will need to make sure the container is the app, not cloudsql
        node_to_restarts[node.to_s] = app["status"]["containerStatuses"].first["restartCount"].to_s.to_i
      end
    end

    node_to_restarts.to_a.sort_by { |(x, y)| y }[-6..-1].reverse
  end

  def get_app_restarts(data)
    app_to_restarts = Hash(String, Int32).new
    data["items"].each do |app|
      namespace = app["metadata"]["namespace"]
      if app_to_restarts[namespace.to_s]?
        old = app_to_restarts[namespace.to_s]

        pro_new = app["status"]["containerStatuses"].first["restartCount"].to_s.to_i
        new_value = pro_new + old

        app_to_restarts[namespace.to_s] = new_value
      else
        # Will need to make sure the container is the app, not cloudsql
        app_to_restarts[namespace.to_s] = app["status"]["containerStatuses"].first["restartCount"].to_s.to_i
      end
    end

    app_to_restarts.to_a.sort_by { |(x, y)| y }[-6..-1].reverse
  end

  def print_all_app_data(app_data)
    app_data.map_with_index do |data, i|
      puts "#{data[0]} - #{data[1]}"
    end
  end

  def print_all_node_data(node_data)
    node_data.map_with_index do |data, i|
      "%*s" % [10, "foo"]
      puts "#{data[0]} - #{data[1]}"
    end
  end
end

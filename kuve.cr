require "./namespaces.cr"
require "./restarts.cr"
require "./nodes.cr"
require "json"

# Have a command for a namespace
# Have a command for a project (eg kubectl get pods --all-namespaces)
# kubectl get events --namespace=balh

if ARGV[0] == "nodes"
  no = Nodes.new
  no.get_all_nodes
elsif ARGV[0] == "restarts"
  a = Restarts.new
  a.show_all_restarts
elsif ARGV[0] == "-h"
  puts "kuve <namespace> - shows all pods in a namespace for each project"
  puts "kuve restarts - shows node and app restarts per project"
  puts "kuve nodes - shows all warning and error messages for all nodes in a project"
else
  na = Namespace.new
  na.get_all_pods_all_namespaces_all_envs
end

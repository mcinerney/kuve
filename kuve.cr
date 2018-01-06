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
else
  na = Namespace.new
  na.get_all_pods_all_namespaces_all_envs
end

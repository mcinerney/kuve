require "./namespaces.cr"
require "./nodes.cr"
require "json"

# Have a command for a namespace
# Have a command for a project (eg kubectl get pods --all-namespaces)
# kubectl get events --namespace=balh

if ARGV[0] == "nodes"
  no = Nodes.new
  no.get_all_nodes
else
  na = Namespace.new
  na.get_all_pods_all_namespaces_all_envs
end

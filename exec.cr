class Exec
  def initialize(namespace : String)
    @namespace = namespace
  end

  def exec_into_pod
    pod_name = get_pod_name.chomp
    env = `kubectl config current-context`
    puts "###### Running the following command in  #{env.chomp}  ######"
    puts ""
    puts "$ kubectl exec -it #{pod_name} -n #{@namespace} -- /bin/bash"
    puts ""
    system("kubectl exec -it #{pod_name} -n #{@namespace} -- /bin/bash")
  end

  def get_pod_name
    `kubectl get pods -n #{@namespace} --no-headers | head -n1 | cut -d " " -f1`
  end
end

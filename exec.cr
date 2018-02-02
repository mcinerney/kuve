class Exec
  def initialize(namespace : String)
    @namespace = namespace
  end

  def exec_into_pod
    system("kubectl exec -it #{get_pod_name.chomp} -n #{@namespace} -- /bin/bash")
  end

  def get_pod_name
    `kubectl get pods -n #{@namespace} --no-headers | head -n1 | cut -d " " -f1`
  end
end

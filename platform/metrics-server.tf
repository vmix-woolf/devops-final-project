resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.13.0"

  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 600

  values = [
    yamlencode({
      replicas = 2

      podDisruptionBudget = {
        enabled      = true
        minAvailable = 1
      }

      resources = {
        requests = {
          cpu    = "50m"
          memory = "100Mi"
        }
        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
      }
    })
  ]
}

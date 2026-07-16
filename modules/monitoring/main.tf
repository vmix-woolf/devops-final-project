resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-admin"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  type = "Opaque"

  data = {
    admin-user     = var.grafana_admin_user
    admin-password = var.grafana_admin_password
  }
}

resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  timeout = 1200
  wait    = true

  values = [
    templatefile("${path.module}/values.yaml", {
      grafana_admin_secret = kubernetes_secret.grafana_admin.metadata[0].name
      grafana_service_type = var.grafana_service_type
    })
  ]

  depends_on = [
    kubernetes_secret.grafana_admin
  ]
}

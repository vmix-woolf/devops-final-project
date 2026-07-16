variable "namespace" {
  description = "Kubernetes namespace for the monitoring stack."
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart."
  type        = string
}

variable "grafana_service_type" {
  description = "Kubernetes service type for Grafana."
  type        = string
  default     = "ClusterIP"
}

variable "grafana_admin_user" {
  description = "Grafana administrator username."
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana administrator password."
  type        = string
  sensitive   = true
}

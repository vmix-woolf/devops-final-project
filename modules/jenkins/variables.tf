variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
}

variable "admin_user" {
  description = "Jenkins admin username"
  type        = string
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "github_ssh_private_key" {
  description = "SSH private key used by Jenkins to access GitHub"
  type        = string
  sensitive   = true
}

variable "service_type" {
  description = "Kubernetes service type for Jenkins controller"
  type        = string
  default     = "ClusterIP"
}

variable "storage_class" {
  description = "Storage class for Jenkins persistent volume"
  type        = string
  default     = "gp2"
}

variable "storage_size" {
  description = "Persistent volume size for Jenkins"
  type        = string
  default     = "8Gi"
}

variable "jenkins_url" {
  description = "Internal Jenkins URL for Kubernetes agents"
  type        = string
}

variable "ecr_repository" {
  description = "ECR repository URL for the Django application image"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "service_account_role_arn" {
  description = "IAM role ARN assumed by Jenkins Kubernetes agents through IRSA"
  type        = string
}

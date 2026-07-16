variable "aws_region" {
  description = "AWS region for platform resources."
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Existing EKS cluster name."
  type        = string
  default     = "devops-final-project-eks"
}

variable "eks_oidc_provider_arn" {
  description = "IAM OIDC provider ARN of the EKS cluster."
  type        = string
}

variable "ecr_repository_url" {
  description = "Existing ECR repository URL."
  type        = string
}

variable "ecr_repository_arn" {
  description = "Existing ECR repository ARN."
  type        = string
}

variable "github_ssh_private_key" {
  description = "SSH private key for GitHub repository access."
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Jenkins administrator password."
  type        = string
  sensitive   = true
}

variable "monitoring_chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart."
  type        = string
  default     = "87.15.1"
}

variable "grafana_admin_password" {
  description = "Grafana administrator password."
  type        = string
  sensitive   = true
}

variable "rds_endpoint" {
  description = "Private PostgreSQL endpoint."
  type        = string
}

variable "database_password" {
  description = "PostgreSQL password used by Django."
  type        = string
  sensitive   = true
}

variable "django_secret_key" {
  description = "Django cryptographic secret key."
  type        = string
  sensitive   = true
}

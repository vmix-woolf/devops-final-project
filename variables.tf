variable "project_name" {
  description = "Base name for project resources."
  type        = string
  default     = "devops-final-project"
}

variable "environment" {
  description = "Project environment name."
  type        = string
  default     = "final"
}

variable "aws_region" {
  description = "AWS region for project resources."
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "devops-final-project-eks"
}

variable "repository_name" {
  description = "ECR repository name."
  type        = string
  default     = "devops-final-project-ecr"
}

variable "database_name" {
  description = "Application database name."
  type        = string
  default     = "django_db"
}

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

variable "ecr_repository_url" {
  description = "Existing ECR repository URL."
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

variable "github_ssh_private_key" {
  description = "SSH private key for GitHub repository access"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Jenkins administrator password."
  type        = string
  sensitive   = true
}
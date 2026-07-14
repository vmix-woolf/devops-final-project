output "jenkins_namespace" {
  description = "Jenkins namespace."
  value       = module.jenkins.namespace
}

output "jenkins_release_name" {
  description = "Jenkins Helm release name."
  value       = module.jenkins.release_name
}

output "jenkins_admin_user" {
  description = "Jenkins administrator username."
  value       = module.jenkins.admin_user
}

output "jenkins_admin_password" {
  description = "Jenkins administrator password."
  value       = module.jenkins.admin_password
  sensitive   = true
}

output "argocd_namespace" {
  description = "Argo CD namespace."
  value       = module.argo_cd.namespace
}

output "argocd_release_name" {
  description = "Argo CD Helm release name."
  value       = module.argo_cd.release_name
}

output "argocd_server_service_name" {
  description = "Argo CD server service name."
  value       = module.argo_cd.server_service_name
}

module "jenkins" {
  source = "../modules/jenkins"

  namespace      = "jenkins"
  chart_version  = "5.9.32"
  admin_user     = "admin"
  admin_password = var.jenkins_admin_password
  service_type   = "ClusterIP"
  storage_class  = "gp2"
  storage_size   = "8Gi"
  jenkins_url    = "http://jenkins.jenkins.svc.cluster.local:8080"
  ecr_repository = var.ecr_repository_url
  aws_region     = var.aws_region
}

module "argo_cd" {
  source = "../modules/argo_cd"

  namespace              = "argocd"
  chart_version          = "8.3.5"
  service_type           = "ClusterIP"
  repository_url         = "git@github.com:vmix-woolf/devops-final-project.git"
  repository_private_key = var.github_ssh_private_key
  target_revision        = "final-project"
  app_chart_path         = "charts/django-app"
  app_namespace          = "django-app"
}

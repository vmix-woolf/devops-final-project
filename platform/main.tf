locals {
  eks_oidc_issuer = replace(
    data.aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}

resource "aws_iam_role" "jenkins_ecr" {
  name = "devops-final-project-jenkins-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = var.eks_oidc_provider_arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${local.eks_oidc_issuer}:aud" = "sts.amazonaws.com"
            "${local.eks_oidc_issuer}:sub" = "system:serviceaccount:jenkins:jenkins"
          }
        }
      }
    ]
  })

  tags = {
    Environment = "final"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "jenkins_ecr" {
  name        = "devops-final-project-jenkins-ecr-policy"
  description = "Allow Jenkins agents to push images only to the project ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECRAuthorization"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "PushProjectImages"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = var.ecr_repository_arn
      }
    ]
  })

  tags = {
    Environment = "final"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_ecr.name
  policy_arn = aws_iam_policy.jenkins_ecr.arn
}

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

  github_ssh_private_key = var.github_ssh_private_key

  service_account_role_arn = aws_iam_role.jenkins_ecr.arn

  depends_on = [
    aws_iam_role_policy_attachment.jenkins_ecr
  ]
}

resource "kubernetes_secret" "django_app" {
  metadata {
    name      = "django-app-secret"
    namespace = "django-app"
  }

  type = "Opaque"

  data = {
    DJANGO_SECRET_KEY = var.django_secret_key
    POSTGRES_PASSWORD = var.database_password
  }

  depends_on = [
    module.argo_cd
  ]
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
  image_repository       = var.ecr_repository_url
  postgres_host          = var.rds_endpoint
}

module "monitoring" {
  source = "../modules/monitoring"

  namespace              = "monitoring"
  chart_version          = var.monitoring_chart_version
  grafana_service_type   = "ClusterIP"
  grafana_admin_user     = "admin"
  grafana_admin_password = var.grafana_admin_password
}

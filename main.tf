terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster" "main" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}

module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name = "terraform-state-devops-final-project-vmix-woolf-20260714"
  table_name  = "terraform-locks-devops-final-project"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]

  availability_zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c"
  ]

  vpc_name     = "devops-final-project-vpc"
  cluster_name = "devops-final-project-eks"
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name        = "devops-final-project-ecr"
  scan_on_push    = true
  encryption_type = "AES256"
  kms_key_arn     = null
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "devops-final-project-eks"
  node_group_name = "devops-final-project-node-group"

  subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 2
  node_max_size       = 6
}

module "jenkins" {
  source = "./modules/jenkins"

  namespace      = "jenkins"
  chart_version  = "5.9.32"
  admin_user     = "admin"
  admin_password = var.jenkins_admin_password
  service_type   = "LoadBalancer"
  storage_class  = "gp2"
  storage_size   = "8Gi"
  jenkins_url    = "http://jenkins.jenkins.svc.cluster.local:8080"
  ecr_repository = module.ecr.repository_url
  aws_region     = "us-west-2"

  depends_on = [
    module.eks
  ]
}

module "argo_cd" {
  source = "./modules/argo_cd"

  namespace              = "argocd"
  chart_version          = "8.3.5"
  service_type           = "LoadBalancer"
  repository_url         = "git@github.com:vmix-woolf/devops-final-project.git"
  target_revision        = "final-project"
  repository_private_key = var.github_ssh_private_key
  app_chart_path         = "charts/django-app"
  app_namespace          = "django-app"

  depends_on = [
    module.eks
  ]
}
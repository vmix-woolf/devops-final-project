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

  vpc_name     = "${var.project_name}-vpc"
  cluster_name = var.cluster_name
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name        = var.repository_name
  scan_on_push    = true
  encryption_type = "AES256"
  kms_key_arn     = null
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  node_group_name = "${var.project_name}-node-group"

  subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 2
  node_max_size       = 6
}

module "rds" {
  source = "./modules/rds"

  name       = "${var.project_name}-db"
  use_aurora = false

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  database_name = var.database_name
  username      = var.database_username
  password      = var.database_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_cidr_blocks = []

  allowed_security_group_ids = [
    module.eks.cluster_security_group_id
  ]

  db_port           = 5432
  allocated_storage = 20
  storage_type      = "gp3"
  multi_az          = false

  publicly_accessible     = false
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

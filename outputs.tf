output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "eks_cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_group_name" {
  description = "Name of the EKS managed node group"
  value       = module.eks.node_group_name
}

output "eks_cluster_certificate_authority_data" {
  description = "Certificate authority data of the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider"
  value       = module.eks.oidc_provider_arn
}

output "eks_ebs_csi_role_arn" {
  description = "IAM role ARN used by the EBS CSI Driver"
  value       = module.eks.ebs_csi_role_arn
}

output "eks_ebs_csi_addon_name" {
  description = "Name of the EBS CSI Driver add-on"
  value       = module.eks.ebs_csi_addon_name
}

output "rds_endpoint" {
  description = "Private PostgreSQL endpoint"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "PostgreSQL port"
  value       = module.rds.port
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = module.rds.db_identifier
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = module.rds.security_group_id
}

output "rds_subnet_group_name" {
  description = "RDS subnet group name"
  value       = module.rds.subnet_group_name
}

output "rds_parameter_group_name" {
  description = "RDS parameter group name"
  value       = module.rds.parameter_group_name
}

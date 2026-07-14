output "s3_bucket_name" {
  description = "S3 bucket used for Terraform remote state."
  value       = module.s3_backend.s3_bucket_name
}

output "s3_bucket_url" {
  description = "S3 URL of the Terraform remote state bucket."
  value       = module.s3_backend.s3_bucket_url
}

output "dynamodb_table_name" {
  description = "DynamoDB table created for Terraform state locking."
  value       = module.s3_backend.dynamodb_table_name
}

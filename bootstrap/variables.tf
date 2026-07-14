variable "aws_region" {
  description = "AWS region for Terraform backend resources."
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "S3 bucket name for Terraform remote state."
  type        = string
  default     = "terraform-state-devops-final-project-vmix-woolf-20260714"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
  default     = "terraform-locks-devops-final-project"
}

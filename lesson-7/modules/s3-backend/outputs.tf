# lesson-7/modules/s3-backend/outputs.tf

output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = aws_s3_bucket.terraform_state.bucket # s3_backend.s3_bucket_name - було
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = aws_dynamodb_table.terraform_locks.name # s3_backend.dynamodb_table_name
}


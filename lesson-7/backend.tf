# # /lesson-7/backend.tf

# terraform {
#   backend "s3" {
#     bucket         = "lesson-7-helm-state-bucket-001001"# Назва S3-бакета
#     key            = "lesson-7/terraform.tfstate"   # Шлях до файлу стейту
#     region         = "eu-west-1"                    # Регіон AWS
#     dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB
#     encrypt        = true                           # Шифрування файлу стейту
#   }
# }

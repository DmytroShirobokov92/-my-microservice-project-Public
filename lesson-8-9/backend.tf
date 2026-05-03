# # /lesson-8-9/backend.tf

# terraform {
#   backend "s3" {
#     bucket         = "lesson-8-9-jenkins-argo-cd-state-bucket-001001"# Назва S3-бакета
#     key            = "lesson-8-9/terraform.tfstate"   # Шлях до файлу стейту
#     region         = "eu-west-1"                    # Регіон AWS
#     dynamodb_table = "terraform-locks-jenkins-argo-cd"      # Назва таблиці DynamoDB
#     encrypt        = true                           # Шифрування файлу стейту
#   }
# }

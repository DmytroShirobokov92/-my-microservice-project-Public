# # /lesson-db-module/backend.tf

# terraform {
#   backend "s3" {
#     bucket         = "lesson-db-module-state-bucket-001001"  # Назва S3-бакета
#     key            = "lesson-db-module/terraform.tfstate"    # Шлях до файлу стейту
#     region         = "eu-west-1"                             # Регіон AWS
#     dynamodb_table = "terraform-locks-lesson-db-module"      # Назва таблиці DynamoDB
#     encrypt        = true                                    # Шифрування файлу стейту
#   }
# }

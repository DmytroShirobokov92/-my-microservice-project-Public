# /final/backend.tf

terraform {
  backend "s3" {
    bucket         = "final-state-bucket-001001"  # Назва S3-бакета
    key            = "final/terraform.tfstate"    # Шлях до файлу стейту
    region         = "eu-west-1"                             # Регіон AWS
    dynamodb_table = "terraform-locks-final"      # Назва таблиці DynamoDB
    encrypt        = true                                    # Шифрування файлу стейту
  }
}

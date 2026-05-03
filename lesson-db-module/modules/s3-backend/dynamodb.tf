# lesson-db-module/modules/s3-backend/dynamodb.tf

# Створюємо DynamoDB-таблицю для блокування стейтів
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"  # збереження блокування

  attribute {
    name = "LockID" # ключ
    type = "S" # означає string"
  }

  tags = {     # теги для ідентифікації
    Name        = "Terraform Lock Table"
    Environment = "lesson-db-module"
  }
}


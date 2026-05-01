# # /lesson-5/backend.tf

# terraform {
#   backend "s3" {
#     bucket         = "petro-davydov-terraform-state-bucket-001001"# Назва S3-бакета
#     key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
#     region         = "eu-west-1"                    # Регіон AWS
#     dynamodb_table = "terraform-locks"              # Назва таблиці DynamoDB
#     encrypt        = true                           # Шифрування файлу стейту
#   }
# }



# # dynamodb_table = "terraform-locks" - визначено як застаріла "команда", бажано використовувати use_lockfile = true, при використанні terraform apply "tfplan"
# # а також простіше відпрацьовує при команді terraform destroy, що не втручатися у ручному режимі
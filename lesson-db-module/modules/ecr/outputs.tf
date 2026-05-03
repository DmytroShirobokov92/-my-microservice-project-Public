# lesson-db-module/modules/ecr/outputs.tf

output "repository_url" {
    description = "URL of the ECR repository for Docker images"
    value       = aws_ecr_repository.my_ecr_repo_lesson_db_module.repository_url
}  


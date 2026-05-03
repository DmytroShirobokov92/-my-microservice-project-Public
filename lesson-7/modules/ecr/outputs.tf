# lesson-7/modules/ecr/outputs.tf

output "repository_url" {
    description = "URL of the ECR repository for Docker images"
    value       = aws_ecr_repository.my_ecr_repo_helm.repository_url
}  


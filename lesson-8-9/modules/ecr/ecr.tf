# lesson-8-9/modules/ecr/ecr.tf

# data-ресурс для отримання account_id
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "my_ecr_repo_jenkins_argo_cd" {
    name                 = var.ecr_name
    
    image_scanning_configuration {
      scan_on_push = var.scan_on_push
    }

    tags = {
      Name = var.ecr_name
      Environment = "lesson-8-9-jenkins-argo-cd"
    }
  
}


resource "aws_ecr_repository_policy" "my_ecr_repo_jenkins_argo_cd" {
    repository = aws_ecr_repository.my_ecr_repo_jenkins_argo_cd.name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowPushPull"
                Effect = "Allow"
                Principal = {
                    AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                    }
                Action = [
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:PutImage",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload",
                    "ecr:DescribeRepositories",
                    "ecr:GetRepositoryPolicy",
                    "ecr:ListImages",
                    "ecr:DeleteRepository",
                    # "ecr:SetRepositoryPolicy"
                ]
            }
        ]
    })
}
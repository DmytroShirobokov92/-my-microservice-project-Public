# final/modules/ecr/ecr.tf

# data-ресурс для отримання account_id
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "my_ecr_repo_final" {
    name                 = var.ecr_name
    force_delete = true
    
    image_scanning_configuration {
      scan_on_push = var.scan_on_push
    }

    tags = {
      Name = var.ecr_name
      Environment = "final"
    }
  
}


resource "aws_ecr_repository_policy" "my_ecr_repo_final" {
    repository = aws_ecr_repository.my_ecr_repo_final.name

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
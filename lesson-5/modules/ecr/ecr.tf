# lesson-5/modules/ecr/ecr.tf
resource "aws_ecr_repository" "my_ecr_repo" {
    name                 = var.ecr_name
    
    image_scanning_configuration {
      scan_on_push = var.scan_on_push
    }

    tags = {
      Name = var.ecr_name
      Environment = "lesson-5"
    }
  
}


resource "aws_ecr_repository_policy" "this" {
    repository = aws_ecr_repository.this.name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowPushPull"
                Effect = "Allow"
                Principal = "*"
                Action = [
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:PutImage",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload"
                ]
            }
        ]
    })
}
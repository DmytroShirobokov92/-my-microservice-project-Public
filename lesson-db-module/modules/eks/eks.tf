# lesson-db-module/modules/eks/eks.tf

# IAM-роль для EKS-кластера
resource "aws_iam_role" "eks" {
# Ім'я IAM-ролі для кластера EKS
  name = "${var.cluster_name}-eks-role"

# Політика, яка дозволяє сервісу EKS «асумувати» цю IAM-роль
# Дозволяє AssumeRole (використання ролі):"Action"
# Дозволено для сервісу EKS: "Service"
# Також додано політику для автоматичного видалення ролей при terraform destroy
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY

  force_detach_policies = true

  lifecycle {
    prevent_destroy = false
  }

}

# Прив'язка IAM-ролі до політики AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks" {
  # ARN політики, що надає дозволи для EKS-кластера
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

# IAM-роль, до якої прив'язується політика
  role = aws_iam_role.eks.name
}

# Створення EKS-кластера
resource "aws_eks_cluster" "eks" {
# Назва кластера
  name     = var.cluster_name

# ARN IAM-ролі, яка потрібна для керування кластером
  role_arn = aws_iam_role.eks.arn
  
# Налаштування мережі (VPC)
  vpc_config {
    endpoint_private_access = true   # Включає приватний доступ до API-сервера
    endpoint_public_access  = true   # Включає публічний доступ до API-сервера
    subnet_ids = var.subnet_ids      # Список підмереж, де буде працювати EKS
  }

# Налаштування доступу до EKS-кластера
  access_config {
    authentication_mode                         = "API"  # Автентифікація через API
    bootstrap_cluster_creator_admin_permissions = true   # Надає адміністративні права користувачу, який створив кластер
  }

# Залежність від IAM-політики для ролі EKS
  depends_on = [
    aws_iam_role_policy_attachment.eks] # aws_eks_node_group - це прибрано для уникненння циклічності

    # Дозволяє видаляти при terraform destroy
  lifecycle {
    prevent_destroy = false
  }
}

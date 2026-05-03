# lesson-8-9/main.tf
# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend/"                      # Шлях до модуля
  bucket_name = "lesson-8-9-jenkins-argo-cd-state-bucket-001001"  # Ім'я S3-бакета
  table_name  = "terraform-locks-jenkins-argo-cd"               # Ім'я DynamoDB
}


# Підключаємо модуль для VPC
module "vpc" {
  source              = "./modules/vpc"           # Шлях до модуля VPC
  vpc_cidr_block      = "10.0.0.0/16"             # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]         # Публічні підмережі
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # Приватні підмережі
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]            # Зони доступності
  vpc_name            = "vpc-lesson-8-9-jenkins-argo-cd"                                # Ім'я VPC
}


# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-8-9-ecr-jenkins-argo-cd"
  scan_on_push = true
}

# Додаємо eks 
module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-lesson-8-9-jenkins-argo-cd" # Назва кластера
  subnet_ids      = module.vpc.private_subnets     # ID підмереж
  instance_type   = "t3.medium"                    # Тип інстансів
  desired_size    = 2                              # Бажана кількість нодів
  max_size        = 4                              # Максимальна кількість нодів
  min_size        = 1                              # Мінімальна кількість нодів
}

# підключаємо Jenkins

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
  depends_on = [ module.eks ] # додано для коректного відпрацювання
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
  depends_on = [ module.eks ] # додано для коректного відпрацювання
}
# ---------------1 варіант --
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# -------------------------2 варіант

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# -------------------------

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  # kubeconfig   = data.aws_eks_cluster.eks.endpoint # add fix with amazon AI
  kubeconfig   = "~/.kube/config" # add myself 

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  # Додано по рекомендації ШІ
  oidc_provider_url = module.eks.oidc_provider_url
  oidc_provider_arn = module.eks.oidc_provider_arn
}


# Підключаємо Argo CD

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
}

# final/main.tf

# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend/" # Шлях до модуля
  bucket_name = "final-state-bucket-001001" # Ім'я S3-бакета
  table_name  = "terraform-locks-final" # Ім'я DynamoDB
}


# Підключаємо модуль для VPC
module "vpc" {
  source = "./modules/vpc" # Шлях до модуля VPC
  vpc_cidr_block = "10.0.0.0/16" # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Публічні підмережі
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # Приватні підмережі
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"] # Зони доступності
  vpc_name = "vpc-final" # Ім'я VPC
}


# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "final"
  scan_on_push = true
}

# Додаємо eks 
module "eks" {
  source = "./modules/eks"          
  cluster_name = "eks-cluster-final" # Назва кластера
  subnet_ids = module.vpc.private_subnets # ID підмереж
  instance_type   = "t3.medium" # Тип інстансів
  desired_size    = 2 # Бажана кількість нодів
  max_size        = 4 # Максимальна кількість нодів
  min_size        = 1 # Мінімальна кількість нодів
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

  github_pat = var.github_pat
  jenkins_admin_user = var.jenkins_admin_user
  jenkins_admin_password = var.jenkins_admin_password

  # Додано по рекомендації ШІ
  oidc_provider_url = module.eks.oidc_provider_url
  oidc_provider_arn = module.eks.oidc_provider_arn
}


# Підключаємо Argo CD

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"

  db_host     = module.rds.aurora_endpoint
  db_name     = module.rds.db_name
  db_user     = module.rds.db_user
  db_password = module.rds.db_password

  django_image_repository = var.django_image_repository
}




# ПІДКЛЮЧАЄМО RDS

module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = true
  aurora_replica_count      = 2

    # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.12"
  parameter_group_family_aurora = "aurora-postgresql15"

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = var.rds_username
  password                   = var.rds_password
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false
  vpc_id                     = module.vpc.vpc_id
  rds_allowed_cidr_blocks    = ["10.0.0.0/16"]
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
} 

# -- Monitoring --

module "monitoring" {
  source = "./modules/monitoring"

  grafana_admin_password = var.grafana_admin_password
}
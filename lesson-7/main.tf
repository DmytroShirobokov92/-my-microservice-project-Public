# lesson-7/main.tf
# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend/"                # Шлях до модуля
  bucket_name = "lesson-7-helm-state-bucket-001001"  # Ім'я S3-бакета
  table_name  = "terraform-locks"                # Ім'я DynamoDB
}


# Підключаємо модуль для VPC
module "vpc" {
  source              = "./modules/vpc"           # Шлях до модуля VPC
  vpc_cidr_block      = "10.0.0.0/16"             # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]        # Публічні підмережі
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # Приватні підмережі
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]            # Зони доступності
  vpc_name            = "vpc-lesson-7-helm"              # Ім'я VPC
}


# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-7-ecr-helm"
  scan_on_push = true
}

# Додаємо eks 
module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-lesson-7-helm"        # Назва кластера
  subnet_ids      = module.vpc.private_subnets     # ID підмереж
  instance_type   = "t3.medium"                    # Тип інстансів
  desired_size    = 2                             # Бажана кількість нодів
  max_size        = 4                             # Максимальна кількість нодів
  min_size        = 2                             # Мінімальна кількість нодів
}
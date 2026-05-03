# final/modules/argo_cd/variables.tf

variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4" 
}


variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {
  sensitive = true
}

variable "django_image_repository" {
  description = "ECR repository for Django app"
  type        = string
}

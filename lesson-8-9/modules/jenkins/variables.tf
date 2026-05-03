# lesson-8-9/modules/jenkins/variables.tf

variable "kubeconfig" {
  description = "Шлях до kubeconfig файлу"
  type        = string
}

variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type = string
}

# додано по рекомендації ШІ для уникнення помилок що до змінних
# ---
variable "oidc_provider_arn" {
  description = "ARN провайдера OIDC для кластера EKS"
  type = string
}

variable "oidc_provider_url" {
  description = "URL провайдера OIDC  для кластера EKS"
  type = string
}
# ---

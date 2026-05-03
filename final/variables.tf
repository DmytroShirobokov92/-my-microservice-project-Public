# final/variables.tf

variable "django_image_repository" {
  description = "ECR repository for Django app"
  type        = string
}

variable "postgres_host" {
  description = "Aurora endpoint for Django"
  type        = string
}

variable "postgres_port" {
  description = "Postgres port"
  type        = string
  default     = "5432"
}

variable "postgres_user" {
  description = "Postgres username"
  type        = string
}

variable "postgres_db" {
  description = "Postgres database name"
  type        = string
}

variable "postgres_password" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}


variable "jenkins_admin_user" {
  description = "Jenkins admin username"
  type        = string
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}


variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "rds_username" {
  description = "Master username for RDS"
  type        = string
}

variable "rds_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}













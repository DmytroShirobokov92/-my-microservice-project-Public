# final/modules/ecr/variables.tf

variable "ecr_name" {
  description = "Name of ECR repository"
  type = string
}

variable "scan_on_push" {
    description = "Enable vulnerability scanning when images are pushed to the repository"
    type = bool
    default = true
}

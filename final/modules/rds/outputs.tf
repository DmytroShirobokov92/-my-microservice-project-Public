# final/modules/rds/outputs.tf

output "aurora_endpoint" {
  value = try(aws_rds_cluster.aurora[0].endpoint, "")
}

output "aurora_reader_endpoint" {
  value = try(aws_rds_cluster.aurora[0].reader_endpoint, "")
}

output "rds_endpoint" {
  value = try(aws_db_instance.standard[0].address, "")
}

output "db_name" {
  value = var.db_name
}


output "db_user" {
  value = var.username
}

output "db_password" {
  value = var.password
  sensitive = true
}

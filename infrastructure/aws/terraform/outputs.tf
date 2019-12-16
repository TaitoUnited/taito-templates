output "bastion_public_ip" {
  description = "Bastion public ip"
  value       = module.taito_zone.bastion_public_ip
}

output "postgres_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.taito_zone.postgres_instance_endpoint
}

output "mysql_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.taito_zone.mysql_instance_endpoint
}

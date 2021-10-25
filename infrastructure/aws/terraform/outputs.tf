output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.databases.postgres_instance_addresses
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.databases.mysql_instance_addresses
}

output "bastion_public_ip" {
  description = "Bastion public ip"
  value       = module.network.bastion_public_ip
}

output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.taito_zone.postgres_private_ip_addresses
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.taito_zone.mysql_private_ip_addresses
}

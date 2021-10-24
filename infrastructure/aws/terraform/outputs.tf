output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.databases.postgres_instance_endpoints
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.databases.mysql_instance_endpoints
}

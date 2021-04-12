# TODO: was private addresses!

output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.databases.postgresql_hosts
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.databases.mysql_hosts
}

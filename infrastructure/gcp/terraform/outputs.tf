output "taito_zone_id" {
  description = "Return GCP project number as zone id"
  value       = google_project.zone.number
}

output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.databases.postgres_private_ip_addresses
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.databases.mysql_private_ip_addresses
}

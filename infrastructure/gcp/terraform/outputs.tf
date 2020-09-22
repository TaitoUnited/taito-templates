output "taito_provider_taito_zone_id" {
  description = "Return GCP project number as taito zone id"
  value       = google_project.zone.number
}

output "network_id" {
  description = "Network name"
  value       = module.network.network.network.id
}

output "network_name" {
  description = "Network name"
  value       = module.network.network_name
}

output "postgres_hosts" {
  description = "Postgres hosts"
  value       = module.databases.postgres_private_ip_addresses
}

output "mysql_hosts" {
  description = "MySQL hosts"
  value       = module.databases.mysql_private_ip_addresses
}

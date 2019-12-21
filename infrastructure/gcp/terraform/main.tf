terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "gcs" {
    bucket  = "TAITO_STATE_BUCKET"
    prefix  = "terraform/state/zone"
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

provider "google" {
  project = var.taito_zone
  region  = var.taito_provider_region
  zone    = var.taito_provider_zone
  version = "~> 2.18.1"
}

provider "google-beta" {
  project = var.taito_zone
  region  = var.taito_provider_region
  zone    = var.taito_provider_zone
  version = "~> 2.18.1"
}

# Convert whitespace delimited strings into list(string)
locals {
  taito_owners = (var.taito_owners == "" ? [] :
    split(" ", trimspace(replace(var.taito_owners, "/\\s+/", " "))))
  taito_editors = (var.taito_editors == "" ? [] :
    split(" ", trimspace(replace(var.taito_editors, "/\\s+/", " "))))
  taito_viewers = (var.taito_viewers == "" ? [] :
    split(" ", trimspace(replace(var.taito_viewers, "/\\s+/", " "))))
  taito_developers = (var.taito_developers == "" ? [] :
    split(" ", trimspace(replace(var.taito_developers, "/\\s+/", " "))))
  taito_externals = (var.taito_externals == "" ? [] :
    split(" ", trimspace(replace(var.taito_externals, "/\\s+/", " "))))

  helm_nginx_ingress_classes = (var.helm_nginx_ingress_classes == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_classes, "/\\s+/", " "))))
  helm_nginx_ingress_replica_counts = (var.helm_nginx_ingress_replica_counts == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_replica_counts, "/\\s+/", " "))))

  kubernetes_zones = (var.kubernetes_zones == "" ? [] :
    split(" ", trimspace(replace(var.kubernetes_zones, "/\\s+/", " "))))
  kubernetes_authorized_networks = (var.kubernetes_authorized_networks == "" ? [] :
    split(" ", trimspace(replace(var.kubernetes_authorized_networks, "/\\s+/", " "))))

  postgres_instances = (var.postgres_instances == "" ? [] :
    split(" ", trimspace(replace(var.postgres_instances, "/\\s+/", " "))))
  postgres_versions  = (var.postgres_versions == "" ? [] :
    split(" ", trimspace(replace(var.postgres_versions, "/\\s+/", " "))))
  postgres_tiers     = (var.postgres_tiers == "" ? [] :
    split(" ", trimspace(replace(var.postgres_tiers, "/\\s+/", " "))))
  postgres_authorized_networks = (var.postgres_authorized_networks == "" ? [] :
    split(" ", trimspace(replace(var.postgres_authorized_networks, "/\\s+/", " "))))

  mysql_instances    = (var.mysql_instances == "" ? [] :
    split(" ", trimspace(replace(var.mysql_instances, "/\\s+/", " "))))
  mysql_versions     = (var.mysql_versions == "" ? [] :
    split(" ", trimspace(replace(var.mysql_versions, "/\\s+/", " "))))
  mysql_tiers        = (var.mysql_tiers == "" ? [] :
    split(" ", trimspace(replace(var.mysql_tiers, "/\\s+/", " "))))
  mysql_admins       = (var.mysql_admins == "" ? [] :
    split(" ", trimspace(replace(var.mysql_admins, "/\\s+/", " "))))
  mysql_authorized_networks = (var.mysql_authorized_networks == "" ? [] :
    split(" ", trimspace(replace(var.mysql_authorized_networks, "/\\s+/", " "))))

  /* TODO
  logging_sinks = (var.logging_sinks == "" ? [] :
    split(" ", trimspace(replace(var.logging_sinks, "/\\s+/", " "))))
  logging_companies = (var.logging_companies == "" ? [] :
    split(" ", trimspace(replace(var.logging_companies, "/\\s+/", " "))))
  */
}

resource "google_project" "zone" {
  name                = var.taito_zone
  project_id          = var.taito_zone
  org_id              = var.taito_provider_org_id
  billing_account     = var.taito_provider_billing_account_id
  auto_create_network = false

  lifecycle {
    prevent_destroy = true
  }
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/google"
  version = "1.0.3"

  # First run
  first_run                          = var.first_run

  # Labeling
  name                               = var.taito_zone

  # Google Provider
  project_id                         = google_project.zone.project_id
  region                             = var.taito_provider_region
  zone                               = var.taito_provider_zone

  # Users
  owners                             = local.taito_owners
  editors                            = local.taito_editors
  viewers                            = local.taito_viewers
  developers                         = local.taito_developers
  externals                          = local.taito_externals

  # Settings
  enable_google_services             = true
  enable_private_google_services     = var.taito_enable_private_google_services
  cicd_deploy_enabled                = var.taito_cicd_deploy_enabled
  email                              = var.taito_devops_email
  archive_day_limit                  = var.taito_archive_day_limit

  # Buckets
  state_bucket                       = var.taito_state_bucket
  projects_bucket                    = var.taito_projects_bucket
  assets_bucket                      = var.taito_assets_bucket

  # Helm
  helm_enabled                       = var.first_run != true
  helm_nginx_ingress_classes         = local.helm_nginx_ingress_classes
  helm_nginx_ingress_replica_counts  = local.helm_nginx_ingress_replica_counts

  # Kubernetes
  kubernetes_name                    = var.kubernetes_name
  kubernetes_zones                   = local.kubernetes_zones
  kubernetes_authorized_networks     = local.kubernetes_authorized_networks
  kubernetes_release_channel         = var.kubernetes_release_channel
  kubernetes_machine_type            = var.kubernetes_machine_type
  kubernetes_disk_size_gb            = var.kubernetes_disk_size_gb
  kubernetes_min_node_count          = var.kubernetes_min_node_count
  kubernetes_max_node_count          = var.kubernetes_max_node_count
  kubernetes_rbac_security_group     = var.kubernetes_rbac_security_group
  kubernetes_shielded_nodes          = var.kubernetes_shielded_nodes
  kubernetes_private_nodes           = var.kubernetes_private_nodes
  kubernetes_network_policy          = var.kubernetes_network_policy
  kubernetes_db_encryption           = var.kubernetes_db_encryption
  kubernetes_pod_security_policy     = var.kubernetes_pod_security_policy
  kubernetes_istio                   = var.kubernetes_istio
  kubernetes_cloudrun                = var.kubernetes_cloudrun

  # Postgres
  postgres_instances                 = local.postgres_instances
  postgres_versions                  = local.postgres_versions
  postgres_tiers                     = local.postgres_tiers
  postgres_high_availability         = var.postgres_high_availability
  postgres_public_ip                 = var.postgres_public_ip
  postgres_authorized_networks       = local.postgres_authorized_networks

  # MySQL
  mysql_instances                    = local.mysql_instances
  mysql_versions                     = local.mysql_versions
  mysql_tiers                        = local.mysql_tiers
  mysql_admins                       = local.mysql_admins
  mysql_public_ip                    = var.mysql_public_ip
  mysql_authorized_networks          = local.mysql_authorized_networks

  # TODO: Logging
  # logging_sinks                    = local.logging_sinks
  # logging_companies                = local.logging_companies
}

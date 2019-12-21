terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "azurerm" {
    resource_group_name  = "TAITO_ZONE"
    storage_account_name = "TAITO_ZONE_ABBR"
    container_name       = "TAITO_STATE_BUCKET"
    key                  = "terraform/state/zone"
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "azurerm" {
}

# Convert whitespace delimited strings into list(string)
locals {
  taito_owners = (var.taito_owners == "" ? [] :
    split(" ", trimspace(replace(var.taito_owners, "/\\s+/", " "))))
  taito_developers = (var.taito_developers == "" ? [] :
    split(" ", trimspace(replace(var.taito_developers, "/\\s+/", " "))))
  taito_authorized_networks = (var.taito_authorized_networks == "" ? [] :
    split(" ", trimspace(replace(var.taito_authorized_networks, "/\\s+/", " "))))

  helm_nginx_ingress_classes = (var.helm_nginx_ingress_classes == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_classes, "/\\s+/", " "))))
  helm_nginx_ingress_replica_counts = (var.helm_nginx_ingress_replica_counts == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_replica_counts, "/\\s+/", " "))))

  postgres_instances = (var.postgres_instances == "" ? [] :
    split(" ", trimspace(replace(var.postgres_instances, "/\\s+/", " "))))
  postgres_admins = (var.postgres_admins == "" ? [] :
    split(" ", trimspace(replace(var.postgres_admins, "/\\s+/", " "))))
  postgres_versions = (var.postgres_versions == "" ? [] :
    split(" ", trimspace(replace(var.postgres_versions, "/\\s+/", " "))))
  postgres_sku_names = (var.postgres_sku_names == "" ? [] :
    split(" ", trimspace(replace(var.postgres_sku_names, "/\\s+/", " "))))
  postgres_sku_capacities = (var.postgres_sku_capacities == "" ? [] :
    split(" ", trimspace(replace(var.postgres_sku_capacities, "/\\s+/", " "))))
  postgres_sku_tiers = (var.postgres_sku_tiers == "" ? [] :
    split(" ", trimspace(replace(var.postgres_sku_tiers, "/\\s+/", " "))))
  postgres_sku_families = (var.postgres_sku_families == "" ? [] :
    split(" ", trimspace(replace(var.postgres_sku_families, "/\\s+/", " "))))
  postgres_node_counts = (var.postgres_node_counts == "" ? [] :
    split(" ", trimspace(replace(var.postgres_node_counts, "/\\s+/", " "))))
  postgres_storage_sizes = (var.postgres_storage_sizes == "" ? [] :
    split(" ", trimspace(replace(var.postgres_storage_sizes, "/\\s+/", " "))))
  postgres_auto_grows = (var.postgres_auto_grows == "" ? [] :
    split(" ", trimspace(replace(var.postgres_auto_grows, "/\\s+/", " "))))
  postgres_backup_retention_days = (var.postgres_backup_retention_days == "" ? [] :
    split(" ", trimspace(replace(var.postgres_backup_retention_days, "/\\s+/", " "))))
  postgres_geo_redundant_backups = (var.postgres_geo_redundant_backups == "" ? [] :
    split(" ", trimspace(replace(var.postgres_geo_redundant_backups, "/\\s+/", " "))))

  # TODO: MySQL
}

resource "azurerm_resource_group" "zone" {
  name     = var.taito_zone
  location = var.taito_provider_region

  tags = {
    zone = var.taito_zone
  }
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/azurerm"
  version = "1.0.3"

  # Labeling
  name                               = var.taito_zone

  # Azure provider
  resource_group_name                = azurerm_resource_group.zone.name
  resource_group_location            = azurerm_resource_group.zone.location

  # Users
  owners                             = local.taito_owners
  developers                         = local.taito_developers

  # Settings
  email                              = var.taito_devops_email

  # Buckets
  state_bucket                       = var.taito_state_bucket
  projects_bucket                    = var.taito_projects_bucket

  # Helm
  helm_enabled                       = var.first_run != true
  helm_nginx_ingress_classes         = local.helm_nginx_ingress_classes
  helm_nginx_ingress_replica_counts  = local.helm_nginx_ingress_replica_counts

  # Kubernetes
  kubernetes_name                    = var.kubernetes_name
  kubernetes_authorized_networks     = local.taito_authorized_networks
  kubernetes_node_size               = var.kubernetes_node_size
  kubernetes_node_count              = var.kubernetes_node_count
  kubernetes_subnet_id               = azurerm_subnet.internal.id

  # Postgres
  postgres_subnet_id                 = azurerm_subnet.internal.id
  postgres_instances                 = local.postgres_instances
  postgres_admins                    = local.postgres_admins
  postgres_versions                  = local.postgres_versions
  postgres_sku_names                 = local.postgres_sku_names
  postgres_sku_capacities            = local.postgres_sku_capacities
  postgres_sku_tiers                 = local.postgres_sku_tiers
  postgres_sku_families              = local.postgres_sku_families
  postgres_node_counts               = local.postgres_node_counts
  postgres_storage_sizes             = local.postgres_storage_sizes
  postgres_auto_grows                = local.postgres_auto_grows
  postgres_backup_retention_days     = local.postgres_backup_retention_days
  postgres_geo_redundant_backups     = local.postgres_geo_redundant_backups

  # TODO: MySQL
}

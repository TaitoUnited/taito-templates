terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    profile = "TAITO_ORGANIZATION"
    bucket  = "TAITO_STATE_BUCKET"
    region  = "TAITO_PROVIDER_REGION"
    skip_region_validation = true   # support brand new regions (e.g. stockholm)
    key  = "terraform/state/zone"
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "aws" {
  region                  = var.taito_provider_region
  profile                 = coalesce(var.taito_provider_user_profile, var.taito_organization)
  shared_credentials_file = "/home/taito/.aws/credentials"
}

# Convert whitespace delimited strings into list(string)
locals {
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
  postgres_tiers     = (var.postgres_tiers == "" ? [] :
    split(" ", trimspace(replace(var.postgres_tiers, "/\\s+/", " "))))
  postgres_sizes     = (var.postgres_sizes == "" ? [] :
    split(" ", trimspace(replace(var.postgres_sizes, "/\\s+/", " "))))
  postgres_admins    = (var.postgres_admins == "" ? [] :
    split(" ", trimspace(replace(var.postgres_admins, "/\\s+/", " "))))

  mysql_instances    = (var.mysql_instances == "" ? [] :
    split(" ", trimspace(replace(var.mysql_instances, "/\\s+/", " "))))
  mysql_tiers        = (var.mysql_tiers == "" ? [] :
    split(" ", trimspace(replace(var.mysql_tiers, "/\\s+/", " "))))
  mysql_sizes        = (var.mysql_sizes == "" ? [] :
    split(" ", trimspace(replace(var.mysql_sizes, "/\\s+/", " "))))
  mysql_admins       = (var.mysql_admins == "" ? [] :
    split(" ", trimspace(replace(var.mysql_admins, "/\\s+/", " "))))
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/aws"
  version = "1.0.2"

  # Labeling
  name                       = var.taito_zone

  # Providers and namespaces
  account_id                 = var.taito_provider_org_id
  user_profile               = coalesce(var.taito_provider_user_profile, var.taito_organization)
  region                     = var.taito_provider_region

  # Users
  developers                 = local.taito_developers

  # Settings
  email                      = var.taito_devops_email
  archive_day_limit          = var.taito_archive_day_limit

  # Buckets
  state_bucket               = var.taito_state_bucket
  projects_bucket            = var.taito_projects_bucket
  assets_bucket              = var.taito_assets_bucket

  # Helm
  helm_enabled                       = var.first_run != true
  helm_nginx_ingress_classes         = local.helm_nginx_ingress_classes
  helm_nginx_ingress_replica_counts  = local.helm_nginx_ingress_replica_counts

  # Kubernetes
  kubernetes_name            = var.kubernetes_name
  kubernetes_machine_type    = var.kubernetes_machine_type
  kubernetes_disk_size_gb    = var.kubernetes_disk_size_gb
  kubernetes_min_node_count  = var.kubernetes_min_node_count
  kubernetes_max_node_count  = var.kubernetes_max_node_count

  # Postgres
  postgres_instances         = local.postgres_instances
  postgres_tiers             = local.postgres_tiers
  postgres_sizes             = local.postgres_sizes
  postgres_admins            = local.postgres_admins

  # MySQL
  mysql_instances            = local.mysql_instances
  mysql_tiers                = local.mysql_tiers
  mysql_sizes                = local.mysql_sizes
  mysql_admins               = local.mysql_admins

  # Messaging
  messaging_webhook          = var.taito_messaging_webhook
  messaging_critical_channel = var.taito_messaging_critical_channel
}

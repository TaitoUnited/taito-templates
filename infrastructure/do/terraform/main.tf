terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    # Fetch credentials from: https://cloud.digitalocean.com/settings/api/tokens
    # NOTE: Do not commit credentials to git
    access_key = "XXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXX"

    bucket  = "TAITO_STATE_BUCKET"
    region = "us-east-1"
    key  = "terraform/state/zone"

    endpoint = "https://TAITO_PROVIDER_REGION.digitaloceanspaces.com"
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "digitalocean" {
  token = var.taito_provider_do_token
}

provider "helm" {
  install_tiller = false
  max_history    = 20
}

# Convert whitespace delimited strings into list(string)
locals {
  # TODO
  # taito_developers = (var.taito_developers == "" ? [] :
  #   split(" ", trimspace(replace(var.taito_developers, "/\\s+/", " "))))
  # taito_authorized_networks = (var.taito_authorized_networks == "" ? [] :
  #   split(" ", trimspace(replace(var.taito_authorized_networks, "/\\s+/", " "))))
  #

  helm_nginx_ingress_classes = (var.helm_nginx_ingress_classes == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_classes, "/\\s+/", " "))))
  helm_nginx_ingress_replica_counts = (var.helm_nginx_ingress_replica_counts == "" ? [] :
    split(" ", trimspace(replace(var.helm_nginx_ingress_replica_counts, "/\\s+/", " "))))

  postgres_instances   = (var.postgres_instances == "" ? [] :
    split(" ", trimspace(replace(var.postgres_instances, "/\\s+/", " "))))
  postgres_node_sizes  = (var.postgres_node_sizes == "" ? [] :
    split(" ", trimspace(replace(var.postgres_node_sizes, "/\\s+/", " "))))
  postgres_node_counts = (var.postgres_node_counts == "" ? [] :
    split(" ", trimspace(replace(var.postgres_node_counts, "/\\s+/", " "))))

  mysql_instances    = (var.mysql_instances == "" ? [] :
    split(" ", trimspace(replace(var.mysql_instances, "/\\s+/", " "))))
  mysql_node_sizes   = (var.mysql_node_sizes == "" ? [] :
    split(" ", trimspace(replace(var.mysql_node_sizes, "/\\s+/", " "))))
  mysql_node_counts  = (var.mysql_node_counts == "" ? [] :
    split(" ", trimspace(replace(var.mysql_node_counts, "/\\s+/", " "))))
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/digitalocean"
  version = "0.1.2"

  # Provider
  do_token                = var.taito_provider_do_token
  region                  = var.taito_provider_region

  # Settings
  email                   = var.taito_devops_email

  # Buckets
  state_bucket            = var.taito_state_bucket

  # Helm
  helm_enabled                       = var.first_run != true
  helm_nginx_ingress_classes         = local.helm_nginx_ingress_classes
  helm_nginx_ingress_replica_counts  = local.helm_nginx_ingress_replica_counts

  # Kubernetes
  kubernetes_name         = var.kubernetes_name
  kubernetes_version      = var.kubernetes_version
  kubernetes_node_size    = var.kubernetes_node_size
  kubernetes_node_count   = var.kubernetes_node_count

  # Postgres
  postgres_instances      = local.postgres_instances
  postgres_node_sizes     = local.postgres_node_sizes
  postgres_node_counts    = local.postgres_node_counts

  # MySQL
  mysql_instances         = local.mysql_instances
  mysql_node_sizes        = local.mysql_node_sizes
  mysql_node_counts       = local.mysql_node_counts
}

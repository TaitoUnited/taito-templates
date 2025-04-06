terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    # Fetch credentials from: https://cloud.digitalocean.com/settings/api/tokens
    # TODO: Credentials should not be committed to git
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
  token                   = var.taito_provider_do_token
  spaces_access_id        = var.taito_provider_spaces_access_id
  spaces_secret_key       = var.taito_provider_spaces_secret_key
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {

  /*
  admin = jsondecode(
    file("${path.root}/../admin.json.tmp")
  )
  */

  databases = jsondecode(
    file("${path.root}/../databases.json.tmp")
  )

  dns = jsondecode(
    file("${path.root}/../dns.json.tmp")
  )

  compute = jsondecode(
    file("${path.root}/../compute.json.tmp")
  )

  kubernetes = jsondecode(
    file("${path.root}/../kubernetes.json.tmp")
  )

  kubernetesPermissions = jsondecode(
    file("${path.root}/../kubernetes-permissions.json.tmp")
  )

  /*
  integrations = jsondecode(
    file("${path.root}/../integrations.json.tmp")
  )
  */

  /*
  monitoring = jsondecode(
    file("${path.root}/../monitoring.json.tmp")
  )
  */

  network = jsondecode(
    file("${path.root}/../network.json.tmp")
  )

  storage = jsondecode(
    file("${path.root}/../storage.json.tmp")
  )
}

/*
module "admin" {
  source              = "TaitoUnited/admin/digitalocean"
  version             = "0.0.1"

  subscription_id     = var.taito_provider_billing_account_id

  permissions         = try(local.admin["permissions"], [])
  custom_roles        = try(local.admin["customRoles"], [])
}
*/

module "databases" {
  source               = "TaitoUnited/databases/digitalocean"
  version              = "0.0.1"

  private_network_id   = module.network.private_network_id

  postgresql_clusters  = try(local.databases.postgresqlClusters, [])
  mysql_clusters       = try(local.databases.mysqlClusters, [])

  # TODO: long_term_backup_bucket = ...
}

module "dns" {
  source              = "TaitoUnited/dns/digitalocean"
  version             = "0.0.1"
  dns_zones           = try(local.dns["dnsZones"], [])
}

module "compute" {
  source              = "TaitoUnited/compute/digitalocean"
  version             = "0.0.1"
  virtual_machines    = try(local.compute["virtualMachines"], [])
}

module "kubernetes" {
  source                     = "TaitoUnited/kubernetes/digitalocean"
  version                    = "0.0.3"

  email                      = var.taito_devops_email

  # Network
  private_network_id         = module.network.private_network_id

  # Permissions
  permissions                = try(local.kubernetesPermissions["permissions"], {})

  # Kubernetes
  kubernetes                 = try(local.kubernetes["kubernetes"], {})

  # Container registry
  registry_name                   = var.taito_zone
  registry_subscription_tier_slug = "starter"

  # Helm infrastructure apps
  # NOTE: helm_enabled should be false on the first run, then true
  helm_enabled               = var.first_run == false
  generate_ingress_dhparam   = true
  use_kubernetes_as_db_proxy = var.kubernetes_db_proxy_enabled
  postgresql_cluster_names = [
    for db in (
      try(local.databases.postgresqlClusters, [])
    ):
    db.name
  ]
  mysql_cluster_names      = [
    for db in (
      try(local.databases.mysqlClusters, [])
    ):
    db.name
  ]

  # OPTIONAL: Helm app versions
  # ingress_nginx_version  = ...
  # cert_manager_version   = ...
  # kubernetes_admin_version = ...
  # socat_tunneler_version = ...
}

/*
module "integrations" {
  source              = "TaitoUnited/integrations/digitalocean"
  version             = "0.0.1"

  kafkas        = try(local.integrations["kafkas"], [])
}
*/

module "network" {
  source              = "TaitoUnited/network/digitalocean"
  version             = "0.0.1"

  name                = var.taito_zone
  region              = var.taito_provider_region

  network             = local.network["network"]
}

/*
module "monitoring" {
  source              = "TaitoUnited/monitoring/digitalocean"
  version             = "0.0.1"

  alert_email         = var.taito_devops_email
}
*/

module "storage" {
  source              = "TaitoUnited/storage/digitalocean"
  version             = "0.0.1"

  storage_buckets     = try(local.storage["storageBuckets"], [])
}

terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    profile = "TAITO_ORGANIZATION"
    bucket  = "TAITO_STATE_BUCKET"
    region  = "TAITO_PROVIDER_REGION"
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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {

  admin = jsondecode(
    file("${path.root}/../admin.json.tmp")
  )

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

  integrations = jsondecode(
    file("${path.root}/../integrations.json.tmp")
  )

  monitoring = jsondecode(
    file("${path.root}/../monitoring.json.tmp")
  )

  network = jsondecode(
    file("${path.root}/../network.json.tmp")
  )

  storage = jsondecode(
    file("${path.root}/../storage.json.tmp")
  )
}

module "admin" {
  source              = "TaitoUnited/admin/aws"
  version             = "0.0.4"

  account_id          = var.taito_provider_org_id

  groups              = try(local.admin["groups"], [])
  users               = try(local.admin["users"], [])
  roles               = try(local.admin["roles"], [])

  # For predefined policies
  create_predefined_policies = true
  predefined_policy_prefix   = ""
  cicd_secrets_path          = "/cicd/"
  shared_cdn_bucket          = var.taito_public_bucket
  shared_state_bucket        = var.taito_projects_bucket
}

module "databases" {
  source              = "TaitoUnited/databases/aws"
  version             = "0.0.4"

  name                = var.taito_zone
  vpc_id              = module.network.vpc_id
  database_subnets    = module.network.database_subnets
  client_subnets      = concat(module.network.private_subnets, module.network.public_subnets)

  postgresql_clusters = try(local.databases.postgresqlClusters, [])
  mysql_clusters      = try(local.databases.mysqlClusters, [])

  # TODO: long_term_backup_bucket = ...
}

module "dns" {
  source              = "TaitoUnited/dns/aws"
  version             = "0.0.2"
  dns_zones           = try(local.dns["dnsZones"], [])
}

module "compute" {
  source              = "TaitoUnited/compute/aws"
  version             = "0.0.1"
  # TODO: virtual_machines    = try(local.compute["virtualMachines"], [])
}

module "kubernetes" {
  # depends_on                 = [ module.admin ]
  source                     = "TaitoUnited/kubernetes/aws"
  version                    = "0.0.4"

  user_profile               = coalesce(var.taito_provider_user_profile, var.taito_organization)
  email                      = var.taito_devops_email

  # Network
  vpc_id                     = module.network.vpc_id
  private_subnets            = module.network.private_subnets

  additional_accounts        = []

  /* TODO: not required? -> use permissions?
  roles = [
    rolearn  = string
    username = "cicd-role"
    groups   = ["system:masters"]
  ]
  users = [
    userarn  = string
    username = "cicd-user"
    groups   = ["system:masters"]
  ]
  */

  # Permissions
  permissions                = try(local.kubernetesPermissions["permissions"], {})

  # Kubernetes
  kubernetes                 = try(local.kubernetes["kubernetes"], {})

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

module "integrations" {
  source              = "TaitoUnited/integrations/aws"
  version             = "0.0.1"

  # TODO: kafkas              = try(local.integrations["kafkas"], [])
}

module "network" {
  source              = "TaitoUnited/network/aws"
  version             = "0.0.5"

  name                = var.taito_zone
  kubernetes_name     = try(local.kubernetes["kubernetes"]["name"], null)

  network             = local.network["network"]
}

module "monitoring" {
  source                     = "TaitoUnited/monitoring/aws"
  version                    = "0.0.1"

  name                       = var.taito_zone

  messaging_app              = var.taito_messaging_app
  messaging_webhook          = var.taito_messaging_webhook
  messaging_critical_channel = var.taito_messaging_critical_channel
  messaging_builds_channel   = var.taito_ci_provider == "aws" ? var.taito_messaging_builds_channel : null

  # TODO: alerts                     = local.network["alerts"]
}

module "storage" {
  source              = "TaitoUnited/storage/aws"
  version             = "0.0.3"

  storage_buckets    = try(local.storage["storageBuckets"], [])
}

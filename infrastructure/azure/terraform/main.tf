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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Convert whitespace delimited strings into list(string)
locals {
  # Read json file
  variables = (
    fileexists("${path.root}/../terraform-substituted.yaml")
      ? yamldecode(file("${path.root}/../terraform-substituted.yaml"))
      : jsondecode(file("${path.root}/../terraform.json.tmp"))
  )["settings"]
}

resource "azurerm_resource_group" "zone" {
  name     = var.taito_zone
  location = var.taito_provider_region

  tags = {
    zone = var.taito_zone
  }
}

locals {

  adminOrig = jsondecode(
    file("${path.root}/../admin.json.tmp")
  )

  admin = merge(local.adminOrig, {
    members = flatten([
      for member in local.adminOrig.members:
      replace(member.id, "TAITO_PROVIDER_TAITO_ZONE_ID", "") == member.id ? [ member ] : []
    ])
  })

  databases = jsondecode(
    file("${path.root}/../databases.json.tmp")
  )

  dns = jsondecode(
    file("${path.root}/../dns.json.tmp")
  )

  kubernetes = jsondecode(
    file("${path.root}/../kubernetes.json.tmp")
  )

  kubernetesPermissions = jsondecode(
    file("${path.root}/../kubernetes-permissions.json.tmp")
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
  source           = "TaitoUnited/admin/azurerm"
  version          = "0.0.1"

  resource_group_name = azurerm_resource_group.zone.name

  members          = local.admin["members"]
  service_accounts = local.admin["serviceAccounts"]
  apis             = local.admin["apis"]
}

module "databases" {
  source              = "TaitoUnited/databases/azurerm"
  version             = "0.0.1"

  postgresql_clusters = local.databases.postgresqlClusters
  mysql_clusters      = local.databases.mysqlClusters
  private_network_id  = (
    var.first_run
    ? data.external.network_wait.result.network_self_link
    : module.network.network_self_link
  )
}

module "dns" {
  source       = "TaitoUnited/dns/azurerm"
  version      = "0.0.1"
  dns_zones    = local.dns["dnsZones"]
}

module "kubernetes" {
  source                 = "TaitoUnited/kubernetes/azurerm"
  version                = "0.0.1"

  # OPTIONAL: Helm app versions
  # ingress_nginx_version  = ...
  # cert_manager_version   = ...
  # kubernetes_admin_version = ...
  # socat_tunneler_version = ...

  resource_group_name = azurerm_resource_group.zone.name

  # Settings
  # NOTE: helm_enabled should be false on the first run, then true
  helm_enabled             = var.first_run == false
  email                    = var.taito_devops_email
  generate_ingress_dhparam = false # Set to true for additional security

  # Network
  network                  = module.network.network_name
  subnetwork               = module.network.subnet_names[0]
  pods_ip_range_name       = module.network.pods_ip_range_name
  services_ip_range_name   = module.network.services_ip_range_name

  # Permissions
  permissions              = local.kubernetesPermissions["permissions"]

  # Kubernetes
  kubernetes               = local.kubernetes["kubernetes"]

  # Database clusters (for db proxies)
  postgresql_cluster_names = [
    for db in (
      local.databases.postgresqlClusters != null ? local.databases.postgresqlClusters : []
    ):
    db.name
  ]
  mysql_cluster_names      = [
    for db in (
      local.databases.mysqlClusters != null ? local.databases.mysqlClusters : []
    ):
    db.name
  ]
}

module "integrations" {
  source       = "TaitoUnited/integrations/azurerm"
  version      = "0.0.1"

  resource_group_name = azurerm_resource_group.zone.name

  cloud_build_notify_enabled = var.taito_messaging_webhook != ""
  cloud_sql_backups_enabled  = var.taito_backup_bucket != ""

  functions_bucket        = var.taito_function_bucket
  functions_region        = "europe-west1" # Not available on all regions
  cloud_sql_backup_bucket = var.taito_backup_bucket
  cloud_sql_backup_path   = "/cloud-sql-backup"
  slack_webhook_url       = var.taito_messaging_webhook
  slack_builds_channel    = var.taito_messaging_builds_channel

  postgresql_clusters     = local.databases.postgresqlClusters
  mysql_clusters          = local.databases.mysqlClusters
}

module "network" {
  source       = "TaitoUnited/network/azurerm"
  version      = "0.0.1"

  resource_group_name = azurerm_resource_group.zone.name
  network      = local.network["network"]
}

module "storage" {
  source          = "TaitoUnited/storage/azurerm"
  version         = "0.0.1"

  resource_group_name = azurerm_resource_group.zone.name
  storage_buckets = local.storage["storageBuckets"]
}

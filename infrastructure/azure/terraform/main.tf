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
  features {}
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "azurerm_resource_group" "zone" {
  name     = var.taito_zone
  location = var.taito_provider_region

  # TODO: conventions https://registry.terraform.io/modules/kumarvna/vpn-gateway/azurerm/latest#metadata-tags
  tags = {
    zone = var.taito_zone
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
  source              = "TaitoUnited/admin/azurerm"
  version             = "0.0.3"

  subscription_id     = var.taito_provider_billing_account_id

  permissions         = try(local.admin["permissions"], [])
  custom_roles        = try(local.admin["customRoles"], [])
}

module "databases" {
  source               = "TaitoUnited/databases/azurerm"
  version              = "0.0.4"

  resource_group_name  = azurerm_resource_group.zone.name
  virtual_network_id   = module.network.virtual_network_id
  subnet_id            = module.network.subnet_id

  postgresql_clusters  = try(local.databases.postgresqlClusters, [])
  mysql_clusters       = try(local.databases.mysqlClusters, [])

  # TODO: long_term_backup_bucket = ...
}

module "dns" {
  source              = "TaitoUnited/dns/azurerm"
  version             = "0.0.3"
  resource_group_name = azurerm_resource_group.zone.name
  dns_zones           = try(local.dns["dnsZones"], [])
}

module "compute" {
  source              = "TaitoUnited/compute/azurerm"
  version             = "0.0.3"
  # TODO: virtual_machines    = try(local.compute["virtualMachines"], [])
}

module "kubernetes" {
  source                     = "TaitoUnited/kubernetes/azurerm"
  version                    = "0.0.3"

  resource_group_name        = azurerm_resource_group.zone.name

  name                       = azurerm_resource_group.zone.name
  location                   = azurerm_resource_group.zone.location
  email                      = var.taito_devops_email
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  # Network
  subnet_id                  = module.network.subnet_id

  # Permissions
  permissions                = try(local.kubernetesPermissions["permissions"], {})

  # Kubernetes
  kubernetes                 = try(local.kubernetes["kubernetes"], {})

  # Helm infrastructure apps
  # NOTE: helm_enabled should be false on the first run, then true
  helm_enabled               = var.first_run == false
  generate_ingress_dhparam   = var.taito_zone_extra_security
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
  source              = "TaitoUnited/integrations/azurerm"
  version             = "0.0.3"

  resource_group_name = azurerm_resource_group.zone.name

  name                = azurerm_resource_group.zone.name
  location            = azurerm_resource_group.zone.location

  # TODO: kafkas        = try(local.integrations["kafkas"], [])
}

module "network" {
  source              = "TaitoUnited/network/azurerm"
  version             = "0.0.4"

  resource_group_name = azurerm_resource_group.zone.name

  name                = azurerm_resource_group.zone.name
  location            = azurerm_resource_group.zone.location

  network             = local.network["network"]
}

module "monitoring" {
  source              = "TaitoUnited/monitoring/azurerm"
  version             = "0.0.3"

  resource_group_name = azurerm_resource_group.zone.name

  name                = azurerm_resource_group.zone.name
  location            = azurerm_resource_group.zone.location

  alert_email         = var.taito_devops_email
}

module "storage" {
  source              = "TaitoUnited/storage/azurerm"
  version             = "0.0.3"

  resource_group_name = azurerm_resource_group.zone.name
  storage_accounts    = try(local.storage["storageAccounts"], [])
}

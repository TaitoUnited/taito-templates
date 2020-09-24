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
}

provider "google-beta" {
  project = var.taito_zone
  region  = var.taito_provider_region
  zone    = var.taito_provider_zone
}

provider "helm" {
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
  source           = "TaitoUnited/admin/google"
  version          = "1.0.3"
  depends_on       = [ google_project.zone ]

  members          = local.admin["members"]
  service_accounts = local.admin["serviceAccounts"]
  apis             = local.admin["apis"]
}

module "databases" {
  source              = "TaitoUnited/databases/google"
  version             = "1.0.4"
  depends_on          = [ module.admin ]

  postgresql_clusters = local.databases.postgresqlClusters
  mysql_clusters      = local.databases.mysqlClusters
  private_network_id  = module.network.network_self_link
}

module "dns" {
  source       = "TaitoUnited/dns/google"
  version      = "1.0.2"
  depends_on   = [ module.admin ]
  dns_zones    = local.dns["dnsZones"]
}

# NOTE: This is a temporary hack to make Kubernetes module wait for an existing
# GCP project and network
data "external" "kubernetes_wait" {
  depends_on = [ google_project.zone, module.network ]
  program = ["sh", "-c", "sleep 5; echo '{ \"project_id\": \"${google_project.zone.project_id}\", \"project_number\": \"${google_project.zone.number}\" }'"]
}

module "kubernetes" {
  source                 = "TaitoUnited/kubernetes/google"
  version                = "1.17.0"

  # OPTIONAL: Helm app versions
  # ingress_nginx_version  = ...
  # cert_manager_version   = ...
  # kubernetes_admin_version = ...
  # socat_tunneler_version = ...

  project_id             = (
    var.first_run
    ? data.external.kubernetes_wait.result.project_id
    : google_project.zone.project_id
  )
  project_number         = (
    var.first_run
    ? data.external.kubernetes_wait.result.project_number
    : google_project.zone.number
  )

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

module "events" {
  source       = "TaitoUnited/events/google"
  version      = "1.1.1"
  depends_on   = [ module.admin, module.databases ]

  project_id             = google_project.zone.project_id

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
  source       = "TaitoUnited/network/google"
  version      = "1.4.0"
  depends_on   = [ module.admin ]

  network      = local.network["network"]
}

module "storage" {
  source          = "TaitoUnited/storage/google"
  version         = "1.3.1"
  depends_on      = [ module.admin ]

  project_id      = google_project.zone.project_id
  storage_buckets = local.storage["storageBuckets"]
}

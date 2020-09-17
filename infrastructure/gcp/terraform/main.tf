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

data "google_organization" "org" {
  count        = var.taito_provider_org_id != "" ? 1 : 0
  organization = var.taito_provider_org_id
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
  admin = yamldecode(replace(
    file("${path.root}/../admin.json.tmp"),
    "GCP_PROJECT_NUMBER",
    google_project.zone.number
  ))

  databases = yamldecode(
    file("${path.root}/../databases.json.tmp")
  )

  dns = yamldecode(
    file("${path.root}/../dns.json.tmp")
  )

  kubernetes = yamldecode(
    replace(
      replace(
        file("${path.root}/../kubernetes.json.tmp"),
        "GCP_PROJECT_NUMBER",
        google_project.zone.number
      ),
      "GKE_SECURITY_GROUP",
      var.taito_provider_org_id != "gke-security-groups@${data.google_organization.org[0].domain}" ? 1 : ""
    )
  )

  monitoring = yamldecode(
    file("${path.root}/../monitoring.json.tmp")
  )

  network = yamldecode(
    file("${path.root}/../network.json.tmp")
  )

  storage = yamldecode(replace(
    file("${path.root}/../storage.json.tmp"),
    "GCP_PROJECT_NUMBER",
    google_project.zone.number
  ))
}

module "admin" {
  source           = "TaitoUnited/admin/google"
  version          = "1.0.1"
  depends_on       = [ google_project.zone ]

  members          = local.admin["members"]
  service_accounts = local.admin["serviceAccounts"]
  apis             = local.admin["apis"]
}

module "databases" {
  source              = "TaitoUnited/databases/google"
  version             = "1.0.1"
  depends_on          = [ module.admin ]

  postgresql_clusters = local.databases.postgresqlClusters
  mysql_clusters      = local.databases.mysqlClusters
  private_network_id  = module.network.network
}

module "dns" {
  source       = "TaitoUnited/dns/google"
  version      = "1.0.1"
  depends_on   = [ module.admin ]
  dns_zones    = local.dns["dnsZones"]
}

module "kubernetes" {
  source                 = "TaitoUnited/kubernetes/google"
  version                = "1.8.1"

  # OPTIONAL: Helm app versions
  ingress_nginx_version  = null
  cert_manager_version   = null
  kubernetes_admin_version = null
  socat_tunneler_version = null

  # Settings
  helm_enabled           = var.first_run  # Should be false on the first run, then true
  email                  = var.taito_devops_email

  # Network
  network                = module.network.network
  subnetwork             = module.network.subnet_names[0]
  pods_ip_range_name     = module.network.pods_ip_range_name
  services_ip_range_name = module.network.services_ip_range_name

  # Permissions
  permissions            = local.kubernetes["permissions"]

  # Kubernetes
  kubernetes             = local.kubernetes["kubernetes"]

  # Database clusters (for db proxies)
  postgresql_cluster_names = [
    for db in local.databases.postgresqlClusters:
    db.name
  ]
  mysql_cluster_names      = [
    for db in local.databases.mysqlClusters:
    db.name
  ]
}

module "monitoring" {
  source       = "TaitoUnited/monitoring/google"
  version      = "1.0.1"
  depends_on   = [ module.admin ]

  alerts       = local.monitoring["alerts"]
}

module "network" {
  source       = "TaitoUnited/network/google"
  version      = "1.2.0"
  depends_on   = [ module.admin ]

  network      = local.network["network"]
}

module "storage" {
  source          = "TaitoUnited/storage/google"
  version         = "1.2.0"
  depends_on      = [ module.admin ]

  storage_buckets = local.storage["storageBuckets"]
}

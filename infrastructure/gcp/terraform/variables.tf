/* First run */

variable "first_run" {
  type    = bool
  default = "true" # first_run
}

/* Labeling */

variable "taito_zone" {
  type = string
}

/* Cloud provider */

variable "taito_provider_org_id" {
  type = string
}

variable "taito_provider_billing_account_id" {
  type    = string
  default = ""
}

variable "taito_provider_region" {
  type = string
}

variable "taito_provider_zone" {
  type = string
}

/* Users */

variable "taito_owners" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "taito_editors" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "taito_viewers" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "taito_developers" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "taito_externals" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* Settings */

variable "taito_cicd_deploy_enabled" {
  type    = bool
  default = "true"
}

variable "taito_devops_email" {
  type = string
}

variable "taito_archive_day_limit" {
  type = number
}

variable "taito_enable_private_google_services" {
  type = bool
  default = "true"
}

/* Buckets */

variable "taito_state_bucket" {
  type    = string
  default = ""
}

variable "taito_projects_bucket" {
  type    = string
  default = ""
}

variable "taito_assets_bucket" {
  type    = string
  default = ""
}

/* Helm */

variable "helm_nginx_ingress_classes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "helm_nginx_ingress_replica_counts" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* Kubernetes */

variable "kubernetes_name" {
  type    = string
}

variable "kubernetes_cluster" {
  type    = string
}

variable "kubernetes_zones" {
  type    = string
  default = ""
}

variable "kubernetes_authorized_networks" {
  type    = string
  default = ""
}

variable "kubernetes_release_channel" {
  type    = string
  default = "STABLE"
}

variable "kubernetes_machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "kubernetes_disk_size_gb" {
  type    = number
  default = "100"
}

variable "kubernetes_min_node_count" {
  type    = number
  default = 1
}

variable "kubernetes_max_node_count" {
  type    = number
  default = 1
}

variable "kubernetes_rbac_security_group" {
  type = string
  default = ""
}

variable "kubernetes_private_nodes" {
  type    = bool
  default = "true"
}

variable "kubernetes_shielded_nodes" {
  type    = bool
  default = "true"
}

variable "kubernetes_network_policy" {
  type    = bool
  default = "false"
}

variable "kubernetes_db_encryption" {
  type    = bool
  default = "false"
}

variable "kubernetes_pod_security_policy" {
  type    = bool
  default = "false"
}

variable "kubernetes_istio" {
  type    = bool
  default = "false"
}

variable "kubernetes_cloudrun" {
  type    = bool
  default = "false"
}

/* Postgres clusters */

variable "postgres_instances" {
  type    = string
  default = ""
}

variable "postgres_versions" {
  type    = string
  default = ""
}

variable "postgres_tiers" {
  type    = string
  default = ""
}

variable "postgres_high_availability" {
  type    = bool
  default = "false"
}

variable "postgres_public_ip" {
  type    = bool
  default = "false"
}

variable "postgres_authorized_networks" {
  type    = string
  default = ""
}

/* MySQL clusters */

variable "mysql_instances" {
  type    = string
  default = ""
}

variable "mysql_versions" {
  type    = string
  default = ""
}

variable "mysql_tiers" {
  type    = string
  default = ""
}

variable "mysql_admins" {
  type    = string
  default = ""
}

variable "mysql_public_ip" {
  type    = bool
  default = "false"
}

variable "mysql_authorized_networks" {
  type    = string
  default = ""
}

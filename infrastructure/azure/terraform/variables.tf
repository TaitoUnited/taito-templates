/* First run */

variable "first_run" {
  type    = bool
  default = "true" # first_run
}

/* Labeling */

variable "taito_organization" {
  type = string
}

variable "taito_zone" {
  type = string
}

/* Cloud provider */

variable "taito_provider" {
  type = string
}

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

/* User rights */

variable "taito_owners" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "taito_developers" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* Settings */

variable "taito_devops_email" {
  type = string
}

variable "taito_authorized_networks" {
  type    = string  # whitespace delimited strings
}

/* TODO: extra configuration options for Azure
variable "taito_high_availability" {
  type    = bool
  default = "true"
}

variable "taito_cicd_deploy_enabled" {
  type    = bool
  default = "true"
}

variable "taito_archive_day_limit" {
  type = number
}
*/

/* Buckets */

variable "taito_state_bucket" {
  type    = string
  default = ""
}

variable "taito_projects_bucket" {
  type    = string
  default = ""
}

/* Kubernetes */
/* NOTE: kubernetes_cluster and kubernetes_user not required on Terraform */

variable "kubernetes_name" {
  type    = string
  default = ""
}

variable "kubernetes_cluster" {
  type    = string
}

variable "kubernetes_version" {
  type    = string
  default = ""
}

variable "kubernetes_node_size" {
    type = string
    default = "Standard_DS1_v2"
}

variable "kubernetes_node_count" {
    type = number
    default = 1
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

/* Postgres */

variable "postgres_instances" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_admins" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_versions" {
  type    = string  # whitespace delimited strings
  default = ""
}

# See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory
variable "postgres_sku_names" {
  type    = string  # whitespace delimited strings
  default = ""
}
variable "postgres_sku_capacities" {
  type    = string  # whitespace delimited strings
  default = ""
}
variable "postgres_sku_tiers" {
  type    = string  # whitespace delimited strings
  default = ""
}
variable "postgres_sku_families" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_node_counts" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_storage_sizes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_auto_grows" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_backup_retention_days" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_geo_redundant_backups" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* MySQL */

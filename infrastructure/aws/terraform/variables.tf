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

variable "taito_provider_user_profile" {
  type    = string
  default = ""
}

variable "taito_provider_region" {
  type = string
}

/* Domain */

variable "taito_default_domain" {
  type = string
}

/* User rights */

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
  default = ""
}

variable "taito_archive_day_limit" {
  type = number
}

variable "taito_cicd_secrets_path" {
  type    = string
  default = ""
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

variable "taito_public_bucket" {
  type    = string
  default = ""
}

/* Kubernetes */

variable "kubernetes_name" {
  type    = string
  default = ""
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

/* Helm */

variable "helm_nginx_ingress_classes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "helm_nginx_ingress_replica_counts" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* Postgres clusters */

variable "postgres_instances" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_tiers" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_sizes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_admins" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* MySQL clusters */

variable "mysql_instances" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "mysql_tiers" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "mysql_sizes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "mysql_admins" {
  type    = string  # whitespace delimited strings
  default = "dummy"
}

/* Messaging */

variable "taito_messaging_webhook" {
  type    = string
}

variable "taito_messaging_critical_channel" {
  type    = string
}

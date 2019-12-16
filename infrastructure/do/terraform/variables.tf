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

variable "taito_provider_region" {
  type = string
}

/* TODO: rename to taito_provider_access_token? */
variable "taito_provider_do_token" {
  type = string
}

/* TODO: Users */

/* Settings */

variable "taito_devops_email" {
  type = string
}

/* Buckets */

variable "taito_state_bucket" {
  type    = string
  default = ""
}

/* Kubernetes */

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
  type    = string
  default = "s-2vcpu-2gb"
}

variable "kubernetes_node_count" {
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

/* Postgres */

variable "postgres_instances" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_node_sizes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "postgres_node_counts" {
  type    = string  # whitespace delimited strings
  default = ""
}

/* MySQL */

variable "mysql_instances" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "mysql_node_sizes" {
  type    = string  # whitespace delimited strings
  default = ""
}

variable "mysql_node_counts" {
  type    = string  # whitespace delimited strings
  default = ""
}

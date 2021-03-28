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
  default = ""
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

/* Settings */

variable "taito_devops_email" {
  type = string
}

variable "taito_zone_extra_security" {
  type = bool
}

variable "kubernetes_db_proxy_enabled" {
  type = bool
}

/* Buckets */

variable "taito_function_bucket" {
  type = string
}

variable "taito_backup_bucket" {
  type = string
}

/* Messaging */

variable "taito_messaging_webhook" {
  type = string
  default = ""
}

variable "taito_messaging_builds_channel" {
  type = string
}

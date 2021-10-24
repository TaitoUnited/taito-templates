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

variable "taito_provider_org_id" {
  type = string
  default = ""
}

variable "taito_provider_region" {
  type = string
}

variable "taito_provider_user_profile" {
  type    = string
  default = ""
}

/* Settings */

variable "taito_devops_email" {
  type = string
}

variable "kubernetes_db_proxy_enabled" {
  type = bool
}

/* Buckets */

variable "taito_public_bucket" {
  type = string
  default = ""
}

variable "taito_projects_bucket" {
  type = string
  default = ""
}

/* Messaging */

variable "taito_messaging_app" {
  type = string
}

variable "taito_messaging_webhook" {
  type = string
  default = ""
}

variable "taito_messaging_critical_channel" {
  type = string
}

variable "taito_messaging_builds_channel" {
  type = string
}

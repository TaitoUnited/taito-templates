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

/* Messaging */

variable "taito_messaging_webhook" {
  type    = string
}

variable "taito_messaging_critical_channel" {
  type    = string
}
variable "taito_messaging_builds_channel" {
  type    = string
}

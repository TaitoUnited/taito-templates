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

variable "taito_cicd_cloud_deploy_enabled" {
  type    = bool
  default = "true"
}

variable "taito_cicd_testing_enabled" {
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

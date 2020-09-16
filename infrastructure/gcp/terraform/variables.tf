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

/* Settings */

variable "taito_devops_email" {
  type = string
}

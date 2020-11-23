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

variable "taito_provider_do_token" {
  type = string
}

variable "taito_provider_spaces_access_id" {
  type = string
}

variable "taito_provider_spaces_secret_key" {
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

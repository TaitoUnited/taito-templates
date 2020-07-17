terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    profile = "TAITO_ORGANIZATION"
    bucket  = "TAITO_STATE_BUCKET"
    region  = "TAITO_PROVIDER_REGION"
    skip_region_validation = true   # support brand new regions (e.g. stockholm)
    key  = "terraform/state/zone"
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "aws" {
  region                  = var.taito_provider_region
  profile                 = coalesce(var.taito_provider_user_profile, var.taito_organization)
  shared_credentials_file = "/home/taito/.aws/credentials"
}

# Convert whitespace delimited strings into list(string)
locals {
  # Read json file
  variables = (
    fileexists("${path.root}/../terraform-substituted.yaml")
      ? yamldecode(file("${path.root}/../terraform-substituted.yaml"))
      : jsondecode(file("${path.root}/../terraform.json.tmp"))
  )["settings"]
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/aws"
  version = "2.2.1"

  # Labeling
  name                       = var.taito_zone

  # Providers and namespaces
  account_id                 = var.taito_provider_org_id
  user_profile               = coalesce(var.taito_provider_user_profile, var.taito_organization)
  region                     = var.taito_provider_region

  # Domain
  default_domain             = var.taito_default_domain

  # Settings
  email                      = var.taito_devops_email
  archive_day_limit          = var.taito_archive_day_limit
  cicd_secrets_path          = var.taito_cicd_secrets_path

  # Buckets
  state_bucket               = var.taito_state_bucket
  projects_bucket            = var.taito_projects_bucket
  public_bucket              = var.taito_public_bucket

  # Helm
  helm_enabled               = var.first_run != true

  # Messaging
  messaging_webhook          = var.taito_messaging_webhook
  messaging_critical_channel = var.taito_messaging_critical_channel
  messaging_builds_channel   = var.taito_messaging_builds_channel

  # Variables
  variables                  = local.variables
}

terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "s3" {
    # Fetch credentials from: https://cloud.digitalocean.com/settings/api/tokens
    # TODO: Credentials should not be committed to git
    access_key = "XXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXX"

    bucket  = "TAITO_STATE_BUCKET"
    region = "us-east-1"
    key  = "terraform/state/zone"

    endpoint = "https://TAITO_PROVIDER_REGION.digitaloceanspaces.com"
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "digitalocean" {
  token                   = var.taito_provider_do_token
  spaces_access_id        = var.taito_provider_spaces_access_id
  spaces_secret_key       = var.taito_provider_spaces_secret_key
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
  source  = "TaitoUnited/kubernetes-infrastructure/digitalocean"
  version = "2.0.0"

  # Labeling
  name                    = var.taito_zone

  # Provider
  token                   = var.taito_provider_do_token
  spaces_access_id        = var.taito_provider_spaces_access_id
  spaces_secret_key       = var.taito_provider_spaces_secret_key
  region                  = var.taito_provider_region

  # Settings
  email                   = var.taito_devops_email

  # Buckets
  state_bucket            = var.taito_state_bucket

  # Helm
  helm_enabled            = var.first_run != true

  # Variables
  variables               = local.variables
}

terraform {
  /* NOTE: Configure Terraform remote backend here. Use the same settings as in
     taito-config.sh. Note that you cannot use environment variables here. */
  /* TODO: ENABLE TERRAFORM BACKEND HERE
  backend "azurerm" {
    resource_group_name  = "TAITO_ZONE"
    storage_account_name = "TAITO_ZONE_ABBR"
    container_name       = "TAITO_STATE_BUCKET"
    key                  = "terraform/state/zone"
  }
  TODO: ENABLE TERRAFORM BACKEND HERE */
}

/* Provider */

provider "azurerm" {
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

resource "azurerm_resource_group" "zone" {
  name     = var.taito_zone
  location = var.taito_provider_region

  tags = {
    zone = var.taito_zone
  }
}

module "taito_zone" {
  source  = "TaitoUnited/kubernetes-infrastructure/azurerm"
  version = "2.0.0"

  # Labeling
  name                        = var.taito_zone

  # Azure provider
  resource_group_name         = azurerm_resource_group.zone.name
  resource_group_location     = azurerm_resource_group.zone.location

  # Settings
  email                       = var.taito_devops_email

  # Buckets
  state_bucket                = var.taito_state_bucket
  projects_bucket             = var.taito_projects_bucket

  # Helm
  helm_enabled                = var.first_run != true

  # Variables
  variables                   = local.variables
}

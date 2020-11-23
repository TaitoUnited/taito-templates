#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  azure-zone azure-secrets
  terraform-zone
  kubectl-zone helm-zone
  generate-secrets links-global custom
"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone
taito_zone_short="${taito_zone//-/}"

# Domains
taito_default_domain=dev.myorganization.com # CHANGE
taito_default_cdn_domain=

# Cloud provider
taito_provider=azure
taito_provider_org_id=mytenant.onmicrosoft.com # CHANGE: Azure tenant
taito_provider_region=northeurope # CHANGE
# Billing account subscription id (Billing -> Subscriptions):
taito_provider_billing_account_id=a1234567-b123-c123-d123-e12345678901 # CHANGE

# Other providers
taito_uptime_provider=azure
taito_uptime_provider_org_id=$taito_provider_org_id
taito_uptime_channels=""
taito_container_registry_provider=azure
taito_container_registry="${taito_zone//-/}.azurecr.io/${taito_zone//-/}"
taito_ci_provider=azure
taito_ci_organization=$taito_organization  # e.g. Azure DevOps organization
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Settings
taito_devops_email=support@myorganization.com # CHANGE
# NOTE: Also CI/CD requires access if CI/CD is used for automatic deployment
taito_authorized_networks="0.0.0.0/0"
taito_provider_secrets_location=
taito_cicd_secrets_path=

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_projects_bucket=$taito_zone-projects
taito_public_bucket=$taito_zone-public

# Kubernetes
# NOTE: If you disable Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins.
kubernetes_name="common-kube"
kubernetes_cluster="${kubernetes_name}"
kubernetes_user="clusterUser_${taito_zone}_${kubernetes_cluster}"

# Default PostgreSQL cluster for new projects
postgres_default_name="$taito_zone-common-postgres"
postgres_default_host="$taito_zone-common-postgres.postgres.database.azure.com"
postgres_default_admin="${taito_zone_short}"
postgres_default_username_suffix="@$taito_zone-common-postgres"

# Secrets:
# - GitHub personal token for tagging releases (optional)
#   -> CHANGE: remove token if this zone is not used for production releases
taito_secrets="
  version-control-buildbot.token/devops:manual
"

# Messaging
# CHANGE: Set slack webhook and channels (optional)
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Links
link_urls="
  * dashboard=https://portal.azure.com/#@${taito_provider_org_id}/resource/subscriptions/${taito_provider_billing_account_id}/resourceGroups/${taito_zone}/overview Azure dashboard
"

set +a

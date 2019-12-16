#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="azure-zone terraform-zone kubectl-zone helm-zone links-global custom"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone

# Domains
taito_default_domain=dev.myorganization.com # CHANGE

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
taito_vc_organization=$taito_organization

# User rights. A set of user or group object ids, for example:
# taito_owners="
#   1234567a-123b-123c-123d-1e2345a6c7e8
#   3456789a-321b-321c-321d-3e5432a1c3e2
# "
taito_owners=
taito_developers=

# Settings
taito_devops_email=support@myorganization.com # CHANGE
# NOTE: Also CI/CD requires access if CI/CD is used for automatic deployment
taito_authorized_networks="0.0.0.0/0"

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_projects_bucket=$taito_zone-projects

# Kubernetes
# NOTE: If you disable Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins.
kubernetes_name="common-kube"
kubernetes_cluster="${kubernetes_name}"
kubernetes_user="clusterUser_${taito_zone}_${kubernetes_cluster}"
kubernetes_node_size=Standard_DS1_v2
kubernetes_node_count=1

# Helm (for Kubernetes)
helm_nginx_ingress_classes="nginx"
helm_nginx_ingress_replica_counts="${kubernetes_node_count}"

# Postgres clusters
postgres_instances="$taito_zone-common-postgres"
postgres_hosts="$taito_zone-common-postgres.postgres.database.azure.com"
postgres_admins="${taito_zone//-/}"
postgres_username_suffixes="@$taito_zone-common-postgres"
postgres_versions="11"
# See https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#compute-generations-vcores-and-memory
postgres_sku_tiers="GeneralPurpose"
postgres_sku_families="Gen5"
postgres_sku_names="GP_Gen5_2" # name=TIER_FAMILY_CORES
postgres_sku_capacities="2"
postgres_node_counts="1"
postgres_storage_sizes="10240" # Megabytes
postgres_auto_grows="Enabled"
postgres_backup_retention_days="7"
postgres_geo_redundant_backups="Disabled"

# TODO: MySQL

# Messaging
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

#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# CHANGE: If you want to enable VPN, you must do the following:
# - Add 'vpn' to taito_plugins
# - Set taito_vpn_enabled to true
# - Enable VPN in terraform/vpn.tf
# - Set 'privateClusterEnabled: true' in kubernetes.yaml

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  azure-zone azure-secrets
  terraform-zone
  kubectl-zone helm-zone
  generate-secrets links-global custom
  postgres-db mysql-db
"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE

# Zone settings
taito_zone=my-zone
taito_zone_short="${taito_zone//-/}"
taito_zone_multi_tenant=false # Not supported yet
taito_vpn_enabled=false # CHANGE
taito_devops_email=support@myorganization.com # CHANGE
taito_default_domain=${taito_zone}.myorganization.com # CHANGE
taito_default_cdn_domain=

# Zone buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=${taito_zone_short}state
taito_function_bucket=${taito_zone_short}function
taito_backup_bucket=${taito_zone_short}backup
taito_public_bucket=${taito_zone_short}public
taito_projects_bucket=${taito_zone_short}projects

# Cloud provider
taito_provider=azure
taito_provider_org_id=mytenant.onmicrosoft.com # CHANGE: Azure tenant
taito_provider_region=westeurope # CHANGE
# Billing account subscription id (Billing -> Subscriptions):
taito_provider_billing_account_id=a1234567-b123-c123-d123-e12345678901 # CHANGE
taito_provider_secrets_location=
taito_provider_secrets_mode=backup
taito_cicd_secrets_path=

# Container registry provider
taito_container_registry_provider=azure
taito_container_registry_provider_url=
taito_container_registry_organization=$taito_organization
taito_container_registry="${taito_zone//-/}.azurecr.io/${taito_zone//-/}"

# CI/CD provider
taito_ci_provider=github  # NOTE: Set to "azure" if you want to use Azure DevOps instead
taito_ci_provider_url=
taito_ci_organization=$taito_organization  # CHANGE: e.g. GitHub organization or Azure DevOps organization

# Version control provider
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Uptime monitoring provider
taito_uptime_provider=azure
taito_uptime_provider_url=
taito_uptime_provider_org_id=$taito_provider_org_id
taito_uptime_channels=""

# Error tracking provider
taito_tracking_provider=sentry
taito_tracking_provider_url=
taito_tracking_organization=$taito_organization

# Distributed tracing provider
taito_tracing_provider=jaeger
taito_tracing_provider_url=https://jaeger.${taito_default_domain}
taito_tracing_organization=$taito_organization

# Messaging provider
# CHANGE: Set slack webhook and channels (optional)
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Default Kubernetes cluster for new projects
# NOTE: If you remove Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins
kubernetes_name="common-kube"
kubernetes_network_policy_provider=azure
kubernetes_cluster="${kubernetes_name}"
kubernetes_user="clusterUser_${taito_zone}_${kubernetes_cluster}"
kubernetes_admin="clusterAdmin_${taito_zone}_${kubernetes_cluster}"
if [[ ${taito_vpn_enabled} == "true" ]]; then
  kubernetes_db_proxy_enabled=false
else
  kubernetes_db_proxy_enabled=true
fi

# Databases
taito_databases="commonpg commonmysql"

# Database: PostgreSQL
db_commonpg_type=pg
db_commonpg_instance=$taito_zone-postgres
db_commonpg_name=postgres
db_commonpg_host="127.0.0.1"
db_commonpg_port=5001
db_commonpg_real_host="POSTGRES_HOST"
db_commonpg_real_port="5432"
db_commonpg_ssl_enabled="true"
db_commonpg_ssl_client_cert_enabled="false"
db_commonpg_ssl_server_cert_enabled="false"
db_commonpg_proxy_ssl_enabled="true"
db_commonpg_username=postgres
db_commonpg_username_suffix="@$taito_zone-postgres"

# Database: MySQL
db_commonmysql_type=mysql
db_commonmysql_instance=$taito_zone-mysql
db_commonmysql_name=mysql
db_commonmysql_host="127.0.0.1"
db_commonmysql_port=6001
db_commonmysql_real_host="MYSQL_HOST"
db_commonmysql_real_port="3306"
db_commonmysql_ssl_enabled="true"
db_commonmysql_ssl_client_cert_enabled="false"
db_commonmysql_ssl_server_cert_enabled="false"
db_commonmysql_proxy_ssl_enabled="true"
db_commonmysql_username=mysql
db_commonmysql_username_suffix="@$taito_zone-mysql"

# Default PostgreSQL cluster for new projects
postgres_default_name=$db_commonpg_instance
postgres_default_host=$db_commonpg_real_host
postgres_default_admin=$db_commonpg_username
postgres_default_username_suffix=$db_commonpg_username_suffix
postgres_ssl_client_cert_enabled=$db_commonpg_ssl_client_cert_enabled
postgres_ssl_server_cert_enabled=$db_commonpg_ssl_server_cert_enabled
postgres_proxy_ssl_enabled=$db_commonpg_proxy_ssl_enabled

# Default MySQL cluster for new projects
mysql_default_name=$db_commonmysql_instance
mysql_default_host=$db_commonmysql_real_host
mysql_default_admin=$db_commonmysql_username
mysql_default_username_suffix=$db_commonpg_username_suffix
mysql_ssl_client_cert_enabled=$db_commonmysql_ssl_client_cert_enabled
mysql_ssl_server_cert_enabled=$db_commonmysql_ssl_server_cert_enabled
mysql_proxy_ssl_enabled=$db_commonmysql_proxy_ssl_enabled

# Secrets
taito_secrets="
  ${taito_secrets}
  common-example-secret.key/common:random
"

# Links
# TODO: more links
link_urls="
  * dashboard=https://portal.azure.com/#@${taito_provider_org_id}/resource/subscriptions/${taito_provider_billing_account_id}/resourceGroups/${taito_zone}/overview Azure dashboard
"

set +a

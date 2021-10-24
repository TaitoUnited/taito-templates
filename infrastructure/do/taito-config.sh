#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# TODO: Digital Ocean example is incomplete. It lacks container registry.

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  do-zone do-secrets
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
taito_vpn_enabled=false # Not supported yet
taito_devops_email=support@myorganization.com # CHANGE
taito_default_domain=${taito_zone}.myorganization.com # CHANGE
taito_default_cdn_domain=

# Zone buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_function_bucket=$taito_zone-function
taito_backup_bucket=$taito_zone-backup
taito_public_bucket=$taito_zone-public
taito_projects_bucket=$taito_zone-projects

# Cloud provider
taito_provider="do"
taito_provider_org_id=123456
taito_provider_region=ams3 # CHANGE
taito_provider_secrets_location=
taito_provider_secrets_mode=backup
taito_cicd_secrets_path=

# Container registry provider
taito_container_registry_provider="do"
taito_container_registry_provider_url=
taito_container_registry_organization=$taito_organization
taito_container_registry=registry.digitalocean.com/CONTAINER_REGISTRY

# CI/CD provider
taito_ci_provider=github  # NOTE: Set to "azure" if you want to use Azure DevOps instead
taito_ci_provider_url=
taito_ci_organization=$taito_organization  # e.g. GitHub organization or Azure DevOps organization

# Version control provider
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Uptime monitoring provider
# TODO: Uptime provider for DO
taito_uptime_provider=
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

# Kubernetes
# NOTE: If you disable Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins.
kubernetes_name="$taito_zone-kube"
kubernetes_cluster_prefix="do-${taito_provider_region}-"
kubernetes_cluster="${kubernetes_cluster_prefix}${kubernetes_name}"
kubernetes_user="${kubernetes_cluster}-admin"
kubernetes_db_proxy_enabled=true

# Databases
taito_databases="commonpg commonmysql"

# Database: PostgreSQL
# TODO: prevent access to public endpoint on DO UI (or with terraform if supported)
db_commonpg_type=pg
db_commonpg_instance=$taito_zone-postgres
db_commonpg_name=postgres
db_commonpg_host="127.0.0.1"
db_commonpg_port=5001
db_commonpg_real_host="POSTGRES_HOST" # private-$taito_zone-postgres-do-user-${taito_provider_org_id}-0.db.ondigitalocean.com
db_commonpg_real_port="25060"
db_commonpg_ssl_enabled="true"
db_commonpg_ssl_client_cert_enabled="false"
db_commonpg_ssl_server_cert_enabled="false"
db_commonpg_proxy_ssl_enabled="true"
db_commonpg_username=postgres
db_commonpg_username_suffix="@$taito_zone-postgres"

# Database: MySQL
# TODO: prevent access to public endpoint on DO UI (or with terraform if supported)
db_commonmysql_type=mysql
db_commonmysql_instance=$taito_zone-mysql
db_commonmysql_name=mysql
db_commonmysql_host="127.0.0.1"
db_commonmysql_port=6001
db_commonmysql_real_host="MYSQL_HOST" # private-$taito_zone-mysql-do-user-${taito_provider_org_id}-0.db.ondigitalocean.com
db_commonmysql_real_port="25060"
db_commonmysql_ssl_enabled="true"
db_commonmysql_ssl_client_cert_enabled="false"
db_commonmysql_ssl_server_cert_enabled="false"
db_commonmysql_proxy_ssl_enabled="true"
db_commonmysql_username=mysql
db_commonmysql_username_suffix="@$taito_zone-mysql"

# Default PostgreSQL cluster for new projects
postgres_default_name=$db_commonpg_instance
postgres_default_host=$db_commonpg_real_host
postgres_default_port=$db_commonpg_real_port
postgres_default_admin=$db_commonpg_username
postgres_default_username_suffix=$db_commonpg_username_suffix
postgres_ssl_client_cert_enabled=$db_commonpg_ssl_client_cert_enabled
postgres_ssl_server_cert_enabled=$db_commonpg_ssl_server_cert_enabled
postgres_proxy_ssl_enabled=$db_commonpg_proxy_ssl_enabled

# Default MySQL cluster for new projects
mysql_default_name=$db_commonmysql_instance
mysql_default_host=$db_commonmysql_real_host
mysql_default_port=$db_commonmysql_real_port
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
link_urls="
  * dashboard=https://cloud.digitalocean.com Digital Ocean Dashboard
  * kubernetes=https://cloud.digitalocean.com/kubernetes/clusters Kubernetes clusters
  * databases=https://cloud.digitalocean.com/databases/ Database clusters
  * registry=https://cloud.digitalocean.com/images/container-registry Container registry
"

set +a

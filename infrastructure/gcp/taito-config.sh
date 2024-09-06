#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  gcp-zone gcp-secrets
  terraform-zone
  kubectl-zone helm-zone
  generate-secrets links-global custom
  postgres-db mysql-db
"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg     # CHANGE

# Zone settings
taito_zone=my-zone
taito_zone_short="${taito_zone//-/}"
taito_zone_multi_tenant=false
taito_devops_email=support@myorganization.com # CHANGE
taito_default_domain=dev.myorganization.com   # CHANGE
taito_default_cdn_domain=

# Zone buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_function_bucket=$taito_zone-function
taito_backup_bucket=$taito_zone-backup
taito_public_bucket=$taito_zone-public
taito_projects_bucket=$taito_zone-projects

# Cloud provider
taito_provider=gcp
# CHANGE: Set org_id and org_domain, or leave them empty for 'no organization'.
# Note that kubernetes.authenticatorSecurityGroup (kubernetes.yaml) should be
# set to "" for 'no organization'
taito_provider_org_id=0123456789
taito_provider_org_domain=myorganization.com
taito_provider_billing_account_id=1234AB-1234AB-1234AB # CHANGE
taito_provider_taito_zone_id=TAITO_PROVIDER_TAITO_ZONE_ID
taito_provider_region=europe-west4 # CHANGE
taito_provider_zone=europe-west4-b # CHANGE
taito_provider_secrets_location=taito_resource_namespace_id
taito_provider_secrets_mode=backup
taito_cicd_secrets_path=

# Container registry provider
taito_container_registry_provider=gcp
taito_container_registry_provider_url=
taito_container_registry_organization=$taito_organization
taito_container_registry=eu.gcr.io/$taito_zone

# CI/CD provider
taito_ci_provider=gcp
taito_ci_provider_url=
taito_ci_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Version control provider
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Uptime monitoring provider
taito_uptime_provider=gcp
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
# taito_plugins and kubernetes module from terraform/main.tf
kubernetes_name="common-kube"
kubernetes_regional=false
kubernetes_cluster_prefix=gke_${taito_zone}_${taito_provider_zone}_
if [[ ${kubernetes_regional} == true ]]; then
  kubernetes_cluster_prefix=gke_${taito_zone}_${taito_provider_region}_
fi
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster

# Databases
taito_databases="commonpg commonmysql"
# kubernetes_db_proxy_enabled=true

# Database: common-postgres
db_commonpg_type=pg
db_commonpg_instance=common-postgres
db_commonpg_name=postgres
db_commonpg_host="127.0.0.1"
db_commonpg_port=5001
db_commonpg_real_host="POSTGRES_HOST"
db_commonpg_real_port="5432"
db_commonpg_ssl_enabled="true"
db_commonpg_ssl_client_cert_enabled="true"
db_commonpg_ssl_server_cert_enabled="true"
db_commonpg_proxy_ssl_enabled="true"
db_commonpg_username=postgres
taito_secrets="
  ${taito_secrets}
  common-postgres-db-ssl.ca/common:file
  common-postgres-db-ssl.cert/common:file
  common-postgres-db-ssl.key/common:file
"

# Database: common-postgres
db_commonmysql_type=mysql
db_commonmysql_instance=common-mysql
db_commonmysql_name=mysql
db_commonmysql_host="127.0.0.1"
db_commonmysql_port=6001
db_commonmysql_real_host="MYSQL_HOST"
db_commonmysql_real_port="3306"
db_commonmysql_ssl_enabled="true"
db_commonmysql_ssl_client_cert_enabled="true"
db_commonmysql_ssl_server_cert_enabled="true"
db_commonmysql_proxy_ssl_enabled="true"
db_commonmysql_username="${taito_zone_short}"
taito_secrets="
  ${taito_secrets}
  common-mysql-db-ssl.ca/common:file
  common-mysql-db-ssl.cert/common:file
  common-mysql-db-ssl.key/common:file
"

# Default PostgreSQL cluster for new projects
postgres_default_name=$db_commonpg_instance
postgres_default_host=$db_commonpg_real_host
postgres_default_admin=$db_commonpg_username
postgres_ssl_client_cert_enabled=$db_commonpg_ssl_client_cert_enabled
postgres_ssl_server_cert_enabled=$db_commonpg_ssl_server_cert_enabled
postgres_proxy_ssl_enabled=$db_commonpg_proxy_ssl_enabled

# Default MySQL cluster for new projects
mysql_default_name=$db_commonmysql_instance
mysql_default_host=$db_commonmysql_real_host
mysql_default_admin=$db_commonmysql_username
mysql_ssl_client_cert_enabled="true"
mysql_ssl_server_cert_enabled="true"
mysql_proxy_ssl_enabled="true"

# Default binary authentication for new projects
binauthz_attestor=
binauthz_secret_name=
binauthz_public_key_id=

# Secrets
# CHANGE: remove CI/CD tester service account if this zone is not used for testing
taito_secrets="
  ${taito_secrets}
  cicd-tester-serviceaccount.key/common:file
"
if [[ $taito_zone_multi_tenant != true ]]; then
  # - GitHub personal token for tagging releases (optional)
  #   -> CHANGE: remove token if this zone is not used for production releases
  taito_secrets="
    ${taito_secrets}
    version-control-buildbot.token/common:manual
  "
fi

# Links
link_urls="
  * state=https://console.cloud.google.com/storage/browser/$taito_state_bucket?project=$taito_zone Terraform state
  * images=https://console.cloud.google.com/gcr/images/$taito_zone Docker images
  * projects=https://console.cloud.google.com/storage/browser/$taito_projects_bucket?project=$taito_zone Google projects
  * dashboard=https://console.cloud.google.com/apis/dashboard?project=${taito_zone} Google Cloud Dashboard
  * kubernetes=https://console.cloud.google.com/kubernetes/list?project=${taito_zone} Kubernetes clusters
  * databases=https://console.cloud.google.com/sql/instances?project=${taito_zone} Database clusters
  * logs=https://console.cloud.google.com/logs/viewer?project=${taito_zone} Logs
  * networking=https://console.cloud.google.com/networking/addresses/list?project=${taito_zone} Google Cloud networking
"

set +a

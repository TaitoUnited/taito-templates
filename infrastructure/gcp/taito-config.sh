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
"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg     # CHANGE
taito_zone=my-zone
taito_zone_short="${taito_zone//-/}"

# Domains
taito_default_domain=dev.myorganization.com      # CHANGE
taito_default_cdn_domain=

# Cloud provider
taito_provider=gcp
taito_provider_org_domain=myorganization.com     # CHANGE: leave empty for 'no organization'
taito_provider_org_id=0123456789 # CHANGE: leave empty for 'no organization'
taito_provider_billing_account_id=1234AB-1234AB-1234AB # CHANGE
taito_provider_region=europe-west1
taito_provider_zone=europe-west1-b

# Other providers
taito_uptime_provider=gcp
taito_uptime_provider_org_id=$taito_provider_org_id
taito_uptime_channels=""
taito_container_registry_provider=gcp
taito_container_registry=eu.gcr.io/$taito_zone
taito_ci_provider=gcp
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Settings
taito_devops_email=support@myorganization.com # CHANGE
taito_cicd_cloud_deploy_enabled=true
taito_cicd_testing_enabled=true
taito_provider_secrets_location=taito_resource_namespace_id
taito_cicd_secrets_path=

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_public_bucket=$taito_zone-public

# Kubernetes
# NOTE: If you remove Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins and kubernetes module from terraform/main.tf
kubernetes_name="common-kube"
kubernetes_cluster_prefix=gke_${taito_zone}_${taito_provider_region}_
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster

# Default PostgreSQL cluster for new projects
postgres_default_name="common-postgres"
postgres_default_host="POSTGRES_HOSTS"
postgres_default_admin="${taito_zone_short}"
postgres_ssl_client_cert_enabled="true"
postgres_ssl_server_cert_enabled="true"
postgres_proxy_ssl_enabled="false"  # Accessed with GCP db proxy
taito_secrets="
  ${taito_secrets}
  common-postgres-ssl.ca/devops:file
  common-postgres-ssl.cert/devops:file
  common-postgres-ssl.key/devops:file
"

# Default MySQL cluster for new projects
mysql_default_name="common-mysql"
mysql_default_host="MYSQL_HOSTS"
mysql_default_admin="${taito_zone_short}"
mysql_ssl_client_cert_enabled="true"
mysql_ssl_server_cert_enabled="true"
mysql_proxy_ssl_enabled="false"  # Accessed with GCP db proxy
taito_secrets="
  ${taito_secrets}
  common-mysql-ssl.ca/devops:file
  common-mysql-ssl.cert/devops:file
  common-mysql-ssl.key/devops:file
"

# Secrets:
# - GitHub personal token for tagging releases (optional)
#   -> CHANGE: remove token if this zone is not used for production releases
# - Database proxy service account
# - CI/CD tester services account
taito_secrets="
  version-control-buildbot.token/devops:manual
  database-proxy-serviceaccount.key/db-proxy:file
  cicd-tester-serviceaccount.key/devops:file
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

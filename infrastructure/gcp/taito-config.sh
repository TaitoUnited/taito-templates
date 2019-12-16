#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  gcp-zone generate-secrets
  terraform-zone
  kubectl-zone helm-zone
  links-global custom
"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone

# Domains
taito_default_domain=dev.myorganization.com # CHANGE

# Cloud provider
taito_provider=gcp
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
taito_vc_organization=$taito_organization

# User rights, for example:
# taito_developers="
#   user:john.doe@gmail.com
#   domain:mydomain.com
# "
# CHANGE: add yourself as an owner "user:my.name@mydomain.com"
taito_owners=
taito_editors=
taito_viewers=
taito_developers=
taito_externals=

# Settings
taito_devops_email=support@myorganization.com # CHANGE
taito_cicd_deploy_enabled=true
taito_archive_day_limit=60
taito_enable_private_google_services=true

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_projects_bucket=$taito_zone-projects
taito_assets_bucket=$taito_zone-assets

# Kubernetes
# NOTE: If you disable Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins.
kubernetes_name="common-kube"
#kubernetes_zones=  # Provide zones if ZONAL instead of REGIONAL
# NOTE: Also CI/CD requires access if CI/CD is used for automatic deployment
kubernetes_authorized_networks="0.0.0.0/0"
kubernetes_release_channel=STABLE  # UNSPECIFIED, RAPID, REGULAR, STABLE
kubernetes_cluster_prefix=gke_${taito_zone}_${taito_provider_region}_
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster
kubernetes_machine_type=n1-standard-1
kubernetes_disk_size_gb=100
# NOTE: On Google Cloud total number of nodes = node_count * num_of_zones
kubernetes_min_node_count=1
kubernetes_max_node_count=1
kubernetes_rbac_security_group=
kubernetes_private_nodes=true
kubernetes_shielded_nodes=true
kubernetes_network_policy=false
kubernetes_db_encryption=false
kubernetes_pod_security_policy=false  # NOTE: not supported yet
kubernetes_istio=false
kubernetes_cloudrun=false

# Helm applications for Kubernetes
helm_nginx_ingress_classes="nginx"
helm_nginx_ingress_replica_counts="$(expr ${kubernetes_min_node_count} \* 3)"

# Postgres clusters
postgres_instances="common-postgres"
postgres_hosts="POSTGRES_HOSTS"
postgres_versions="POSTGRES_11"
postgres_tiers="db-f1-micro"
postgres_high_availability="true"
postgres_public_ip=false
#postgres_authorized_networks=
postgres_ssl_client_cert_enabled="true"
postgres_proxy_ssl_enabled="false"  # Accessed with GCP db proxy
taito_secrets="
  ${taito_secrets}
  common-postgres-ssl.ca/devops:file
  common-postgres-ssl.cert/devops:file
  common-postgres-ssl.key/devops:file
"

# MySQL clusters
mysql_instances="common-mysql"
mysql_hosts="MYSQL_HOSTS"
mysql_versions="MYSQL_5_7"
mysql_tiers="db-f1-micro"
mysql_admins="${taito_zone//-/}"
mysql_public_ip=false
#mysql_authorized_networks=
mysql_ssl_client_cert_enabled="true"
mysql_proxy_ssl_enabled="false"  # Accessed with GCP db proxy
taito_secrets="
  ${taito_secrets}
  common-mysql-ssl.ca/devops:file
  common-mysql-ssl.cert/devops:file
  common-mysql-ssl.key/devops:file
"

# Secrets
taito_secrets="
  ${taito_secrets}
  database-proxy-serviceaccount.key/db-proxy:file
  cicd-tester-serviceaccount.key/devops:file
"

# Messaging
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

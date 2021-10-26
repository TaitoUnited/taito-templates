#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# CHANGE: For serverless infrastucture (no Kubernetes) you should do the
# following changes:
# - Remove kubectl-zone and helm-zone from taito_plugins
# - Remove kubernetes_* settings from this file
# - Delete kubernetes.yaml and kubernetes-permissions.yaml files
# - Enable bastion host by setting taito_bastion_enabled=true
# - Set empty value to taito_provider_secrets_mode
# - Uncomment DNS settings in dns.yaml

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
# TODO: aws-secrets should use secret manager
taito_plugins="
  aws-zone aws-secrets
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
taito_bastion_enabled=false
taito_bastion_public_ip=TAITO_BASTION_PUBLIC_IP
taito_devops_email=support@myorganization.com # CHANGE
taito_default_domain=${taito_zone}.myorganization.com # CHANGE
taito_default_cdn_domain= # was $taito_zone-public.s3.amazonaws.com

# Zone buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_function_bucket=$taito_zone-function
taito_backup_bucket=$taito_zone-backup
taito_public_bucket=$taito_zone-public
taito_projects_bucket=$taito_zone-projects

# Cloud provider
taito_provider=aws
taito_provider_org_id=0123456789 # CHANGE: AWS account id
taito_provider_region=us-east-1 # CHANGE
taito_provider_zone=us-east-1a # CHANGE
taito_provider_secrets_location=$taito_zone
taito_provider_secrets_mode=backup
taito_cicd_secrets_path=

# Container registry provider
taito_container_registry_provider=aws
taito_container_registry_provider_url=
taito_container_registry_organization=$taito_organization
taito_container_registry=${taito_provider_org_id}.dkr.ecr.${taito_provider_region}.amazonaws.com

# CI/CD provider
taito_ci_provider=github  # NOTE: Set to "azure" if you want to use Azure DevOps instead
taito_ci_provider_url=
taito_ci_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Version control provider
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization  # CHANGE: e.g. GitHub organization or username

# Uptime monitoring provider
taito_uptime_provider=aws
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
taito_messaging_uptime_channels="arn:aws:sns:${taito_provider_region}:${taito_provider_org_id}:${taito_zone}-uptimez"

# Default network settings for new projects
taito_network_tags="{ Name = \"${taito_zone}-vpc\" }"
taito_function_subnet_tags='{ tier = "private" }'
taito_function_security_group_tags='{}'
taito_cache_subnet_tags='{ tier = "elasticache" }'
taito_cache_security_group_tags='{}'

# Default policies for new projects
taito_gateway_policies="[]"
taito_cicd_policies="[]"

# Default Kubernetes cluster for new projects
# NOTE: If you remove Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins
kubernetes_name="$taito_zone-common-kube"
kubernetes_cluster_prefix=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster
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
db_commonpg_real_host="POSTGRES_HOST" # ${taito_zone}-common-postgres.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com
db_commonpg_real_port="5432"
db_commonpg_ssl_enabled="true"
db_commonpg_ssl_client_cert_enabled="false"
db_commonpg_ssl_server_cert_enabled="true"
db_commonpg_proxy_ssl_enabled="true"
db_commonpg_username=${taito_zone_short}
db_commonpg_username_suffix=

# Database: MySQL
db_commonmysql_type=mysql
db_commonmysql_instance=$taito_zone-mysql
db_commonmysql_name=mysql
db_commonmysql_host="127.0.0.1"
db_commonmysql_port=6001
db_commonmysql_real_host="MYSQL_HOST" # ${taito_zone}-common-mysql.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com
db_commonmysql_real_port="3306"
db_commonmysql_ssl_enabled="true"
db_commonmysql_ssl_client_cert_enabled="false"
db_commonmysql_ssl_server_cert_enabled="true"
db_commonmysql_proxy_ssl_enabled="true"
db_commonmysql_username=${taito_zone_short}
db_commonmysql_username_suffix=

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

# Secrets:
# - Database certificates
taito_secrets="
  $db_commonpg_instance-db-ssl.ca/common:file
  $db_commonmysql_instance-mysql-db-ssl.ca/common:file
"

# Links
link_urls="
  * state=https://s3.console.aws.amazon.com/s3/buckets/$taito_state_bucket/ Terraform state
  * images=https://console.aws.amazon.com/ecr/repositories?region=${taito_provider_region} Docker images
  * projects=https://s3.console.aws.amazon.com/s3/buckets/$taito_projects_bucket/ projects
  * dashboard=https://${taito_provider_region}.console.aws.amazon.com/console/home?region=${taito_provider_region} AWS Management Console
  * kubernetes=https://${taito_provider_region}.console.aws.amazon.com/eks/home?region=${taito_provider_region}#/clusters/${kubernetes_cluster} Kubernetes clusters
  * nodes=https://${taito_provider_region}.console.aws.amazon.com/ec2/v2/home?region=${taito_provider_region}#Instances:search=${kubernetes_cluster};sort=instanceId Kubernetes nodes
  * databases=https://console.aws.amazon.com/rds/home?region=${taito_provider_region}#databases: Database clusters
  * logs=https://${taito_provider_region}.console.aws.amazon.com/cloudwatch/home?region=${taito_provider_region}#logs: Logs
"

set +a

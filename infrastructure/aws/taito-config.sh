#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# CHANGE: For serverless infrastucture (no Kubernetes) you should do the
# following changes:
# - Remove kubectl-zone and helm-zone from taito_plugins
# - Remove kubernetes settings from taito-config.sh and terraform.yaml
# - Use serverless submodule in main.tf source:
#   TaitoUnited/kubernetes-infrastructure/aws//modules/serverless

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="
  aws-zone aws-secrets
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
taito_default_cdn_domain=$taito_zone-public.s3.amazonaws.com

# Cloud provider
taito_provider=aws
taito_provider_org_id=0123456789 # CHANGE: AWS account id
taito_provider_region_hexchars=TAITO_PROVIDER_REGION_HEXCHARS
taito_provider_region=us-east-1 # CHANGE
taito_provider_zone=us-east-1a # CHANGE

# Other providers
taito_uptime_provider=aws
taito_uptime_provider_org_id=$taito_provider_org_id
taito_container_registry_provider=aws
taito_container_registry=${taito_provider_org_id}.dkr.ecr.${taito_provider_region}.amazonaws.com
taito_ci_provider=aws
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization

# Settings
taito_devops_email=support@myorganization.com # CHANGE
taito_bastion_public_ip=TAITO_BASTION_PUBLIC_IP
taito_archive_day_limit=60
taito_provider_secrets_location=$taito_zone
taito_cicd_secrets_path=

# Network
taito_network_tags="{ name = \"${taito_zone}\" }"
taito_function_subnet_tags='{ tier = "private" }'
taito_function_security_group_tags='{ group-name = "default" }' # TODO
taito_cache_subnet_tags='{ tier = "elasticache" }'
taito_cache_security_group_tags='{ group-name = "default" }' # TODO

# Policies
taito_gateway_policies='[]'
taito_cicd_policies="[
  \"arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser\",
  \"arn:aws:iam::$taito_provider_org_id:policy/$taito_zone-serverlessdeployer\",
  \"arn:aws:iam::$taito_provider_org_id:policy/$taito_zone-devopssecretreader\"
]"

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_projects_bucket=$taito_zone-projects
taito_public_bucket=$taito_zone-public

# Kubernetes
kubernetes_name="$taito_zone-common-kube"
kubernetes_cluster_prefix=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster

# Default PostgreSQL cluster for new projects
postgres_default_name="$taito_zone-common-postgres"
postgres_default_host="${taito_zone}-common-postgres.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
postgres_default_admin="${taito_zone_short}"
postgres_ssl_server_cert_enabled="true"

# Default MySQL cluster for new projects
mysql_default_name="$taito_zone-common-mysql"
mysql_default_host="${taito_zone}-common-mysql.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
mysql_default_admin="${taito_zone_short}"
mysql_ssl_server_cert_enabled="true"

# Secrets:
# - GitHub personal token for tagging releases (optional)
#   -> CHANGE: remove token if this zone is not used for production releases
# - Database certificates
taito_secrets="
  version-control-buildbot.token/devops:manual
  $taito_zone-common-postgres-ssl.ca/devops:file
  $taito_zone-common-mysql-ssl.ca/devops:file
"

# Messaging
# CHANGE: Set slack webhook and channels (optional)
taito_messaging_app=slack
taito_messaging_webhook=https://hooks.slack.com/services/AAA/BBB/CCC
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring
taito_messaging_uptime_channels="arn:aws:sns:${taito_provider_region}:${taito_provider_org_id}:${taito_zone}-uptimez"

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

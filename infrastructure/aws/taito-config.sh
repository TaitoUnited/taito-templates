#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# CHANGE: For serverless infrastucture (no Kubernetes) you should do the
# following changes:
# - Remove kubectl-zone and helm-zone from taito_plugins
# - Define taito_authorized_networks as IP addresses instead of CIDRs
# - Use serverless submodule in main.tf source:
#   TaitoUnited/kubernetes-infrastructure/aws//modules/serverless

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="aws-zone terraform-zone kubectl-zone helm-zone links-global custom"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone
taito_provider_secrets_location=$taito_zone

# Domains
taito_default_domain=dev.myorganization.com # CHANGE
taito_default_cdn_domain=$taito_zone-assets.s3.amazonaws.com

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

# User rights, for example:
# taito_developers="
#   arn:aws:iam::${taito_provider_org_id}:user/john-doe
#   arn:aws:iam::${taito_provider_org_id}:user/jane-doe
# "
taito_developers=

# Settings
taito_devops_email=support@myorganization.com # CHANGE
# NOTE: Also CI/CD requires access if CI/CD is used for automatic deployment
# TODO: restrict access to VPC resources on AWS
# taito_authorized_networks="0.0.0.0/0"
taito_bastion_public_ip=TAITO_BASTION_PUBLIC_IP
taito_archive_day_limit=60

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state
taito_projects_bucket=$taito_zone-projects
taito_assets_bucket=$taito_zone-assets

# Kubernetes
kubernetes_name="$taito_zone-common-kube"
kubernetes_cluster_prefix=arn:aws:eks:$taito_provider_region:$taito_provider_org_id:cluster/
kubernetes_cluster=${kubernetes_cluster_prefix}${kubernetes_name}
kubernetes_user=$kubernetes_cluster
kubernetes_machine_type=t3.medium # e.g. t2.small, t3.small, t3.medium
kubernetes_disk_size_gb=100
kubernetes_min_node_count=2
kubernetes_max_node_count=2

# Helm (for Kubernetes)
helm_nginx_ingress_classes="nginx"
helm_nginx_ingress_replica_counts="${kubernetes_min_node_count}"

# Postgres clusters
postgres_instances="$taito_zone-common-postgres"
postgres_hosts="${taito_zone}-common-postgres.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
postgres_tiers="db.t3.medium"
postgres_sizes="20"
postgres_admins="${taito_zone//-/}"
postgres_ssl_server_cert_enabled="true"
taito_secrets="
  ${taito_secrets}
  $taito_zone-common-postgres-ssl.ca/devops:file
"

# MySQL clusters
mysql_instances="$taito_zone-common-mysql"
mysql_hosts="${taito_zone}-common-mysql.${taito_provider_region_hexchars}.${taito_provider_region}.rds.amazonaws.com"
mysql_tiers="db.t3.medium"
mysql_sizes="20"
mysql_admins="${taito_zone//-/}"
mysql_ssl_server_cert_enabled="true"
taito_secrets="
  ${taito_secrets}
  $taito_zone-common-mysql-ssl.ca/devops:file
"

# Messaging
# TODO: implement for AWS
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

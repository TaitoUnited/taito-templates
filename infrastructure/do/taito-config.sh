#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# NOTE: Digital Ocean example is incomplete. It lacks container registry.

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="do-zone terraform-zone kubectl-zone helm-zone links-global custom"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone

# Domains
taito_default_domain=dev.myorganization.com # CHANGE

# Cloud provider
taito_provider="do"
taito_provider_org_id=123456
taito_provider_region=ams3

# Other providers
# TODO: Uptime provider for DO
# TODO: Use Digital Ocean as taito_container_registry_provider by default
# TODO: Use GitHub actions as taito_ci_provider by default
taito_uptime_provider=
taito_uptime_provider_org_id=
taito_uptime_channels=""
taito_container_registry_provider="do"
taito_container_registry=registry.digitalocean.com/CONTAINER_REGISTRY
taito_ci_provider=github
taito_ci_organization=$taito_organization
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization

# TODO: Users

# Settings
taito_devops_email=support@myorganization.com # CHANGE

# Buckets
# NOTE: State bucket name also in terraform/main.tf file (terraform backend)
taito_state_bucket=$taito_zone-state

# Kubernetes
# NOTE: If you disable Kubernetes, remove also kubectl-zone and helm-zone from
# taito_plugins.
kubernetes_name="$taito_zone-kube"
kubernetes_version="1.16.2-do.1"
kubernetes_cluster_prefix="do-${taito_provider_region}-"
kubernetes_cluster="${kubernetes_cluster_prefix}${kubernetes_name}"
kubernetes_user="${kubernetes_cluster}-admin"
kubernetes_node_size=s-2vcpu-2gb
kubernetes_node_count=1

# Helm (for Kubernetes)
helm_nginx_ingress_classes="nginx"
helm_nginx_ingress_replica_counts="${kubernetes_node_count}"

# Postgres clusters
# TODO: prevent access to public endpoint on DO UI (or with terraform if supported)
postgres_instances="$taito_zone-postgres"
postgres_hosts="private-$taito_zone-postgres-do-user-${taito_provider_org_id}-0.db.ondigitalocean.com"
postgres_ports="25060"
postgres_node_sizes="db-s-1vcpu-1gb"
postgres_node_counts="1"

# MySQL clusters
# TODO: prevent access to public endpoint on DO UI (or with terraform if supported)
mysql_instances="$taito_zone-mysql"
mysql_hosts="private-$taito_zone-mysql-do-user-${taito_provider_org_id}-0.db.ondigitalocean.com"
mysql_ports="25060"
mysql_node_sizes="db-s-1vcpu-1gb"
mysql_node_counts="1"

# Messaging
# TODO: not used yet
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Links
link_urls="
  * dashboard=https://cloud.digitalocean.com Digital Ocean Dashboard
  * kubernetes=https://cloud.digitalocean.com/kubernetes/clusters Kubernetes clusters
  * databases=https://cloud.digitalocean.com/databases/ Database clusters
  * registry=https://cloud.digitalocean.com/images/container-registry Container registry
"

set +a

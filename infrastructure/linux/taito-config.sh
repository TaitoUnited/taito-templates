#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# Network Access - Configure authorized networks in:
# - ansible-playbooks/group_vars/all

# User Rights - Configure user rights in:
# - ansible-playbooks/group_vars/development   # CHANGE
# - ansible-playbooks/group_vars/production    # CHANGE

# Service Accounts - Configure service authentication in:
# - ansible-playbooks/files/docker/config.json # CHANGE

# Servers - Configure servers in:
# - ansible-playbookss/development             # CHANGE
# - ansible-playbookss/production

# Taito CLI
taito_version=1
taito_type=zone
# TODO: custom extension -> taito_extensions="./extension"
taito_plugins="ansible-zone links-global custom"

# Labeling
taito_organization=myorganization             # CHANGE
taito_organization_abbr=myorg                 # CHANGE

# Zone settings
taito_zone=my-zone
taito_zone_short="${taito_zone//-/}"
taito_zone_multi_tenant=false
taito_devops_email=support@myorganization.com # CHANGE
taito_default_domain=dev1.mydomain.com        # CHANGE
taito_default_domain_prod=prod1.mydomain.com  # CHANGE
taito_default_cdn_domain=

# Zone buckets
taito_state_bucket=$taito_zone-state
taito_function_bucket=$taito_zone-function
taito_backup_bucket=$taito_zone-backup
taito_public_bucket=$taito_zone-public
taito_projects_bucket=$taito_zone-projects

# Cloud provider
taito_provider=linux

# Container registry provider
taito_container_registry_provider=github
taito_container_registry_provider_url=
taito_container_registry_organization=$taito_organization
taito_container_registry=ghcr.io/$taito_container_registry_organization

# CI/CD provider
taito_ci_provider=github
taito_ci_provider_url=
taito_ci_organization=$taito_organization     # CHANGE: e.g. GitHub organization or username

# Version control provider
taito_vc_provider=github
taito_vc_domain=github.com
taito_vc_organization=$taito_organization     # CHANGE: e.g. GitHub organization or username

# Uptime monitoring provider
taito_uptime_provider=
taito_uptime_provider_url=
taito_uptime_provider_org_id=
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

# Ansible
# ansible_options="--ask-vault-pass"

# Postgres
postgres_default_host="x.$taito_default_domain"
postgres_default_host_prod="x.$taito_default_domain_prod"
postgres_default_admin="${taito_zone//-/}"

# MySQL
mysql_default_host="x.$taito_default_domain"
mysql_default_host_prod="x.$taito_default_domain_prod"
mysql_default_admin="${taito_zone//-/}"

# Links
# CHANGE: configure some links here
link_urls="
  * dashboard=https://CHANGE-TO-LINK-THAT-POINTS-TO-SERVERS Dashboard
"

set +a

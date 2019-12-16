#!/usr/bin/env bash
# shellcheck disable=SC2034
set -a

# NOTE: Before modifying the configuration values,
# read configuration instructions from README.md

# Taito CLI
taito_version=1
taito_type=zone
# TODO: taito_extensions="./extension"
taito_plugins="ansible-zone links-global custom"

# Labeling
taito_organization=myorganization # CHANGE
taito_organization_abbr=myorg # CHANGE
taito_zone=my-zone

# Domains
# CHANGE: Change domain names also in:
# - ansible-playbooks/development
# - ansible-playbooks/production
taito_default_domain=dev1.mydomain.com # CHANGE
taito_default_domain_prod=prod1.mydomain.com # CHANGE

# Providers
taito_provider=linux
taito_uptime_provider=
taito_uptime_provider_org_id=
taito_container_registry_provider=local
taito_container_registry=local
taito_ci_provider=local
taito_vc_provider=github # CHANGE
taito_vc_domain=github.com # CHANGE

# User rights - configure user rights in:
# - ansible-playbook/group_vars/development # CHANGE
# - ansible-playbook/group_vars/production # CHANGE

# Ansible
# ansible_options="--ask-vault-pass"

# Settings
taito_devops_email=support@mydomain.com # CHANGE
taito_ssh_authorized_networks="0.0.0.0/0"
taito_http_authorized_networks="0.0.0.0/0"
taito_worker_authorized_networks="127.0.0.1" # Only local nginx accesses worker ports
taito_worker_port_range="9000:9010"
taito_database_authorized_networks="172.17.0.0/16 172.18.0.0/16" # Docker subnets

# Postgres
postgres_default_host="x.$taito_default_domain"
postgres_default_host_prod="x.$taito_default_domain_prod"
postgres_default_admin="${taito_zone//-/}"

# MySQL
mysql_default_host="x.$taito_default_domain"
mysql_default_host_prod="x.$taito_default_domain_prod"
mysql_default_admin="${taito_zone//-/}"

# Messaging
taito_messaging_app=slack
taito_messaging_webhook=
taito_messaging_builds_channel=builds
taito_messaging_critical_channel=critical
taito_messaging_monitoring_channel=monitoring

# Links
# CHANGE: configure some links here
link_urls="
  * dashboard=https://CHANGE-TO-LINK-THAT-POINTS-TO-SERVERS Dashboard
"

set +a

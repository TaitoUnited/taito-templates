# DigitalOcean example

Example for a taito zone located in DigitalOcean. Create infrastructure with the following steps:

- Configure settings to your liking in `taito-config.sh` and `*.yaml` files. Change at least all the settings that have been marked with `CHANGE`.
- Authenticate with `taito auth`.
- Create the zone by running `taito zone apply`.

Infrastructure is provisioned with Terraform and you can customize it to your liking by modifying the `*.yaml` files and terraform scripts.

## Links

[//]: # "GENERATED LINKS START"

LINKS WILL BE GENERATED HERE

[//]: # "GENERATED LINKS END"

> You can update this section by configuring links in `taito-config.sh` and running `taito project generate`.

## Interactive operations

- `taito zone init`: Initialize configuration by upgrading dependencies, etc.
- `taito zone apply`: Apply infrastructure changes to the zone.
- `taito zone status`: Show status summary of the zone.
- `taito zone doctor`: Analyze and repair the zone.
- `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
- `taito zone destroy`: Destroy the zone.
- `taito project settings`: Show project template settings for this zone.

## User permissions

Grant permissions for user groups in zone configuration:

- In **admin.yaml** grant TODO.
- In **admin.yaml** grant TODO. This allows external developers to connect to Kubernetes, but they don't have permissions to any namespaces by default.
- In **kubernetes-permissions.yaml** grant `taito-proxyer` role on `db-proxy` namespace for `External developers` group. This allows external developers to connect to database clusters, but they don't have access to any database credentials by default.

Use project specific configuration to grant access to project specific namespaces and database credentials. See [the example](https://github.com/TaitoUnited/full-stack-template/blob/dev/scripts/terraform/examples.yaml).

## Troubleshooting

Misc Terraform problems:

- Just retry a few times to see if that resolves the issue.
- Use `terraform_init_options` and `terraform_apply_options` in `taito-config.sh` to pass extra parameters for terraform (e.g. `-target=module.vpn`).
- Run `taito shell` and execute terraform commands directly.

# Google Cloud example

Example for a taito zone located in Google Cloud. Create infrastructure with the following steps:

- Configure settings to your liking in `taito-config.sh` and `*.yaml` files. Change at least all the `taito-config.sh` settings that have been marked with `CHANGE`.
- Authenticate with `taito auth`.
- Create the zone by running `taito zone apply`.

Infrastructure is provisioned with Terraform and you can customize it to your liking by modifying the `*.yaml` files and terraform scripts.

## Links

[//]: # "GENERATED LINKS START"

LINKS WILL BE GENERATED HERE

[//]: # "GENERATED LINKS END"

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Interactive operations

- `taito zone init`: Initialize configuration by upgrading dependencies, etc.
- `taito zone apply`: Apply infrastructure changes to the zone.
- `taito zone status`: Show status summary of the zone.
- `taito zone doctor`: Analyze and repair the zone.
- `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
- `taito zone destroy`: Destroy the zone.
- `taito project settings`: Show project template settings for this zone.

Terraform specific commands:

- `taito terraform apply ARGS`: Apply infrastructure changes by running Terraform only. For example: `taito terraform apply -target=module.dns`.
- `taito terraform destroy ARGS`: Destroy infrastructure changes by running Terraform only. For example: `taito terraform destroy -target=module.dns`.

## Updating the zone

The `taito zone maintenance` command has not been implemented yet. Once in a while update version numbers in `terraform/*.tf` and apply the changes.

## Destroying resources

Terraform lifecycle rules might prevent destroying some resources, namely databases and storage buckets. If you want to destroy some of these, you might need to temporarily modify `terraform/.terraform` modules by setting `prevent_destroy` lifecycle rule to `false`. For storage buckets you also might need to set `force_destroy = true` storage bucket attribute.

## Troubleshooting

The step "dhparam" takes a long time to execute:

- It might take a few minutes, as it is generating Diffie-Hellman key for your ingress. Just be patient.

Terraform freezes during execution:

- Delete the `terraform/.terraform` folder and try again

Terraform fails during Helm release execution:

- Just retry a few times to see if that resolves the issue.
- Reinstall all Helm releases:
  1. Set `helm_enabled = false` in `main.tf`
  2. Run `taito terraform apply -target=module.kubernetes`, and retry until it succeeds.
  3. Delete rest of the cert-manager [manually](https://github.com/jetstack/cert-manager/issues/2273#issuecomment-564525232) in case something extra is still lying around.
  4. Set `helm_enabled = true` in `main.tf`
  5. Run `taito terraform apply -target=module.kubernetes`, and retry until succeeds.

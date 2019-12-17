# AWS example

Example for a taito zone located in AWS. Configure settings in `taito-config.sh` and then create the zone by running `taito zone apply`.

## Links

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Interactive operations:

* `taito zone apply`: Apply infrastructure changes to the zone.
* `taito zone status`: Show status summary of the zone.
* `taito zone doctor`: Analyze and repair the zone.
* `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
* `taito zone destroy`: Destroy the zone.
* `taito project settings`: Show project template settings for this zone.

## Troubleshooting

Terraform fails during Helm release execution:

* Just retry a few times to see if that resolves the issue.
* Reinstall all Helm releases:
  1. Set `helm_enabled = false` in `main.tf`
  2. Run `taito zone apply`, and retry until it succeeds.
  3. Delete rest of the cert-manager [manually](https://github.com/jetstack/cert-manager/issues/2273#issuecomment-564525232) in case something extra is still lying around.
  4. Set `helm_enabled = true` in `main.tf`
  5. Run `taito zone apply`, and retry until succeeds.
* Limit terraform execution to a specific target by setting `teffaform_target` in `taito-config.sh`. For example: `teffaform_target=module.taito_zone.helm_release.postgres_proxy`.

## TODO

* TODOs on taito-config.sh
* EFK
* Log alerts
* Uptime monitoring
* Prometheus
* Enable Kubernetes pod security policies
* Enable Kubernetes network policies

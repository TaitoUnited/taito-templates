# Google Cloud example

Example for a taito zone located in Google Cloud. Configure settings in `taito-config.sh` and then create the zone by running `taito zone apply`.

## Links

[//]: # (GENERATED LINKS START)

LINKS WILL BE GENERATED HERE

[//]: # (GENERATED LINKS END)

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Interactive operations

* `taito zone apply`: Apply infrastructure changes to the zone.
* `taito zone status`: Show status summary of the zone.
* `taito zone doctor`: Analyze and repair the zone.
* `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
* `taito zone destroy`: Destroy the zone.
* `taito project settings`: Show project template settings for this zone.

## Troubleshooting

Terraform:

* Just retry by running `taito zone apply` again and see if it works.
* Try to reauthenticate with `taito auth` or `taito auth --reset`.
* Limit terraform execution to a specific target by setting `teffaform_target` in `taito-config.sh`. For example: `teffaform_target=module.taito_zone`.

## projects.json

TODO: instructions

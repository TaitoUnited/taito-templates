# Linux servers example

An example for using Linux servers as a basis for infrastructure. Use this when Kubernetes or serverless functions are not an option. By default the example installs the following components on one or more Linux servers:

- NGINX: Reverse proxy that provides SSL termination and routing.
- Certbot: Retrieves domain validated SSL certificates automatically from Let's Encrypt.
- Docker Compose: For running containers.
- PostgreSQL and/or MySQL (MariaDB): For storing data.

Projects are then deployed on top of this infrastructure. Multiple project environments may run on the same server. You can create projects with `taito project create: TEMPLATE` and project environments with `taito env apply:ENV`.

You may also replace Docker with some Java application server or install projects directly on host. In such case you need to implement a [custom provider](https://github.com/TaitoUnited/server-template/blob/dev/CONFIGURATION.md#stack) for your projects.

## Links

[//]: # "GENERATED LINKS START"

- [Dashboard](https://CHANGE-TO-LINK-THAT-POINTS-TO-SERVERS)

[//]: # "GENERATED LINKS END"

> You can update this section by configuring links in `taito-config.sh` and running `taito project docs`.

## Configuration

The infrastructure is configured in `ansible-playbooks` folder. Most of the `taito-config.sh` settings only affect the output of the `taito project settings` command, but some of them are used in ansible scripts also.

Initial configuration:

1. Get one or two Debian servers from any provider. You might also want to enable automatic backups for them, if such option is available.
2. Configure DNS for the servers (e.g. _.dev1.mydomain.com, _.prod1.mydomain.com).
3. Check that ssh login works properly with domain name x prefix (e.g. x.dev1.mydomain.com, x.dev1.mydomain.com). This step adds servers to known hosts.
4. Configure all the "CHANGE" parts in taito-config.sh and ansible playbook files.
5. Apply infrastructure changes with `taito zone apply` for both development and production. To save time, you can run taito commands for both simultaneously in two different terminals. Note that if you login as root the first time, you need to run the `taito zone apply` command again as a normal user using ssh key authentication, as one of the steps disables root ssh access and therefore interrupts process.
6. Create personal or organizational taito-config.sh file based on settings shown by `taito project settings`.

Add new server:

1. Get a Debian server from any provider and enable automatic backups for it, if such option is available.
2. Configure DNS for the server (e.g. _.dev2.mydomain.com, or _.prod2.mydomain.com).
3. Check that ssh login works properly with domain name x prefix (e.g. x.dev2.mydomain.com, x.prod2.mydomain.com). This step adds servers to known hosts.
4. Increase server counts in ansible-playbooks/development and/or ansible-playbooks/production (e.g. `dev[1:1].mydomain.com` -> `dev[1:2].mydomain.com`).
5. Apply infrastructure changes with `taito zone apply`. Note that if you login as root the first time, you need to run the `taito zone apply` command again as a normal user using ssh key authentication, as one of the steps disables root ssh access and therefore interrupts process.
6. Optional: Create personal or organizational taito-config.sh file based on settings shown by `taito project settings`, but change the settings listed below, if required:
   - taito_template_default_domain
   - taito_template_default_domain_prod
   - template_default_postgres_host
   - template_default_postgres_host_prod
   - template_default_mysql_host
   - template_default_mysql_host_prod

## Interactive operations

- `taito zone init`: Initialize configuration by upgrading dependencies, etc.
- `taito zone apply`: Apply infrastructure changes to the zone.
- `taito zone status`: Show status summary of the zone.
- `taito zone doctor`: Analyze and repair the zone.
- `taito zone maintenance`: Execute supervised maintenance tasks that need to be run periodically for the zone (e.g. upgrades, secret rotation, log reviews, access right reviews).
- `taito zone destroy`: Destroy the zone.
- `taito project settings`: Show project template settings for this zone.

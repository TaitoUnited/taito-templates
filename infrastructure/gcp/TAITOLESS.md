# Taitoless: without Taito CLI

> TODO: Update instructions (nowadays multiple yaml files)

Creating a zone without Taito CLI:

1. Configure settings in _taito-config.sh_ and add terraform specific `TF_VAR_` prefix to each variable.

2. Authenticate to Google Cloud with the _gcloud_ command-line tool.

3. Run Terraform scripts:

   ```
   . taito-config.sh
   cd terraform
   terraform init
   terraform apply
   ```

4. Authenticate to Google Kubernetes with the _gcloud_ command-line tool.

5. Set Kubernetes default context with the _kubectl_ command-line tool.

6. Replace PLACEHOLDERS written in all caps with the correct values in _taito-config.sh_ and _terraform/main.tf_.

7. Set first_run to false in _terraform/variables.tf_.

8. Run Terraform scripts again:

   ```
   . taito-config.sh
   cd terraform
   terraform init
   terraform apply
   ```

9. Check ingress-nginx load balancer external IP address:

   ```
   kubectl get services --namespace ingress-nginx
   ```

10. Add A record for the load balancer IP address (e.g. `A *.gcp.mydomain.com -> 123.123.123.123`)

11. Reset database master passwords on Google Cloud web console.

> TIP: You can remove `*.tfstate` and `*.tfstate.backup` files from your local disk once the state has been saved to a storage bucket.

# Taitoless: without Taito CLI

Creating a zone without Taito CLI:

1) Configure settings in *taito-config.sh* and add terraform specific `TF_VAR_` prefix to each variable.

2) Authenticate to Google Cloud with the *gcloud* command-line tool.

3) Run Terraform scripts:

    ```
    . taito-config.sh
    cd terraform
    terraform init
    terraform apply
    ```

4) Authenticate to Google Kubernetes with the *gcloud* command-line tool.

5) Set Kubernetes default context with the *kubectl* command-line tool.

6) Replace PLACEHOLDERS written in all caps with the correct values in *taito-config.sh* and *terraform/main.tf*.

7) Set first_run to false in *terraform/variables.tf*.

8) Run Terraform scripts again:

    ```
    . taito-config.sh
    cd terraform
    terraform init
    terraform apply
    ```

9) Check nginx-ingress load balancer external IP address:

    ```
    kubectl get services --namespace nginx-ingress
    ```

10) Add A record for the load balancer IP address (e.g. `A *.gcp.mydomain.com -> 123.123.123.123`)

11) Reset database master passwords on Google Cloud web console.

> TIP: You can remove `*.tfstate` and `*.tfstate.backup` files from your local disk once the state has been saved to a storage bucket.

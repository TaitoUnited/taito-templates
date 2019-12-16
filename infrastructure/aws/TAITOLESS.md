# Taitoless: without Taito CLI

Creating a zone without Taito CLI:

1) Configure settings in *taito-config.sh* and add terraform specific `TF_VAR_` prefix to each variable.

2) Authenticate to AWS with the *aws* command-line tool.

3) Run Terraform scripts:

    ```
    . taito-config.sh
    cd terraform
    terraform init
    terraform apply
    ```

4) Authenticate to AWS Kubernetes (EKS) with the *aws* command-line tool.

5) Authenticate to AWS Container Registry (ECR) with the *aws* command-line tool.

6) Set Kubernetes default context with the *kubectl* command-line tool.

7) Replace PLACEHOLDERS written in all caps with the correct values in *taito-config.sh* and *terraform/main.tf*.

8) Set first_run to false in *terraform/variables.tf*.

9) Run Terraform scripts again:

    ```
    . taito-config.sh
    cd terraform
    terraform init
    terraform apply
    ```

10) Update DNS of parent domain according to these [instructions](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html#UpdateDNSParentDomain).

11) Reset database master passwords on AWS web console.

> TIP: You can remove `*.tfstate` and `*.tfstate.backup` files from your local disk once the state has been saved to a storage bucket.

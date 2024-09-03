terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    helm = {
      source = "hashicorp/helm"
    }

    /* Disabled by default as does not support linux_arm64
    mysql = {
      source = "terraform-providers/mysql"
    }
    */
    
    postgresql = {
      source = "terraform-providers/postgresql"
    }
    external = {
      source = "hashicorp/external"
    }
  }
}

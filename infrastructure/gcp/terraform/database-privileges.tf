/*
# PostgreSQL example
# NOTE: Add provider and module for each PostgreSQL cluster

provider "postgresql" {
  alias           = "postgresql_0"
  host            = "127.0.0.1"
  port            = 5000
  username        = local.databases.postgresqlClusters[0].adminUsername
  password        = var.postgresql_0_password
  superuser       = false

  sslmode         = "require"
  sslrootcert     = "${path.root}/../tmp/common-postgres-db-ssl.ca"
  clientcert {
    cert = "${path.root}/../tmp/common-postgres-db-ssl.cert"
    key  = "${path.root}/../tmp/common-postgres-db-ssl.key"
  }
}

module "postgresql_0" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.5"
  privileges                 = local.databases.postgresqlClusters[0]
  providers = {
    postgresql = postgresql.postgresql_0
  }
}

variable "postgresql_0_password" {
  type = string
  description = "Database admin password is required for setting PostgreSQL roles and users. Leave this empty if the database does not exist yet. Warning! The password is saved in Terraform state as plain text! It is advisable to change the password after you have run the command."
}
*/

/*
# MySQL example
# NOTE: Add provider and module for each MySQL cluster
# NOTE: mysql provider does not support SSL yet.

provider "mysql" {
  alias           = "mysql_0"
  endpoint        = "127.0.0.1:6000"
  username        = local.databases.mysqlClusters[0].adminUsername
  password        = var.mysql_0_password
}

module "mysql_0" {
  source                     = "TaitoUnited/privileges/mysql"
  version                    = "1.0.3"
  privileges                 = local.databases.mysqlClusters[0]
  providers = {
    mysql = mysql.mysql_0
  }
}

variable "mysql_0_password" {
  type = string
  description = "Database admin password is required for setting MySQL roles and users. Leave this empty if the database does not exist yet. Warning! The password is saved in Terraform state as plain text! It is advisable to change the password after you have run the command."
}
*/

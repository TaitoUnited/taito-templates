# PostgreSQL
# NOTE: Add provider and module for each PostgreSQL cluster

provider "postgresql" {
  alias           = "postgresql_0"
  host            = "127.0.0.1"
  port            = 5000
  username        = local.databases.postgresqlClusters[0].adminUsername
  password        = var.postgresql_0_password
}

module "postgresql_0" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.1"
  privileges                 = local.databases.postgresqlClusters[0]
  providers = {
    postgresql = postgresql.postgresql_0
  }
}

# MySQL
# NOTE: Add provider and module for each MySQL cluster

provider "mysql" {
  alias           = "mysql_0"
  endpoint        = "127.0.0.1:6000"
  username        = local.databases.mysqlClusters[0].adminUsername
  password        = var.mysql_0_password
}

module "mysql_0" {
  source                     = "TaitoUnited/privileges/mysql"
  version                    = "1.0.1"
  privileges                 = local.databases.mysqlClusters[0]
  providers = {
    mysql = mysql.mysql_0
  }
}

# PostgreSQL
# NOTE: Add provider and module for each PostgreSQL cluster

provider "postgresql" {
  alias           = postgresql_0
  host            = 127.0.0.1
  port            = 5000
  username        = databases[0].adminUsername
  password        = var.postgresql_0_password
}

module "postgresql_0" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.0"
  provider                   = postgresql.postgresql_0
  privileges                 = local.databases.postgresqlClusters[0]
}

# MySQL
# NOTE: Add provider and module for each MySQL cluster

provider "mysql" {
  alias           = mysql_0
  host            = 127.0.0.1
  port            = 6000
  username        = databases[0].adminUsername
  password        = var.mysql_0_password
}

module "mysql_0" {
  source                     = "TaitoUnited/privileges/mysql"
  version                    = "1.0.0"
  provider                   = mysql.mysql_0
  privileges                 = local.databases.mysqlClusters[0]
}

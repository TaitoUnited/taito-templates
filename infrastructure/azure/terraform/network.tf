resource "azurerm_virtual_network" "main" {
  name                = "${var.taito_zone}-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.zone.location
  resource_group_name = azurerm_resource_group.zone.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.zone.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.1.0.0/16"
  service_endpoints    = ["Microsoft.Sql"]
}

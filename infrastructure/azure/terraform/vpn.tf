/* NOTE: uncomment these to enable VPN

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.zone.name
  virtual_network_name = module.network.virtual_network_name
  address_prefixes     = [ "10.1.1.0/24" ]
}

# NOTE: This is a hack to make vpn module wait for an existing resource group and network
data "external" "network_wait" {
  depends_on = [ azurerm_resource_group.zone, module.network ]
  program = ["sh", "-c", "sleep 5; echo '{ \"azurerm_resource_group_name\": \"${azurerm_resource_group.zone.name}\", \"virtual_network_name\": \"${module.network.virtual_network_name}\" }'"]
}

module "vpn" {
  source  = "kumarvna/vpn-gateway/azurerm"
  version = "1.1.0"

  # Resource Group, location, VNet and Subnet details
  resource_group_name  = (
    var.first_run
    ? data.external.network_wait.result.azurerm_resource_group_name
    : azurerm_resource_group.zone.name
  )
  virtual_network_name  = (
    var.first_run
    ? data.external.network_wait.result.virtual_network_name
    : module.network.virtual_network_name
  )
  # TODO: obsolete? subnet_name          = azurerm_subnet.gateway_subnet.name
  vpn_gateway_name     = "${azurerm_resource_group.zone.name}-vpn"
  vpn_gw_sku           = "VpnGw1"
  public_ip_sku        = "Basic"

  # client configuration for Point-to-Site VPN Gateway connections
  vpn_client_configuration = {
    address_space        = "10.2.0.0/24"
    vpn_client_protocols = ["OpenVPN"]
    certificate          = trimspace(
      replace(
        replace(
          file(local.network["network"].vpnCertificateFilePath), "-----BEGIN CERTIFICATE-----", ""
        ), "-----END CERTIFICATE-----", ""
      )
    )
  }

  tags = {
  }
}

output "vpn_gateway_id" {
  value = module.vpn.vpn_gateway_id
}

output "vpn_gateway_public_ip" {
  value = module.vpn.vpn_gateway_public_ip
}

output "vpn_gateway_public_ip_fqdn" {
  value = module.vpn.vpn_gateway_public_ip_fqdn
}

*/

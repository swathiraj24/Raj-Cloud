output "vpn_gateway_id" {
  value       = azurerm_virtual_network_gateway.this.id
  description = "The ID of the Azure Virtual Network Gateway."
}

output "vpn_gateway_public_ip" {
  value       = azurerm_public_ip.vpn_gateway.ip_address
  description = "The public IP address assigned to the VPN gateway."
}

output "site2site_connection_id" {
  value       = length(azurerm_virtual_network_gateway_connection.site2site) > 0 ? azurerm_virtual_network_gateway_connection.site2site[0].id : null
  description = "The ID of the site-to-site VPN connection, if created."
}

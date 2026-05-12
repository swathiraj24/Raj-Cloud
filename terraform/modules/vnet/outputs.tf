output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "The resource group created for the hub and spoke network."
}

output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "ID of the hub virtual network."
}

output "spoke_vnet_ids" {
  value       = [for v in azurerm_virtual_network.spoke : v.id]
  description = "IDs of the spoke virtual networks."
}

output "hub_gateway_subnet_id" {
  value       = azurerm_subnet.hub_gateway.id
  description = "ID of the hub gateway subnet."
}

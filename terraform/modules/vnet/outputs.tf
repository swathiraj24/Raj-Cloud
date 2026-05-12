output "resource_group_name" {
  value       = var.create_resource_group ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.existing[0].name
  description = "The resource group used for the hub and spoke network."
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

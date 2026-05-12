terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  address_space       = [var.hub_vnet_address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "hub_private" {
  name                 = var.hub_private_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_private_subnet_prefix]
  service_endpoints    = var.service_endpoints
}

resource "azurerm_subnet" "hub_gateway" {
  name                 = var.hub_gateway_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_gateway_subnet_prefix]
}

resource "azurerm_virtual_network" "spoke" {
  for_each            = { for s in var.spoke_vnets : s.name => s }
  name                = each.value.name
  address_space       = [each.value.address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "spoke_private" {
  for_each            = azurerm_virtual_network.spoke
  name                 = "${each.value.name}-private"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = each.value.name
  address_prefixes     = [lookup(var.spoke_subnet_prefixes, each.key, "10.1.0.0/24")]
  service_endpoints    = var.service_endpoints
}

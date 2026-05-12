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
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "existing" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  spoke_vnets = { for s in var.spoke_vnets : s.name => s }
}

data "azurerm_virtual_network" "hub" {
  count               = var.create_hub_vnet ? 0 : 1
  name                = var.hub_vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "hub" {
  count               = var.create_hub_vnet ? 1 : 0
  name                = var.hub_vnet_name
  address_space       = [var.hub_vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "hub_private" {
  count                = var.create_hub_vnet ? 0 : 1
  name                 = var.hub_private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.hub[0].name
}

resource "azurerm_subnet" "hub_private" {
  count                = var.create_hub_vnet ? 1 : 0
  name                 = var.hub_private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub[0].name
  address_prefixes     = [var.hub_private_subnet_prefix]
  service_endpoints    = var.service_endpoints
}

data "azurerm_subnet" "hub_gateway" {
  count                = var.create_hub_vnet ? 0 : 1
  name                 = var.hub_gateway_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.hub[0].name
}

resource "azurerm_subnet" "hub_gateway" {
  count                = var.create_hub_vnet ? 1 : 0
  name                 = var.hub_gateway_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub[0].name
  address_prefixes     = [var.hub_gateway_subnet_prefix]
}

data "azurerm_virtual_network" "spoke" {
  for_each            = var.create_spoke_vnets ? {} : local.spoke_vnets
  name                = each.value.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "spoke" {
  for_each            = var.create_spoke_vnets ? local.spoke_vnets : {}
  name                = each.value.name
  address_space       = [each.value.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "spoke_private" {
  for_each             = var.create_spoke_vnets ? {} : data.azurerm_virtual_network.spoke
  name                 = "${each.value.name}-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.name
}

resource "azurerm_subnet" "spoke_private" {
  for_each             = azurerm_virtual_network.spoke
  name                 = "${each.value.name}-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.name
  address_prefixes     = [lookup(var.spoke_subnet_prefixes, each.key, "10.1.0.0/24")]
  service_endpoints    = var.service_endpoints
}

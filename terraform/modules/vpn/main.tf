terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

resource "azurerm_public_ip" "vpn_gateway" {
  name                = var.vpn_gateway_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = var.vpn_type
  active_active       = false
  enable_bgp          = var.enable_bgp
  sku                 = var.vpn_gateway_sku
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway.id
    subnet_id                     = var.hub_gateway_subnet_id
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  count               = var.create_local_network_gateway && var.local_network_gateway_ip_address != "" && length(var.local_address_space) > 0 ? 1 : 0
  name                = var.local_network_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.local_network_gateway_ip_address
  local_network_address_space = var.local_address_space
}

resource "azurerm_virtual_network_gateway_connection" "site2site" {
  count                       = var.create_connection && length(azurerm_local_network_gateway.onprem) > 0 ? 1 : 0
  name                        = var.connection_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  type                        = "IPsec"
  virtual_network_gateway_id  = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id    = azurerm_local_network_gateway.onprem[0].id
  shared_key                  = var.shared_key
  enable_bgp                  = var.enable_bgp
}

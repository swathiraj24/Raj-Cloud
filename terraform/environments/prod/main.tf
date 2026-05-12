provider "azurerm" {
  features {}
}

module "network" {
  source                    = "../../modules/vnet"
  resource_group_name       = var.resource_group_name
  create_resource_group     = false
  location                  = var.location
  hub_vnet_name             = "hub-vnet-prod"
  hub_vnet_address_space    = "10.0.0.0/16"
  hub_private_subnet_prefix = "10.0.1.0/24"
  spoke_vnets = [
    {
      name          = "spoke-vnet-apps-prod"
      address_space = "10.1.0.0/16"
    },
    {
      name          = "spoke-vnet-aks-prod"
      address_space = "10.2.0.0/16"
    }
  ]
  spoke_subnet_prefixes = {
    "spoke-vnet-apps-prod" = "10.1.1.0/24"
    "spoke-vnet-aks-prod"  = "10.2.1.0/24"
  }
}

/*
module "vpn" {
  source                         = "../../modules/vpn"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  hub_gateway_subnet_id          = module.network.hub_gateway_subnet_id
  create_local_network_gateway   = false
  local_network_gateway_ip_address = var.local_network_gateway_ip_address
  local_address_space            = var.local_address_space
  shared_key                     = var.vpn_shared_key
  create_connection              = false
}
*/

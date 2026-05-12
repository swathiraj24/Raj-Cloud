variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for hub and spoke resources."
}

variable "create_resource_group" {
  type        = bool
  description = "Whether to create the resource group in this module. Set false when the resource group already exists."
  default     = true
}

variable "create_hub_vnet" {
  type        = bool
  description = "Whether to create the hub virtual network. Set false when the hub VNet already exists."
  default     = true
}

variable "create_spoke_vnets" {
  type        = bool
  description = "Whether to create the spoke virtual networks. Set false when the spoke VNets already exist."
  default     = true
}

variable "location" {
  type        = string
  description = "Azure region for the hub and spoke network."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub virtual network."
  default     = "hub-vnet"
}

variable "hub_vnet_address_space" {
  type        = string
  description = "Address space for the hub virtual network."
  default     = "10.0.0.0/16"
}

variable "hub_private_subnet_name" {
  type        = string
  description = "Private subnet name in the hub."
  default     = "hub-private-subnet"
}

variable "hub_private_subnet_prefix" {
  type        = string
  description = "Header prefix for the hub private subnet."
  default     = "10.0.1.0/24"
}

variable "hub_gateway_subnet_name" {
  type        = string
  description = "Name for the hub gateway subnet."
  default     = "GatewaySubnet"
}

variable "hub_gateway_subnet_prefix" {
  type        = string
  description = "Address prefix for the hub gateway subnet."
  default     = "10.0.255.0/27"
}

variable "spoke_vnets" {
  type = list(object({
    name          = string
    address_space = string
  }))
  description = "List of spoke VNets to create."
  default     = []
}

variable "spoke_subnet_prefixes" {
  type        = map(string)
  description = "Map of spoke VNet names to private subnet CIDRs."
  default     = {}
}

variable "service_endpoints" {
  type        = list(string)
  description = "Azure service endpoints to enable on subnets."
  default     = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for VPN gateway resources."
}

variable "location" {
  type        = string
  description = "Azure region for VPN gateway resources."
}

variable "hub_gateway_subnet_id" {
  type        = string
  description = "Resource ID of the hub gateway subnet."
}

variable "vpn_gateway_name" {
  type        = string
  description = "Name of the Azure Virtual Network Gateway."
  default     = "hub-vpn-gateway"
}

variable "vpn_gateway_public_ip_name" {
  type        = string
  description = "Name of the public IP for the VPN gateway."
  default     = "hub-vpn-gateway-pip"
}

variable "vpn_gateway_sku" {
  type        = string
  description = "SKU for the Azure Virtual Network Gateway."
  default     = "VpnGw1"
}

variable "vpn_type" {
  type        = string
  description = "VPN type for the gateway."
  default     = "RouteBased"
}

variable "enable_bgp" {
  type        = bool
  description = "Whether to enable BGP on the VPN gateway."
  default     = false
}

variable "create_local_network_gateway" {
  type        = bool
  description = "Whether to create a local network gateway for-site-to-site connectivity."
  default     = true
}

variable "local_network_gateway_name" {
  type        = string
  description = "Name of the local network gateway."
  default     = "onprem-local-gateway"
}

variable "local_network_gateway_ip_address" {
  type        = string
  description = "On-premises VPN device public IP address."
  default     = ""
}

variable "local_address_space" {
  type        = list(string)
  description = "Address spaces for the on-premises/local network."
  default     = []
}

variable "connection_name" {
  type        = string
  description = "Name of the site-to-site VPN connection."
  default     = "site2site-connection"
}

variable "shared_key" {
  type        = string
  description = "Shared key for the VPN connection."
  sensitive   = true
  default     = ""
}

variable "create_connection" {
  type        = bool
  description = "Whether to create the virtual network gateway connection."
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the prod environment."
  default     = "rg-azure-landingzone-prod"
}

variable "location" {
  type        = string
  description = "Azure region for the prod environment."
  default     = "eastus2"
}

variable "local_network_gateway_ip_address" {
  type        = string
  description = "Optional on-premises VPN public IP for site-to-site connectivity."
  default     = ""
}

variable "local_address_space" {
  type        = list(string)
  description = "Optional local on-premises address spaces for site-to-site VPN."
  default     = []
}

variable "vpn_shared_key" {
  type        = string
  description = "Optional shared key used for site-to-site VPN."
  default     = ""
}

# VPN Module

This module deploys an Azure Virtual Network Gateway and optional site-to-site VPN connection.

It assumes the hub VNet already includes a `GatewaySubnet` and that the subnet ID is passed in.

Use this module for real-time site-to-site VPN connectivity from on-premises or branch office networks.

Optional firewall deployment is not required for a student landing zone.

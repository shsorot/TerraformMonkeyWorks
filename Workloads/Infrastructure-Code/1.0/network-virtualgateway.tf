variable "LocalNetworkGateways" {
  default = {}
}

module "Landscape-Local-Network-Gateways" {
  source          = "../../../AzureRM/Modules/Network/Azure-LocalNetworkGateway/1.0"
  for_each        = var.LocalNetworkGateways
  name            = each.value.name == null ? each.key : each.value.name
  resource_group  = each.value.resource_group
  location        = try(each.value.location, null)
  tags            = try(each.value.tags, {})
  inherit_tags    = try(each.value.inherit_tags, false)
  address_space   = try(each.value.address_space, null)
  bgp_settings    = try(each.value.bgp_settings, null)
  gateway_address = try(each.value.gateway_address, null)
  gateway_fqdn    = try(each.value.gateway_fqdn, null)
  resource_groups = module.Landscape-Resource-Groups
}

output "LocalNetworkGateways" {
  value = module.Landscape-Local-Network-Gateways
}


variable "VPNGateways" {
  default = {}
}

module "Landscape-VPN-Gateways" {
  source                        = "../../../AzureRM/Modules/Network/Azure-VirtualNetworkGateway/1.0"
  for_each                      = var.VPNGateways
  name                          = each.value.name == null ? each.key : each.value.name
  resource_group                = each.value.resource_group
  location                      = try(each.value.location, null)
  tags                          = try(each.value.tags, {})
  inherit_tags                  = try(each.value.inherit_tags, false)
  type                          = try(each.value.type,"Vpn")
  vpn_type                      = try(each.value.vpn_type, "RouteBases")
  enable_bgp                    = try(each.value.enable_bgp, false)
  active_active                 = try(each.value.active_active, false)
  private_ip_address_enabled    = try(each.value.private_ip_address_enabled, false)
  default_local_network_gateway = try(each.value.virtual_network_gateway, null)
  sku                           = try(each.value.sku,"Basic")
  generation                    = try(each.value.generation,"None")
  ip_configuration              = each.value.ip_configuration
  vpn_client_configuration      = try(each.value.vpn_client_configuration, null)
  bgp_settings                  = try(each.value.bgp_settings, null)
  custom_route                  = try(each.value.custom_route, null)
  virtual_networks              = module.Landscape-Virtual-Networks
  resource_groups               = module.Landscape-Resource-Groups
  public_ip_addresses           = module.Landscape-Public-IP-Addresses
  local_network_gateways        = module.Landscape-Local-Network-Gateways
}

output "VPNGateways" {
  value = module.Landscape-VPN-Gateways
}


variable "VPNGatewayConnections" {
  default = {}
}

module "Landscape-VPN-Gateway-Connections" {
  source                             = "../../../AzureRM/Modules/Network/Azure-VirtualNetworkGatewayConnection/1.0"
  for_each                           = var.VPNGatewayConnections
  name                               = each.value.name == null ? each.key : each.value.name
  resource_group                     = each.value.resource_group
  location                           = try(each.value.location, null)
  tags                               = try(each.value.tags, {})
  inherit_tags                       = try(each.value.inherit_tags, false)
  type                               = each.value.type
  virtual_network_gateway            = each.value.virtual_network_gateway
  authorization_key                  = try(each.value.authorization_key, null)
  dpd_timeout_seconds                = try(each.value.dpd_timeout_seconds, null)
  express_route_circuit              = try(each.value.express_route_circuit, null)
  peer_virtual_network_gateway       = try(each.value.peer_virtual_network_gateway, null)
  local_azure_ip_address_enabled     = try(each.value.local_azure_ip_address_enabled, false)
  local_network_gateway              = try(each.value.local_network_gateway, null)
  routing_weight                     = try(each.value.routing_weight, 10)
  shared_key                         = try(each.value.shared_key, null)
  connection_protocol                = try(each.value.connection_protocol, "IKEv2")
  enable_bgp                         = try(each.value.enable_bgp, false)
  express_route_gateway_bypass       = try(each.value.express_route_gateway_bypass, false)
  use_policy_based_traffic_selectors = try(each.value.use_policy_based_traffic_selectors, false)
  ipsec_policy                       = try(each.value.ipsec_policy, null)
  traffic_selector_policy            = try(each.value.traffic_selector_policy, null)
  local_network_gateways             = module.Landscape-Local-Network-Gateways
  resource_groups                    = module.Landscape-Resource-Groups
  express_route_circuits             = module.Landscape-ExpressRoute-Circuits
  virtual_network_gateways           = module.Landscape-VPN-Gateways
}

output "VPNGatewayConnections" {
  value = module.Landscape-VPN-Gateway-Connections
}

variable "VirtualNetworkPeerings" {
  default = {}
}
module "Landscape-Virtual-Network-Peerings" {
  source                       = "../../../AzureRM/Modules/Network/Azure-VNetPeering/1.0"
  for_each                     = var.VirtualNetworkPeerings
  name                         = each.value.name == null ? each.key : each.value.name
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.virtual_network_name
  remote_virtual_network       = each.value.remote_virtual_network
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)
  virtual_networks             = module.Landscape-Virtual-Networks
}

output "VirtualNetworkPeerings" {
  value = module.Landscape-Virtual-Network-Peerings
}


variable "BiDirectionalVirtualNetworkPeering" {
  default = {}
}

module "Landscape-Bi-Directional-Virtual-Network-Peering" {
  source                       = "../../../AzureRM/Modules/Network/Azure-VNetPeering/2.0"
  for_each                     = var.BiDirectionalVirtualNetworkPeering
  name                         = each.value.name == null ? each.key : each.value.name
  local_virtual_network        = each.value.local_virtual_network
  remote_virtual_network       = each.value.remote_virtual_network
  virtual_networks             = module.Landscape-Virtual-Networks
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)
}


output "BiDirectionalVirtualNetworkPeering" {
  value = module.Landscape-Bi-Directional-Virtual-Network-Peering
}
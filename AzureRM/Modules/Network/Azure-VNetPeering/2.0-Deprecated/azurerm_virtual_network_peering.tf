resource "azurerm_virtual_network_peering" "local" {
  name                         = var.name == null ? local.local_name : var.name
  resource_group_name          = var.local_virtual_network.resource_group_name
  virtual_network_name         = var.local_virtual_network.name
  remote_virtual_network_id    = local.remote_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.use_remote_gateways == true ? false : var.allow_gateway_transit
  use_remote_gateways          = var.allow_gateway_transit == true ? false : var.use_remote_gateways
}




resource "azurerm_virtual_network_peering" "remote" {
  name                         = var.name == null ? local.remote_name : var.name
  resource_group_name          = var.remote_virtual_network.resource_group_name
  virtual_network_name         = var.remote_virtual_network.name
  remote_virtual_network_id    = local.local_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.use_remote_gateways
  use_remote_gateways          = var.allow_gateway_transit
}
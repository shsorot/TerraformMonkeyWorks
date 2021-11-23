resource "azurerm_express_route_circuit" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  sku {
    tier   = var.sku.tier
    family = var.sku.family
  }
  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth_in_mbps

  allow_classic_operations = var.allow_classic_operations
  express_route_port_id    = local.express_route_port_id
  bandwidth_in_gbps        = var.bandwidth_in_gbps
}
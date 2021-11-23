resource "azurerm_virtual_hub_route_table_route" "this" {
  route_table_id    = local.route_table_id
  name              = var.name
  destinations      = var.destinations
  destinations_type = var.destinations_type
  next_hop          = local.next_hop_id
  next_hop_type     = var.next_hop_type
}
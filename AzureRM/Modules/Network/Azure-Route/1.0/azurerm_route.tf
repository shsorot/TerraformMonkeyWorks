
resource "azurerm_route" "this" {
  name                   = var.name
  resource_group_name    = local.resource_group_name
  route_table_name       = local.route_table_name
  address_prefix         = var.address_prefix
  next_hop_type          = var.next_hop_type
  next_hop_in_ip_address = var.next_hop_in_ip_address
}
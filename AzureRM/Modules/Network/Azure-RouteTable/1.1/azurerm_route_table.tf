
resource "azurerm_route_table" "this" {
  tags                          = local.tags
  name                          = var.name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  route                         = var.route == null ? [] : var.route
}

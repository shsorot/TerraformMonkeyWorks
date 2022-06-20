resource "azurerm_virtual_hub_route_table" "this" {
  name           = var.name
  virtual_hub_id = local.virtual_hub_id
  labels         = var.labels
  dynamic "route" {
    for_each = var.route == null ? [] : [1]
    content {
      name              = var.route.name
      destinations      = var.route.destinations
      destinations_type = var.route.destinations_type
      next_hop_type     = var.route.next_hop_type == null ? "ResourceId" : var.route.next_hop_type
      next_hop = var.route.next_hop.id == null ? (
        var.route.next_hop.name == null ? (
          var.virtual_hub_connections[var.route.next_hop.key].id
        ) : "${local.virtual_hub_id}/hubVirtualNetworkConnections/${var.route.next_hop.name}"
      ) : var.route.next_hop.id
    }
  }

}
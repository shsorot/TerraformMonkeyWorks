# <TODO> add support for local lookup of WAN routing table in routing block
resource "azurerm_express_route_connection" "this" {
  name                             = var.name
  express_route_circuit_peering_id = local.express_route_circuit_peering_id
  express_route_gateway_id         = local.express_route_gateway_id
  authorization_key                = var.authorization_key
  enable_internet_security         = var.enable_internet_security
  dynamic "routing" {
    for_each = var.routing == null ? [] : [1]
    content {
      associated_route_table_id = var.routing.associated_route_table.id == null ? (
        var.routing.associated_route_table.name == null && var.routing.associated_route_table.resource_group_name && var.routing.associated_route_table.virtual_hub_name ? (
          var.virtual_hub_route_tables[var.routing.associated_route_table.tag].id
        ) :
        "/subscriptions/${local.subscription_id}/resourceGroups/${var.routing.associated_route_table.resource_group_name}/providers/Microsoft.Network/virtualHubs/${var.routing.associated_route_table.virtual_hub_name}/hubRouteTables/${var.routing.associated_route_table.name}"
      ) : var.routing.associated_route_table.id

      dynamic "propagated_route_table" {
        for_each = var.routing.propagated_route_table == null ? [] : [1]
        content {
          labels = var.routing.propagated_route_table.labels
          route_table_ids = [for instance in var.routing.propagated_route_table.route_table_ids : instance.id == null ? (
            instance.name == null && instance.resource_group_name == null && instance.virtual_hub_name == null ? (
              var.virtual_hub_route_tables[instance.tag].id
            ) : "/subscriptions/${local.subscription_id}/resourceGroups/${instance.resource_group_name}/providers/Microsoft.Network/virtualHubs/${instance.virtual_hub_name}/hubRouteTables/${instance.name}"
          ) : instance.id]
        }
      }
    }
  }
  routing_weight = var.routing_weight
}
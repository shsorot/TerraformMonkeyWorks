data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}

locals {
  peering_id = var.peering.id == null ? (
    var.peering.name == null && var.peering.resource_group_name == null && var.peering.express_route_circuit_name == null ? (
      var.express_route_circuit_peerings[var.peering.tag].id
    ) : "/subscriptions/${coalesce(var.peering.subscription_id, local.subscription_id)}/resourceGroups/${var.peering.resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/${var.peering.express_route_circuit_name}/peerings/${var.peering.name}"
  ) : var.peering.id

  peer_peering_id = var.peer_peering.id == null ? (
    var.peer_peering.name == null && var.peer_peering.resource_group_name == null && var.peer_peering.express_route_circuit_name == null ? (
      var.express_route_circuit_peerings[var.peer_peering.tag].id
    ) : "/subscriptions/${coalesce(var.peer_peering.subscription_id, local.subscription_id)}/resourceGroups/${var.peer_peering.resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/${var.peering.express_route_circuit_name}/peerings/${var.peer_peering.name}"
  ) : var.peer_peering.id

}
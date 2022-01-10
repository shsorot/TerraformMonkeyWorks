# This file contains local & data blocks
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
# <TODO> add data block lookup for azurerm_express_route_circuit_peering & express route gateway when available from Terraform

locals {
  express_route_circuit_peering_id = var.express_route_circuit_peering.id == null ? (
    var.express_route_circuit_peering.name == null && var.express_route_circuit_peering.express_route_circuit_name == null && var.express_route_circuit_peering.resource_group_name == null ? (
      var.express_route_circuit_peerings[var.express_route_circuit_peering.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.express_route_circuit_peering.resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/${var.express_route_circuit_peering.express_route_circuit_name}/peerings/${var.express_route_circuit_peering.name}"
  ) : var.express_route_circuit_peering.id

  express_route_gateway_id = var.express_route_gateway.id == null ? (
    var.express_route_gateway.name == null && var.express_route_gateway.resource_group_name == null ? (
      var.express_route_gateways[var.express_route_gateway.tag].id
    ) : "/subscriptions/${local.subscription_id}/resourceGroups/${var.express_route_gateway.resource_group_name}/providers/Microsoft.Network/expressRouteGateways/${var.express_route_gateway.name}"
  ) : var.express_route_gateway.id
}

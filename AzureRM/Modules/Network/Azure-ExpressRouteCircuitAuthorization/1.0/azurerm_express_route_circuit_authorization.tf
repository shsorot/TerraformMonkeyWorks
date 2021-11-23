resource "azurerm_express_route_circuit_authorization" "this" {
  name                       = var.name
  resource_group_name        = local.resource_group_name
  express_route_circuit_name = local.express_route_circuit_name
}
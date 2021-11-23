resource "azurerm_express_route_gateway" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  scale_units         = var.scale_units
  virtual_hub_id      = local.virtual_hub_id
}
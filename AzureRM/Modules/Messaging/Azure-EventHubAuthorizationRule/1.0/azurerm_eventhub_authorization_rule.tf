resource "azurerm_eventhub_authorization_rule" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  eventhub_name       = var.eventhub_name
  namespace_name      = var.namespace_name
}
resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  namespace_name      = local.namespace_name
  listen              = var.listen
  send                = var.send
  manage              = var.manage
}
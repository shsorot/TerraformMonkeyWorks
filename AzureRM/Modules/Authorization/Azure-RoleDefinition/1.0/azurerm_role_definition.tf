# <TODO> assign data block and list based lookup for scope and resource types when scope is < subscription
resource "azurerm_role_definition" "this" {
  role_definition_id = var.role_definition_id
  name               = var.name
  scope              = var.scope
  description        = var.description
  assignable_scopes  = var.assignable_scopes
  dynamic "permissions" {
    for_each = var.permissions == null ? [] : [1]
    content {
      actions          = var.permissions.actions
      data_actions     = var.permissions.data_actions
      not_actions      = var.permissions.not_actions
      not_data_actions = var.permissions.not_data_actions
    }
  }
}
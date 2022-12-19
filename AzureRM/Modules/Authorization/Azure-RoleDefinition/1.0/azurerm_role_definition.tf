resource "azurerm_role_definition" "this" {
  role_definition_id = var.role_definition_id
  name               = var.name
  # Currently this must be explicitly specified.
  # TODO : investigate possible discovery using data block
  scope       = local.scope
  description = var.description
  # Currently this must be explicitly specified.
  # TODO : investigate possible discovery using data block. Must be specified as list of resource Ids or long string subscription id.
  assignable_scopes = local.assignable_scopes
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
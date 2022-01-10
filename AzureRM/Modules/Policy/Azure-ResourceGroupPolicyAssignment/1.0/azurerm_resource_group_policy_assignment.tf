resource "azurerm_resource_group_policy_assignment" "this" {
  # This may change to Management Group in later provider release
  name                 = var.name
  policy_definition_id = coalesce(local.policy_definition_id, local.policy_definition_set_id)
  resource_group_id    = local.resource_group_id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  dynamic "identity" {
    for_each = var.identity == null || var.identity == {} ? [] : [1]
    content {
      type = var.identity.type
    }
  }
  location   = var.location
  metadata   = local.metadata
  not_scopes = var.not_scopes
  parameters = local.parameters
}
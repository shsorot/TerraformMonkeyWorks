resource "azurerm_management_group_policy_assignment" "this" {
  # This may change to Management Group in later provider release
  management_group_id  = local.management_group_id
  name                 = var.name
  policy_definition_id = coalesce(local.policy_definition_id, local.policy_definition_set_id)
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  dynamic "identity" {
    for_each = var.identity == null || var.identity == {} ? [] : [1]
    content {
      type = var.identity.type
    }
  }
  location   = local.location
  metadata   = local.metadata
  not_scopes = var.not_scopes
  parameters = local.parameters
}
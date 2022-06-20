resource "azurerm_policy_definition" "this" {
  name         = var.name
  policy_type  = var.policy_type
  mode         = var.mode
  display_name = var.display_name
  description  = var.description
  #Deprecated from provider version > 3.00.0
  # management_group_name = var.management_group_name
  management_group_id = local.management_group_id
  policy_rule         = local.policy_rule
  metadata            = local.metadata
  parameters          = local.parameters
}
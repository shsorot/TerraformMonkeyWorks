resource "azurerm_policy_remediation" "this" {
  name                           = var.name
  scope                          = local.scope
  policy_assignment_id           = local.policy_assignment_id
  policy_definition_reference_id = local.policy_definition_reference_id
  location_filters               = var.location_filters
  resource_discovery_mode        = var.resource_discovery_mode
}
# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}


locals {
  scope = var.scope
  policy_assignment_id = var.policy_assignment.id == null ? (
    var.policy_assignments[var.policy_assignment.key].id
  ) : var.policy_assignment.id

  policy_definition_reference_id = var.policy_definition_reference.id == null ? (
    var.policy_definitions[var.policy_definition_reference.key].id
  ) : var.policy_definition_reference.id
}
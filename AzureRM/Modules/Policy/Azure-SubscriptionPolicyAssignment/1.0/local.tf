# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = var.subscription_id == null ? data.azurerm_subscription.current.subscription_id : var.subscription_id
}


# <TODO> add logic for lookup of subscriptions using name and azurerm_subscriptions block
locals {
  policy_definition_id = var.policy_definition.id == null ? (
    var.policy_definition.definition_tag == null ? (
      var.policy_definition_sets[var.policy_definition.definition_set_tag].id
    ) : var.policy_definitions[var.policy_definition.key].id
  ) : var.policy_definition.id
  metadata = var.metadata == null ? null : (
    var.metadata.json == null ? (
      var.metadata.file == null ? null : file(var.metadata.file)
    ) : var.metadata.json
  )
  parameters = var.parameters == null ? null : (
    var.parameters.json == null ? (
      var.parameters.file == null ? null : file(var.parameters.file)
    ) : var.parameters.json
  )
}
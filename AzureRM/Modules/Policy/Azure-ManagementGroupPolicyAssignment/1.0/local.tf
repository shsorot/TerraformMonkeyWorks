# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  location        = var.location
}

data "azurerm_management_group" "this" {
  count = var.management_group.name == null ? 0 : 1
  name  = var.management_group.name
}

data "azurerm_policy_definition" "this" {
  count = (var.policy_definition == null ? null : var.policy_definition.name) == null ? 0 : 1
  name  = var.policy_definition.name
}

data "azurerm_policy_set_definition" "this" {
  count = (var.policy_definition_set == null ? null : var.policy_definition_set.name) == null ? 0 : 1
  name  = var.policy_definition_set.name
}

locals {
  management_group_id = var.management_group.id == null ? (
    var.management_group.name == null ? (
      var.management_groups[var.management_group.tag].id
    ) : data.azurerm_management_group.this[0].id
  ) : var.management_group.id

  policy_definition_id = var.policy_definition == null ? null : (
    var.policy_definition.id == null ? (
      var.policy_definition.name == null ? (
        var.policy_definitions[var.policy_definition.tag].id
      ) : data.azurerm_policy_definition.this[0].id
    ) : var.policy_definition.id
  )


  policy_definition_set_id = var.policy_definition_set == null ? null : (
    var.policy_definition_set.id == null ? (
      var.policy_definition_set.name == null ? (
        var.policy_definition_sets[var.policy_definition_set.tag].id
      ) : data.azurerm_policy_set_definition.this[0].id
    ) : var.policy_definition_set.id
  )


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
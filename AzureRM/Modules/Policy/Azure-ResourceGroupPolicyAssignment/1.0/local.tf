# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  location        = var.location
}

data "azurerm_policy_definition" "this" {
  count = (var.policy_definition == null ? null : var.policy_definition.name) == null ? 0 : 1
  name  = var.policy_definition.name
}

data "azurerm_policy_set_definition" "this" {
  count = (var.policy_definition_set == null ? null : var.policy_definition_set.name) == null ? 0 : 1
  name  = var.policy_definition_set.name
}

# Create a provider to specific subscription where the resource exists.

provider "azurerm" {
  alias           = "policy"
  subscription_id = coalesce(var.resource_group.subscription_id, local.subscription_id)
}

data "azurerm_resource_group" "this" {
  count    = var.resource_group.name == null ? 0 : 1
  name     = var.resource_group.name
  provider = provider.policy
}

locals {
  resource_group_id = var.resource_group.id == null ? (
    var.resource_group.name == null ? (
      var.resource_groups[var.resource_group.key].id
    ) : data.azurerm_resource_group.this[0].id
  ) : var.resource_group.id

  policy_definition_id = var.policy_definition == null ? null : (
    var.policy_definition.id == null ? (
      var.policy_definition.name == null ? (
        var.policy_definitions[var.policy_definition.key].id
      ) : data.azurerm_policy_definition.this[0].id
    ) : var.policy_definition.id
  )


  policy_definition_set_id = var.policy_definition_set == null ? null : (
    var.policy_definition_set.id == null ? (
      var.policy_definition_set.name == null ? (
        var.policy_definition_sets[var.policy_definition_set.key].id
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
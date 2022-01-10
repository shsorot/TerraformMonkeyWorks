# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}


# <TODO> Add a list based lookup for resource types, Terraform data class and a remote subscription provider block 
locals {
  resource_id = var.resource.id == null ? (
    var.resource.name == null ? (
      var.resources[var.resource.tag].id
    ) : "/subscriptions/${var.resource.subscription_id == null ? local.subscription_id : var.resource.subscription_id}/resourceGroups/${var.resource.resource_group_name}/providers/${var.resource.provider}/${var.resource.name}"
  ) : var.resource.id

  policy_definition_id = var.policy_definition.id == null ? (
    var.policy_definition.definition_tag == null ? (
      var.policy_definition_sets[var.policy_definition.definition_set_tag].id
    ) : var.policy_definitions[var.policy_definition.tag].id
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
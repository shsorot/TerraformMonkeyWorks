# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  policy_rule = var.policy_rule == null ? null : (
    var.policy_rule.json == null ? (
      var.policy_rule.file == null ? null : file(var.policy_rule.file)
    ) : var.policy_rule.json
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

data "azurerm_management_group" "this"{
  count = var.management_group.name != null ? 0 : 1
  name = var.management_group.name
}

locals {
  management_group_id = var.management_group == null || var.management_group == {} ? null : (
    var.management_group.id == null ? (
      var.management_group.name == null ? (
        var.management_groups[var.management_group.tag].id
       ) : data.azurerm_management_group.this[0].id
    ) : var.management_group.id
  )
}
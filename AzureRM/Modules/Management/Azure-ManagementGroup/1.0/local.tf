# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
  parent_management_group_id = var.parent_management_group == null || var.parent_management_group == {} ? null : (
    var.parent_management_group.id == null ? (
      var.parent_management_group.name == null ? (
        var.management_groups[var.parent_management_group.tag].id
      ) : "/providers/Microsoft.Management/managementGroups/${var.parent_management_group.name}"
    ) : var.parent_management_group.id
  )
}

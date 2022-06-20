# This file contains local & data blocks
data "azurerm_subscription" "current" {
}


data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = var.tenant_id == null ? data.azurerm_client_config.current.tenant_id : var.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = var.subscription_id == null ? data.azurerm_subscription.current.subscription_id : var.subscription_id
  management_group_id = var.management_group == null || var.management_group == {} ? null : (
    var.management_group.id == null ? (
      var.management_group.name == null ? (
        var.management_groups[var.management_group.key].id
      ) : "/providers/Microsoft.Management/managementGroups/${var.management_group.name}"
    ) : var.management_group.id
  )
}

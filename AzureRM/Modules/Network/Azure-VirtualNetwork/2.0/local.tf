# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "this" {
  count = var.resource_group.name == null ? 0 : 1
  name  = var.resource_group.name
}

#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.tag].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}
locals {

  subnet          = { for instance in var.subnet : instance.name => instance }
  security_groups = { for instance in var.subnet : instance.name => instance.security_group if instance.security_group != null }
  route_tables    = { for instance in var.subnet : instance.name => instance.route_table if instance.route_table != null }
}


locals {
  ddos_protection_plan_id = var.ddos_protection_plan == null || var.ddos_protection_plan == {} ? null : (
    var.ddos_protection_plan.id == null ? (
      var.ddos_protection_plan.name == null ? (
        var.ddos_protection_plans[var.ddos_protection_plan.tag].id
      ) : "/subscriptions/${var.ddos_protection_plan.subscription_id == null ? local.subscription_id : var.ddos_protection_plan.subscription_id}/resourceGroups/${var.ddos_protection_plan.resource_group_name == null ? local.resource_group_name : var.ddos_protection_plan.resource_group_name}/providers/Microsoft.Network/ddosProtectionPlans/${var.ddos_protection_plan.name}"
    ) : var.ddos_protection_plan.id
  )
}
# This file contains local & data blocks
data "azurerm_subscription" "current" {
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

#Create the local variables
locals {
  ddos_protection_plan_rg              = var.ddos_protection_plan == null ? local.resource_group_name : (var.ddos_protection_plan.resource_group_name == null ? local.resource_group_name : var.ddos_protection_plan.resource_group_name)
  ddos_protection_plan_name            = var.ddos_protection_plan == null ? "" : var.ddos_protection_plan.name
  ddos_protection_plan_subscription_id = var.ddos_protection_plan == null ? local.subscription_id : (var.ddos_protection_plan.subscription_id == null ? local.subscription_id : var.ddos_protection_plan.subscription_id)
  ddos_protection_plan_lookup_id = var.ddos_protection_plans == null ? null : var.ddos_protection_plan.tag == null ? null : (
    var.ddos_protection_plans[var.ddos_protection_plan.tag].id
  )
  ddos_protection_plan_remote_id = "/subscriptions/${local.ddos_protection_plan_subscription_id}/resourceGroups/${local.ddos_protection_plan_rg}/providers/Microsoft.Network/ddosProtectionPlans/${local.ddos_protection_plan_name}"
  ddos_protection_plan_id = var.ddos_protection_plans == null ? null : var.ddos_protection_plan.id == null ? (
    local.ddos_protection_plan_name == null ? local.ddos_protection_plan_lookup_id : local.ddos_protection_plan_remote_id
  ) : var.ddos_protection_plan.id

  subnet = var.subnet == null ? {} : { for instance in var.subnet : instance.name => instance }
}

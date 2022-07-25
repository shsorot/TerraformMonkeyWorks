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
  resource_group_name     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].name : data.azurerm_resource_group.this[0].name
  resource_group_tags     = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].tags : data.azurerm_resource_group.this[0].tags
  tags                    = merge(var.tags, (var.inherit_tags == true ? local.resource_group_tags : {}))
  resource_group_location = var.resource_group.name == null ? var.resource_groups[var.resource_group.key].location : data.azurerm_resource_group.this[0].location
  location                = var.location == null ? local.resource_group_location : var.location
}

# Data block for NSG, consumed by azurerm_subnet_network_security_group_association.tf for subnet association
data "azurerm_network_security_group" "this"{
  for_each = { for instance in var.subnet: instance.security_group.name => instance.security_group if (
    instance.security_group == null || instance.security_group == {} ? false : (
      instance.security_group.name == null ? false : true ))}
  name   = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name,local.resource_group_name)
}

# Data block for Route Table , to be used consumed by azurerm_subnet_route_table_association for subnet association
data "azurerm_route_table" "this"{
  for_each  = { for instance in var.subnet: instance.route_table.name => instance.route_table if (
    instance.route_table == null || instance.route_table == {} ? false: (
      instance.route_table.name == null ? false : true )) }
  name = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name,local.resource_group_name)
}

locals {
  subnet          = { for instance in var.subnet : instance.name => instance }
  # security_groups = { for instance in var.subnet : instance.name => instance.security_group if instance.security_group != null }
  security_groups = { for instance in var.subnet : instance.name => {
    network_security_group_id = instance.security_group.id == null ? (
      instance.security_group.name == null ? (
        var.network_security_groups[instance.security_group.key].id
      ) : data.azurerm_network_security_group.this[instance.security_group.name].id
    ) : instance.security_group.id
  } if (instance.security_group == null || instance.security_group == {} ? false : true )}

  # route_tables    = { for instance in var.subnet : instance.name => instance.route_table if instance.route_table != null }
   route_tables = { for instance in var.subnet : instance.name => {
    route_table_id = instance.route_table.id == null ? (
      instance.route_table.name == null ? (
        var.route_tables[instance.route_table.key].id
      ) : data.azurerm_network_security_group.this[instance.route_table.name].id
    ) : instance.route_table.id
  } if (instance.route_table == null || instance.route_table == {} ? false : true )}
}


locals {
  ddos_protection_plan_id = var.ddos_protection_plan == null || var.ddos_protection_plan == {} ? null : (
    var.ddos_protection_plan.id == null ? (
      var.ddos_protection_plan.name == null ? (
        var.ddos_protection_plans[var.ddos_protection_plan.key].id
      ) : "/subscriptions/${var.ddos_protection_plan.subscription_id == null ? local.subscription_id : var.ddos_protection_plan.subscription_id}/resourceGroups/${var.ddos_protection_plan.resource_group_name == null ? local.resource_group_name : var.ddos_protection_plan.resource_group_name}/providers/Microsoft.Network/ddosProtectionPlans/${var.ddos_protection_plan.name}"
    ) : var.ddos_protection_plan.id
  )
}
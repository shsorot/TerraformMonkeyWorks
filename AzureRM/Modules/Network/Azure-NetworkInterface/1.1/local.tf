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

  #load_balanced_ip_configuration = { for v in var.ip_configuration : v.name => v.backend_address_pool  if  v.backend_address_pool != null }
  load_balanced_ip_configuration = flatten([for v in var.ip_configuration :
    [for instance in v.backend_address_pool :
      {
        ip_configuration_name = v.name
        backend_address_pool_id = instance.id == null ? (
          instance.name == null && instance.load_balancer_name == null ? (
            var.loadbalancers[instance.loadbalancer_tag].backend_address_pool[instance.backend_pool_tag].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${instance.resource_group_name == null ? local.resource_group_name : instance.resource_group_name}/providers/Microsoft.Network/loadBalancers/${instance.load_balancer_name}/backendAddressPools/${instance.name}"
        ) : instance.id
      }
    ]
  if(v.backend_address_pool != null && v.backend_address_pool != [])])

  public_ip_address = { for v in var.ip_configuration : v.name => v.public_ip_address if(v.public_ip_address != null || v.public_ip_address != []) }
}
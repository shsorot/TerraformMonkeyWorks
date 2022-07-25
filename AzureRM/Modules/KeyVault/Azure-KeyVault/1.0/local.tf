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

 # Data block to be consumed by network_acls
data "azurerm_subnet" "this"{
  for_each =  { for instance in (var.network_acls == null || var.network_acls == {} ? [] : (
                  var.network_acls.virtual_network_subnet == [] ||  var.network_acls.virtual_network_subnet == null ? [] :  var.network_acls.virtual_network_subnet
                ) ) : concat(instance.name,"-",instance.virtual_network_name) => instance if ( 
                  instance.name == null && instance.virtual_network_name == null ? false : true )
              }
  name = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name = coalesce(each.value.resource_group_name,local.resource_group_name)
}


locals{
  network_acls = var.network_acls == null || var.network_acls == {} ? null : {
      bypass          = var.network_acls.bypass
      default_action  =  var.network_acls.default_action
      ip_rules        =  var.network_acls.ip_rules
      virtual_network_subnet_ids = flatten([ for item in var.network_acls.virtual_network_subnet : [
                                              item.id == null ? (
                                                item.name == null && item.virtual_network_name == null  ? (
                                                  var.virtual_networks[item.virtual_network_key].subnet[item.key].id
                                                ) : data.azurerm_subnet.this[ concat(item.name,"-",item.virtual_network_name)].id
                                              ) : item.id
                                          ] if ( var.network_acls.virtual_network_subnet == null ||  var.network_acls.virtual_network_subnet ==  [] ? false : true )])
    }


}
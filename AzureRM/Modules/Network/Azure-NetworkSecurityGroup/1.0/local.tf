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

# TODO : Add data block based lookup

# Specific to NSG rule assignment.
locals {
  # keys  = var.application_security_groups == null ? [] : keys(var.application_security_groups)
  # values= var.application_security_groups == null ? [] : values(var.application_security_groups)[*].application_security_group_id

  # Reconstruct the NSG rule object
  nsg_rule = { for instance in(var.nsg_rule == null ? [] : var.nsg_rule) : instance.name => {
    "name"                    = instance.name
    "description"             = instance.description
    "direction"               = instance.direction
    "priority"                = instance.priority
    "access"                  = instance.access
    "protocol"                = instance.protocol
    "source_address_prefix"   = instance.source_address_prefix
    "source_address_prefixes" = instance.source_address_prefixes
    "source_application_security_group_ids" = [for asg in(instance.source_application_security_group == null ? [] : instance.source_application_security_group) :
      (
        asg.id == null ? (
          asg.name == null ? (
            var.application_security_groups[asg.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${asg.resource_group_name == null ? local.resource_group_name : asg.resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${asg.name}"
        ) : asg.id
      )
    ]
    "source_port_range"            = instance.source_port_range
    "source_port_ranges"           = instance.source_port_ranges
    "destination_address_prefix"   = instance.destination_address_prefix
    "destination_address_prefixes" = instance.destination_address_prefixes
    "destination_application_security_group_ids" = [for asg in(instance.destination_application_security_group == null ? [] : instance.destination_application_security_group) :
      (
        asg.id == null ? (
          asg.name == null ? (
            var.application_security_groups[asg.key].id
          ) : "/subscriptions/${local.subscription_id}/resourceGroups/${asg.resource_group_name == null ? local.resource_group_name : asg.resource_group_name}/providers/Microsoft.Network/applicationSecurityGroups/${asg.name}"
        ) : asg.id
      )
    ]
    "destination_port_range"  = instance.destination_port_range
    "destination_port_ranges" = instance.destination_port_ranges
  } }
}

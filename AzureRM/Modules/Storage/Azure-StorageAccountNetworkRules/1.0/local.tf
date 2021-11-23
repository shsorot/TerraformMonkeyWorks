# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id       = data.azurerm_client_config.current.client_id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  subscription_id = data.azurerm_subscription.current.subscription_id
}

locals {
  virtual_network_subnet_ids = var.virtual_network_subnet == null || var.virtual_network_subnet == [] ? null : (
    [for instance in(var.virtual_network_subnet == null || var.virtual_network_subnet == [] ? [] : var.virtual_network_subnet) : (
      instance.id == null ? (
        instance.name == null && instance.virtual_network_name == null ? (
          var.virtual_networks[instance.virtual_network_tag].subnet[instance.tag].id
        ) : "/subscriptions/${local.subscription_id}/resourceGroups/${instance.resource_group_name == null ? local.resource_group_name : instance.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${instance.virtual_network_name}/subnets/${instance.name}"
      ) : instance.id
      )
    ]
  )
}
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

# TODO : add support for role_definition_id property
data "azurerm_role_definition" "this" {
  count = (var.role_definition == null || var.role_definition == {}) && var.role_definition_name != null ? 0 : (var.role_definition.name == null ? 0 : 1)
  name  = var.role_definition.name
  scope = coalesce(var.role_definition.scope, data.azurerm_subscription.current.id)
}

# <TODO> assign data block and list based lookup for scope and resource types when scope is < subscription
locals {
  scope = var.scope
  role_definition_id = (var.role_definition == null || var.role_definition == {}) && var.role_definition_name != null ? null : (
    var.role_definition.id == null ? (
      var.role_definition.name == null ? (
        var.role_assignments[var.role_definition.key].id
      ) : data.azurerm_role_assignment.this[0].id
    ) : var.role_def
  )

}
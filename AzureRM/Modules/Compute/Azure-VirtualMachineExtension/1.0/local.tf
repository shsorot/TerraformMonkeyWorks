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
  tags            = var.tags
}

data "azurerm_virtual_machine" "this" {
  count               = var.virtual_machine.name == null ? 0 : 1
  name                = var.virtual_machine.name
  resource_group_name = var.virtual_machine.resource_group_name
}

locals {
  virtual_machine_id = var.virtual_machine.id == null ? (
    var.virtual_machine.name == null && var.virtual_machine.resource_group_name == null ? (
      var.virtual_machines[var.virtual_machine.key].id
    ) : data.azurerm_virtual_machine.this[0].id
  ) : var.virtual_machine.id
}

# Create an extension settings and protected settings blocks
locals {
  settings = var.settings.json == null ? (
    file(var.settings.file)
  ) : var.settings.json
  protected_settings = var.protected_settings.json == null ? (
    file(var.protected_settings.file)
  ) : var.protected_settings.json
}
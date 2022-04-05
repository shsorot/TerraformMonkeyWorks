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
  tags            = merge(var.tags, { "extensionType" = "JsonADDomainExtension" })
}

data "azurerm_virtual_machine" "this" {
  count               = var.virtual_machine.name == null ? 0 : 1
  name                = var.virtual_machine.name
  resource_group_name = var.virtual_machine.resource_group_name
}

locals {
  virtual_machine_id = var.virtual_machine.id == null ? (
    var.virtual_machine.name == null && var.virtual_machine.resource_group_name == null ? (
      var.virtual_machines[var.virtual_machine.tag].id
    ) : data.azurerm_virtual_machine.this[0].id
  ) : var.virtual_machine.id
}

# Create a domain join settings and protected blocks
locals {
  settings           = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "${var.ou_path != null ? var.ou_path : ""}",
        "User": "${var.active_directory_username}@${var.active_directory_domain}",
        "Restart": "true",
        "Options": "3"
    }
    SETTINGS
  protected_settings = <<SETTINGS
        {
            "Password": "${var.active_directory_password}"
        }
    SETTINGS
}
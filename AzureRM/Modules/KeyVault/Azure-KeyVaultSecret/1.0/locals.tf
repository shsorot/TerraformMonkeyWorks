# Generate the Keyvault ID from userinput/output of Module Azure-KeyVault or generate from resource group and Key vault name
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


data "azurerm_key_vault" "this" {
  count               = var.key_vault.name == null && var.key_vault.resource_group_name == null ? 0 : 1
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

locals {
  key_vault_id = var.key_vault.id == null ? (
    var.key_vault.name == null && var.key_vault.resource_group_name == null ? (
      var.key_vaults[var.key_vault.key].id
    ) : data.azurerm_key_vault.this[0].id
  ) : var.key_vault.id
}



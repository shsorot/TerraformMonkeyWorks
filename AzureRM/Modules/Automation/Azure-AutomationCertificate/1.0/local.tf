# This file contains local & data blocks
data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}


#Create the local variables
locals {
  client_id               = data.azurerm_client_config.current.client_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  subscription_id         = data.azurerm_subscription.current.subscription_id
}


data "azurerm_automation_account" "this"{
  count = var.automation_account.name == null ? 0 : 1
  name  = var.automation_account.name
  resource_group_name = var.automation_account.resource_group_name
}

locals {
  automation_account_name = var.automation_account.id == null ? (
    var.automation_account.name == null && var.automation_account.resource_group_name == null ? (
      var.automation_accounts[var.automation_account.tag].name
    ) : data.azurerm_automation_account.this[0].name
  ) : split("/",var.automation_account.id)[8]
  resource_group_name  = var.automation_account.id == null ? (
    var.automation_account.name == null && var.automation_account.resource_group_name == null ? (
      var.automation_accounts[var.automation_account.tag].resource_group_name
    ) : data.azurerm_automation_account.this[0].resource_group_name
  ) : split("/",var.automation_account.id)[4]

  base64 = var.base64.raw == null ? filebase64(var.base64.file) : var.base64.raw
}
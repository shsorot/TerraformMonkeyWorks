resource "azurerm_automation_certificate" "this" {
  name                    = var.name
  resource_group_name     = local.resource_group_name
  automation_account_name = local.automation_account_name
  
  description = var.description
  base64      = local.base64
  exportable  = var.exportable
}
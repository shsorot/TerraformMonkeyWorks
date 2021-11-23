
resource "azurerm_automation_account" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  sku_name = var.sku_name == null ? "Basic" : var.sku_name
}
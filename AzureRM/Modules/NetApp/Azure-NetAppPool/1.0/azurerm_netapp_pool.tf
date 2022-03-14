resource "azurerm_netapp_pool" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = var.location
  account_name        = local.account_name
  tags                = local.tags
  service_level       = var.service_level
  size_in_tb          = var.size_in_tb
  qos_type            = var.qos_type
}
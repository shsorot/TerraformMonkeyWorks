resource "azurerm_network_ddos_protection_plan" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
}
resource "azurerm_subnet" "this" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.subnet.resource_group_name
  virtual_network_name = var.subnet.virtual_network_name
  address_prefixes     = var.subnet.address_prefixes
}
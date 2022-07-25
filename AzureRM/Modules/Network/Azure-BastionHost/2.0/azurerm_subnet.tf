resource "azurerm_subnet" "this" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = local.virtual_network_resource_group_name
  virtual_network_name = local.virtual_network_name
  address_prefixes     = local.address_prefixes
}
resource "azurerm_virtual_wan" "this" {
  name                              = var.name
  resource_group_name               = local.resource_group_name
  location                          = local.location
  tags                              = local.tags
  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category
  type                              = var.type
}
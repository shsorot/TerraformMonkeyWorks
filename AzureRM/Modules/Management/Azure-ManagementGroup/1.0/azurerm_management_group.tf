resource "azurerm_management_group" "this" {
  name                       = var.name
  group_id                   = var.group_id
  display_name               = var.display_name
  parent_management_group_id = local.parent_management_group_id
  subscription_ids           = var.subscription_ids
}
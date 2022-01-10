resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = local.management_group_id
  subscription_id     = local.subscription_id
}
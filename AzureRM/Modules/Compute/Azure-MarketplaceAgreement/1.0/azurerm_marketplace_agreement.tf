resource "azurerm_marketplace_agreement" "this" {
  publisher = var.publisher
  offer     = var.offer
  plan      = var.plan
}
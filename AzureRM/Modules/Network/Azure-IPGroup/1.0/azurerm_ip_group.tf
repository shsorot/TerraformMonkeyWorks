#Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group

resource "azurerm_ip_group" "this" {

  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  cidrs               = var.cidrs
}

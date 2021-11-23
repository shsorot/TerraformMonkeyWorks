# v1.0 create an application security group

resource "azurerm_application_security_group" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

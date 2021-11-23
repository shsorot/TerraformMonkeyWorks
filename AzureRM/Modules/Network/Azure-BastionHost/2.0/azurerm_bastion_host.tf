resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = azurerm_subnet.this.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  sku = var.sku
  copy_paste_enabled = var.copy_paste_enabled
  file_copy_enabled = var.sku == "Standard" ? var.file_copy_enabled : null
  ip_connect_enabled = var.sku == "Standard" ? var.ip_connect_enabled : null
  scale_units = var.sku == "Standard" ? var.scale_units : 2
  shareable_link_enabled = var.sku == "Standard" ? var.shareable_link_enabled : null
  tunneling_enabled = var.sku == "Standard" ? var.tunneling_enabled : null
  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = azurerm_subnet.this.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
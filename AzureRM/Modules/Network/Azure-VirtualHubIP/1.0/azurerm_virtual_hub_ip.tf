resource "azurerm_virtual_hub_ip" "this" {
  name                         = var.name
  virtual_hub_id               = local.virtual_hub_id
  subnet_id                    = local.subnet_id
  private_ip_address           = var.private_ip_address
  private_ip_allocation_method = var.private_ip_address == null ? "Dynamic" : var.private_ip_allocation_method
  public_ip_address_id         = local.public_ip_address_id
}
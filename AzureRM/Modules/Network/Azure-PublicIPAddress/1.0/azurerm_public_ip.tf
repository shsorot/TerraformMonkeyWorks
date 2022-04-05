
resource "azurerm_public_ip" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  # only dynamic is supported with IPv6
  #allocation_method       = var.ip_version == "IPv6" ? "Dynamic" : var.allocation_method
  allocation_method       = var.allocation_method
  sku                     = var.sku
  ip_version              = var.ip_version
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  domain_name_label       = var.domain_name_label
  reverse_fqdn            = var.reverse_fqdn

  public_ip_prefix_id = local.public_ip_prefix_id

  # Depcrecated from provider > 3.00.0
  # availability_zone = var.availability_zone
  zones             = var.zones
  tags              = local.tags
}
# TODO : Add data block based lookup
resource "azurerm_network_interface_application_security_group_association" "this" {
  count                         = local.application_security_group_ids == null || local.application_security_group_ids == [] ? 0 : length(local.application_security_group_ids)
  network_interface_id          = azurerm_network_interface.this.id
  application_security_group_id = local.application_security_group_ids[count.index]
}
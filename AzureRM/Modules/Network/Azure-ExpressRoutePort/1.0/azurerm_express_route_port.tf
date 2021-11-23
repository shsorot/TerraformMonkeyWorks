resource "azurerm_express_route_port" "this" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  bandwidth_in_gbps   = var.bandwidth_in_gbps
  encapsulation       = var.encapsulation
  peering_location    = var.peering_location
  #link1               = var.link1
  #link2               = var.link2
  dynamic "link1" {
    for_each = var.link1 == null ? [] : var.link1
    content {
      admin_enabled                 = link1.value.admin_enabled
      macsec_cipher                 = link1.value.macsec_cipher
      macsec_ckn_keyvault_secret_id = link1.value.macsec_ckn_keyvault_secret_id
      macsec_cak_keyvault_secret_id = link1.value.macsec_cak_keyvault_secret_id
    }
  }

  dynamic "link2" {
    for_each = var.link2 == null ? [] : var.link1
    content {
      admin_enabled                 = link2.value.admin_enabled
      macsec_cipher                 = link2.value.macsec_cipher
      macsec_ckn_keyvault_secret_id = link2.value.macsec_ckn_keyvault_secret_id
      macsec_cak_keyvault_secret_id = link2.value.macsec_cak_keyvault_secret_id
    }
  }

  # TODO , add a lookup for identity from identity object
  dynamic "identity" {
    for_each = var.identity
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
}
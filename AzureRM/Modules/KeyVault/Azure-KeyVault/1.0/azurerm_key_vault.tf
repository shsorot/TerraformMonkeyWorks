resource "azurerm_key_vault" "this" {
  tags                = local.tags
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = (var.sku_name == null) ? "standard" : var.sku_name
  tenant_id           = local.tenant_id

  enabled_for_deployment          = (var.enabled_for_deployment == null) ? false : var.enabled_for_deployment
  enabled_for_template_deployment = (var.enabled_for_template_deployment == null) ? false : var.enabled_for_template_deployment
  enabled_for_disk_encryption     = (var.enabled_for_disk_encryption == null) ? false : var.enabled_for_disk_encryption
  enable_rbac_authorization       = (var.enable_rbac_authorization == null) ? false : var.enable_rbac_authorization
  soft_delete_retention_days      = (var.soft_delete_retention_days == null) ? 90 : var.soft_delete_retention_days
  purge_protection_enabled        = (var.purge_protection_enabled == null) ? false : var.purge_protection_enabled

  # This is not an inline block, but an actual list of object . Set to [] to remove any access policies.
  # this will not work if enable_rbac_authorization is set to true
  # access_policy                   = var.access_policy == null || var.access_policy == [] ? [] : var.access_policy
  access_policy = var.access_policy

  # Single block, Optional
  # TODO : Add data block based lookup
  # Move complex lookup code to local.tf
  # Note: This is a single block, but can have multiple IP rules and virtual network subnet IDS. Default action is to block, and you allow IP/subnets on individual basis
  dynamic "network_acls" {
    for_each = local.network_acls == null ? [] : [1]
    content {
      default_action = local.network_acls.default_action
      bypass         = local.network_acls.bypass
      ip_rules       = local.network_acls.ip_rules
      virtual_network_subnet_ids = local.network_acls.virtual_network_subnet_ids
    }
  }

  # Single block, Optional
  dynamic "contact" {
    for_each = var.contact == {} || var.contact == null ? [] : [1]
    content {
      email = var.contact.email
      name  = var.contact.name
      phone = var.contact.phone
    }
  }


  lifecycle {
    ignore_changes = [
      tenant_id # Terraform tries to change this attribute on subsequent runs, ignore_changes prevents this
    ]
    #prevent_destroy = true
  }
}

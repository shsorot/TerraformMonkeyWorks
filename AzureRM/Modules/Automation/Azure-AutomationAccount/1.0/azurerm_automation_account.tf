
resource "azurerm_automation_account" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  sku_name = var.sku_name == null ? "Basic" : var.sku_name
  # Added in > 3.xx.x
  public_network_access_enabled = var.public_network_access_enabled
  local_authentication_enabled = var.local_authentication_enabled


  # Added identity block to support Azure Automation Account with Managed Identity
  # Single block, Optional
  # Note: you can have both system assigned and list of user assigned identities for automation account managed identity configuration
  dynamic "identity" {
    for_each = local.identity == null ? [] : [1]
    content {
      type = local.identity.type
      # you can have multiple ID's for user assigned identity. You can also have 1 system assigned + multiple user assigned identities.
      identity_ids = local.identity.identity_ids
    }
  }

  # added in >3.3x.x
  # Single Block, Optional
  dynamic "encryption"{
    for_each = local.encryption == null ? [] : [1]
    content {
      user_assigned_identity_id = each.value.user_assigned_identity_id
      key_source = each.value.key_source
      key_vault_key_id = each.value.key_vault_key_id
    }
  }
}
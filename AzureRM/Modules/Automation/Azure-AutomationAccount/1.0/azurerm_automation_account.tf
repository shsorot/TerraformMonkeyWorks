
resource "azurerm_automation_account" "this" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  sku_name = var.sku_name == null ? "Basic" : var.sku_name

  # Added identity block to support Azure Automation Account with Managed Identity
  # Single block
  dynamic "identity"{
    for_each = local.identity == null ? [] : [1]
    content {
      type = local.identity.type
      # you can have multiple ID's for user assigned identity. You can also have 1 system assigned + multiple user assigned identities.
      identity_ids = local.identity.identity_ids
    }
  }
}
# -
# - Generate Password for Windows Virtual Machine
# -


resource "random_password" "credential-value" {
  length           = 12
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}

# -
# - Store Generated Password to Key Vault Secrets
# - Design Decision #1582
# -
resource "azurerm_key_vault_secret" "pan-fw-secret" {
  for_each     = { for instance in var.firewall-vm : instance.name => instance }
  name         = "${each.value.name}-firewall-password"
  value        = local.admin-password
  key_vault_id = local.key-vault-id

  lifecycle {
    ignore_changes = [value, key_vault_id]
  }
}


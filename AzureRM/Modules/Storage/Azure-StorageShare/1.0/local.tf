
locals {
  storage_account_name = var.storage_account.name == null ? (
    var.storage_accounts[var.storage_account.key].name
  ) : var.storage_account.name
}
data "terraform_remote_state" "this" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_resource_group_name
    storage_account_name = var.remote_storage_account_name
    container_name       = var.remote_container_name
    key                  = var.remote_key_name
  }
}
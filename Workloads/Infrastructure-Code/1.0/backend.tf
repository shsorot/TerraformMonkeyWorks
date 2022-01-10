
terraform {
  backend "azurerm" {
    storage_account_name = "shsorotsapstor"
    container_name       = "tfstatefile"
    key                  = "SHSOROT-statefile2.tfstate"
    access_key           = "swSWBdwW+4r5TAm7et5+vcr+XoAO+s/vZT1piMttoZd7k5ZXhg3sM0/aXsQZJy9N2bGkK4rvxncWRA7Fr2fSNg=="
  }
}
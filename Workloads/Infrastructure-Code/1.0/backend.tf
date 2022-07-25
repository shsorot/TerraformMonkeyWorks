
terraform {
  backend "azurerm" {
    storage_account_name = "shsorotsapstor"
    container_name       = "tfstatefile"
    key                  = "SHSOROT-statefile.tfstate"
    access_key           = "BfqT1PshXU9yHp7QO7Fb5EKxoKKc4PcLZ4jCQAzUz5JrRXrI0W/1asjyUO1td6CAgbxn2vvoMvgPdbjdUeD1Dw=="
  }
}

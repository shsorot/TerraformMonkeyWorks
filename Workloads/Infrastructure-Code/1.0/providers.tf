/*
Description:

  Constraining provider versions
    =    (or no operator): exact version equality
    !=   version not equal
    >    greater than version number
    >=   greater than or equal to version number
    <    less than version number
    <=   less than or equal to version number
    ~>   pessimistic constraint operator, constraining both the oldest and newest version allowed.
           For example, ~> 0.9   is equivalent to >= 0.9,   < 1.0 
                        ~> 0.8.4 is equivalent to >= 0.8.4, < 0.9
*/
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
      graceful_shutdown          = false
    }
  }
  partner_id = ""
}

provider "azurerm" {
  alias = "test"
  subscription_id = "ae894bb7-da9a-40de-b039-5018557f3df1"
  tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  features{}
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7.0"
    }
  }
}

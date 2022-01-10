ResourceGroups = {
  RG-NAM-IDT-Network = {
    name     = "RG-NAM-IDT-Network"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  },
  RG-NAM-IDT-IaC = {
    name     = "RG-NAM-IDT-IaC"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Application"
    }
  }
  RG-NAM-IDT-Security = {
    name     = "RG-NAM-IDT-Security"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  RG-NAM-IDT-Mgmt = {
    name     = "RG-NAM-IDT-Mgmt"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  RG-NAM-IDT-PRD-Identity = {
    name     = "RG-NAM-IDT-PRD-Identity"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  RG-NAM-IDT-PRD-ADFS = {
    name     = "RG-NAM-IDT-PRD-ADFS"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Security"
    }
  }
  #         "NeworkWatcherRG" =   {
  #                     name        =   "NetworkWatcherRG"
  #                     location    =   "East US2"
  #                     tags        =   {
  #                                         "Environment" = "Dev"
  #                                         "Component"   = "Automation"
  #                                     }
  #         }
}

AvailabilitySets = {
  AV-NAM-IDT-PRD-identity = {
    name                         = "AV-NAM-IDT-PRD-identity"
    resource_group               = { name = "RG-NAM-IDT-PRD-Identity" }
    location                     = "East US2"
    platform_fault_domain_count  = 3
    platform_update_domain_count = 2
    managed                      = true
  }
  AV-NAM-IDT-PRD-ADFS-01 = {
    name                         = "AV-NAM-IDT-PRD-ADFS-01"
    resource_group               = { name = "RG-NAM-IDT-PRD-ADFS" }
    location                     = "East US2"
    platform_fault_domain_count  = 3
    platform_update_domain_count = 2
    managed                      = true
  }
  AV-NAM-IDT-PRD-ADFSRP-02 = {
    name                         = "AV-NAM-IDT-PRD-ADFSRP-02"
    resource_group               = { name = "RG-NAM-IDT-PRD-ADFS" }
    location                     = "East US2"
    platform_fault_domain_count  = 3
    platform_update_domain_count = 2
    managed                      = true
  }
}

KeyVaults = {
  "KV-NAM-IDT-Core" = {
    name                        = "KV-NAM-IDT-Core-sbx2"
    resource_group              = { tag = "RG-NAM-IDT-Security" }
    location                    = "East US2"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
    enabled_for_disk_encryption = true
    network_acls = {
      default_action = "Allow"
      bypass         = "AzureServices"
      # ip_rules              =   ["10.0.0.0/8"]
    }
  }
}

KeyVaultAccessPolicies = {
  "KV-NAM-IDT-Core_acl_AZU-EUR-WW-DEV-CoreEngineering4" = {
    key_vault = {
      tag = "KV-NAM-IDT-Core"
    }
    tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    object_id = "59d33c4f-8163-4e4a-b5e6-3d17a6347437"
    #application_id  =   "c66aac7a-ecd1-4631-88cd-fd467752fcda"
    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]
    key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]
  }
}

NetworkSecurityGroups = {
  NSG-NAM-Idt-sbnt-identity = {
    name           = "NSG-NAM-IDT-sbnt-identity"
    resource_group = { tag = "RG-NAM-IDT-Network" }
    location       = "East US2"
    # nsg_rule =  [
    #     {
    #         name        = "AllowInApp"
    #         direction   = "InBound"
    #         priority    =   100
    #         access      =   "Allow"
    #         protocol    =   "tcp"
    #         source_application_security_group   =   [
    #             {
    #                 tag =   "appasg1"
    #             },
    #             {
    #                 tag =   "appasg2"
    #             },
    #             {
    #                 tag =   "appasg3"
    #             }
    #         ]
    #         destination_application_security_group  =   [
    #             {
    #                 tag =   "dbasg1"
    #             },
    #             {
    #                 tag =   "dbasg2"
    #             }
    # ]
    # }
    # ] 
  }
  NSG-NAM-Idt-sbnt-application1 = {
    name           = "NSG-NAM-IDT-sbnt-application1"
    resource_group = { tag = "RG-NAM-IDT-Network" }
    location       = "East US2"
  }
  NSG-NAM-Idt-sbnt-dmz-external = {
    name           = "NSG-NAM-IDT-sbnt-dmz-external"
    resource_group = { tag = "RG-NAM-IDT-Network" }
    location       = "East US2"
  }
}

RouteTables = {
  RT-VNET-NAM-sbnt-identity = {
    name                          = "RT-VNET-NAM-sbnt-identity"
    resource_group                = { name = "RG-NAM-IDT-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
  RT-VNET-NAM-sbnt-application1 = {
    name                          = "RT-VNET-NAM-sbnt-application1"
    resource_group                = { name = "RG-NAM-IDT-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
  RT-VNET-NAM-sbnt-dmz-external = {
    name                          = "RT-VNET-NAM-sbnt-dmz-external"
    resource_group                = { name = "RG-NAM-IDT-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
}

VirtualNetworks = {
  VNET-NAM-Identity = {
    name           = "VNET-NAM-Identity"
    resource_group = { name = "RG-NAM-IDT-Network" }
    location       = "East US2"
    address_space  = ["10.1.0.0/16"]
    dns_servers    = null
    subnet = [
      {
        name              = "sbnt-identity"
        address_prefixes  = ["10.1.0.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        route_table       = { tag = "RT-VNET-NAM-sbnt-identity" }
      },
      {
        name              = "sbnt-application1"
        address_prefixes  = ["10.1.1.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        route_table       = { tag = "RT-VNET-NAM-sbnt-application1" }
      },
      {
        name              = "sbnt-dmz-external"
        address_prefixes  = ["10.1.2.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        route_table       = { tag = "RT-VNET-NAM-sbnt-dmz-external" }
      }
    ]
  }
}



RecoveryServicesVaults = {
  RSV-NAM-Identity = {
    name                = "RSV-NAM-Identity-sbx"
    resource_group      = { name = "RG-NAM-IDT-Mgmt" }
    location            = "East US2"
    sku                 = "Standard"
    soft_delete_enabled = "false"
  }
}


BackupPolicyVMs = {
  vm_backup_pol_01 = {
    name                         = "vm_backup_pol_01"
    resource_group               = { tag = "RG-NAM-IDT-Mgmt" }
    recovery_services_vault_name = "RSV-NAM-Identity-sbx"
    timeone                      = "UTC"
    backup = {
      frequency = "Daily"
      time      = "23:00"
    }

    retention_daily = {
      count = 10
    }

    retention_weekly = {
      count    = 42
      weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
    }

    retention_monthly = {
      count    = 7
      weekdays = ["Sunday", "Wednesday"]
      weeks    = ["First", "Last"]
    }

    retention_yearly = {
      count    = 77
      weekdays = ["Sunday"]
      weeks    = ["Last"]
      months   = ["January"]
    }
  }
}


BiDirectionalVirtualNetworkPeering = {
  VNET-NAM-Identity-To-VNET-NAM-Conn = {
    local_virtual_network = {
      name                = "VNET-NAM-Identity"
      resource_group_name = "RG-NAM-IDT-Network"
      subscription_id     = "ae894bb7-da9a-40de-b039-5018557f3df1"
    }
    remote_virtual_network = {
      name                = "VNET-NAM-Conn"
      resource_group_name = "RG-NAM-Conn-Network"
      subscription_id     = "ae894bb7-da9a-40de-b039-5018557f3df1"
    }
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}


CustomIdentityVMs = {
  domaincontrollers = {
    location         = "East US2"
    resource-group   = { tag = "RG-NAM-IDT-PRD-Identity" }
    virtual-network  = { tag = "VNET-NAM-Identity" }
    mgmt-subnet-name = "sbnt-identity"
    windows-vm = [
      {
        name = "dc01"
        # zone    =   1
        size                    = "Standard_DS3_v2"
        mgmt-private-ip-address = "10.1.0.4"
        availability-set        = { tag = "AV-NAM-IDT-PRD-identity" }
        license-type            = "Windows_Server"
        datadisk-size           = 16
      },
      {
        name = "dc02"
        # zone    =   1
        size                    = "Standard_DS3_v2"
        mgmt-private-ip-address = "10.1.0.5"
        availability-set        = { tag = "AV-NAM-IDT-PRD-identity" }
        license-type            = "Windows_Server"
        datadisk-size           = 16
      }
    ]
    datadisk-size               = 8
    admin-username              = "azureadmin"
    admin-password              = "P@ssw0rd@2021"
    keyvault                    = { tag = "KV-NAM-IDT-Core" }
    diagnostics-storage-account = "shsorotprdboot001"
    inherit_tags                = true
  }
}
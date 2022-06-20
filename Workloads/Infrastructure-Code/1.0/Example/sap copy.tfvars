

ResourceGroups  =   {
        "sap-network-rg" =   {
                    name        =   "sap-network-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Network"
                                    }
                },
        "sap-application-rg" =   {
                    name        =   "sap-application-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Application"
                                    }
                }
        "sap-database-rg" =   {
                    name        =   "sap-database-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Database"
                                    }
                }
        "sap-storage-rg" =   {
                    name        =   "sap-storage-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Database"
                                    }
                }
        "sap-security-rg" =   {
                    name        =   "sap-security-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Security"
                                    }
                }
        "sap-jumpbox-rg" =   {
                    name        =   "sap-jumpbox-rg"
                    location    =   "West Europe"
                    tags        =   {
                                        "Environment" = "Dev"
                                        "Component"   = "Jumpbox"
                                    }
        }
}


ApplicationSecurityGroups   =   {
    "application-asg1"  =   {
                                    name =  "application-asg1"
                                    resource_group      =   { tag = "sap-network-rg"}
                                    location            =   "West Europe"
                            }
    "database-asg1"     =   {
                                name =  "database-asg1"
                                resource_group      =   { tag =  "sap-network-rg"}
                                location            =   "West Europe"
                            }
    "jumpbox-asg1"      =   {
                                name =  "jumpbox-asg1"
                                resource_group      =   { tag = "sap-network-rg"}
                                location            =   "West Europe"
                            }
}


NetworkSecurityGroups   =   {
    jumpbox-nsg01    =   {
                    name    =   "jumpbox-nsg01"
                    resource_group      =   { tag = "sap-network-rg"}
                    location            =   "West Europe"
                     nsg_rule =  [
                         {
                             name        = "AllowInSSH"
                             direction   = "InBound"
                             priority    =   100
                             access      =   "Allow"
                             protocol    =   "Tcp"
                             destination_port_ranges    =   ["22"]
                             source_address_prefix      =   "*"
                             destination_application_security_group  =   [
                                 {
                                     tag =   "jumpbox-asg1"
                                 }
                             ]
                         }
                     ] 
                }
    application-nsg01    =   {
                    name    =   "application-nsg01"
                    resource_group      =   { tag = "sap-network-rg"}
                    location            =   "West Europe"
                     nsg_rule =  [
                         {
                             name        = "AllowInSSH"
                             direction   = "InBound"
                             priority    =   100
                             access      =   "Allow"
                             protocol    =   "Tcp"
                             destination_port_ranges    =   ["22"]
                             source_address_prefix      =   "*"
                             destination_application_security_group  =   [
                                 {
                                     tag =   "application-asg1"
                                 }
                             ]
                         },
                         {
                             name        = "AllowInSWPM"
                             direction   = "InBound"
                             priority    =   110
                             access      =   "Allow"
                             protocol    =   "Tcp"
                             destination_port_ranges    =   ["4237"]
                             source_address_prefix      =   "*"
                             destination_application_security_group  =   [
                                 {
                                     tag =   "application-asg1"
                                 }
                             ]
                         }
                     ] 
                }
    database-nsg01  =   {
                    name    =   "database-nsg01"
                    resource_group      =   { tag = "sap-network-rg"}
                    location            =   "West Europe"
                     nsg_rule =  [
                         {
                             name        = "AllowInSSH"
                             direction   = "InBound"
                             priority    =   100
                             access      =   "Allow"
                             protocol    =   "Tcp"
                             destination_port_ranges    =   ["22"]
                             source_address_prefix      =   "*"
                             destination_application_security_group  =   [
                                 {
                                     tag =   "database-asg1"
                                 }
                             ]
                         }
                     ] 
    }
}



VirtualSubnets  = {
    "jumpbox" =  {
        virtual_network_name = "vnet_dtit_cid0019"
        name = "jumpbox"
        address_prefixes = ["10.206.16.0/28"]
        resource_group = { name = "rg-ci-vnet" }
        service_endpoints = ["Microsoft.Storage","Microsoft.KeyVault"]
      },
      "application" =  {
        virtual_network_name = "vnet_dtit_cid0019"
        name = "application"
        address_prefixes = ["10.206.16.16/28"]
        resource_group = { name = "rg-ci-vnet" }
        service_endpoints = ["Microsoft.Storage","Microsoft.KeyVault"]
      },
      "database" =  {
        virtual_network_name = "vnet_dtit_cid0019"
        name = "database"
        address_prefixes = ["10.206.16.32/28"]
        resource_group = { name = "rg-ci-vnet" }
        service_endpoints = ["Microsoft.Storage","Microsoft.KeyVault"]
      }
}



NetworkInterfaces   =   {
    app-01-nic01    =   {
             name =  "app-01-nic01"
             resource_group      =   { tag = "sap-application-rg"}
             location    =   "West Europe"
             ip_configuration    =   [
                 {
                     name = "ipconfig1"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 =   "application"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.20"
                 },
                 {
                     name = "ipconfig2"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 =   "application"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.21"
                 }
             ]
             application_security_group  =   [{
                                                 tag = "application-asg1"
                                             }]
    }
    app-02-nic01    =   {
             name =  "app-02-nic01"
             resource_group      =   { tag = "sap-application-rg"}
             location    =   "West Europe"
             ip_configuration    =   [
                 {
                     name = "ipconfig1"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 =   "application"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.22"
                 },
                 {
                     name = "ipconfig2"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 =   "application"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.23"
                 }
             ]
             application_security_group  =   [{
                                                 tag = "application-asg1"
                                             }]
    }
    hana-01-nic01    =   {
             name =  "hana-01-nic01"
             resource_group      =   { tag = "sap-database-rg"}
             location    =   "West Europe"
             ip_configuration    =   [
                 {
                     name = "ipconfig1"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 = "database"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.36"
                 },
                 {
                     name = "ipconfig2"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 = "database"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "10.206.16.37"
                 }
             ]
             application_security_group  =   [{
                                                 tag = "database-asg1"
                                             }]
    }
    jumpbox-01-nic01 = {
             name =  "jumpbox-01-nic01"
             resource_group      =   { tag = "sap-jumpbox-rg"}
             location    =   "West Europe"
             ip_configuration    =   [
                 {
                     name = "ipconfig1"
                     subnet =    {
                                     virtual_network_name = "vnet_dtit_cid0019"
                                     name                 = "jumpbox"
                                     resource_group_name  = "rg-ci-vnet"
                                 }
                     private_ip_address_allocation   =   "Static"
                     private_ip_address              = "
}

ManagedDisks = {
    app-01-datadisk-00 = {
        name                =   "app-01-datadisk-00"
        resource_group      =   { tag = "sap-application-rg" }
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    app-02-datadisk-00 = {
        name                =   "app-02-datadisk-00"
        resource_group      =   { tag = "sap-application-rg" }
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    app-02-datadisk-01 = {
        name                =   "app-02-datadisk-01"
        resource_group      =   { tag = "sap-application-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   8
    }
    hana-01-datadisk-00 = {
        name                =   "hana-01-datadisk-00"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   128
    }
    hana-01-datadisk-01 = {
        name                =   "hana-01-datadisk-01"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   128
    }
    hana-01-datadisk-11 = {
        name                =   "hana-01-datadisk-11"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    hana-01-datadisk-12 = {
        name                =   "hana-01-datadisk-12"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    hana-01-datadisk-13 = {
        name                =   "hana-01-datadisk-13"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    hana-01-datadisk-14 = {
        name                =   "hana-01-datadisk-14"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   64
    }
    hana-01-datadisk-21 = {
        name                =   "hana-01-datadisk-21"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   32
    }
    hana-01-datadisk-22 = {
        name                =   "hana-01-datadisk-22"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   32
    }
    hana-01-datadisk-23 = {
        name                =   "hana-01-datadisk-23"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "StandardSSD_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   32
    }
    hana-01-datadisk-31 = {
        name                =   "hana-01-datadisk-31"
        resource_group      =   { tag = "sap-database-rg"}
        location            =   "West Europe"
        inherit_tags        =   true
        storage_account_type=   "Standard_LRS"
        create_option       =   "Empty"
        disk_size_gb        =   8
    }
}

KeyVaults   =   {
    "dtagsapsandbox1"   =   {
        name                    =   "dtagsapsandbox1"
        resource_group      =   { tag = "sap-security-rg"}
        location            =   "West Europe"
        soft_delete_retention_days  =   7
        purge_protection_enabled    =   true
        network_acls    =   {
                default_action  =   "Deny"
                bypass          =   "AzureServices"
                # ip_rules        =   ["10.0.0.0/8"]
                virtual_network_subnet  =   [
                    {
                      virtual_network_name = "vnet_dtit_cid0019"
                      name                 =   "jumpbox"
                      resource_group_name  = "rg-ci-vnet"
                    },
                    {
                      virtual_network_name = "vnet_dtit_cid0019"
                      name                 =   "application"
                      resource_group_name  = "rg-ci-vnet"
                    },
                    {
                      virtual_network_name = "vnet_dtit_cid0019"
                      name                 =   "database"
                      resource_group_name  = "rg-ci-vnet"
                    }
                ]
            }
    }
}



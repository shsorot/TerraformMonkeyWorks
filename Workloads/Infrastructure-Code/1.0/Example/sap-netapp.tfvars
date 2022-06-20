

ResourceGroups = {
  "sap-network-rg" = {
    name     = "sap-network-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  },
  "sap-application-rg" = {
    name     = "sap-application-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Application"
    }
  }
  "sap-webdispatcher-rg" = {
    name     = "sap-webdispatcher-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "WebDispatcher"
    }
  }
  "sap-database-rg" = {
    name     = "sap-database-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  "sap-storage-rg" = {
    name     = "sap-storage-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  "sap-security-rg" = {
    name     = "sap-security-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Security"
    }
  }
  "sap-jumpbox-rg" = {
    name     = "sap-jumpbox-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Jumpbox"
    }
  }
}


ApplicationSecurityGroups = {
  "application-asg1" = {
    name           = "application-asg1"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
  }
  "database-asg1" = {
    name           = "database-asg1"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
  }
  "jumpbox-asg1" = {
    name           = "jumpbox-asg1"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
  }
}


NetworkSecurityGroups = {
  jumpbox-nsg01 = {
    name           = "jumpbox-nsg01"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
    #nsg_rule = [
    #{
    #  name                    = "AllowInSSH"
    #  direction               = "Inbound"
    #  priority                = 100
    #  access                  = "Allow"
    #  protocol                = "Tcp"
    #  destination_port_ranges = ["22"]
    #  source_address_prefix   = "*"
    #  destination_application_security_group = [
    #    {
    #      tag = "jumpbox-asg1"
    #    }
    #  ]
    #},
    #{
    #  name                    = "AllowInRDP"
    #  direction               = "Inbound"
    #  priority                = 101
    #  access                  = "Allow"
    #  protocol                = "Tcp"
    #  destination_port_ranges = ["3389"]
    #  source_address_prefix   = "*"
    #  destination_application_security_group = [
    #    {
    #      tag = "jumpbox-asg1"
    #    }
    #  ]
    #}
    #]
  }
  application-nsg01 = {
    name           = "application-nsg01"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
    nsg_rule = [
      {
        name                   = "AllowInDBTCP"
        direction              = "Inbound"
        priority               = 100
        access                 = "Allow"
        protocol               = "Tcp"
        destination_port_range = "*"
        source_application_security_group = [
          {
            tag = "database-asg1"
          }
        ]
        destination_application_security_group = [
          {
            tag = "application-asg1"
          }
        ]
      },
      {
        name                    = "AllowInSWPM"
        direction               = "Inbound"
        priority                = 110
        access                  = "Allow"
        protocol                = "Tcp"
        destination_port_ranges = ["4237"]
        source_address_prefix   = "*"
        destination_application_security_group = [
          {
            tag = "application-asg1"
          }
        ]
      }
    ]
  }
  database-nsg01 = {
    name           = "database-nsg01"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
    nsg_rule = [
      {
        name                   = "AllowInAppTCP"
        direction              = "Inbound"
        priority               = 100
        access                 = "Allow"
        protocol               = "Tcp"
        destination_port_range = "*"
        source_application_security_group = [
          {
            tag = "application-asg1"
          }
        ]
        destination_application_security_group = [
          {
            tag = "database-asg1"
          }
        ]
      }
    ]
  }
}

DDOSProtectionPlans = {}

VirtualNetworks = {
  VNET-NAM-Conn = {
    name           = "VNET-NAM-Conn"
    resource_group = { tag = "sap-network-rg" }
    location       = "North Europe"
    address_space  = ["10.0.0.0/16"]
    dns_servers    = null
    subnet = [
      {
        name              = "jumpbox"
        address_prefixes  = ["10.0.0.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        security_group = {
          tag = "jumpbox-nsg01"
        }
      },
      {
        name              = "application"
        address_prefixes  = ["10.0.1.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        security_group = {
          tag = "application-nsg01"
        }
      },
      {
        name              = "database"
        address_prefixes  = ["10.0.2.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        security_group = {
          tag = "database-nsg01"
        }
      },
      {
        name              = "identity"
        address_prefixes  = ["10.0.21.0/24"]
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        security_group    = null

      },
      {
        name             = "netapp"
        address_prefixes = ["10.0.22.0/24"]
        delegation = {
          name = "netapp delegation"
          service_delegation = {
            name = "Microsoft.Netapp/volumes"
          }
        }
      }
    ]
  }
}

PrivateDNSZones = {
  contoso-zone = {
    name           = "contoso.com"
    resource_group = { tag = "sap-network-rg" }
    inherit_tags   = true
    soa_record = {
      email        = "azureprivatedns-host.microsoft.com"
      refresh_time = 1800
    }
  }
}

PrivateDNSZonesVirtualNetworkLinks = {
  contoso-zone-sap-network-association = {
    name                  = "contoso-zone-sap-network-association"
    resource_group        = { tag = "sap-network-rg" }
    private_dns_zone_name = "contoso.com"
    virtual_network = {
      tag = "VNET-NAM-Conn"
    }
    registration_enabled = true
  }
}


PublicIPPrefixes = {
  #     pipprefix1 =   {
  #         name = "pip_prefix_eun"
  #         resource_group      =   "sap-network-rg"
  #         location                =   "North Europe"
  #         sku                     =   "Standard"
  #         prefix_length           =   28
  #         availability_zone       =   "Zone-Redundant"
  #     }
}

PublicIPAddresses = {
  app-01-pip01 = {
    name              = "app-01-pip01"
    resource_group    = { tag = "sap-network-rg" }
    location          = "North Europe"
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
  }
  hana-01-pip01 = {
    name              = "hana-01-pip01"
    resource_group    = { tag = "sap-network-rg" }
    location          = "North Europe"
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
  }
}

LocalNetworkGateways = {
  #     localnetworks1 = {
  #         name                =   "EUN-local-network_gateway"
  #         resource_group      =   "sap-network-rg"
  #         location            =   "North Europe"
  #         address_space       =   ["11.0.0.0/8"]
  #         gateway_address     =   "12.13.14.15"
  #     }
}

LoadBalancers = {
  # ilb1    =   {
  #                 name                =     "test-loadbalancer-eun"
  #                 resource_group      =     "sap-network-rg"
  #                 location            =     "North Europe"
  #                 sku                 =     "Standard"
  #                 frontend_ip_configuration   =   [{
  #                                                     name = "defaultfrontend"
  #                                                     subnet  =   {
  #                                                         tag  =   "defaultsubnet"
  #                                                         virtual_network_tag =   "VNET-NAM-Conn"
  #                                                     }
  #                                                     private_ip_address_allocation   =   "Dynamic"
  #                                                 }]
  #                 backend_address_pool    =   ["defaultbackendpool"]
  #             }
}

NetworkInterfaces = {
  app-01-nic01 = {
    name           = "app-01-nic01"
    resource_group = { tag = "sap-application-rg" }
    location       = "North Europe"
    ip_configuration = [
      {
        name = "ipconfig1"
        subnet = {
          virtual_network_tag = "VNET-NAM-Conn"
          tag                 = "application"
        }
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.4"
        public_ip_address = {
          tag = "app-01-pip01"
        }
        # backend_address_pool    =   {
        #                                 backend_pool_tag    =   "defaultbackendpool"
        #                                 loadbalancer_tag    =   "ilb1"
        #                             }
      }
    ]
    application_security_group = [{
      tag = "application-asg1"
    }]
  }
  hana-01-nic01 = {
    name           = "hana-01-nic01"
    resource_group = { tag = "sap-database-rg" }
    location       = "North Europe"
    ip_configuration = [
      {
        name = "ipconfig1"
        subnet = {
          virtual_network_tag = "VNET-NAM-Conn"
          tag                 = "database"
        }
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.2.4"
        public_ip_address = {
          tag = "hana-01-pip01"
        }
        # backend_address_pool    =   {
        #                                 backend_pool_tag    =   "defaultbackendpool"
        #                                 loadbalancer_tag    =   "ilb1"
        #                             }
      }
    ]
    application_security_group = [{
      tag = "database-asg1"
    }]
  }
}

BastionHosts = {
  # bastionhost1    =   {
  #     name    =   "bastionhost-eun"
  #     resource_group_name  =   "sap-network-rg"
  #     subnet  =   {
  #                     virtual_network_name    =   "virtual_network_eun"
  #                     resource_group      =   "sap-network-rg"
  #                     address_prefixes        =   ["10.254.254.0/24"]
  #                 }
  #     public_ip_address   =   {
  #                                 name    =   "bastionhost-eun-pip01"
  #                             }
  # }
}

KeyVaults = {
  "sapappkeyvault1" = {
    name                       = "sapappkeyvault1"
    resource_group             = { tag = "sap-security-rg" }
    location                   = "North Europe"
    soft_delete_retention_days = 7
    purge_protection_enabled   = true
    network_acls = {
      default_action = "Allow"
      bypass         = "AzureServices"
      # ip_rules        =   ["10.0.0.0/8"]
      virtual_network_subnet = [
        {
          tag                 = "jumpbox"
          virtual_network_tag = "VNET-NAM-Conn"
        },
        {
          tag                 = "application"
          virtual_network_tag = "VNET-NAM-Conn"
        },
        {
          tag                 = "database"
          virtual_network_tag = "VNET-NAM-Conn"
        }
      ]
    }
  }
}

RecoveryServicesVaults = {
  # rsv1    =   {
  #     name                =   "testrsv01"
  #     resource_group      =   "sap-recovery-rg"
  #     location            =   "North Europe"
  #     soft_delete_enabled =   "false"
  # }
}

StorageAccounts = {
  stor1 = {
    name           = "shsorotstoracc01"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    network_rules = {
      default_action = "Allow"
      bypass         = ["Logging", "Metrics", "AzureServices"]
      # virtual_network_subnet  =   [
      #                                 {
      #                                     tag  =   "defaultsubnet"
      #                                     virtual_network_tag    =   "VNET-NAM-Conn"
      #                                 }
      #                             ]
    }
  }
}

AutomationAccounts = {
  # automat1    =   {
  #                     name = "shsorottestautomat1"
  #                     resource_group      =   "sap-automation-rg"
  #                     location            =   "North Europe"
  #                     sku_name    =   "Basic"
  # }
}




# LinuxVirtualMachines = {
#   app-01  =   {
#        name        =   "app-01"
#        resource_group      =   { tag = "sap-application-rg"}
#        location            =   "North Europe"
#        admin_ssh_key  =   [
#           {
#               username = "azureadmin"
#               public_key  =   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ7mrz8g1AH1yOV2lQeWAjYuKEhlGg7Cb6AAniPBcfnr1UuZkdb9Z4m9fzuakzsh72tJGffEpcVPw69yoBAHuf13TQ6l1Ue0Cp08lmD9cq4LIwczFXhozxoKPaXQvLD/K1vhWSCzyN98K8Dhz9L67SG3B9wcyKjlYnVPp3H8i/R7XuOiwV5vQX5MgzEgo9Hd6Nl5ja/u3SbCNWDA6qZyCzzyAZbrD9AcSgpEOagnK60hzIg1FjdQgTxpY/i3dP5gnSBUk/t/qTfbFWS2c3HzJTfHaGa/JjiCDwZeTtk1jVBN/yfVCypWJByRIiOQ96dGsa0HOvuvigNEc5p6JIv9rfoBYD3t1x9deXwJ50yClXq/S0fUyvKBGnePbCMIN8DC0O3DBcjvHPay2kV1+p8z7R0ly2z5w4RipXxbxhyXe1ncGtdvrSJh2N9WrCreXW9V/d62t7ihAnOhJpLPLMX+FGttPac90ZQuMFfEnYEAJDobATEQtESnrMjX+dCPQBfTk= generated-by-azure"
#           }
#        ]
#        disable_password_authentication =   true
#        network_interface   =   [{tag = "app-01-nic01"}]
#        os_disk         =   {
#                                disk_size_gb    =   "64"
#                            }
#        size            =   "Standard_E2s_v3"
#        timezone        =   "GMT Standard Time"
#        boot_diagnostics    =   {
#            storage_account_name    =   "shsorotstoracc01"
#        }
#        source_image_reference  =   {
#                                        publisher = "SUSE"
#                                        offer     = "sles-sap-15-sp2"
#                                        sku       = "gen2"
#                                        version   = "latest"
#                                    }
#        identity = {
#           type = "SystemAssigned"
#        }

#   }
#   hana-01 = {
#     name           = "hana-01"
#     resource_group = { tag = "sap-database-rg" }
#     location       = "North Europe"
#     admin_ssh_key = [
#       {
#         username   = "azureadmin"
#         public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ7mrz8g1AH1yOV2lQeWAjYuKEhlGg7Cb6AAniPBcfnr1UuZkdb9Z4m9fzuakzsh72tJGffEpcVPw69yoBAHuf13TQ6l1Ue0Cp08lmD9cq4LIwczFXhozxoKPaXQvLD/K1vhWSCzyN98K8Dhz9L67SG3B9wcyKjlYnVPp3H8i/R7XuOiwV5vQX5MgzEgo9Hd6Nl5ja/u3SbCNWDA6qZyCzzyAZbrD9AcSgpEOagnK60hzIg1FjdQgTxpY/i3dP5gnSBUk/t/qTfbFWS2c3HzJTfHaGa/JjiCDwZeTtk1jVBN/yfVCypWJByRIiOQ96dGsa0HOvuvigNEc5p6JIv9rfoBYD3t1x9deXwJ50yClXq/S0fUyvKBGnePbCMIN8DC0O3DBcjvHPay2kV1+p8z7R0ly2z5w4RipXxbxhyXe1ncGtdvrSJh2N9WrCreXW9V/d62t7ihAnOhJpLPLMX+FGttPac90ZQuMFfEnYEAJDobATEQtESnrMjX+dCPQBfTk= generated-by-azure"
#       }
#     ]
#     disable_password_authentication = true
#     network_interface               = [{ tag = "hana-01-nic01" }]
#     os_disk = {
#       disk_size_gb = "64"
#     }
#     size     = "Standard_E16s_v3"
#     timezone = "GMT Standard Time"
#     boot_diagnostics    =   {
#         storage_account_name    =   "shsorotstoracc01"
#     }
#     source_image_reference = {
#       publisher = "SUSE"
#       offer     = "sles-sap-15-sp2"
#       sku       = "gen2"
#       version   = "latest"
#     }
#     identity = {
#       type = "SystemAssigned"
#     }
#   }
# }


NetAppAccounts = {
  sapnetappinstance01 = {
    name           = "sapnetappinstance01"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
  }
}

NetAppSnapshotPolicies = {
  sapnetappinstance01_daily_sample = {
    name           = "dailysnapolicysample01"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    enabled        = true
    hourly_schedule = {
      snapshots_to_keep = 1
      minute            = 30
    }
  }
}

NetAppPools = {
  hanastandardpool01 = {
    name           = "hanastandardpool01"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    qos_type       = "Manual"
    size_in_tb     = 5
    service_level  = "Premium"
  }
}

NetAppVolumes = {
  x03_usrsap = {
    name           = "x03_usrsap"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    pool           = { tag = "hanastandardpool01" }
    subnet = { tag = "netapp"
      virtual_network_tag = "VNET-NAM-Conn"
    }
    protocols                  = ["NFSv4.1"]
    storage_quota_in_gb        = 100
    throughput_in_mibps        = 6.4
    snapshot_directory_visible = true
    export_policy_rule = [{
      rule_index          = 1
      allowed_clients     = ["10.0.2.4"]
      protocols_enabled   = ["NFSv4.1"]
      unix_read_only      = false
      unix_read_write     = true
      root_access_enabled = true
    }]
    volume_path = "x03usrsap"
    # data_protection_snapshot_policy = { tag = "sapnetappinstance01_daily_sample" }
  }
  x03_hanashared = {
    name           = "x03_hanashared"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    pool           = { tag = "hanastandardpool01" }
    subnet = { tag = "netapp"
      virtual_network_tag = "VNET-NAM-Conn"
    }
    protocols                  = ["NFSv4.1"]
    storage_quota_in_gb        = 256
    throughput_in_mibps        = 16
    snapshot_directory_visible = true
    export_policy_rule = [{
      rule_index          = 1
      allowed_clients     = ["10.0.2.4"]
      protocols_enabled   = ["NFSv4.1"]
      unix_read_only      = false
      unix_read_write     = true
      root_access_enabled = true
    }]
    volume_path = "x03hanashared"
  }
  x03_hanadata = {
    name           = "x03_hanadata"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    pool           = { tag = "hanastandardpool01" }
    subnet = { tag = "netapp"
      virtual_network_tag = "VNET-NAM-Conn"
    }
    protocols                  = ["NFSv4.1"]
    storage_quota_in_gb        = 2048
    throughput_in_mibps        = 128
    snapshot_directory_visible = true
    export_policy_rule = [{
      rule_index          = 1
      allowed_clients     = ["10.0.2.4"]
      protocols_enabled   = ["NFSv4.1"]
      unix_read_only      = false
      unix_read_write     = true
      root_access_enabled = true
    }]
    volume_path = "x03hanadata"
  }
  x03_hanalog = {
    name           = "x03_hanalog"
    resource_group = { tag = "sap-storage-rg" }
    location       = "North Europe"
    account        = { tag = "sapnetappinstance01" }
    pool           = { tag = "hanastandardpool01" }
    subnet = { tag = "netapp"
      virtual_network_tag = "VNET-NAM-Conn"
    }
    protocols                  = ["NFSv4.1"]
    storage_quota_in_gb        = 1024
    throughput_in_mibps        = 32
    snapshot_directory_visible = true
    export_policy_rule = [{
      rule_index          = 1
      allowed_clients     = ["10.0.2.4"]
      protocols_enabled   = ["NFSv4.1"]
      unix_read_only      = false
      unix_read_write     = true
      root_access_enabled = true
    }]
    volume_path = "x03hanalog"
  }
}

# give jumpbox access to key vault for deployment
# ManagedDisks = {
#   app-01-datadisk-00 = {
#     name                 = "app-01-datadisk-00"
#     resource_group       = { tag = "sap-application-rg" }
#     location             = "North Europe"
#     inherit_tags         = true
#     storage_account_type = "StandardSSD_LRS"
#     create_option        = "Empty"
#     disk_size_gb         = 64
#   }
# }

# VirtualMachineManagedDiskAttachments = {
#     app-01-diskattachment-00 = {
#     virtual_machine = {
#       tag = "app-01"
#     }
#     managed_disk = {
#       tag = "app-01-datadisk-00"
#     }
#     lun           = 00
#     caching       = "None"
#     create_option = "Attach"
#   }
# }


KeyVaultAccessPolicies = {
  shsorot-keyvault-accesspolicy = {
    key_vault = {
      tag = "sapappkeyvault1"
    }
    tenant_id          = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    object_id          = "59d33c4f-8163-4e4a-b5e6-3d17a6347437"
    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  }
}
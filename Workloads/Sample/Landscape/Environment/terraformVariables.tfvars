ResourceGroups = {
  "sbx-network-rg" = {
    name     = "sbx-network-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  },
  "sbx-application-rg" = {
    name     = "sbx-application-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Application"
    }
  }
  "sbx-database-rg" = {
    name     = "sbx-database-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  "sbx-recovery-rg" = {
    name     = "sbx-recovery-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  "sbx-storage-rg" = {
    name     = "sbx-storage-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Database"
    }
  }
  "sbx-security-rg" = {
    name     = "sbx-security-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Security"
    }
  }
  "sbx-automation-rg" = {
    name     = "sbx-automation-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Automation"
    }
  }
  "sbx-jumpbox-rg" = {
    name     = "sbx-jumpbox-rg"
    location = "North Europe"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Jumpbox"
    }
  }
}


# ApplicationSecurityGroups   =   {
#     "application-asg1"  =   {
#                                     name =  "application-asg1"
#                                     resource_group_name =   "sbx-application-rg"
#                                     location            =   "North Europe"
#                             }
#     "database-asg1"     =   {
#                                 name =  "database-asg1"
#                                 resource_group_name =   "sbx-database-rg"
#                                 location            =   "North Europe"
#                             }
#     "jumpbox-asg1"      =   {
#                                 name =  "jumpbox-asg1"
#                                 resource_group_name =   "sbx-jumpbox-rg"
#                                 location            =   "North Europe"
#                             }
# }


# NetworkSecurityGroups   =   {
#     nsg1    =   {
#                     name    =   "appsubnetnsg1"
#                     resource_group_name     =   "sbx-network-rg"
#                     location            =   "North Europe"
#                     # nsg_rule =  [
#                     #     {
#                     #         name        = "AllowInApp"
#                     #         direction   = "InBound"
#                     #         priority    =   100
#                     #         access      =   "Allow"
#                     #         protocol    =   "tcp"
#                     #         source_application_security_group   =   [
#                     #             {
#                     #                 tag =   "appasg1"
#                     #             },
#                     #             {
#                     #                 tag =   "appasg2"
#                     #             },
#                     #             {
#                     #                 tag =   "appasg3"
#                     #             }
#                     #         ]
#                     #         destination_application_security_group  =   [
#                     #             {
#                     #                 tag =   "dbasg1"
#                     #             },
#                     #             {
#                     #                 tag =   "dbasg2"
#                     #             }
#                             # ]
#                         # }
#                     # ] 
#                 }
# }

# DDOSProtectionPlans =   {}

# VirtualNetworks     =   {
#     network1    =   {
#         name        =   "sbx-virtual-network-eun"
#         resource_group_name =   "sbx-network-rg"
#         location            =   "North Europe"
#         address_space       =   ["10.0.0.0/8"]
#         dns_servers         =   null
#         subnet  =   [
#             {
#                 name = "jumpbox"
#                 address_prefixes    =   ["10.0.0.0/24"]
#                 service_endpoints   =   ["Microsoft.Storage","Microsoft.KeyVault"]
#                 security_group      =   {
#                     tag = "nsg1"
#                 }
#             },
#             {
#                 name = "application"
#                 address_prefixes    =   ["10.0.1.0/24"]
#                 service_endpoints   =   ["Microsoft.Storage","Microsoft.KeyVault"]
#                 security_group      =   {
#                     tag = "nsg1"
#                 }
#             },
#             {
#                 name = "database"
#                 address_prefixes    =   ["10.0.2.0/24"]
#                 service_endpoints   =   ["Microsoft.Storage","Microsoft.KeyVault"]
#                 security_group      =   {
#                     tag = "nsg1"
#                 }
#             }
#         ]
#     }
# }

# PublicIPPrefixes    =   {
# #     pipprefix1 =   {
# #         name = "pip_prefix_eun"
# #         resource_group_name     =   "sbx-network-rg"
# #         location                =   "North Europe"
# #         sku                     =   "Standard"
# #         prefix_length           =   28
# #         availability_zone       =   "Zone-Redundant"
# #     }
# }

# PublicIPAddresses   =   {
# #     pip1    =   {
# #         name                    =   "test-pip1"
# #         resource_group_name     =   "sbx-network-rg"
# #         location            =   "North Europe"
# #         sku                     =   "Standard"
# #         allocation_method       =   "Static"
# #         ip_version              =   "IPv4"
# #         # public_ip_prefix        =   {
# #         #     tag =   "pipprefix1"
# #         # }
# #         availability_zone       =   "Zone-Redundant"
# #     }
# }

# LocalNetworkGateways    =   {
# #     localnetworks1 = {
# #         name                =   "EUN-local-network_gateway"
# #         resource_group_name =   "sbx-network-rg"
# #         location            =   "North Europe"
# #         address_space       =   ["11.0.0.0/8"]
# #         gateway_address     =   "12.13.14.15"
# #     }
# }

# Loadbalancers   =   {
#     # ilb1    =   {
#     #                 name                = "test-loadbalancer-eun"
#     #                 resource_group_name =   "sbx-network-rg"
#     #                 location            =   "North Europe"
#     #                 sku                 =   "Standard"
#     #                 frontend_ip_configuration   =   [{
#     #                                                     name = "defaultfrontend"
#     #                                                     subnet  =   {
#     #                                                         subnet_tag  =   "defaultsubnet"
#     #                                                         virtual_network_tag =   "network1"
#     #                                                     }
#     #                                                     private_ip_address_allocation   =   "Dynamic"
#     #                                                 }]
#     #                 backend_address_pool    =   ["defaultbackendpool"]
#     #             }
# }

# NetworkInterfaces   =   {
#     # testnic1    =   {
#     #     name =  "AppVM1-NIC1"
#     #     resource_group_name =   "sbx-application-rg"
#     #     location    =   "North Europe"
#     #     ip_configuration    =   [
#     #         {
#     #             name = "ipconfig1"
#     #             subnet =    {
#     #                             virtual_network_tag = "network1"
#     #                             subnet_tag          =   "defaultsubnet"
#     #                         }
#     #             backend_address_pool    =   {
#     #                                             backend_pool_tag    =   "defaultbackendpool"
#     #                                             loadbalancer_tag    =   "ilb1"
#     #                                         }
#     #         }
#     #     ]
#     #     application_security_group  =   {
#     #                                         tag = "appasg1"
#     #                                     }
#     # }
# }

# BastionHosts    =   {
#     # bastionhost1    =   {
#     #     name    =   "bastionhost-eun"
#     #     resource_group_name  =   "sbx-network-rg"
#     #     subnet  =   {
#     #                     virtual_network_name    =   "virtual_network_eun"
#     #                     resource_group_name     =   "sbx-network-rg"
#     #                     address_prefixes        =   ["10.254.254.0/24"]
#     #                 }
#     #     public_ip_address   =   {
#     #                                 name    =   "bastionhost-eun-pip01"
#     #                             }
#     # }
# }

# KeyVaults   =   {
#     "adcappkeyvault1"   =   {
#         name                    =   "adcappkeyvault1"
#         resource_group_name     =   "sbx-security-rg"
#         location            =   "North Europe"
#         soft_delete_retention_days  =   7
#         network_acls    =   {
#                 default_action  =   "Deny"
#                 bypass          =   "AzureServices"
#                 # ip_rules        =   ["10.0.0.0/8"]
#                 virtual_network_subnet  =   [
#                     {
#                         subnet_tag  =   "jumpbox"
#                         virtual_network_tag =   "network1"
#                     },
#                     {
#                         subnet_tag  =   "application"
#                         virtual_network_tag =   "network1"
#                     },
#                     {
#                         subnet_tag  =   "database"
#                         virtual_network_tag =   "network1"
#                     }
#                 ]
#             }
#     }
# }

# RecoveryServicesVaults  =   {
#     # rsv1    =   {
#     #     name                =   "adctstrsv01"
#     #     resource_group_name =   "sbx-recovery-rg"
#     #     location            =   "North Europe"
#     #     soft_delete_enabled =   "false"
#     # }
# }

# StorageAccounts =   {
#     stor1   =   {
#         name                =   "adctststoracc01"
#         resource_group_name =   "sbx-storage-rg"
#         location            =   "North Europe"
#         network_rules       =   {
#                     default_action  =   "Allow"
#                     bypass          =   ["Logging","Metrics","AzureServices"]
#                     # virtual_network_subnet  =   [
#                     #                                 {
#                     #                                     subnet_tag  =   "defaultsubnet"
#                     #                                     virtual_network_tag    =   "network1"
#                     #                                 }
#                     #                             ]
#         }
#     }
# }

# AutomationAccounts  =   {
#     automat1    =   {
#                         name = "adctsttestautomat1"
#                         resource_group_name =   "sbx-automation-rg"
#                         location            =   "North Europe"
#                         sku_name    =   "Basic"
#     }
# }


# WindowsVirtualMachines  =   {
#     # windowsvm1  =   {
#     #     name        =   "testvm1"
#     #     resource_group_name =   "sbx-application-rg"
#     #     location            =   "North Europe"
#     #     admin_username      =   "azureadmin"
#     #     admin_password      =   "P@ssw0rd@2021"
#     #     network_interface   =   [{tag = "testnic1"}]
#     #     os_disk         =   {
#     #                             disk_size_gb    =   "127"
#     #                         }
#     #     size            =   "Standard_E4s_v3"
#     #     timezone        =   "GMT Standard Time"
#     #     boot_diagnostics    =   {
#     #         storage_account_name    =   "adctststoracc01"
#     #     }
#     # }
# }


# LinuxVirtualMachines  =   {
# #     linuxvm1  =   {
# #         name        =   "testvm2"
# #         resource_group_name =   "sbx-application-rg"
# #         location            =   "North Europe"
# #         admin_username      =   "azureadmin"
# #         admin_password      =   "P@ssw0rd@2021"
# #         disable_password_authentication =   false
# #         network_interface   =   [{tag = "testnic1"}]
# #         os_disk         =   {
# #                                 disk_size_gb    =   "64"
# #                             }
# #         size            =   "Standard_E4s_v3"
# #         timezone        =   "GMT Standard Time"
# #         boot_diagnostics    =   {
# #             storage_account_name    =   "adctststoracc01"
# #         }
# #     }
# }
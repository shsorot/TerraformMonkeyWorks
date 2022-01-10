ResourceGroups = {
  "RG-NAM-Conn-Network" = {
    name     = "RG-NAM-Conn-Network"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  },
  "RG-NAM-Conn-ER" = {
    name     = "RG-NAM-Conn-ER"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Express Route"
    }
  }
  "RG-NAM-Conn-Security" = {
    name     = "RG-NAM-Conn-Security"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Security"
    }
  }
  "RG-NAM-Conn-IaC" = {
    name     = "RG-NAM-Conn-IaC"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "IaC Storage Account"
    }
  }
  "RG-NAM-Conn-Mgmt" = {
    name     = "RG-NAM-Conn-Mgmt"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Recovery Vaults"
    }
  }
}




AvailabilitySets = {}



RouteTables = {
  RT-VNET-NAM-Conn-GatewaySubnet = {
    name                          = "RT-VNET-NAM-Conn-GatewaySubnet"
    resource_group                = { tag = "RG-NAM-Conn-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route = [
      {
        name                   = "To-VNET-NAM-Identity"
        address_prefix         = "10.1.0.0/16"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.5.10"
      },
      {
        name                   = "ToFWforOnPremise"
        address_prefix         = "192.1.0.0/16"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.5.10"
      }
    ]
  }
  RT-VNET-NAM-Conn-sbnt-management = {
    name                          = "RT-VNET-NAM-Conn-sbnt-management"
    resource_group                = { tag = "RG-NAM-Conn-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
  RT-VNET-NAM-Conn-sbnt-security-management = {
    name                          = "RT-VNET-NAM-Conn-sbnt-security-management"
    resource_group                = { tag = "RG-NAM-Conn-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
  RT-VNET-NAM-Conn-sbnt-security-management = {
    name                          = "RT-VNET-NAM-Conn-sbnt-security-management"
    resource_group                = { tag = "RG-NAM-Conn-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }
  RT-VNET-NAM-Conn-sbnt-waf-ha = {
    name                          = "RT-VNET-NAM-Conn-sbnt-waf-ha"
    resource_group                = { tag = "RG-NAM-Conn-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route                         = []
  }

}

VirtualNetworks = {
  VNET-NAM-Conn = {
    name           = "VNET-NAM-Conn"
    resource_group = { tag = "RG-NAM-Conn-Network" }
    location       = "East US2"
    inherit_tags   = true
    address_space  = ["10.0.0.0/16"]
    dns_servers    = null
    subnet = [
      {
        name             = "GatewaySubnet"
        address_prefixes = ["10.0.255.0/24"]
        route_table      = { tag = "RT-VNET-NAM-Conn-GatewaySubnet" }
      },
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.0.10.0/24"]
      },
      {
        name             = "sbnt-intranet-security-ext"
        address_prefixes = ["10.0.2.0/24"]
      },
      {
        name             = "sbnt-intranet-security-int"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name             = "sbnt-security-management"
        address_prefixes = ["10.0.3.0/24"]
      },
      {
        name             = "sbnt-waf-ha"
        address_prefixes = ["10.0.4.0/24"]
      },
      {
        name             = "sbnt-waf-ext"
        address_prefixes = ["10.0.5.0/24"]
      },
      {
        name             = "sbnt-management"
        address_prefixes = ["10.0.6.0/24"]
      }
    ]
  }
}



PublicIPPrefixes = {
  PIPPFX-NAM-Conn-WAF = {
    name              = "PIPPFX-NAM-Conn-WAF"
    resource_group    = { tag = "RG-NAM-Conn-Security" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    prefix_length     = 29
    availability_zone = "Zone-Redundant"
  },
  PIPPFX-NAM-Conn-FW = {
    name              = "PIPPFX-NAM-Conn-FW"
    resource_group    = { tag = "RG-NAM-Conn-Security" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    prefix_length     = 29
    availability_zone = "Zone-Redundant"
  }
}

PublicIPAddresses = {
  PIP-NAM-Conn-NatGW-FW = {
    name              = "PIP-NAM-Conn-NatGW-FW"
    resource_group    = { tag = "RG-NAM-Conn-Security" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
    availability_zone = "Zone-Redundant"
  }
  PIP-NAM-Conn-NatGW-WAF = {
    name              = "PIP-NAM-Conn-NatGW-WAF"
    resource_group    = { tag = "RG-NAM-Conn-Security" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
    availability_zone = "Zone-Redundant"
  }
  PIP-NAM-Conn-WAF-PRD-1 = {
    name              = "PIP-NAM-Conn-WAF-PRD-1"
    resource_group    = { tag = "RG-NAM-Conn-Security" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
    availability_zone = "Zone-Redundant"
  }

}

LoadBalancers = {
}

NATGateways = {
  NAT-NAM-Conn-WAFEXT = {
    name           = "NAT-NAM-Conn-WAFEXT"
    resource_group = { tag = "RG-NAM-Conn-Network" }
    location       = "East US2"
    #zones                   =       [1,3]
  }
  NAT-NAM-Conn-FWEXT = {
    name           = "NAT-NAM-Conn-FWEXT"
    resource_group = { tag = "RG-NAM-Conn-Network" }
    location       = "East US2"
    #zones                   =       [1,3]
  }
}

NATGatewayPublicIPPrefixAssociations = {
  NAT-NAM-Conn-WAFEXT_PIP-NAM-Conn-NatGW-WAF = {
    nat_gateway = {
      tag = "NAT-NAM-Conn-WAFEXT"
    }
    public_ip_prefix = {
      tag = "PIPPFX-NAM-Conn-WAF"
    }
  }
  NAT-NAM-Conn-FWEXT_PIP-NAM-Conn-NatGW-WAF = {
    nat_gateway = {
      tag = "NAT-NAM-Conn-WAFEXT"
    }
    public_ip_prefix = {
      tag = "PIPPFX-NAM-Conn-FW"
    }
  }
}


ConsolidatedLoadbalancers = {
  ILB-NAM-Conn-WAF-1 = {
    location       = "East US2"
    resource_group = { tag = "RG-NAM-Conn-Security" }
    name           = "ILB-NAM-Conn-WAF-1"
    sku            = "Standard"
    frontend_ip_configuration = [
      {
        name = "untrusted-internal-frontend"
        subnet = {
          virtual_network_tag = "VNET-NAM-Conn"
          tag                 = "sbnt-waf-ext"
        }
        private_ip_address            = "10.0.5.10"
        private_ip_address_allocation = "Static"
        availability_zone             = "Zone-Redundant"
        private_ip_address_version    = "IPv4"
      }
    ]
    backend_address_pool = [
      "untrusted-internal-backendpool"
    ]
    probe = [
      {
        name           = "waf-probe-port"
        probe_protocol = "Tcp"
        probe_port     = 22
      }
    ]
    loadbalancer_rule = [
      {
        name                           = "WAF-internal-loadbalancer-rule"
        backend_address_pool_name      = "untrusted-internal-backendpool"
        protocol                       = "Tcp"
        enable_tcp_reset               = false
        enable_floating_ip             = true
        frontend_ip_configuration_name = "untrusted-internal-frontend"
        frontend_port                  = 5555
        backend_port                   = 5555
        load_distribution              = "None"
      }
    ]
  }
  PLB-NAM-Conn-WAF-1 = {
    location       = "East US2"
    resource_group = { tag = "RG-NAM-Conn-Security" }
    name           = "PLB-NAM-Conn-WAF-1"
    sku            = "Standard"
    frontend_ip_configuration = [
      {
        name = "untrusted-external-frontend"
        public_ip_address = {
          tag = "PIP-NAM-Conn-WAF-PRD-1"
        }
      }
    ]
    backend_address_pool = [
      "untrusted-external-backendpool"
    ]
    probe = [
      {
        name           = "waf-probe-port"
        probe_protocol = "Tcp"
        probe_port     = 22
      }
    ]
    loadbalancer_rule = [
      {
        name                           = "WAF-external-loadbalancer-rule"
        backend_address_pool_name      = "untrusted-external-backendpool"
        protocol                       = "Tcp"
        enable_tcp_reset               = false
        enable_floating_ip             = true
        frontend_ip_configuration_name = "untrusted-external-frontend"
        frontend_port                  = 5555
        backend_port                   = 5555
        load_distribution              = "None"
      }
    ]
  }
  ILB-NAM-Conn-FWInt-1 = {
    location       = "East US2"
    resource_group = { tag = "RG-NAM-Conn-Security" }
    name           = "ILB-NAM-Conn-FWInt-1"
    sku            = "Standard"
    frontend_ip_configuration = [
      {
        name = "trusted-internal-frontend"
        subnet = {
          virtual_network_tag = "VNET-NAM-Conn"
          tag                 = "sbnt-intranet-security-int"
        }
        private_ip_address            = "10.0.1.10"
        private_ip_address_allocation = "Static"
        private_ip_address_version    = "IPv4"
      }
    ]
    backend_address_pool = [
      "trusted-internal-backendpool"
    ]
    # backend_address_pool_address    =   [
    #     {
    #         name = "paltofwint01-internal-ip"
    #         backend_address_pool_name   =   "trusted-internal-backendpool"
    #         virtual_network     =   {
    #             tag =   "VNET-NAM-Conn"
    #         }
    #         ip_address  =   "10.0.1.7"
    #     }
    # ]
    probe = [
      {
        name           = "pan-probe-port"
        probe_protocol = "Tcp"
        probe_port     = 22
      }
    ]
    loadbalancer_rule = [
      {
        name                           = "pan-internal-loadbalancer-rule"
        backend_address_pool_name      = "trusted-internal-backendpool"
        protocol                       = "Tcp"
        enable_tcp_reset               = false
        enable_floating_ip             = true
        frontend_ip_configuration_name = "trusted-internal-frontend"
        frontend_port                  = 5555
        backend_port                   = 5555
        load_distribution              = "None"
      }
    ]
  }
  ILB-NAM-Conn-FWExt-1 = {
    location       = "East US2"
    resource_group = { tag = "RG-NAM-Conn-Security" }
    name           = "ILB-NAM-Conn-FWExt-1"
    sku            = "Standard"
    frontend_ip_configuration = [
      {
        name = "trusted-internal-frontend"
        subnet = {
          virtual_network_tag = "VNET-NAM-Conn"
          tag                 = "sbnt-intranet-security-int"
        }
        private_ip_address            = "10.0.1.11"
        private_ip_address_allocation = "Static"
        private_ip_address_version    = "IPv4"
      }
    ]
    backend_address_pool = [
      "trusted-internal-backendpool"
    ]
    # backend_address_pool_address    =   [
    #     {
    #         name = "paltofwext01-internal-ip"
    #         backend_address_pool_name   =   "trusted-internal-backendpool"
    #         virtual_network     =   {
    #             tag =   "VNET-NAM-Conn"
    #         }
    #         ip_address  =   "10.0.1.4"
    #     }
    # ]
    probe = [
      {
        name           = "pan-probe-port"
        probe_protocol = "Tcp"
        probe_port     = 22
      }
    ]
    loadbalancer_rule = [
      {
        name                           = "pan-internal-loadbalancer-rule"
        backend_address_pool_name      = "trusted-internal-backendpool"
        protocol                       = "Tcp"
        enable_tcp_reset               = false
        enable_floating_ip             = true
        frontend_ip_configuration_name = "trusted-internal-frontend"
        frontend_port                  = 5555
        backend_port                   = 5555
        load_distribution              = "None"
      }
    ]
  }
}


KeyVaults = {
  "KV-NAM-Conn-Core" = {
    name                        = "KV-NAM-Conn-Core-sbx2"
    resource_group              = { tag = "RG-NAM-Conn-Security" }
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
  "KV-NAM-Conn-Core_acl_AZU-EUR-WW-DEV-CoreEngineering4" = {
    key_vault = {
      tag = "KV-NAM-Conn-Core"
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


RecoveryServicesVaults = {
  RSV-NAM-Conn = {
    name                = "RSV-NAM-Conn-sbx2"
    resource_group      = { tag = "RG-NAM-Conn-Mgmt" }
    location            = "East US2"
    sku                 = "Standard"
    soft_delete_enabled = "false"
  }
}


BackupPolicyVMs = {
  vm_backup_pol_01 = {
    name                    = "vm_backup_pol_01"
    resource_group          = { tag = "RG-NAM-Conn-Mgmt" }
    recovery_services_vault = { tag = "RSV-NAM-Conn" }
    timeone                 = "UTC"
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


StorageAccounts = {
  sagsnamprdboot001 = {
    name                     = "shsorotprdboot001"
    resource_group           = { tag = "RG-NAM-Conn-Mgmt" }
    location                 = "East US2"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    network_rules = {
      default_action = "Allow"
      bypass         = ["Logging", "Metrics", "AzureServices"]
    }
  }
}

AutomationAccounts = {
  AA-NAM-Conn-Core = {
    name           = "AA-NAM-Conn-Core"
    resource_group = { tag = "RG-NAM-Conn-Mgmt" }
    location       = "East US2"
    sku_name       = "Basic"
  }
}

LogAnalyticsWorkspaces = {
  LAW-NAM-Conn-Core = {
    name              = "LAW-NAM-Conn-Core"
    resource_group    = { tag = "RG-NAM-Conn-Mgmt" }
    location          = "East US2"
    sku               = "PerGB2018"
    retention_in_days = 182
  }
}


PaloAltoExternalFirewalls = {
  firewallset1 = {
    location = "eastus2"
    # virtual-machine-resource-group-name     =   "RG-NAM-Conn-Security"
    # virtual-network-name                    =   "VNET-NAM-Conn"
    resource-group = { tag = "RG-NAM-Conn-Security" }
    # virtual-network-resource-group-name     =   "RG-NAM-Conn-Network"
    virtual-network       = { tag = "VNET-NAM-Conn" }
    trusted-subnet-name   = "sbnt-intranet-security-int"
    untrusted-subnet-name = "sbnt-intranet-security-ext"
    mgmt-subnet-name      = "sbnt-security-management"
    # trusted-internal-loadbalancer           =   {
    #     name                        =   "ILB-NAM-Conn-FWExt-1"
    #     resource-group-name         =   "RG-NAM-Conn-Security"
    #     backend-address-pool-name   =   "trusted-internal-backendpool"
    # }
    trusted-internal-loadbalancer                           = { tag = "ILB-NAM-Conn-FWExt-1" }
    trusted-internal-loadbalancer-backend-address-pool-name = "trusted-internal-backendpool"

    firewall-vm = [
      {
        name                         = "paltofwext01"
        zone                         = 1
        size                         = "Standard_DS3_v2"
        mgmt-private-ip-address      = "10.0.3.4"
        trusted-private-ip-address   = "10.0.1.4"
        untrusted-private-ip-address = "10.0.2.4"
      }
    ]
    admin-username = "azureadmin"
    admin-password = "P@ssw0rd@2021"
    # credential-keyvault-name                =   "KV-NAM-Conn-Core-sbx2"
    # credential-keyvault-resource-group-name =   "RG-NAM-Conn-Security"
    keyvault                    = { tag = "KV-NAM-Conn-Core" }
    diagnostics-storage-account = "shsorotprdboot001"
    inherit_tags                = true
    tags = {
      "workload" = "PaloAlto external firewall"
    }
    backup_policy = {
      tag = "vm_backup_pol_01"
    }
  }
}

PaloAltoInternalFirewalls = {
  firewallset1 = {
    location = null
    # virtual-machine-resource-group-name     =   "RG-NAM-Conn-Security"
    # virtual-network-name                    =   "VNET-NAM-Conn"
    resource-group = { tag = "RG-NAM-Conn-Security" }
    # virtual-network-resource-group-name     =   "RG-NAM-Conn-Network"
    virtual-network     = { tag = "VNET-NAM-Conn" }
    trusted-subnet-name = "sbnt-intranet-security-int"
    mgmt-subnet-name    = "sbnt-security-management"
    # trusted-internal-loadbalancer           =   {
    #     name                        =   "ILB-NAM-Conn-FWInt-1"
    #     resource-group-name         =   "RG-NAM-Conn-Security"
    #     backend-address-pool-name   =   "trusted-internal-backendpool"
    # }
    trusted-internal-loadbalancer                           = { tag = "ILB-NAM-Conn-FWInt-1" }
    trusted-internal-loadbalancer-backend-address-pool-name = "trusted-internal-backendpool"
    firewall-vm = [
      {
        name                       = "paltofwint01"
        zone                       = 1
        size                       = "Standard_DS3_v2"
        mgmt-private-ip-address    = "10.0.3.7"
        trusted-private-ip-address = "10.0.1.7"
      }
    ]
    admin-username = "azureadmin"
    admin-password = "P@ssw0rd@2021"
    # credential-keyvault-name                =   "KV-NAM-Conn-Core-sbx2"
    # credential-keyvault-resource-group-name =   "RG-NAM-Conn-Security"
    keyvault                    = { tag = "KV-NAM-Conn-Core" }
    diagnostics-storage-account = "shsorotprdboot001"
    inherit_tags                = true
    tags = {
      "workload" = "PaloAlto internal firewall"
    }
    backup_policy = {
      tag = "vm_backup_pol_01"
    }
  }
}

#CustomBigF5owafAppliances   =   {
#     f501    =   {
#         resource-group                          =   { tag = "RG-NAM-Conn-Security"}
#        #  virtual-network-name                    =   "VNET-NAM-Conn"
#        #  virtual-network-resource-group-name     =   "RG-NAM-Conn-Network"
#         virtual-network                         =   {tag = "VNET-NAM-Conn"}
#         trusted-subnet-name                     =   "sbnt-waf-ha"
#         untrusted-subnet-name                   =   "sbnt-waf-ext"
#         mgmt-subnet-name                        =   "sbnt-management"
#        untrusted-external-loadbalancer        =   {tag = "PLB-NAM-Conn-WAF-1"}
#        untrusted-external-loadbalancer-backend-address-pool-name  =   "untrusted-external-backendpool"
#        #  untrusted-external-loadbalancer         =   {
#        #      name                        =   "PLB-NAM-Conn-WAF-1"
#        #      resource-group-name         =   "RG-NAM-Conn-Security"
#        #      backend-address-pool-name   =   "untrusted-external-backendpool"
#        #  }
#        untrusted-internal-loadbalancer        =   {tag = "ILB-NAM-Conn-WAF-1"}
#        untrusted-internal-loadbalancer-backend-address-pool-name = "untrusted-internal-backendpool"
#        #  untrusted-internal-loadbalancer         =   {
#        #      name                        =   "ILB-NAM-Conn-WAF-1"
#        #      resource-group-name         =   "RG-NAM-Conn-Security"
#        #      backend-address-pool-name   =   "untrusted-internal-backendpool"
#        #  }
#         waf-vm =   [
#             {
#                 name    =   "f501"
#                 zone    =   1
#                 size    =   "Standard_DS3_v2"
#                 mgmt-private-ip-address =   "10.0.6.4"
#                 trusted-private-ip-address =  "10.0.4.4"
#                untrusted-private-ip-address  = "10.0.5.4"
#             }
#         ]
#         admin-username      =   "azureadmin"
#         admin-password      =   "Password2021"
#        #  credential-keyvault-name                =   "KV-NAM-Conn-Core-sbx2"
#        #  credential-keyvault-resource-group-name =   "RG-NAM-Conn-Security"
#         keyvault                            =   { tag = "KV-NAM-Conn-Core"}
#         diagnostics-storage-account         =   "shsorotprdboot001"
#         inherit_tags        =   true
#     }
#}
ResourceGroups = {
  "RG-Network" = {
    name     = "RG-Network"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
  }
  "RG-Compute" = {
    name     = "RG-Compute"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Compute"
    }
  }
}

RouteTables = {
  vnet1-routetable = {
    name                          = "vnet1-routetable"
    resource_group                = { key =  "RG-Network" }
    location                      = "East US2"
    disable_bgp_route_propagation = false
    route = [
      # {
      #   name                   = "Firewall"
      #   address_prefix         = "0.0.0.0/0"
      #   next_hop_type          = "VirtualAppliance"
      #   next_hop_in_ip_address = "10.0.10.4"
      # },
      {
        name           = "Gateway"
        address_prefix = "10.1.0.0/16"
        next_hop_type  = "VirtualNetworkGateway"
      }
    ]
  }
  vnet2-routetable = {
    name                          = "vnet2-routetable"
    resource_group                = { key =  "RG-Network" }
    location                      = "West US"
    disable_bgp_route_propagation = false
    route = [
      # {
      #   name                   = "Firewall"
      #   address_prefix         = "0.0.0.0/0"
      #   next_hop_type          = "VirtualAppliance"
      #   next_hop_in_ip_address = "10.0.10.4"
      # },
      {
        name           = "Gateway"
        address_prefix = "10.0.0.0/16"
        next_hop_type  = "VirtualNetworkGateway"
      }
    ]
  }
}

StorageAccounts = {
  stor1 = {
    name           = "shsorotstoracc01"
    resource_group = { key =  "RG-Compute" }
    location       = "East US2"
  }
  stor2 = {
    name           = "shsorotstoracc02"
    resource_group = { key =  "RG-Compute" }
    location       = "West US"
  }
}


PrivateDNSZones = {
  contoso-zone = {
    name           = "contoso.com"
    resource_group = { key =  "RG-Network" }
    inherit_tags   = true
    soa_record = {
      email        = "azureprivatedns-host.microsoft.com"
      refresh_time = 1800
    }
  },
  adatum-zone = {
    name           = "adatum.com"
    resource_group = { key =  "RG-Network" }
    inherit_tags   = true
    soa_record = {
      email        = "azureprivatedns-host.microsoft.com"
      refresh_time = 1800
    }
  }
}

PrivateDNSZonesVirtualNetworkLinks = {
  contoso-zone-network-association = {
    name                  = "contoso-zone-network-association"
    resource_group        = { key =  "RG-Network" }
    private_dns_zone      = { key = "contoso-zone"}
    virtual_network = {
      key = "vnet1"
    }
    registration_enabled = true
  },
  adatum-zone-network-association = {
    name                  = "adatum-zone-network-association"
    resource_group        = { key =  "RG-Network" }
    private_dns_zone      = { key = "adatum-zone"}
    virtual_network = {
      key = "vnet2"
    }
    registration_enabled = true
  }
}


VirtualNetworks = {
  vnet1 = {
    name           = "vnet1"
    resource_group = { key =  "RG-Network" }
    location       = "East US2"
    inherit_tags   = true
    address_space  = ["10.0.0.0/16"]
    dns_servers    = null
    subnet = [
      {
        name             = "GatewaySubnet"
        address_prefixes = ["10.0.255.0/24"]
        # route_table      = { key =  "vnet1-routetable" }
      },
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.0.10.0/24"]
      },
      {
        name             = "AzureFirewallManagementSubnet"
        address_prefixes = ["10.0.11.0/24"]
      },
      {
        name             = "compute"
        address_prefixes = ["10.0.12.0/24"]
        route_table      = { key =  "vnet1-routetable" }
      },
      {
        name             = "privateendpoints"
        address_prefixes = ["10.0.13.0/24"]
        # route_table      = { key =  "vnet1-routetable" }
      }
    ]
  }
  vnet2 = {
    name           = "vnet2"
    resource_group = { key =  "RG-Network" }
    location       = "West US"
    inherit_tags   = true
    address_space  = ["10.1.0.0/16"]
    dns_servers    = null
    subnet = [
      {
        name             = "GatewaySubnet"
        address_prefixes = ["10.1.255.0/24"]
        # route_table      = { key =  "vnet2-routetable" }
      },
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.1.10.0/24"]
      },
      {
        name             = "AzureFirewallManagementSubnet"
        address_prefixes = ["10.1.11.0/24"]
      },
      {
        name             = "compute"
        address_prefixes = ["10.1.12.0/24"]
        # route_table      = { key =  "vnet2-routetable" }
      }
    ]
  }
}

NetworkInterfaces = {
  app-01-nic01 = {
    name           = "app-01-nic01"
    resource_group = { key =  "RG-Compute" }
    location       = "East US2"
    ip_configuration = [
      {
        name = "ipconfig1"
        subnet = {
          virtual_network_key = "vnet1"
          key                 = "compute"
        }
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.12.4"
        primary = true
      }
    ]
  },
  app-02-nic01 = {
    name           = "app-02-nic01"
    resource_group = { key =  "RG-Compute" }
    location       = "West US"
    ip_configuration = [
      {
        name = "ipconfig1"
        subnet = {
          virtual_network_key = "vnet2"
          key                 = "compute"
        }
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.1.12.4"
        primary = true
      }
    ]
  }
}

LinuxVirtualMachines = {
  app-01 = {
    name                            = "app-01"
    resource_group                  = { key =  "RG-Compute" }
    location                        = "East US2"
    admin_username                  = "azureadmin"
    admin_password                  = "Password12!"
    disable_password_authentication = false
    network_interface               = [{ key =  "app-01-nic01" }]
    os_disk = {
      disk_size_gb = "64"
    }
    size     = "Standard_E2s_v3"
    timezone = "GMT Standard Time"
    boot_diagnostics = {
      storage_account_name = "shsorotstoracc01"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    identity = {
      type = "SystemAssigned"
    }

  }
  app-02 = {
    name                            = "app-02"
    resource_group                  = { key =  "RG-Compute" }
    location                        = "West US"
    admin_username                  = "azureadmin"
    admin_password                  = "Password12!"
    disable_password_authentication = false
    network_interface               = [{ key =  "app-02-nic01" }]
    os_disk = {
      disk_size_gb = "64"
    }
    size     = "Standard_E2s_v3"
    timezone = "GMT Standard Time"
    boot_diagnostics = {
      storage_account_name = "shsorotstoracc02"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

# PublicIPPrefixes = {
#   PIPPFX-NAM-Conn-WAF = {
#     name              = "PIPPFX-EUS2"
#     resource_group    = { key =  "RG-Network" }
#     location          = "East US2"
#     inherit_tags      = true
#     sku               = "Standard"
#     prefix_length     = 29
#     availability_zone = "Zone-Redundant"
#   }
# }

# PublicIPAddresses = {
#   PIP-FW = {
#     name              = "PIP-FW"
#     resource_group    = { key =  "RG-Network" }
#     location          = "East US2"
#     inherit_tags      = true
#     sku               = "Standard"
#     allocation_method = "Static"
#     ip_version        = "IPv4"
#     availability_zone = "Zone-Redundant"
#   },
#   PIP-GW-01 = {
#     name              = "PIP-GW-01"
#     resource_group    = { key =  "RG-Network" }
#     location          = "East US2"
#     inherit_tags      = true
#     sku               = "Basic"
#     allocation_method = "Dynamic"
#     ip_version        = "IPv4"
#     availability_zone = "Zone-Redundant"
#   },
#   PIP-GW-02 = {
#     name              = "PIP-GW-02"
#     resource_group    = { key =  "RG-Network" }
#     location          = "West US"
#     inherit_tags      = true
#     sku               = "Basic"
#     allocation_method = "Dynamic"
#     ip_version        = "IPv4"
#     availability_zone = "Zone-Redundant"
#   }
# }

# AzureFirewalls = {
#   testFW = {
#       name = "testFW"
#       resource_group    = { key =  "RG-Network" }
#       location          = "East US2"
#       inherit_tags    = true
#       sku_name        = "AZFW_VNet"
#       sku_tier        = "Standard"
#       ip_configuration  = {
#         name = "IPConfiguration"
#         subnet = { virtual_network_key = "vnet1" }
#         public_ip_address = {key = "PIP-FW"}
#       }
#       #  management_ip_configuration = {
#       #   name = "ManagementIPConfiguration"
#       #   subnet = { virtual_network_key = "vnet1" }
#       #   public_ip_address = {key = "PIP-FW"}
#       # }
#       # firewall_policy = {
#       #   name = "TestFWPolicies"
#       # }
#   }
# }



# VPNGateways = {
#   vnet1-gw = {
#     name = "vnet1-gw"
#     resource_group = { key =  "RG-Network" }
#     location       = "East US2"
#     type = "Vpn"
#     vpn_type = "RouteBased"
#     sku = "Basic"
#     generation = "Generation1"
#     ip_configuration = {
#       subnet = {
#         virtual_network_key = "vnet1"
#       }
#       public_ip_address = { key =  "PIP-GW-01" }
#     }
#   },
#   vnet2-gw = {
#     name = "vnet2-gw"
#     resource_group = { key =  "RG-Network" }
#     location       = "West US"
#     type = "Vpn"
#     vpn_type = "RouteBased"
#     sku = "Basic"
#     generation = "Generation1"
#     ip_configuration = {
#       subnet = {
#         virtual_network_key = "vnet2"
#       }
#       public_ip_address = { key =  "PIP-GW-02" }
#     }
#   }
# }
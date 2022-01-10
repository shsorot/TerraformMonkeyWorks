ResourceGroups = {
  "RG-NAM-Conn-Network" = {
    name     = "RG-NAM-Conn-Network"
    location = "East US2"
    tags = {
      "Environment" = "Dev"
      "Component"   = "Network"
    }
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
      },
      {
        name             = "AzureFirewallSubnet"
        address_prefixes = ["10.0.10.0/24"]
      },
      {
        name             = "AzureFirewallManagementSubnet"
        address_prefixes = ["10.0.11.0/24"]
      }
    ]
  }
}


PublicIPAddresses = {
  PIP-NAM-Conn-NatGW-FW = {
    name              = "PIP-NAM-Conn-FW"
    resource_group    = { tag = "RG-NAM-Conn-Network" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
    availability_zone = "Zone-Redundant"
  }
  PIP-NAM-Conn-NatGW-FW-Mgmt = {
    name              = "PIP-NAM-Conn-FW-Mgmt"
    resource_group    = { tag = "RG-NAM-Conn-Network" }
    location          = "East US2"
    inherit_tags      = true
    sku               = "Standard"
    allocation_method = "Static"
    ip_version        = "IPv4"
    availability_zone = "Zone-Redundant"
  }
}

# VirtualHubs = {
#   testVirtualhub = {
#     name = "testVirtualhub"
#     resource_group    = { tag = "RG-NAM-Conn-Network" }
#     location          = "East US2"
#     inherit_tags    = true
#     sku = "Standard"
#   }
# }

# AzureFirewalls = {
#   testFW = {
#       name = "testFW"
#       resource_group    = { tag = "RG-NAM-Conn-Network" }
#       location          = "East US2"
#       inherit_tags    = true
#       ip_configuration  = {
#         name = "IPConfiguration"
#         subnet = { virtual_network_tag = "VNET-NAM-Conn" }
#         public_ip_address = {tag = "PIP-NAM-Conn-NatGW-FW"}
#       }
#        management_ip_configuration = {
#         name = "ManagementIPConfiguration"  
#         public_ip_address = {tag = "PIP-NAM-Conn-NatGW-FW-Mgmt"}
#       }
#     # virtual_hub = { 
#     #   virtual_hub = 1
#     #   virtual_hub = {tag = "testVirtualhub" }
#     # }
#   }
# }
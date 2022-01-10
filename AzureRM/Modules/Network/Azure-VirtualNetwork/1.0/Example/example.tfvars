resource_group_name  = "network-rg"
name                 = "test-vnet"
tags                 = {}
inherit_tags         = true
address_space        = ["10.0.0.0/18"]
location             = null
bgp_community        = null
ddos_protection_plan = null
subnet = [
  {
    name           = "default"
    address_prefix = "10.0.0.0/24"
  }
]
dns_servers             = null
ddos_protection_plans   = null
network_security_groups = null
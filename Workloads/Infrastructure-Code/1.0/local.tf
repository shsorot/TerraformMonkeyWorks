
# Template: Core Infrastructure
# Version:  1.0
# Date:     25.03.2021

variable "DefaultTags" {
  default = {}
}

locals {
  default_nsg_rules = {
    "RDP-Allow" = {
      description                                = "Allow RDP connections"
      direction                                  = "Inbound"
      priority                                   = 100
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = null
      source_application_security_group_ids      = null
      source_port_range                          = "*"
      source_port_ranges                         = null
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = null
      destination_application_security_group_ids = null
      destination_port_range                     = "3389"
      destination_port_ranges                    = null
    },
    "SSH-Allow" = {
      description                                = "Allow SSH connections"
      direction                                  = "Inbound"
      priority                                   = 110
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = null
      source_application_security_group_ids      = null
      source_port_range                          = "*"
      source_port_ranges                         = null
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = null
      destination_application_security_group_ids = null
      destination_port_range                     = "22"
      destination_port_ranges                    = null
    },
    "HTTPS-Allow" = {
      description                                = "Allow HTTPS connections"
      direction                                  = "Inbound"
      priority                                   = 200
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = null
      source_application_security_group_ids      = null
      source_port_range                          = "*"
      source_port_ranges                         = null
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = null
      destination_application_security_group_ids = null
      destination_port_range                     = "443"
      destination_port_ranges                    = null
    },
    "HTTP-Allow" = {
      description                                = "Allow HTTP connections"
      direction                                  = "Inbound"
      priority                                   = 210
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = null
      source_application_security_group_ids      = null
      source_port_range                          = "*"
      source_port_ranges                         = null
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = null
      destination_application_security_group_ids = null
      destination_port_range                     = "80"
      destination_port_ranges                    = null
    }
  }
  tags = try(var.DefaultTags, {})
}

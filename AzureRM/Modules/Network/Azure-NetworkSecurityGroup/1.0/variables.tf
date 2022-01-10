variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

# variable "resource_group_name" {
#   type = string
# }

variable "resource_group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
  description = "(Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup."
}

variable "resource_groups" {
  type = map(object({
    id       = optional(string)
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
  description = "(Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Tags"
  default     = {}
}

variable "location" {
  type    = string
  default = false
}

variable "name" {
  type = string
}

variable "nsg_rule" {
  type = list(object({
    name                    = string
    description             = optional(string)
    direction               = string                 # Can be "Inbound" or "Outbound"
    priority                = number                 # A value between 100 and 4096
    access                  = string                 # Can be "Allow" or "Deny"
    protocol                = string                 # Can be "tcp", "udp", "icmp" or "*"
    source_address_prefix   = optional(string)       # A CIDR range, a service tag (e.g. "VirtualNetwork") or "*" (null defaults to "*"). Ignored if either <source_address_prefixes> or <source_application_security_group_ids> is set.
    source_address_prefixes = optional(list(string)) # An array of CIDR ranges (neither service tags nor "*" can be used). Ignored if <source_application_security_group_ids> is set.
    source_application_security_group = optional(list(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })))
    source_port_range            = optional(string)       # Can be a number (e.g. "445"), a range (e.g. "1024-2048") or "*" (null defaults to "*"). Ignored if <source_port_ranges> is set.
    source_port_ranges           = optional(list(string)) # An array of numbers or ranges ("*" cannot be used)
    destination_address_prefix   = optional(string)       # A CIDR range, a service tag (e.g. "VirtualNetwork") or "*" (null defaults to "*"). Ignored if either <destination_address_prefixes> or <destination_application_security_group_ids> is set.
    destination_address_prefixes = optional(list(string)) # An array of CIDR ranges (neither service tags nor "*" can be used). Ignored if <destination_application_security_group_ids> is set.
    destination_application_security_group = optional(list(object({
      id                  = optional(string)
      name                = optional(string)
      resource_group_name = optional(string)
      tag                 = optional(string)
    })))
    destination_port_range  = optional(string)       # Can be a number (e.g. "445"), a range (e.g. "1024-2048") or "*" (null defaults to "*"). Ignored if <destination_port_ranges> is set.
    destination_port_ranges = optional(list(string)) # An array of numbers or ranges ("*" cannot be used)
  }))
  default = []
}

variable "application_security_groups" {
  type = map(object({
    id = string
  }))
  default = null
}


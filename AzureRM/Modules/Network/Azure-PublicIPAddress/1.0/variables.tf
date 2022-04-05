variable "name" {
  description = "(Required) Specifies the name of the Public IP resource . Changing this forces a new resource to be created."
  type        = string
}
# variable "resource_group_name" {
#     description = "(Required) The name of the resource group in which to create the public ip."
#     type        = string
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
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "sku" {
  description = " (Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  type        = string
  default     = "Basic"
}
variable "allocation_method" {
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic. Only Dynamic is supported in IPv6"
  type        = string
  default     = "Dynamic"
}
variable "ip_version" {
  description = "(Optional) The IP Version to use, IPv6 or IPv4."
  type        = string
  default     = "IPv4"
}
variable "idle_timeout_in_minutes" {
  description = " (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes."
  type        = number
  default     = 5
}
variable "domain_name_label" {
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  type        = string
  default     = null
}

variable "reverse_fqdn" {
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
  type        = string
  default     = null
}

variable "public_ip_prefix" {
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource."
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    tag                 = optional(string)
  })
  default = null
}

variable "public_ip_prefixes" {
  description = "(Optional) Output of Module Azure-PublicIPPRefix, used to lookup resource ID when var.public_ip_prefix_tag is specified."
  type = map(object({
    id        = string           # Resource ID of the public ip prefix object
    ip_prefix = optional(string) # CIDR prefix count of prefix object.
  }))
  default = {}
}


variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "inherit_tags" {
  type    = bool
  default = false
}

# Depcrecated from provider > 3.00.0
# variable "availability_zone" {
#   description = "(Optional) The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone. Defaults to Zone-Redundant"
#   type        = string
#   default     = null
# }

variable "zones" {
  description = "(Optional) The availability zones to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone. Defaults to Zone-Redundant"
  type        = list(string) 
  default     = null
}




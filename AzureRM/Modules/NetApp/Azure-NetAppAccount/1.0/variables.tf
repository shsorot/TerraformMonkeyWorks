variable "name" {
  type        = string
  description = "(Required) The name of the NetApp Account. Changing this forces a new resource to be created."
}

variable "resource_group" {
  type = object({
    name = optional(string) # Name of the resource group
    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"
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
  description = <<EOF
   (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"
    id       = # ID of the resource group
    location = # Location of the resource group
    tags     = # List of Azure tags applied to resource group
    name     = # Name of the resource group
  EOF
  default     = {}
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Log Analytics Cluster should exist. Changing this forces a new Log Analytics Cluster to be created."
  default     = null
}

variable "tags" {
  type    = map(string)
  description = " (Optional) A mapping of tags to assign to the resource."
  default = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

variable "active_directory" {
  type = object({
    dns_servers         = optional(list(string)) # (Required) A list of DNS server IP addresses for the Active Directory domain. Only allows IPv4 address.
    domain              = optional(string)       # (Required) The name of the Active Directory domain.
    smb_server_name     = optional(string)       # (Required) The NetBIOS name which should be used for the NetApp SMB Server, which will be registered as a computer account in the AD and used to mount volumes.
    username            = optional(string)       # (Required) The Username of Active Directory Domain Administrator.
    password            = optional(string)       # (Required) The password associated with the username
    organizational_unit = optional(string)       # (Optional) The Organizational Unit (OU) within the Active Directory Domain.
  })
  default = null
}

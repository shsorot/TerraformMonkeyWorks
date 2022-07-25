variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Virtual Hub IP. Changing this forces a new resource to be created."
}

variable "virtual_hub" {
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
  description = "(Required) The ID of the Virtual Hub within which this ip configuration should be created. Changing this forces a new resource to be created."
}


variable "virtual_hubs" {
  type = map(object({
    id = optional(string)
  }))
}

variable "subnet" {
  description = "Required) The ID of the Subnet that the IP will reside. Changing this forces a new resource to be created."
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    key                  = optional(string)
    virtual_network_key  = optional(string)
  })
}

variable "virtual_networks" {
  type = map(object({
    id = optional(string)
    subnet = map(object({
      id = optional(string)
    }))
  }))
}

variable "private_ip_address" {
  type        = string
  description = "(Optional) The private IP address of the IP configuration."
  default     = null
}


variable "private_ip_allocation_method" {
  type        = string
  description = "(Optional) The private IP address allocation method. Possible values are Static and Dynamic is allowed. Defaults to Dynamic."
  default     = null
}

variable "public_ip_address" {
  description = "(Optional) The ID of the Public IP Address."
  type = object({
    id                  = optional(string)
    name                = optional(string)
    resource_group_name = optional(string)
    key                 = optional(string)
  })
}

variable "public_ip_addresses" {
  type = map(object({
    fqdn    = string
    id      = string
    address = string
  }))
  description = "(Required) Public IP address output from Azure-PublicIPAddress module. IP address must be of type static and standard."
}

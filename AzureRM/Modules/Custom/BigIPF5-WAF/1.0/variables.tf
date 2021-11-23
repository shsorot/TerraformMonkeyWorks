variable "tags" {
  type    = map(string)
  default = {}
}

variable "inherit_tags" {
  type    = bool
  default = true
}

variable "location" {
  type    = string
  default = null
}

variable "virtual-network" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
}


variable "trusted-subnet-name" {
  type = string
}

variable "untrusted-subnet-name" {
  type = string
}

variable "mgmt-subnet-name" {
  type = string
}

variable "resource-group" {
  type = object({
    name = optional(string)
    tag  = optional(string)
  })
}

variable "untrusted-external-loadbalancer" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
}

variable "untrusted-external-loadbalancer-backend-address-pool-name" {
  type = string
}

variable "untrusted-internal-loadbalancer" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
}

variable "untrusted-internal-loadbalancer-backend-address-pool-name" {
  type = string
}

variable "waf-vm" {
  type = list(object({
    name                            = string
    zone                            = number
    size                            = optional(string)
    timezone                        = optional(string)
    boot-siagnostics-storageaccount = optional(string)
    image-publisher                 = optional(string)
    image-offer                     = optional(string)
    image-sku                       = optional(string)
    image-version                   = optional(string)
    mgmt-private-ip-address         = string
    trusted-private-ip-address      = string
    untrusted-private-ip-address    = string
  }))
}

variable "keyvault" {
  type = object({
    id  = optional(string)
    tag = optional(string)
  })
}

variable "admin-username" {
  type = string
}

variable "admin-password" {
  type    = string
  default = null
}

variable "diagnostics-storage-account" {
  type = string
}

variable "virtual_networks" {
  type = map(object({
    id = optional(string)
    subnet = map(object({
      id = optional(string)
    }))
  }))
}

variable "loadbalancers" {
  type = map(object({
    id = optional(string)
    backend_address_pool = optional(map(object({
      id = optional(string)
    })))
  }))
}

variable "keyvaults" {
  type = map(object({
    id = optional(string)
  }))
}

variable "resource_groups" {
  type = map(object({
    location = optional(string)
    tags     = optional(map(string))
    name     = optional(string)
  }))
}
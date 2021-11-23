variable "storage_account_name " {
  type        = string
  description = <<EOT
    (Required) Specifies the name of the storage account. Changing this forces a new resource to be created. 
    This must be unique across the entire Azure service, not just within the resource group.
    EOT
}

variable "resource_group+name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
}

variable "default_action" {
  type        = string
  description = "(Required) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
}

#User has to explicitly set bypass to empty slice ([]) to remove it.
variable "bypass" {
  type        = list(string)
  description = <<EOT
  (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
  User has to explicitly set bypass to empty slice ([]) to remove it.
  EOT
  default     = []
}


variable "ip_rules" {
  type        = list(string)
  description = <<EOT
    (Optional) List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed.
    User has to explicitly set virtual_network_subnet_ids to empty slice ([]) to remove it.
    EOT
  default     = null
}

variable "virtual_network_subnet" {
  type = object({
    id                   = optional(string)
    name                 = optional(string)
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    tag                  = optional(string)
    virtual_network_tag  = optional(string)
  })
  default = null
}


variable "private_link_access" {
  type = list(object({
    endpoint_resource_id = optional(string) #   (Required) The resource id of the azurerm_private_endpoint of the resource access rule.
    endpoint_tenant_id   = optional(string) #   (Optional) The tenant id of the azurerm_private_endpoint of the resource access rule. Defaults to the current tenant id.
  }))
  default = null
}


variable "virtual_networks" {
  description = "(Optional) Output object from Module Azure-VirtualNetwork, to be used with 'virtual_network_tag' and 'virtual_network_tag'"
  type = map(object({
    id   = string # Resource ID of the virtual Network
    name = string # Name of the Virtual Network
    subnet = map(object({
      id = string
    }))
  }))
  default = {}
}

variable "private_endpoints" {
  description = "(Optional) Output of module Azure-PrivateEndpoint for ID & ALias lookup"
  type = map(object({
    id                         = string
    private_dns_zone_group     = optional(string)
    custom_dns_configs         = optional(string)
    private_dns_zone_configs   = optional(string)
    private_service_connection = optional(string)
    record_sets                = optional(string)
  }))
  default = {}
}



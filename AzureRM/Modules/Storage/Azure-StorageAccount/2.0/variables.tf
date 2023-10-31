variable "tags" {
  type        = map(string)
  description = "azurerm_storage_account"
  default     = {}
}

variable "inherit_tags" {
  type        = bool
  default     = false
  description = "If true, the tags from the resource group will be applied to the resource in addition to tags in the variable 'tags'."
}

# variable "resource_group_name" {
#   type = string
#   description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
# }

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
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "name" {
  type        = string
  description = <<EOT
  (Required) Specifies the name of the storage account. 
  Changing this forces a new resource to be created. 
  This must be unique across the entire Azure service landscape, not just within the resource group or subscription.
  EOT
}

variable "account_kind" { # Can be one of "StorageV2", "Storage", "FileStorage", "BlobStorage" and "BlockBlobStorage"
  type        = string
  default     = "StorageV2"
  description = <<EOT
  (Optional) Defines the Kind of account. 
  Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. 
  Changing this forces a new resource to be created. Defaults to StorageV2
  EOT
}

variable "account_tier" { # Can be "Standard" or "Premium"
  type        = string
  description = <<EOT
  (Required) Defines the Tier to use for this storage account. 
  Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. 
  Changing this forces a new resource to be created.
  EOT
  default     = "Standard"
}

variable "account_replication_type" { # Can be one of "LRS", "GRS", "RAGRS", "ZRS", "GZRS" and "RAGZRS"
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  default     = "LRS"
}

variable "access_tier" { # Can be "Hot" or "Cool"
  type        = string
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  default     = true
}

variable "min_tls_version" { # Can be one of "TLS1_0", "TLS1_1" and "TLS1_2"
  type        = string
  description = <<EOT
  (Optional) The minimum supported TLS version for the storage account. 
  Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts.
  EOT
  default     = "TLS1_0"
}

variable "allow_blob_public_access" {
  type        = bool
  description = "Allow or disallow public access to all blobs or containers in the storage account. Defaults to false."
  default     = false
}

variable "shared_access_key_enabled" {
  type        = bool
  description = <<EOT
  Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. 
  If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). 
  The default value is true.
  If Set to True, Blob access is disabled unless 'the_storage_use_azuread' flag is enabled in the Provider block.
  EOT
  default     = true
}

variable "is_hns_enabled" {
  type        = bool
  description = <<EOT
  (Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 
  Changing this forces a new resource to be created.
  This can only be true when account_tier is Standard or when account_tier is Premium and account_kind is BlockBlobStorage
  EOT
  default     = false
}

variable "nfsv3_enabled" {
  type        = bool
  description = <<EOT
    (Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false.
    This can only be true when account_tier is Standard and account_kind is StorageV2, or account_tier is Premium and account_kind is BlockBlobStorage. 
    Additionally, the is_hns_enabled is true, and enable_https_traffic_only is false.
    EOT
  default     = false
}

variable "large_file_share_enabled" {
  type        = bool
  description = "(Optional) Is Large File Share Enabled?"
  default     = null
}

variable "identity" {
  type = object({
    type = string # (Required) Specifies the identity type of the Storage Account. At this time the only allowed value is SystemAssigned.
  })
  default = {
    type = "SystemAssigned"
  }
}


variable "blob_properties" {
  type = object({
    cors_rule = optional(object({
      allowed_headers    = string # (Required) A list of headers that are allowed to be a part of the cross-origin request.
      allowed_methods    = string # (Required) A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
      allowed_origins    = string # (Required) A list of origin domains that will be allowed by CORS.
      exposed_headers    = string # (Required) A list of response headers that are exposed to CORS clients.
      max_age_in_seconds = string # (Required) The number of seconds the client should cache a preflight response.
    }))
    delete_retention_policy = optional(object({
      days = number # (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7.
    }))
    container_delete_retention_policy = optional(object({
      days = number # (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7.
    }))
    versioning_enabled       = optional(bool)   # (Optional) Is versioning enabled? Default to false.
    change_feed_enabled      = optional(bool)   #  (Optional) Is the blob service properties for change feed events enabled? Default to false.
    default_service_version  = optional(string) # (Optional) The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version. Defaults to 2020-06-12.
    last_access_time_enabled = optional(bool)   #  (Optional) Is the last access time based tracking enabled? Default to false.
  })
  default = null
}

variable "custom_domain" {
  type = object({
    name          = string         #(Required) The Custom Domain Name to use for the Storage Account, which will be validated by Azure.
    use_subdomain = optional(bool) # (Optional) Should the Custom Domain Name be validated by using indirect CNAME validation?
  })
  default = null
}

variable "queue_properties" {
  type = object({
    cors_rule = optional(object({
      allowed_headers    = string # (Required) A list of headers that are allowed to be a part of the cross-origin request.
      allowed_methods    = string # (Required) A list of http headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
      allowed_origins    = string # (Required) A list of origin domains that will be allowed by CORS.
      exposed_headers    = string # (Required) A list of response headers that are exposed to CORS clients.
      max_age_in_seconds = string # (Required) The number of seconds the client should cache a preflight response.
    }))
    logging = optional(object({
      delete                = bool   # (Required) Indicates whether all delete requests should be logged. Changing this forces a new resource.
      read                  = bool   # (Required) Indicates whether all read requests should be logged. Changing this forces a new resource.
      versio                = string # (Required) The version of storage analytics to configure. Changing this forces a new resource.
      write                 = bool   # (Required) Indicates whether all write requests should be logged. Changing this forces a new resource.
      retention_policy_days = number #  (Optional) Specifies the number of days that logs will be retained. Changing this forces a new resource.
    }))
    minute_metrics = optional(object({
      enabled               = bool   # (Required) Indicates whether minute metrics are enabled for the Queue service. Changing this forces a new resource.
      version               = string # (Required) The version of storage analytics to configure. Changing this forces a new resource.
      include_apis          = bool   # (Optional) Indicates whether metrics should generate summary statistics for called API operations.
      retention_policy_days = number #  (Optional) Specifies the number of days that logs will be retained. Changing this forces a new resource.
    }))
    hour_metrics = optional(object({
      enabled               = bool   # (Required) Indicates whether minute metrics are enabled for the Queue service. Changing this forces a new resource.
      version               = string # (Required) The version of storage analytics to configure. Changing this forces a new resource.
      include_apis          = bool   # (Optional) Indicates whether metrics should generate summary statistics for called API operations.
      retention_policy_days = number #  (Optional) Specifies the number of days that logs will be retained. Changing this forces a new resource.
    }))
  })
  default = null
}

variable "static_website" {
  type = object({
    index_document     = optional(string) # (Optional) The webpage that Azure Storage serves for requests to the root of a website or any subfolder. For example, index.html. The value is case-sensitive.
    error_404_document = optional(string) # (Optional) The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file.
  })
  default = null
}

variable "network_rules" {
  type = object({
    default_action = optional(string)       # (Required) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow.
    bypass         = optional(list(string)) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.
    ip_rules       = optional(list(string)) # (Optional) List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed.
    virtual_network_subnet = optional(list(object({
      id                   = optional(string)
      name                 = optional(string)
      virtual_network_name = optional(string)
      resource_group_name  = optional(string)
      key                  = optional(string)
      virtual_network_key  = optional(string)
    }))) # (Optional) A list of resource ids for subnets.
    private_link_access = optional(map(object({
      endpoint_tenant_id   = optional(string) # (Optional) The tenant id of the azurerm_private_endpoint of the resource access rule. Defaults to the current tenant id.
      endpoint_resource_id = string           # (Required) The resource id of the azurerm_private_endpoint of the resource access rule.
    })))
  })
  default = {}
}

variable "azure_files_authentication" {
  type = object({
    directory_type = string # (Required) Specifies the directory service used. Possible values are AADDS and AD.
    active_directory = optional(object({
      storage_sid         = string # (Required) Specifies the security identifier (SID) for Azure Storage.
      domain_name         = string # (Required) Specifies the primary domain that the AD DNS server is authoritative for.
      domain_sid          = string # (Required) Specifies the security identifier (SID).
      domain_guid         = string # (Required) Specifies the domain GUID.
      forest_name         = string # (Required) Specifies the Active Directory forest.
      netbios_domain_name = string # (Required) Specifies the NetBIOS domain name.
    }))
  })
  default = null
}

variable "routing" {
  type = object({
    publish_internet_endpoints  = optional(bool)   #  (Optional) Should internet routing storage endpoints be published? Defaults to false.
    publish_microsoft_endpoints = optional(bool)   #  (Optional) Should microsoft routing storage endpoints be published? Defaults to false.
    choice                      = optional(string) # (Optional) Specifies the kind of network routing opted by the user. Possible values are InternetRouting and MicrosoftRouting. Defaults to MicrosoftRouting.
  })
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

# Added encryption variables as of 2.94.0
variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
  #NOTE:
  #This can only be true when account_kind is StorageV2.
  default = false
}

variable "queue_encryption_key_type" {
  type        = string
  description = " (Optional) The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  default     = "Service"
}

variable "table_encryption_key_type" {
  type        = string
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  default     = "Service"
}

variable "private_endpoints"{
  type = list(object({
    name = string # (Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created.
    subnet = object({  #  (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.
      id = optional(string) 
      name = optional(string)

    })
  }))
}
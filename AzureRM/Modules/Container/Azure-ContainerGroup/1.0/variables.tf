variable "location" {
  description = " (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
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

variable "name" {
  description = "(Required) Specifies the name of the Container Group. Changing this forces a new resource to be created."
  type        = string
}


variable "identity" {
  type = object({
    type         = string                 # (Required) Specifies the type of Managed Service Identity that should be configured on this Container Group. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
    identity_ids = optional(list(string)) # (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Group.
  })
  default = null
}

variable "init_container" {
  type = object({
    name                         = string                 #(Required) Specifies the name of the Container. Changing this forces a new resource to be created.
    image                        = string                 # (Required) The container image name. Changing this forces a new resource to be created.
    environment_variables        = optional(list(string)) # (Optional) A list of environment variables to be set on the container. Specified as a map of name/value pairs. Changing this forces a new resource to be created.
    secure_environment_variables = optional(list(string)) # (Optional) A list of sensitive environment variables to be set on the container. Specified as a map of name/value pairs. Changing this forces a new resource to be created.
    commands                     = optional(list(string)) # (Optional) A list of commands which should be run on the container. Changing this forces a new resource to be created.
    volume = optional(object({
      name                 = string           # (Required) The name of the volume mount. Changing this forces a new resource to be created.
      mount_path           = string           # (Required) The path on which this volume is to be mounted. Changing this forces a new resource to be created.
      read_only            = optional(bool)   #   (Optional) Specify if the volume is to be mounted as read only or not. The default value is false. Changing this forces a new resource to be created.
      empty_dir            = optional(bool)   # (Optional) Boolean as to whether the mounted volume should be an empty directory. Defaults to false. Changing this forces a new resource to be created.
      storage_account_name = optional(string) # (Optional) The Azure storage account from which the volume is to be mounted. Changing this forces a new resource to be created.
      storage_account_key  = optional(string) # (Optional) The access key for the Azure Storage account specified as above. Changing this forces a new resource to be created.
      share_name           = optional(string) #  (Optional) The Azure storage share that is to be mounted as a volume. This must be created on the storage account specified as above. Changing this forces a new resource to be created.
      git_repo = optional(object({
        url       = string           # (Required) Specifies the Git repository to be cloned. Changing this forces a new resource to be created.
        directory = optional(string) #   (Optional) Specifies the directory into which the repository should be cloned. Changing this forces a new resource to be created.
        revision  = optional(string) # (Optional) Specifies the commit hash of the revision to be cloned. If unspecified, the HEAD revision is cloned. Changing this forces a new resource to be created.
      }))
      secret = optional(map(string)) #  (Optional) A map of secrets that will be mounted as files in the volume. Changing this forces a new resource to be created.
    }))
  })
  default = null
}

variable "container" {
  type = object({
    name   = string # (Required) Specifies the name of the Container. Changing this forces a new resource to be created.
    image  = string # (Required) The container image name. Changing this forces a new resource to be created.
    cpu    = string # (Optional) The number of CPU cores assigned to the container. Changing this forces a new resource to be created.
    memory = string # (Required) The required memory of the containers in GB. Changing this forces a new resource to be created.
    gpu = optional(object({

    }))
    ports = optional(list(object({
      port     = string # (Required) The port number the container will expose. Changing this forces a new resource to be created.
      protocol = string # (Required) The network protocol associated with port. Possible values are TCP & UDP. Changing this forces a new resource to be created.
    })))
    environment_variables        = optional(list(string)) # (Optional) A list of environment variables to be set on the container. Specified as a map of name/value pairs. Changing this forces a new resource to be created.
    secure_environment_variables = optional(list(string)) # (Optional) A list of sensitive environment variables to be set on the container. Specified as a map of name/value pairs. Changing this forces a new resource to be created.
    readiness_probe = optional(object({
      exec = optional(string) # (Optional) Commands to be run to validate container readiness. Changing this forces a new resource to be created.
      http_get = optional(object({
        path   = string # (Optional) The path to probe for readiness. Changing this forces a new resource to be created.
        port   = string # (Optional) The port to probe for readiness. Changing this forces a new resource to be created.
        scheme = string # (Optional) The protocol to probe for readiness. Possible values are HTTP & HTTPS. Changing this forces a new resource to be created.
      }))
      initial_delay_seconds = optional(number) #  (Optional) Number of seconds after the container has started before liveness or readiness probes are initiated. Changing this forces a new resource to be created.
      period_seconds        = optional(number) # (Optional) How often (in seconds) to perform the probe. Changing this forces a new resource to be created.
      failure_threshold     = optional(number) # (Optional) Minimum consecutive failures for the probe to be considered failed after having succeeded. Changing this forces a new resource to be created.
      success_threshold     = optional(number) # (Optional) Minimum consecutive successes for the probe to be considered successful after having failed. Changing this forces a new resource to be created.
      timeout_seconds       = optional(number) # (Optional) Number of seconds after which the probe times out. Changing this forces a new resource to be created.
    }))
    liveness_probe = optional(object({
      exec = optional(string) # (Optional) Commands to be run to validate container readiness. Changing this forces a new resource to be created.
      http_get = optional(object({
        path   = string # (Optional) The path to probe for readiness. Changing this forces a new resource to be created.
        port   = string # (Optional) The port to probe for readiness. Changing this forces a new resource to be created.
        scheme = string # (Optional) The protocol to probe for readiness. Possible values are HTTP & HTTPS. Changing this forces a new resource to be created.
      }))
      initial_delay_seconds = optional(number) #  (Optional) Number of seconds after the container has started before liveness or readiness probes are initiated. Changing this forces a new resource to be created.
      period_seconds        = optional(number) # (Optional) How often (in seconds) to perform the probe. Changing this forces a new resource to be created.
      failure_threshold     = optional(number) # (Optional) Minimum consecutive failures for the probe to be considered failed after having succeeded. Changing this forces a new resource to be created.
      success_threshold     = optional(number) # (Optional) Minimum consecutive successes for the probe to be considered successful after having failed. Changing this forces a new resource to be created.
      timeout_seconds       = optional(number) # (Optional) Number of seconds after which the probe times out. Changing this forces a new resource to be created.
    }))
    commands = optional(list(string)) # (Optional) A list of commands which should be run on the container. Changing this forces a new resource to be created.
    volume = optional(object({
      name                 = string           # (Required) The name of the volume mount. Changing this forces a new resource to be created.
      mount_path           = string           # (Required) The path on which this volume is to be mounted. Changing this forces a new resource to be created.
      read_only            = optional(bool)   #   (Optional) Specify if the volume is to be mounted as read only or not. The default value is false. Changing this forces a new resource to be created.
      empty_dir            = optional(bool)   # (Optional) Boolean as to whether the mounted volume should be an empty directory. Defaults to false. Changing this forces a new resource to be created.
      storage_account_name = optional(string) # (Optional) The Azure storage account from which the volume is to be mounted. Changing this forces a new resource to be created.
      storage_account_key  = optional(string) # (Optional) The access key for the Azure Storage account specified as above. Changing this forces a new resource to be created.
      share_name           = optional(string) #  (Optional) The Azure storage share that is to be mounted as a volume. This must be created on the storage account specified as above. Changing this forces a new resource to be created.
      git_repo = optional(object({
        url       = string           # (Required) Specifies the Git repository to be cloned. Changing this forces a new resource to be created.
        directory = optional(string) #   (Optional) Specifies the directory into which the repository should be cloned. Changing this forces a new resource to be created.
        revision  = optional(string) # (Optional) Specifies the commit hash of the revision to be cloned. If unspecified, the HEAD revision is cloned. Changing this forces a new resource to be created.
      }))
      secret = optional(map(string)) #  (Optional) A map of secrets that will be mounted as files in the volume. Changing this forces a new resource to be created.
    }))
  })
  default = null
}

variable "os_type" {
  type        = string
  default     = "Linux"
  description = "(Required) The definition of a container that is part of the group as documented in the container block below. Changing this forces a new resource to be created."
}

variable "dns_config" {
  type = object({
    nameservers    = list(string)           #  (Required) A list of nameservers the containers will search out to resolve requests.
    search_domains = optional(list(string)) # (Optional) A list of search domains that DNS requests will search along.
    options        = optional(list(string)) #  (Optional) A list of resolver configuration options from https://man7.org/linux/man-pages/man5/resolv.conf.5.html
  })
  default = null
}

variable "diagnostics" {
  type = object({
    log_analytics = object({
      log_type      = optional(string) #  (Optional) The log type which should be used. Possible values are ContainerInsights and ContainerInstanceLogs. Changing this forces a new resource to be created.
      workspace_id  = string           #  (Optional) The workspace ID for the log analytics workspace. Changing this forces a new resource to be created.
      workspace_key = string           #  (Optional) The workspace key for the log analytics workspace. Changing this forces a new resource to be created.
      metadata      = optional(string) # (Optional) Any metadata required for Log Analytics. Changing this forces a new resource to be created.
    })
  })
  default = null
}

variable "dns_name_label" {
  type        = string
  description = "(Optional) The DNS label/name for the container groups IP. Changing this forces a new resource to be created."
  #DNS label/name is not supported when deploying to virtual networks.
  default = null
}

variable "exposed_port" {
  type = object({
    port     = string # (Required) The port number exposed by the container. Changing this forces a new resource to be created.
    protocol = string # (Required) The network protocol associated with port. Possible values are TCP & UDP. Changing this forces a new resource to be created.
  })
  default = null
}

variable "ip_address_type" {
  type        = string
  description = "(Optional) Specifies the ip address type of the container. Public, Private or None. Changing this forces a new resource to be created. If set to Private, network_profile_id also needs to be set."
  default     = null
}

variable "network_profile_id" {
  type        = string
  description = "(Optional) Network profile ID for deploying to virtual network."
  default     = null
}

variable "image_registry_credential" {
  type = object({
    username = string #  (Required) The username with which to connect to the registry. Changing this forces a new resource to be created.
    password = string # (Required) The password with which to connect to the registry. Changing this forces a new resource to be created.
    server   = string # (Required) The address to use to connect to the registry without protocol ("https"/"http"). For example: "myacr.acr.io". Changing this forces a new resource to be created.
  })
  default   = null
  sensitive = true
}

variable "restart_policy" {
  type        = string
  description = "(Optional) Restart policy for the container group. Allowed values are Always, Never, OnFailure. Defaults to Always. Changing this forces a new resource to be created."
  default     = "Always"
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


 
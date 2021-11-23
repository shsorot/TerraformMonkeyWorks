variable "name" {
  type        = string
  description = <<EOT
  (Required) Specifies the name of the EventHub resource. 
  Changing this forces a new resource to be created.
  EOT
}

variable "namespace_name" {
  type        = string
  description = <<EOT
  (Required) Specifies the name of the EventHub Namespace. 
  Changing this forces a new resource to be created.
  EOT
}

# variable "resource_group_name"{
#     type = string
#     description = <<EOT
#     (Required) The name of the resource group in which the EventHub's parent Namespace exists. 
#     Changing this forces a new resource to be created.
#     EOT
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

variable "partition_count" {
  type        = number
  description = "(Required) Specifies the current number of shards on the Event Hub. Changing this forces a new resource to be created."
}

variable "message_retention" {
  type        = number
  description = "(Required) Specifies the number of days to retain the events for this Event Hub."
}

variable "capture_description" {
  type = object({
    enabled             = bool           #   (Required) Specifies if the Capture Description is Enabled.
    encoding            = string         #   (Required) Specifies the Encoding used for the Capture Description. Possible values are Avro and AvroDeflate.
    interval_in_seconds = number         #   (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between 60 and 900 seconds. Defaults to 300 seconds.
    size_limit_in_bytes = number         #   (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between 10485760 and 524288000 bytes. Defaults to 314572800 bytes.
    skip_empty_archives = optional(bool) #   (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to false.
    destination = object({
      name                = string #   (Required) The Name of the Destination where the capture should take place. At this time the only supported value is EventHubArchive.AzureBlockBlob.
      archive_name_format = string #   The Blob naming convention for archiving. e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order
      blob_container_name = string #   (Required) The name of the Container within the Blob Storage Account where messages should be archived.
      storage_account = object({
        id                  = optional(string)
        name                = optional(string)
        resource_group_name = optional(string)
        tag                 = optional(string)
      }) #   (Required) The ID of the Blob Storage Account where messages should be archived.
    })
  })
  default = null
}

variable "status" {
  type        = string
  default     = null
  description = " (Optional) Specifies the status of the Event Hub resource. Possible values are Active, Disabled and SendDisabled. Defaults to Active."
}

variable "storage_accounts" {
  type = map(object({
    id = optional(string)
  }))
  default     = {}
  description = "(Optional) Output of module Azure-StorageAccount, to be used for lookup of Storage account ID using tag."
}




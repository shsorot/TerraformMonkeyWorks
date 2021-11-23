variable "name" {
  type        = string
  description = "(Required) The name of the Container which should be created within the Storage Account."
}

variable "storage_account_name" {
  type        = string
  description = "(Required) The name of the Storage Account where the Container should be created."
}

variable "storage_container_name" {
  type        = string
  description = "(Required) The name of the storage container in which this blob should be created."
}


variable "type" {
  type        = string
  description = "(Required) The type of the storage blob to be created. Possible values are Append, Block or Page. Changing this forces a new resource to be created."
}

variable "size" {
  type        = number
  description = " (Optional) Used only for page blobs to specify the size in bytes of the blob to be created. Must be a multiple of 512. Defaults to 0."
  default     = null
}

variable "access_tier" {
  type        = string
  description = "(Optional) The access tier of the storage blob. Possible values are Archive, Cool and Hot."
  default     = null
}

variable "content_type" {
  type        = string
  description = "(Optional) The content type of the storage blob. Cannot be defined if source_uri is defined. Defaults to application/octet-stream"
  default     = null
}

variable "content_md5" {
  type        = string
  description = <<HELP
  (Optional) The MD5 sum of the blob contents. Cannot be defined if source_uri is defined, or if blob type is Append or Page. 
  Changing this forces a new resource to be created.
  This property is intended to be used with the Terraform internal filemd5 and md5 functions when source or source_content, respectively, are defined.
  HELP
  default     = null
}

variable "source" {

}




variable "metadata" {
  type        = map(string)
  description = "(Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase."
  default     = {}
}


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capture_description"></a> [capture\_description](#input\_capture\_description) | n/a | <pre>object({<br>    enabled             = bool           #   (Required) Specifies if the Capture Description is Enabled.<br>    encoding            = string         #   (Required) Specifies the Encoding used for the Capture Description. Possible values are Avro and AvroDeflate.<br>    interval_in_seconds = number         #   (Optional) Specifies the time interval in seconds at which the capture will happen. Values can be between 60 and 900 seconds. Defaults to 300 seconds.<br>    size_limit_in_bytes = number         #   (Optional) Specifies the amount of data built up in your EventHub before a Capture Operation occurs. Value should be between 10485760 and 524288000 bytes. Defaults to 314572800 bytes.<br>    skip_empty_archives = optional(bool) #   (Optional) Specifies if empty files should not be emitted if no events occur during the Capture time window. Defaults to false.<br>    destination = object({<br>      name                = string #   (Required) The Name of the Destination where the capture should take place. At this time the only supported value is EventHubArchive.AzureBlockBlob.<br>      archive_name_format = string #   The Blob naming convention for archiving. e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order<br>      blob_container_name = string #   (Required) The name of the Container within the Blob Storage Account where messages should be archived.<br>      storage_account = object({<br>        id                  = optional(string)<br>        name                = optional(string)<br>        resource_group_name = optional(string)<br>        key                 = optional(string)<br>      }) #   (Required) The ID of the Blob Storage Account where messages should be archived.<br>    })<br>  })</pre> | `null` | no |
| <a name="input_message_retention"></a> [message\_retention](#input\_message\_retention) | (Required) Specifies the number of days to retain the events for this Event Hub. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the EventHub resource. <br>  Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | (Required) Specifies the name of the EventHub Namespace. <br>  Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | (Required) Specifies the current number of shards on the Event Hub. Changing this forces a new resource to be created. | `number` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The name of the resource group where to create the resource. Specify either the actual name or the Tag value that can be used to look up Resource group properties from output of module Azure-ResourceGroup. | <pre>object({<br>    name = optional(string) # Name of the resource group<br>    key  = optional(string) # Terraform Object Key to use to find the resource group from output of module Azure-ResourceGroup supplied to variable "resource_groups"<br>  })</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Optional) Output of Module Azure-ResourceGroup. Used to lookup RG properties using Terraform Object Keys"<br>    id       = # ID of the resource group<br>    location = # Location of the resource group<br>    tags     = # List of Azure tags applied to resource group<br>    name     = # Name of the resource group | <pre>map(object({<br>    id       = optional(string)<br>    location = optional(string)<br>    tags     = optional(map(string))<br>    name     = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_status"></a> [status](#input\_status) | (Optional) Specifies the status of the Event Hub resource. Possible values are Active, Disabled and SendDisabled. Defaults to Active. | `string` | `null` | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | (Optional) Output of module Azure-StorageAccount, to be used for lookup of Storage account ID using tag. | <pre>map(object({<br>    id = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_partition_ids"></a> [partition\_ids](#output\_partition\_ids) | n/a |
<!-- END_TF_DOCS -->
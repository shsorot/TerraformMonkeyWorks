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
| [azurerm_marketplace_agreement.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/marketplace_agreement) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_offer"></a> [offer](#input\_offer) | (Required) The Offer of the Marketplace Image. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_plan"></a> [plan](#input\_plan) | (Required) The Plan of the Marketplace Image. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_publisher"></a> [publisher](#input\_publisher) | (Required) The Publisher of the Marketplace Image. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->
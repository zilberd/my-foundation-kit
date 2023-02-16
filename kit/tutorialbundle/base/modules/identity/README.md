<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Controls whether to manage the identity landing zone policies and deploy the identity resources into the current Subscription context. | `bool` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Configuration settings for the "Identity" landing zone resources. | <pre>object({<br>    identity = object({<br>      enabled = bool<br>      config = object({<br>        enable_deny_public_ip             = bool<br>        enable_deny_rdp_from_internet     = bool<br>        enable_deny_subnet_without_nsg    = bool<br>        enable_deploy_azure_backup_on_vms = bool<br>      })<br>    })<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Returns the configuration settings for resources to deploy for the identity solution. |
<!-- END_TF_DOCS -->
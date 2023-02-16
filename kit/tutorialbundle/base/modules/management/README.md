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
| <a name="input_asc_export_resource_group_name"></a> [asc\_export\_resource\_group\_name](#input\_asc\_export\_resource\_group\_name) | If specified, will customise the `ascExportResourceGroupName` parameter for the `Deploy-MDFC-Config` Policy Assignment when managed by the module. | `string` | `""` | no |
| <a name="input_custom_settings_by_resource_type"></a> [custom\_settings\_by\_resource\_type](#input\_custom\_settings\_by\_resource\_type) | If specified, allows full customization of common settings for all resources (by type) deployed by this module. | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Controls whether to manage the management landing zone policies and deploy the management resources into the current Subscription context. | `bool` | n/a | yes |
| <a name="input_existing_automation_account_resource_id"></a> [existing\_automation\_account\_resource\_id](#input\_existing\_automation\_account\_resource\_id) | If specified, module will skip creation of Automation Account and use existing. | `string` | `""` | no |
| <a name="input_existing_log_analytics_workspace_resource_id"></a> [existing\_log\_analytics\_workspace\_resource\_id](#input\_existing\_log\_analytics\_workspace\_resource\_id) | If specified, module will skip creation of Log Analytics workspace and use existing. | `string` | `""` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | If specified, module will skip creation of the management Resource Group and use existing. | `string` | `""` | no |
| <a name="input_link_log_analytics_to_automation_account"></a> [link\_log\_analytics\_to\_automation\_account](#input\_link\_log\_analytics\_to\_automation\_account) | If set to true, module will link the Log Analytics workspace and Automation Account. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Sets the default location used for resource deployments where needed. | `string` | `"eastus"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | If specified, will set the resource name prefix for management resources (default value determined from "var.root\_id"). | `string` | `""` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | If specified, will set the resource name suffix for management resources. | `string` | `""` | no |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | Specifies the ID of the Enterprise-scale root Management Group, used as a prefix for resources created by this module. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Configuration settings for the "Management" landing zone resources. | <pre>object({<br>    log_analytics = object({<br>      enabled = bool<br>      config = object({<br>        retention_in_days                                 = number<br>        enable_monitoring_for_arc                         = bool<br>        enable_monitoring_for_vm                          = bool<br>        enable_monitoring_for_vmss                        = bool<br>        enable_solution_for_agent_health_assessment       = bool<br>        enable_solution_for_anti_malware                  = bool<br>        enable_solution_for_azure_activity                = bool<br>        enable_solution_for_change_tracking               = bool<br>        enable_solution_for_service_map                   = bool<br>        enable_solution_for_sql_assessment                = bool<br>        enable_solution_for_sql_vulnerability_assessment  = bool<br>        enable_solution_for_sql_advanced_threat_detection = bool<br>        enable_solution_for_updates                       = bool<br>        enable_solution_for_vm_insights                   = bool<br>        enable_sentinel                                   = bool<br>      })<br>    })<br>    security_center = object({<br>      enabled = bool<br>      config = object({<br>        email_security_contact             = string<br>        enable_defender_for_app_services   = bool<br>        enable_defender_for_arm            = bool<br>        enable_defender_for_containers     = bool<br>        enable_defender_for_dns            = bool<br>        enable_defender_for_key_vault      = bool<br>        enable_defender_for_oss_databases  = bool<br>        enable_defender_for_servers        = bool<br>        enable_defender_for_sql_servers    = bool<br>        enable_defender_for_sql_server_vms = bool<br>        enable_defender_for_storage        = bool<br>      })<br>    })<br>  })</pre> | <pre>{<br>  "log_analytics": {<br>    "config": {<br>      "enable_monitoring_for_arc": true,<br>      "enable_monitoring_for_vm": true,<br>      "enable_monitoring_for_vmss": true,<br>      "enable_sentinel": true,<br>      "enable_solution_for_agent_health_assessment": true,<br>      "enable_solution_for_anti_malware": true,<br>      "enable_solution_for_azure_activity": true,<br>      "enable_solution_for_change_tracking": true,<br>      "enable_solution_for_service_map": true,<br>      "enable_solution_for_sql_advanced_threat_detection": true,<br>      "enable_solution_for_sql_assessment": true,<br>      "enable_solution_for_sql_vulnerability_assessment": true,<br>      "enable_solution_for_updates": true,<br>      "enable_solution_for_vm_insights": true,<br>      "retention_in_days": 30<br>    },<br>    "enabled": true<br>  },<br>  "security_center": {<br>    "config": {<br>      "email_security_contact": "security_contact@replace_me",<br>      "enable_defender_for_app_services": true,<br>      "enable_defender_for_arm": true,<br>      "enable_defender_for_containers": true,<br>      "enable_defender_for_dns": true,<br>      "enable_defender_for_key_vault": true,<br>      "enable_defender_for_oss_databases": true,<br>      "enable_defender_for_servers": true,<br>      "enable_defender_for_sql_server_vms": true,<br>      "enable_defender_for_sql_servers": true,<br>      "enable_defender_for_storage": true<br>    },<br>    "enabled": true<br>  }<br>}</pre> | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Specifies the Subscription ID for the Subscription containing all management resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | If specified, will set the default tags for all resources deployed by this module where supported. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Returns the configuration settings for resources to deploy for the management solution. |
<!-- END_TF_DOCS -->
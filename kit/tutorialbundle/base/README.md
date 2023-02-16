---
name: Azure CAF Enterprise Scale
summary: |
  todo description goes here
---
  
# Azure landing zones Terraform module

[![Build Status](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_apis/build/status/Tests/E2E?branchName=refs%2Ftags%2Fv2.4.1)](https://dev.azure.com/mscet/CAE-ALZ-Terraform/_build/latest?definitionId=26&branchName=refs%2Ftags%2Fv2.4.1)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Azure/terraform-azurerm-caf-enterprise-scale?style=flat&logo=github)

Detailed information about how to use, configure and extend this module can be found on our Wiki:

- [Home][wiki_home]
- [User Guide][wiki_user_guide]
- [Examples][wiki_examples]
- [Frequently Asked Questions][wiki_frequently_asked_questions]
- [Troubleshooting][wiki_troubleshooting]
- [Contributing][wiki_contributing]

## Overview

The [Azure landing zones Terraform module][alz_tf_registry] is designed to accelerate deployment of platform resources based on the [Azure landing zones conceptual architecture][alz_architecture] using Terraform.

![A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module.][alz_tf_overview]

This is currently split logically into the following capabilities within the module (*links to further guidance on the Wiki*):

| Module capability | Scope | Design area |
| :--- | :--- | :--- |
| [Core Resources][wiki_core_resources] | Management group and subscription organization | [Resource organization][alz_hierarchy] |
| [Management Resources][wiki_management_resources] | Management subscription | [Management][alz_management] |
| [Connectivity Resources][wiki_connectivity_resources] | Connectivity subscription | [Network topology and connectivity][alz_connectivity] |
| [Identity Resources][wiki_identity_resources] | Identity subscription | [Identity and access management][alz_identity] |

Using a very [simple initial configuration](#maintf), the module will deploy a management group hierarchy based on the above diagram.
This includes the recommended governance baseline, applied using Azure Policy and Access control (IAM) resources deployed at the management group scope.
The default configuration can be easily extended to meet differing requirements, and includes the ability to deploy platform resources in the `management` and `connectivity` subscriptions.

> **NOTE:** In addition to setting input variables to control which resources are deployed, the module requires setting a [Provider Configuration][wiki_provider_configuration] block to enable deployment across multiple subscriptions.

Although resources are logically grouped to simplify operations, the modular design of the module also allows resources to be deployed using different Terraform workspaces.
This allows customers to address concerns around managing large state files, or assigning granular permissions to pipelines based on the principle of least privilege. (*more information coming soon in the Wiki*)

## Terraform versions

This module has been tested using Terraform `0.15.1` and AzureRM Provider `3.0.2` as a baseline, and various versions to up the latest at time of release.
In some cases, individual versions of the AzureRM provider may cause errors.
If this happens, we advise upgrading to the latest version and checking our [troubleshooting][wiki_troubleshooting] guide before [raising an issue](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues).

## Usage

We recommend starting with the following configuration in your root module to learn what resources are created by the module and how it works.

This will deploy the core components only.

> **NOTE:** For production use we highly recommend using the Terraform Registry and pinning to the latest stable version, as per the example below.
> Pinning to the `main` branch in GitHub will give you the latest updates quicker, but increases the likelihood of unplanned changes to your environment and unforeseen issues.

### `main.tf`

```hcl
# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# management group.

data "azurerm_client_config" "core" {}

# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Enterprise-Scale"
}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.4.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

}
```

> **NOTE:** For additional guidance on how to customize your deployment using the advanced configuration options for this module, please refer to our [User Guide][wiki_user_guide] and the additional [examples][wiki_examples] in our documentation.

## Permissions

Please refer to our [Module Permissions][wiki_module_permissions] guide on the Wiki.

## Examples

The following list outlines some of our most popular examples:

- [Examples - Level 100][wiki_examples_level_100]
  - [Deploy Default Configuration][wiki_deploy_default_configuration]
  - [Deploy Demo Landing Zone Archetypes][wiki_deploy_demo_landing_zone_archetypes]
- [Examples - Level 200][wiki_examples_level_200]
  - [Deploy Custom Landing Zone Archetypes][wiki_deploy_custom_landing_zone_archetypes]
  - [Deploy Connectivity Resources][wiki_deploy_connectivity_resources]
  - [Deploy Identity Resources][wiki_deploy_identity_resources]
  - [Deploy Management Resources][wiki_deploy_management_resources]
  - [Assign a Built-in Policy][wiki_assign_a_built_in_policy]
- [Examples - Level 300][wiki_examples_level_300]
  - [Deploy Connectivity Resources With Custom Settings][wiki_deploy_connectivity_resources_custom]
  - [Deploy Identity Resources With Custom Settings][wiki_deploy_identity_resources_custom]
  - [Deploy Management Resources With Custom Settings][wiki_deploy_management_resources_custom]
  - [Expand Built-in Archetype Definitions][wiki_expand_built_in_archetype_definitions]
  - [Create Custom Policies, Policy Sets and Assignments][wiki_create_custom_policies_policy_sets_and_assignments]

For the complete list of our latest examples, please refer to our [Examples][wiki_examples] page on the Wiki.

## Release notes

Please see the [releases][repo_releases] page for the latest module updates.

## Upgrade guides

For upgrade guides from previous versions, please refer to the following links:

- [Upgrade from v1.1.4 to v2.0.0][wiki_upgrade_from_v1_1_4_to_v2_0_0]
- [Upgrade from v0.4.0 to v1.0.0][wiki_upgrade_from_v0_4_0_to_v1_0_0]
- [Upgrade from v0.3.3 to v0.4.0][wiki_upgrade_from_v0_3_3_to_v0_4_0]
- [Upgrade from v0.1.2 to v0.2.0][wiki_upgrade_from_v0_1_2_to_v0_2_0]
- [Upgrade from v0.0.8 to v0.1.0][wiki_upgrade_from_v0_0_8_to_v0_1_0]

## Telemetry

> **NOTE:** The following statement is applicable from release v2.0.0 onwards

When you deploy one or more modules using the Azure landing zones Terraform module, Microsoft can identify the installation of said module/s with the deployed Azure resources.
Microsoft can correlate these resources used to support the software.
Microsoft collects this information to provide the best experiences with their products and to operate their business.
The telemetry is collected through customer usage attribution.
The data is collected and governed by [Microsoft's privacy policies][msft_privacy_policy].

If you don't wish to send usage data to Microsoft, details on how to turn it off can be found [here][wiki_disable_telemetry].

## License

- [MIT License][alz_license]

## Contributing

- [Contributing][wiki_contributing]
  - [Raising an Issue][wiki_raising_an_issue]
  - [Feature Requests][wiki_feature_requests]
  - [Contributing to Code][wiki_contributing_to_code]
  - [Contributing to Documentation][wiki_contributing_to_documentation]

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_tf_overview]: https://raw.githubusercontent.com/wiki/Azure/terraform-azurerm-caf-enterprise-scale/media/alz-tf-module-overview.png "A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[msft_privacy_policy]: https://www.microsoft.com/trustcenter  "Microsoft's privacy policy"

[alz_tf_registry]:  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
[alz_architecture]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture
[alz_hierarchy]:    https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[alz_management]:   https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management
[alz_connectivity]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[alz_identity]:     https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access
[alz_license]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/blob/main/LICENSE
[repo_releases]:    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/releases "Release notes"

<!--
The following link references should be copied from `_sidebar.md` in the `./docs/wiki/` folder.
Replace `./` with `https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/` when copying to here.
-->

[wiki_home]:                                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Home "Wiki - Home"
[wiki_user_guide]:                            https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/User-Guide "Wiki - User Guide"
[wiki_getting_started]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Getting-Started "Wiki - Getting Started"
[wiki_module_permissions]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Permissions "Wiki - Module Permissions"
[wiki_module_variables]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Variables "Wiki - Module Variables"
[wiki_module_releases]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Releases "Wiki - Module Releases"
[wiki_provider_configuration]:                https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Provider-Configuration "Wiki - Provider Configuration"
[wiki_archetype_definitions]:                 https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Archetype-Definitions "Wiki - Archetype Definitions"
[wiki_core_resources]:                        https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Core-Resources "Wiki - Core Resources"
[wiki_management_resources]:                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Management-Resources "Wiki - Management Resources"
[wiki_connectivity_resources]:                https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Connectivity-Resources "Wiki - Connectivity Resources"
[wiki_identity_resources]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Identity-Resources "Wiki - Identity Resources"
[wiki_upgrade_from_v0_0_8_to_v0_1_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.0.8-to-v0.1.0 "Wiki - Upgrade from v0.0.8 to v0.1.0"
[wiki_upgrade_from_v0_1_2_to_v0_2_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.1.2-to-v0.2.0 "Wiki - Upgrade from v0.1.2 to v0.2.0"
[wiki_upgrade_from_v0_3_3_to_v0_4_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.3.3-to-v0.4.0 "Wiki - Upgrade from v0.3.3 to v0.4.0"
[wiki_upgrade_from_v0_4_0_to_v1_0_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v0.4.0-to-v1.0.0 "Wiki - Upgrade from v0.4.0 to v1.0.0"
[wiki_upgrade_from_v1_1_4_to_v2_0_0]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Upgrade-from-v1.1.4-to-v2.0.0 "Wiki - Upgrade from v1.1.4 to v2.0.0"
[wiki_examples]:                              https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples "Wiki - Examples"
[wiki_examples_level_100]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-100 "Wiki - Examples"
[wiki_examples_level_200]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-200 "Wiki - Examples"
[wiki_examples_level_300]:                    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Examples#advanced-level-300 "Wiki - Examples"
[wiki_deploy_default_configuration]:          https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration "Wiki - Deploy Default Configuration"
[wiki_deploy_demo_landing_zone_archetypes]:   https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Demo-Landing-Zone-Archetypes "Wiki - Deploy Demo Landing Zone Archetypes"
[wiki_deploy_custom_landing_zone_archetypes]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes "Wiki - Deploy Custom Landing Zone Archetypes"
[wiki_deploy_management_resources]:           https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources "Wiki - Deploy Management Resources"
[wiki_deploy_management_resources_custom]:    https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Management-Resources-With-Custom-Settings "Wiki - Deploy Management Resources With Custom Settings"
[wiki_deploy_connectivity_resources]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources "Wiki - Deploy Connectivity Resources"
[wiki_deploy_connectivity_resources_custom]:  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Connectivity-Resources-With-Custom-Settings "Wiki - Deploy Connectivity Resources With Custom Settings"
[wiki_deploy_identity_resources]:             https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources "Wiki - Deploy Identity Resources"
[wiki_deploy_identity_resources_custom]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Identity-Resources-With-Custom-Settings "Wiki - Deploy Identity Resources With Custom Settings"
[wiki_deploy_using_module_nesting]:           https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Using-Module-Nesting "Wiki - Deploy Using Module Nesting"
[wiki_frequently_asked_questions]:            https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Frequently-Asked-Questions "Wiki - Frequently Asked Questions"
[wiki_troubleshooting]:                       https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Troubleshooting "Wiki - Troubleshooting"
[wiki_contributing]:                          https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing "Wiki - Contributing"
[wiki_raising_an_issue]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Raising-an-Issue "Wiki - Raising an Issue"
[wiki_feature_requests]:                      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Feature-Requests "Wiki - Feature Requests"
[wiki_contributing_to_code]:                  https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Code "Wiki - Contributing to Code"
[wiki_contributing_to_documentation]:         https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/Contributing-to-Documentation "Wiki - Contributing to Documentation"
[wiki_expand_built_in_archetype_definitions]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Expand-Built-in-Archetype-Definitions "Wiki - Expand Built-in Archetype Definitions"
[wiki_override_module_role_assignments]:      https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Override-Module-Role-Assignments "Wiki - Override Module Role Assignments"
[wiki_create_custom_policies_policy_sets_and_assignments]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Create-Custom-Policies-Policy-Sets-and-Assignments "Wiki - Create Custom Policies, Policy Sets and Assignments"
[wiki_assign_a_built_in_policy]: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Assign-a-Built-in-Policy "Wiki - Assign a Built-in Policy"
[wiki_disable_telemetry]:                     https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-disable_telemetry "Wiki - Disable telemetry"
[wiki_create_and_assign_custom_rbac_roles]:                     https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BVariables%5D-Create-and-Assign-Custom-RBAC-Roles "Wiki - Create and Assign Custom RBAC Roles"

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.2 |
| <a name="provider_azurerm.connectivity"></a> [azurerm.connectivity](#provider\_azurerm.connectivity) | >= 3.0.2 |
| <a name="provider_azurerm.management"></a> [azurerm.management](#provider\_azurerm.management) | >= 3.0.2 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_connectivity_resources"></a> [connectivity\_resources](#module\_connectivity\_resources) | ./modules/connectivity | n/a |
| <a name="module_identity_resources"></a> [identity\_resources](#module\_identity\_resources) | ./modules/identity | n/a |
| <a name="module_management_group_archetypes"></a> [management\_group\_archetypes](#module\_management\_group\_archetypes) | ./modules/archetypes | n/a |
| <a name="module_management_resources"></a> [management\_resources](#module\_management\_resources) | ./modules/management | n/a |
| <a name="module_role_assignments_for_policy"></a> [role\_assignments\_for\_policy](#module\_role\_assignments\_for\_policy) | ./modules/role_assignments_for_policy | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_dns_zone.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_express_route_gateway.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) | resource |
| [azurerm_firewall.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_log_analytics_linked_service.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurerm_log_analytics_solution.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_management_group.level_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group.level_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group.level_3](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group.level_4](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group.level_5](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group.level_6](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) | resource |
| [azurerm_management_group_policy_assignment.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_subscription_association.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_subscription_association) | resource |
| [azurerm_network_ddos_protection_plan.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_policy_definition.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_set_definition.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |
| [azurerm_private_dns_zone.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.enterprise_scale](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_subnet.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subscription_template_deployment.telemetry_connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_template_deployment) | resource |
| [azurerm_subscription_template_deployment.telemetry_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_template_deployment) | resource |
| [azurerm_subscription_template_deployment.telemetry_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_template_deployment) | resource |
| [azurerm_subscription_template_deployment.telemetry_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_template_deployment) | resource |
| [azurerm_virtual_hub.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) | resource |
| [azurerm_virtual_hub_connection.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) | resource |
| [azurerm_virtual_network.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [azurerm_virtual_network_peering.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_wan.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan) | resource |
| [azurerm_vpn_gateway.virtual_wan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) | resource |
| [local_file.output_md](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.after_azurerm_management_group](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.after_azurerm_policy_assignment](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.after_azurerm_policy_definition](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.after_azurerm_policy_set_definition](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.after_azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.after_azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_policy_definition.external_lookup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_definition) | data source |
| [azurerm_policy_set_definition.external_lookup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_set_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archetype_config_overrides"></a> [archetype\_config\_overrides](#input\_archetype\_config\_overrides) | If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups. | `any` | `{}` | no |
| <a name="input_configure_connectivity_resources"></a> [configure\_connectivity\_resources](#input\_configure\_connectivity\_resources) | If specified, will customize the "Connectivity" landing zone settings and resources. | <pre>object({<br>    settings = object({<br>      hub_networks = list(<br>        object({<br>          enabled = bool<br>          config = object({<br>            address_space                = list(string)<br>            location                     = string<br>            link_to_ddos_protection_plan = bool<br>            dns_servers                  = list(string)<br>            bgp_community                = string<br>            subnets = list(<br>              object({<br>                name                      = string<br>                address_prefixes          = list(string)<br>                network_security_group_id = string<br>                route_table_id            = string<br>              })<br>            )<br>            virtual_network_gateway = object({<br>              enabled = bool<br>              config = object({<br>                address_prefix           = string<br>                gateway_sku_expressroute = string<br>                gateway_sku_vpn          = string<br>                advanced_vpn_settings = object({<br>                  enable_bgp                       = bool<br>                  active_active                    = bool<br>                  private_ip_address_allocation    = string<br>                  default_local_network_gateway_id = string<br>                  vpn_client_configuration = list(<br>                    object({<br>                      address_space = list(string)<br>                      aad_tenant    = string<br>                      aad_audience  = string<br>                      aad_issuer    = string<br>                      root_certificate = list(<br>                        object({<br>                          name             = string<br>                          public_cert_data = string<br>                        })<br>                      )<br>                      revoked_certificate = list(<br>                        object({<br>                          name             = string<br>                          public_cert_data = string<br>                        })<br>                      )<br>                      radius_server_address = string<br>                      radius_server_secret  = string<br>                      vpn_client_protocols  = list(string)<br>                      vpn_auth_types        = list(string)<br>                    })<br>                  )<br>                  bgp_settings = list(<br>                    object({<br>                      asn         = number<br>                      peer_weight = number<br>                      peering_addresses = list(<br>                        object({<br>                          ip_configuration_name = string<br>                          apipa_addresses       = list(string)<br>                        })<br>                      )<br>                    })<br>                  )<br>                  custom_route = list(<br>                    object({<br>                      address_prefixes = list(string)<br>                    })<br>                  )<br>                })<br>              })<br>            })<br>            azure_firewall = object({<br>              enabled = bool<br>              config = object({<br>                address_prefix                = string<br>                enable_dns_proxy              = bool<br>                dns_servers                   = list(string)<br>                sku_tier                      = string<br>                base_policy_id                = string<br>                private_ip_ranges             = list(string)<br>                threat_intelligence_mode      = string<br>                threat_intelligence_allowlist = list(string)<br>                availability_zones = object({<br>                  zone_1 = bool<br>                  zone_2 = bool<br>                  zone_3 = bool<br>                })<br>              })<br>            })<br>            spoke_virtual_network_resource_ids      = list(string)<br>            enable_outbound_virtual_network_peering = bool<br>            enable_hub_network_mesh_peering         = bool<br>          })<br>        })<br>      )<br>      vwan_hub_networks = list(<br>        object({<br>          enabled = bool<br>          config = object({<br>            address_prefix = string<br>            location       = string<br>            sku            = string<br>            routes = list(<br>              object({<br>                address_prefixes    = list(string)<br>                next_hop_ip_address = string<br>              })<br>            )<br>            expressroute_gateway = object({<br>              enabled = bool<br>              config = object({<br>                scale_unit = number<br>              })<br>            })<br>            vpn_gateway = object({<br>              enabled = bool<br>              config = object({<br>                bgp_settings = list(<br>                  object({<br>                    asn         = number<br>                    peer_weight = number<br>                    instance_0_bgp_peering_address = list(<br>                      object({<br>                        custom_ips = list(string)<br>                      })<br>                    )<br>                    instance_1_bgp_peering_address = list(<br>                      object({<br>                        custom_ips = list(string)<br>                      })<br>                    )<br>                  })<br>                )<br>                routing_preference = string<br>                scale_unit         = number<br>              })<br>            })<br>            azure_firewall = object({<br>              enabled = bool<br>              config = object({<br>                enable_dns_proxy              = bool<br>                dns_servers                   = list(string)<br>                sku_tier                      = string<br>                base_policy_id                = string<br>                private_ip_ranges             = list(string)<br>                threat_intelligence_mode      = string<br>                threat_intelligence_allowlist = list(string)<br>                availability_zones = object({<br>                  zone_1 = bool<br>                  zone_2 = bool<br>                  zone_3 = bool<br>                })<br>              })<br>            })<br>            spoke_virtual_network_resource_ids = list(string)<br>            enable_virtual_hub_connections     = bool<br>          })<br>        })<br>      )<br>      ddos_protection_plan = object({<br>        enabled = bool<br>        config = object({<br>          location = string<br>        })<br>      })<br>      dns = object({<br>        enabled = bool<br>        config = object({<br>          location = string<br>          enable_private_link_by_service = object({<br>            azure_automation_webhook             = bool<br>            azure_automation_dscandhybridworker  = bool<br>            azure_sql_database_sqlserver         = bool<br>            azure_synapse_analytics_sqlserver    = bool<br>            azure_synapse_analytics_sql          = bool<br>            storage_account_blob                 = bool<br>            storage_account_table                = bool<br>            storage_account_queue                = bool<br>            storage_account_file                 = bool<br>            storage_account_web                  = bool<br>            azure_data_lake_file_system_gen2     = bool<br>            azure_cosmos_db_sql                  = bool<br>            azure_cosmos_db_mongodb              = bool<br>            azure_cosmos_db_cassandra            = bool<br>            azure_cosmos_db_gremlin              = bool<br>            azure_cosmos_db_table                = bool<br>            azure_database_for_postgresql_server = bool<br>            azure_database_for_mysql_server      = bool<br>            azure_database_for_mariadb_server    = bool<br>            azure_key_vault                      = bool<br>            azure_kubernetes_service_management  = bool<br>            azure_search_service                 = bool<br>            azure_container_registry             = bool<br>            azure_app_configuration_stores       = bool<br>            azure_backup                         = bool<br>            azure_site_recovery                  = bool<br>            azure_event_hubs_namespace           = bool<br>            azure_service_bus_namespace          = bool<br>            azure_iot_hub                        = bool<br>            azure_relay_namespace                = bool<br>            azure_event_grid_topic               = bool<br>            azure_event_grid_domain              = bool<br>            azure_web_apps_sites                 = bool<br>            azure_machine_learning_workspace     = bool<br>            signalr                              = bool<br>            azure_monitor                        = bool<br>            cognitive_services_account           = bool<br>            azure_file_sync                      = bool<br>            azure_data_factory                   = bool<br>            azure_data_factory_portal            = bool<br>            azure_cache_for_redis                = bool<br>          })<br>          private_link_locations                                 = list(string)<br>          public_dns_zones                                       = list(string)<br>          private_dns_zones                                      = list(string)<br>          enable_private_dns_zone_virtual_network_link_on_hubs   = bool<br>          enable_private_dns_zone_virtual_network_link_on_spokes = bool<br>        })<br>      })<br>    })<br>    location = any<br>    tags     = any<br>    advanced = any<br>  })</pre> | <pre>{<br>  "advanced": null,<br>  "location": null,<br>  "settings": {<br>    "ddos_protection_plan": {<br>      "config": {<br>        "location": ""<br>      },<br>      "enabled": false<br>    },<br>    "dns": {<br>      "config": {<br>        "enable_private_dns_zone_virtual_network_link_on_hubs": true,<br>        "enable_private_dns_zone_virtual_network_link_on_spokes": true,<br>        "enable_private_link_by_service": {<br>          "azure_app_configuration_stores": true,<br>          "azure_automation_dscandhybridworker": true,<br>          "azure_automation_webhook": true,<br>          "azure_backup": true,<br>          "azure_cache_for_redis": true,<br>          "azure_container_registry": true,<br>          "azure_cosmos_db_cassandra": true,<br>          "azure_cosmos_db_gremlin": true,<br>          "azure_cosmos_db_mongodb": true,<br>          "azure_cosmos_db_sql": true,<br>          "azure_cosmos_db_table": true,<br>          "azure_data_factory": true,<br>          "azure_data_factory_portal": true,<br>          "azure_data_lake_file_system_gen2": true,<br>          "azure_database_for_mariadb_server": true,<br>          "azure_database_for_mysql_server": true,<br>          "azure_database_for_postgresql_server": true,<br>          "azure_event_grid_domain": true,<br>          "azure_event_grid_topic": true,<br>          "azure_event_hubs_namespace": true,<br>          "azure_file_sync": true,<br>          "azure_iot_hub": true,<br>          "azure_key_vault": true,<br>          "azure_kubernetes_service_management": true,<br>          "azure_machine_learning_workspace": true,<br>          "azure_monitor": true,<br>          "azure_relay_namespace": true,<br>          "azure_search_service": true,<br>          "azure_service_bus_namespace": true,<br>          "azure_site_recovery": true,<br>          "azure_sql_database_sqlserver": true,<br>          "azure_synapse_analytics_sql": true,<br>          "azure_synapse_analytics_sqlserver": true,<br>          "azure_web_apps_sites": true,<br>          "cognitive_services_account": true,<br>          "signalr": true,<br>          "storage_account_blob": true,<br>          "storage_account_file": true,<br>          "storage_account_queue": true,<br>          "storage_account_table": true,<br>          "storage_account_web": true<br>        },<br>        "location": "",<br>        "private_dns_zones": [],<br>        "private_link_locations": [],<br>        "public_dns_zones": []<br>      },<br>      "enabled": true<br>    },<br>    "hub_networks": [<br>      {<br>        "config": {<br>          "address_space": [<br>            "10.100.0.0/16"<br>          ],<br>          "azure_firewall": {<br>            "config": {<br>              "address_prefix": "10.100.0.0/24",<br>              "availability_zones": {<br>                "zone_1": true,<br>                "zone_2": true,<br>                "zone_3": true<br>              },<br>              "base_policy_id": "",<br>              "dns_servers": [],<br>              "enable_dns_proxy": true,<br>              "private_ip_ranges": [],<br>              "sku_tier": "",<br>              "threat_intelligence_allowlist": [],<br>              "threat_intelligence_mode": ""<br>            },<br>            "enabled": false<br>          },<br>          "bgp_community": "",<br>          "dns_servers": [],<br>          "enable_hub_network_mesh_peering": false,<br>          "enable_outbound_virtual_network_peering": false,<br>          "link_to_ddos_protection_plan": false,<br>          "location": "",<br>          "spoke_virtual_network_resource_ids": [],<br>          "subnets": [],<br>          "virtual_network_gateway": {<br>            "config": {<br>              "address_prefix": "10.100.1.0/24",<br>              "advanced_vpn_settings": {<br>                "active_active": null,<br>                "bgp_settings": [],<br>                "custom_route": [],<br>                "default_local_network_gateway_id": "",<br>                "enable_bgp": null,<br>                "private_ip_address_allocation": "",<br>                "vpn_client_configuration": []<br>              },<br>              "gateway_sku_expressroute": "ErGw2AZ",<br>              "gateway_sku_vpn": "VpnGw3"<br>            },<br>            "enabled": false<br>          }<br>        },<br>        "enabled": true<br>      }<br>    ],<br>    "vwan_hub_networks": [<br>      {<br>        "config": {<br>          "address_prefix": "10.200.0.0/22",<br>          "azure_firewall": {<br>            "config": {<br>              "availability_zones": {<br>                "zone_1": true,<br>                "zone_2": true,<br>                "zone_3": true<br>              },<br>              "base_policy_id": "",<br>              "dns_servers": [],<br>              "enable_dns_proxy": false,<br>              "private_ip_ranges": [],<br>              "sku_tier": "Standard",<br>              "threat_intelligence_allowlist": [],<br>              "threat_intelligence_mode": ""<br>            },<br>            "enabled": false<br>          },<br>          "enable_virtual_hub_connections": false,<br>          "expressroute_gateway": {<br>            "config": {<br>              "scale_unit": 1<br>            },<br>            "enabled": false<br>          },<br>          "location": "",<br>          "routes": [],<br>          "sku": "",<br>          "spoke_virtual_network_resource_ids": [],<br>          "vpn_gateway": {<br>            "config": {<br>              "bgp_settings": [],<br>              "routing_preference": "",<br>              "scale_unit": 1<br>            },<br>            "enabled": false<br>          }<br>        },<br>        "enabled": false<br>      }<br>    ]<br>  },<br>  "tags": null<br>}</pre> | no |
| <a name="input_configure_identity_resources"></a> [configure\_identity\_resources](#input\_configure\_identity\_resources) | If specified, will customize the "Identity" landing zone settings. | <pre>object({<br>    settings = object({<br>      identity = object({<br>        enabled = bool<br>        config = object({<br>          enable_deny_public_ip             = bool<br>          enable_deny_rdp_from_internet     = bool<br>          enable_deny_subnet_without_nsg    = bool<br>          enable_deploy_azure_backup_on_vms = bool<br>        })<br>      })<br>    })<br>  })</pre> | <pre>{<br>  "settings": {<br>    "identity": {<br>      "config": {<br>        "enable_deny_public_ip": true,<br>        "enable_deny_rdp_from_internet": true,<br>        "enable_deny_subnet_without_nsg": true,<br>        "enable_deploy_azure_backup_on_vms": true<br>      },<br>      "enabled": true<br>    }<br>  }<br>}</pre> | no |
| <a name="input_configure_management_resources"></a> [configure\_management\_resources](#input\_configure\_management\_resources) | If specified, will customize the "Management" landing zone settings and resources. | <pre>object({<br>    settings = object({<br>      log_analytics = object({<br>        enabled = bool<br>        config = object({<br>          retention_in_days                                 = number<br>          enable_monitoring_for_arc                         = bool<br>          enable_monitoring_for_vm                          = bool<br>          enable_monitoring_for_vmss                        = bool<br>          enable_solution_for_agent_health_assessment       = bool<br>          enable_solution_for_anti_malware                  = bool<br>          enable_solution_for_azure_activity                = bool<br>          enable_solution_for_change_tracking               = bool<br>          enable_solution_for_service_map                   = bool<br>          enable_solution_for_sql_assessment                = bool<br>          enable_solution_for_sql_vulnerability_assessment  = bool<br>          enable_solution_for_sql_advanced_threat_detection = bool<br>          enable_solution_for_updates                       = bool<br>          enable_solution_for_vm_insights                   = bool<br>          enable_sentinel                                   = bool<br>        })<br>      })<br>      security_center = object({<br>        enabled = bool<br>        config = object({<br>          email_security_contact             = string<br>          enable_defender_for_app_services   = bool<br>          enable_defender_for_arm            = bool<br>          enable_defender_for_containers     = bool<br>          enable_defender_for_dns            = bool<br>          enable_defender_for_key_vault      = bool<br>          enable_defender_for_oss_databases  = bool<br>          enable_defender_for_servers        = bool<br>          enable_defender_for_sql_servers    = bool<br>          enable_defender_for_sql_server_vms = bool<br>          enable_defender_for_storage        = bool<br>        })<br>      })<br>    })<br>    location = any<br>    tags     = any<br>    advanced = any<br>  })</pre> | <pre>{<br>  "advanced": null,<br>  "location": null,<br>  "settings": {<br>    "log_analytics": {<br>      "config": {<br>        "enable_monitoring_for_arc": true,<br>        "enable_monitoring_for_vm": true,<br>        "enable_monitoring_for_vmss": true,<br>        "enable_sentinel": true,<br>        "enable_solution_for_agent_health_assessment": true,<br>        "enable_solution_for_anti_malware": true,<br>        "enable_solution_for_azure_activity": true,<br>        "enable_solution_for_change_tracking": true,<br>        "enable_solution_for_service_map": true,<br>        "enable_solution_for_sql_advanced_threat_detection": true,<br>        "enable_solution_for_sql_assessment": true,<br>        "enable_solution_for_sql_vulnerability_assessment": true,<br>        "enable_solution_for_updates": true,<br>        "enable_solution_for_vm_insights": true,<br>        "retention_in_days": 30<br>      },<br>      "enabled": true<br>    },<br>    "security_center": {<br>      "config": {<br>        "email_security_contact": "security_contact@replace_me",<br>        "enable_defender_for_app_services": true,<br>        "enable_defender_for_arm": true,<br>        "enable_defender_for_containers": true,<br>        "enable_defender_for_dns": true,<br>        "enable_defender_for_key_vault": true,<br>        "enable_defender_for_oss_databases": true,<br>        "enable_defender_for_servers": true,<br>        "enable_defender_for_sql_server_vms": true,<br>        "enable_defender_for_sql_servers": true,<br>        "enable_defender_for_storage": true<br>      },<br>      "enabled": true<br>    }<br>  },<br>  "tags": null<br>}</pre> | no |
| <a name="input_create_duration_delay"></a> [create\_duration\_delay](#input\_create\_duration\_delay) | Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type. | `map(string)` | <pre>{<br>  "azurerm_management_group": "30s",<br>  "azurerm_policy_assignment": "30s",<br>  "azurerm_policy_definition": "30s",<br>  "azurerm_policy_set_definition": "30s",<br>  "azurerm_role_assignment": "0s",<br>  "azurerm_role_definition": "60s"<br>}</pre> | no |
| <a name="input_custom_landing_zones"></a> [custom\_landing\_zones](#input\_custom\_landing\_zones) | If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups. | `any` | `{}` | no |
| <a name="input_custom_policy_roles"></a> [custom\_policy\_roles](#input\_custom\_policy\_roles) | If specified, the custom\_policy\_roles variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned "policyDefinitionId" (key) is included in this variable. | `map(list(string))` | `{}` | no |
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/ | `string` | `"eastus"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | If specified, will set the default tags for all resources deployed by this module where supported. | `map(string)` | `{}` | no |
| <a name="input_deploy_connectivity_resources"></a> [deploy\_connectivity\_resources](#input\_deploy\_connectivity\_resources) | If set to true, will enable the "Connectivity" landing zone settings and add "Connectivity" resources into the current Subscription context. | `bool` | `false` | no |
| <a name="input_deploy_core_landing_zones"></a> [deploy\_core\_landing\_zones](#input\_deploy\_core\_landing\_zones) | If set to true, module will deploy the core Enterprise-scale Management Group hierarchy, including "out of the box" policies and roles. | `bool` | `true` | no |
| <a name="input_deploy_corp_landing_zones"></a> [deploy\_corp\_landing\_zones](#input\_deploy\_corp\_landing\_zones) | If set to true, module will deploy the "Corp" Management Group, including "out of the box" policies and roles. | `bool` | `false` | no |
| <a name="input_deploy_demo_landing_zones"></a> [deploy\_demo\_landing\_zones](#input\_deploy\_demo\_landing\_zones) | If set to true, module will deploy the demo "Landing Zone" Management Groups ("Corp", "Online", and "SAP") into the core Enterprise-scale Management Group hierarchy. | `bool` | `false` | no |
| <a name="input_deploy_identity_resources"></a> [deploy\_identity\_resources](#input\_deploy\_identity\_resources) | If set to true, will enable the "Identity" landing zone settings. | `bool` | `false` | no |
| <a name="input_deploy_management_resources"></a> [deploy\_management\_resources](#input\_deploy\_management\_resources) | If set to true, will enable the "Management" landing zone settings and add "Management" resources into the current Subscription context. | `bool` | `false` | no |
| <a name="input_deploy_online_landing_zones"></a> [deploy\_online\_landing\_zones](#input\_deploy\_online\_landing\_zones) | If set to true, module will deploy the "Online" Management Group, including "out of the box" policies and roles. | `bool` | `false` | no |
| <a name="input_deploy_sap_landing_zones"></a> [deploy\_sap\_landing\_zones](#input\_deploy\_sap\_landing\_zones) | If set to true, module will deploy the "SAP" Management Group, including "out of the box" policies and roles. | `bool` | `false` | no |
| <a name="input_destroy_duration_delay"></a> [destroy\_duration\_delay](#input\_destroy\_duration\_delay) | Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type. | `map(string)` | <pre>{<br>  "azurerm_management_group": "0s",<br>  "azurerm_policy_assignment": "0s",<br>  "azurerm_policy_definition": "0s",<br>  "azurerm_policy_set_definition": "0s",<br>  "azurerm_role_assignment": "0s",<br>  "azurerm_role_definition": "0s"<br>}</pre> | no |
| <a name="input_disable_base_module_tags"></a> [disable\_base\_module\_tags](#input\_disable\_base\_module\_tags) | If set to true, will remove the base module tags applied to all resources deployed by the module which support tags. | `bool` | `false` | no |
| <a name="input_disable_telemetry"></a> [disable\_telemetry](#input\_disable\_telemetry) | If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry. | `bool` | `false` | no |
| <a name="input_library_path"></a> [library\_path](#input\_library\_path) | If specified, sets the path to a custom library folder for archetype artefacts. | `string` | `""` | no |
| <a name="input_output_md_file"></a> [output\_md\_file](#input\_output\_md\_file) | location of the file where this cloud foundation kit module generates its documentation output | `string` | n/a | yes |
| <a name="input_root_id"></a> [root\_id](#input\_root\_id) | If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups. | `string` | `"es"` | no |
| <a name="input_root_name"></a> [root\_name](#input\_root\_name) | If specified, will set a custom Display Name value for the Enterprise-scale "root" Management Group. | `string` | `"Enterprise-Scale"` | no |
| <a name="input_root_parent_id"></a> [root\_parent\_id](#input\_root\_parent\_id) | The root\_parent\_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones. | `string` | n/a | yes |
| <a name="input_strict_subscription_association"></a> [strict\_subscription\_association](#input\_strict\_subscription\_association) | If set to true, subscriptions associated to management groups will be exclusively set by the module and any added by another process will be removed. If set to false, the module will will only enforce association of the specified subscriptions and those added to management groups by other processes will not be removed. | `bool` | `true` | no |
| <a name="input_subscription_id_connectivity"></a> [subscription\_id\_connectivity](#input\_subscription\_id\_connectivity) | If specified, identifies the Platform subscription for "Connectivity" for resource deployment and correct placement in the Management Group hierarchy. | `string` | `""` | no |
| <a name="input_subscription_id_identity"></a> [subscription\_id\_identity](#input\_subscription\_id\_identity) | If specified, identifies the Platform subscription for "Identity" for resource deployment and correct placement in the Management Group hierarchy. | `string` | `""` | no |
| <a name="input_subscription_id_management"></a> [subscription\_id\_management](#input\_subscription\_id\_management) | If specified, identifies the Platform subscription for "Management" for resource deployment and correct placement in the Management Group hierarchy. | `string` | `""` | no |
| <a name="input_subscription_id_overrides"></a> [subscription\_id\_overrides](#input\_subscription\_id\_overrides) | If specified, will be used to assign subscription\_ids to the default Enterprise-scale Management Groups. | `map(list(string))` | `{}` | no |
| <a name="input_template_file_variables"></a> [template\_file\_variables](#input\_template\_file\_variables) | If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library\_path. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_automation_account"></a> [azurerm\_automation\_account](#output\_azurerm\_automation\_account) | Returns the configuration data for all Automation Accounts created by this module. |
| <a name="output_azurerm_dns_zone"></a> [azurerm\_dns\_zone](#output\_azurerm\_dns\_zone) | Returns the configuration data for all DNS Zones created by this module. |
| <a name="output_azurerm_express_route_gateway"></a> [azurerm\_express\_route\_gateway](#output\_azurerm\_express\_route\_gateway) | Returns the configuration data for all (Virtual WAN) ExpressRoute Gateways created by this module. |
| <a name="output_azurerm_firewall"></a> [azurerm\_firewall](#output\_azurerm\_firewall) | Returns the configuration data for all Azure Firewalls created by this module. |
| <a name="output_azurerm_firewall_policy"></a> [azurerm\_firewall\_policy](#output\_azurerm\_firewall\_policy) | Returns the configuration data for all Azure Firewall Policies created by this module. |
| <a name="output_azurerm_log_analytics_linked_service"></a> [azurerm\_log\_analytics\_linked\_service](#output\_azurerm\_log\_analytics\_linked\_service) | Returns the configuration data for all Log Analytics linked services created by this module. |
| <a name="output_azurerm_log_analytics_solution"></a> [azurerm\_log\_analytics\_solution](#output\_azurerm\_log\_analytics\_solution) | Returns the configuration data for all Log Analytics solutions created by this module. |
| <a name="output_azurerm_log_analytics_workspace"></a> [azurerm\_log\_analytics\_workspace](#output\_azurerm\_log\_analytics\_workspace) | Returns the configuration data for all Log Analytics workspaces created by this module. Excludes sensitive values. |
| <a name="output_azurerm_management_group"></a> [azurerm\_management\_group](#output\_azurerm\_management\_group) | Returns the configuration data for all Management Groups created by this module. |
| <a name="output_azurerm_management_group_policy_assignment"></a> [azurerm\_management\_group\_policy\_assignment](#output\_azurerm\_management\_group\_policy\_assignment) | Returns the configuration data for all Management Group Policy Assignments created by this module. |
| <a name="output_azurerm_management_group_subscription_association"></a> [azurerm\_management\_group\_subscription\_association](#output\_azurerm\_management\_group\_subscription\_association) | Returns the configuration data for all Management Group Subscription Associations created by this module. |
| <a name="output_azurerm_network_ddos_protection_plan"></a> [azurerm\_network\_ddos\_protection\_plan](#output\_azurerm\_network\_ddos\_protection\_plan) | Returns the configuration data for all DDoS Protection Plans created by this module. |
| <a name="output_azurerm_policy_definition"></a> [azurerm\_policy\_definition](#output\_azurerm\_policy\_definition) | Returns the configuration data for all Policy Definitions created by this module. |
| <a name="output_azurerm_policy_set_definition"></a> [azurerm\_policy\_set\_definition](#output\_azurerm\_policy\_set\_definition) | Returns the configuration data for all Policy Set Definitions created by this module. |
| <a name="output_azurerm_private_dns_zone"></a> [azurerm\_private\_dns\_zone](#output\_azurerm\_private\_dns\_zone) | Returns the configuration data for all Private DNS Zones created by this module. |
| <a name="output_azurerm_private_dns_zone_virtual_network_link"></a> [azurerm\_private\_dns\_zone\_virtual\_network\_link](#output\_azurerm\_private\_dns\_zone\_virtual\_network\_link) | Returns the configuration data for all Private DNS Zone network links created by this module. |
| <a name="output_azurerm_public_ip"></a> [azurerm\_public\_ip](#output\_azurerm\_public\_ip) | Returns the configuration data for all Public IPs created by this module. |
| <a name="output_azurerm_resource_group"></a> [azurerm\_resource\_group](#output\_azurerm\_resource\_group) | Returns the configuration data for all Resource Groups created by this module. |
| <a name="output_azurerm_role_assignment"></a> [azurerm\_role\_assignment](#output\_azurerm\_role\_assignment) | Returns the configuration data for all Role Assignments created by this module. |
| <a name="output_azurerm_role_definition"></a> [azurerm\_role\_definition](#output\_azurerm\_role\_definition) | Returns the configuration data for all Role Definitions created by this module. |
| <a name="output_azurerm_subnet"></a> [azurerm\_subnet](#output\_azurerm\_subnet) | Returns the configuration data for all Subnets created by this module. |
| <a name="output_azurerm_virtual_hub"></a> [azurerm\_virtual\_hub](#output\_azurerm\_virtual\_hub) | Returns the configuration data for all Virtual Hubs created by this module. |
| <a name="output_azurerm_virtual_hub_connection"></a> [azurerm\_virtual\_hub\_connection](#output\_azurerm\_virtual\_hub\_connection) | Returns the configuration data for all Virtual Hub Connections created by this module. |
| <a name="output_azurerm_virtual_network"></a> [azurerm\_virtual\_network](#output\_azurerm\_virtual\_network) | Returns the configuration data for all Virtual Networks created by this module. |
| <a name="output_azurerm_virtual_network_gateway"></a> [azurerm\_virtual\_network\_gateway](#output\_azurerm\_virtual\_network\_gateway) | Returns the configuration data for all Virtual Network Gateways created by this module. |
| <a name="output_azurerm_virtual_network_peering"></a> [azurerm\_virtual\_network\_peering](#output\_azurerm\_virtual\_network\_peering) | Returns the configuration data for all Virtual Network Peerings created by this module. |
| <a name="output_azurerm_virtual_wan"></a> [azurerm\_virtual\_wan](#output\_azurerm\_virtual\_wan) | Returns the configuration data for all Virtual WANs created by this module. |
| <a name="output_azurerm_vpn_gateway"></a> [azurerm\_vpn\_gateway](#output\_azurerm\_vpn\_gateway) | Returns the configuration data for all (Virtual WAN) VPN Gateways created by this module. |
<!-- END_TF_DOCS -->
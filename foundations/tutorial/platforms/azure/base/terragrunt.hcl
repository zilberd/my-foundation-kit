include "platform" {
    path = find_in_parent_folders("platform.hcl")
    expose = true
  }

include "module" {
    path = find_in_parent_folders("module.hcl")
  }

terraform {
    source = "${get_repo_root()}//kit/tutorialbundle/base"
  }

inputs = {
    
  root_parent_id = "${include.platform.locals.platform.azure.aadTenantId}"
  root_id        = "root-dzil"
  root_name      = "root-dzil"
  default_location = "westeurope"
  deploy_corp_landing_zones = true
  deploy_online_landing_zones = true
  # Management resources
  deploy_management_resources = true
  subscription_id_management  = "${include.platform.locals.platform.azure.subscriptionId}" # Subscription created manually as a prerequisite

  }
include "platform" {
    path = find_in_parent_folders("platform.hcl")
    expose = true
  }

# todo: this is a bootstrap module, you typically want to set up a provider
  # with user credentials (cloud CLI based authentication) here
  generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
  skip_provider_registration = false
  tenant_id                  = "${include.platform.locals.platform.azure.aadTenantId}"
  subscription_id            = "${include.platform.locals.platform.azure.subscriptionId}"
  storage_use_azuread        = true
}
provider "azuread" {
  tenant_id = "${include.platform.locals.platform.azure.aadTenantId}"
}
EOF
}

terraform {
    source = "${get_repo_root()}//kit/tutorialbundle/bootstrap"
  }

inputs = {
    root_parent_id = "${include.platform.locals.platform.azure.aadTenantId}"
    foundation_name = "tutorial"
    platform_engineers_members = [
      "local_admin@helsana4dzil4test.onmicrosoft.com",
    ]
    storage_account_name = "hel4dzil4mdsn4poc4tf4sa"
    storage_rg_name = "core_admin_rg"
    tfstate_location     = "westeurope"

  }
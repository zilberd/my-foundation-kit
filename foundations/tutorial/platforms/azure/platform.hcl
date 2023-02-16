locals {
    platform = yamldecode(regex("^---([\\s\\S]*)\\n---\\n[\\s\\S]*$", file(".//README.md"))[0])
}




  # recommended: enable documentation generation for kit modules
  inputs = {
    output_md_file = "${get_path_to_repo_root()}/../output.md"
  }
  
# recommended: remote state configuration
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "azurerm" {
    tenant_id            = "${local.platform.azure.aadTenantId}"
    subscription_id      = "${local.platform.azure.subscriptionId}"
    resource_group_name  = "core_admin_rg"
    storage_account_name = "hel4dzil4mdsn4poc4tf4sa"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}.tfstate"
  }
}
EOF
}

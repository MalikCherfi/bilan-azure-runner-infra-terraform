locals {
  tags = merge(
    {
      managed_by  = "terraform"
      environment = "bilan-tp"
      owner       = var.owner
    },
    var.tags
  )
}


data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "keyvaul" {
  name = "Key Vault Certificates Officer"
}


module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = local.tags
}

module "runner_vm" {
  source = "./modules/runner-vm"

  resource_group_name = var.resource_group_name
  location            = var.location
  interface_id        = module.network.interface_id
  key_vault_id        = module.keyvault.key_vault_id
  tags                = local.tags
}


resource "azurerm_key_vault" "runner" {
  name                       = "githubactionskeyvaultmc"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "list",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

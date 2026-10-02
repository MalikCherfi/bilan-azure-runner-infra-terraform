resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "private_ssh" {
  name         = "private-ssh"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = var.key_vault_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "pipeline-runner"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "runner-admin"
  disable_password_authentication = true
  tags                            = var.tags
  network_interface_ids = [
    var.interface_id,
  ]

  boot_diagnostics {
  }

  admin_ssh_key {
    username   = "runner-admin"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "contributor" {
  scope                            = data.azurerm_resource_group.rg.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "keyvault" {
  scope                            = var.key_vault_id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  skip_service_principal_aad_check = true
}

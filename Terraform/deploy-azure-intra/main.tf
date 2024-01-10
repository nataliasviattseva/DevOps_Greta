terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.86.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Get-AzSubscription
  subscription_id = "5cd9efd0-43cb-412c-9353-32fae676a3b1"
  tenant_id       = "6cba93b2-a894-4062-bed3-530b4e4685bd"

  # Get-AzADServicePrincipal -DisplayNameBeginsWith "srvAzTerraform"
  # $sp.AppId
  client_id       = "7c1b90c1-cfce-4070-aaf1-157b8cd31e8a"

  # $sp.PasswordCredentials.SecretText
  client_secret   = "5gY8Q~rP0pWRLPAoTgWtojVl-kHwO~qm1jH2Oal4"
}

## Déploiement d’un groupe de ressources nommé TerraformRg situé en France Central
resource "azurerm_resource_group" "rg" {
  name     = "NSTerraformRg"
  location = "france central"
}

## Déploiement d’un réseau virtuel nommé vNet en 10.0.0.0/1
resource "azurerm_virtual_network" "vnet1" {
  name                = "vNet1"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


## Déploiement d’une interface réseau nommée tf-vmwin-nic et qui récupérera une adresse IP de façon dynamique
resource "azurerm_network_interface" "int_vnet1" {
  name                = "tf-vmwin-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vNet2"
  address_space       = ["10.0.2.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet3" {
  name                = "vNet3"
  address_space       = ["10.0.3.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                         = "vnet1-to-vnet2"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                         = "vnet2-to-vnet1"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet3" {
  name                         = "vnet2-to-vnet3"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet3_to_vnet2" {
  name                         = "vnet3_to_vnet2"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet3.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet3.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet1_to_vnet3" {
  name                         = "vnet1-to-vnet3"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet3_to_vnet1" {
  name                         = "vnet3-to-vnet1"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet3.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet3.id
  allow_virtual_network_access = true
}


## Configuration de la machine virtuelle Azure avec un utilisateur administrateur nommé adminuser, son mot de passe, son disque dur, son OS Windows Server 2022
resource "azurerm_windows_virtual_machine" "vnet2" {
  name                 = "tf-vmwin2"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  size                 = "Standard_F2"
  admin_username       = "nscloud"
  admin_password       = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.int_vnet1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "vnet3" {
  name                 = "tf-vmwin3"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  size                 = "Standard_F2"
  admin_username       = "nscloud"
  admin_password       = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.int_vnet1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

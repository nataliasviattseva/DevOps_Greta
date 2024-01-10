terraform {
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = "3.86.0"
}
}
}
provider "azurerm" {
features {}
# Get-AzSubscription
subscription_id = ""
tenant_id = ""
# Get-AzADServicePrincipal -DisplayNameBeginsWith "srvAzTerraform"
# $sp.AppId
client_id = ""
# $sp.PasswordCredentials.SecretText
client_secret = "9-38Q~cY_n.QYFovu8pk5TEWH5MnKlW~IT9c5aeh"
}
## Déploiement d’un groupe de ressources nommé TerraformRg situé en France Central
resource "azurerm_resource_group" "rg" {
name = "TerraformRg"
location = "france central"
}
## Déploiement d’un groupe de haute disponibilité pour la machine virtuelle
resource "azurerm_availability_set" "DemoAset" {
name = "tf-aset"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}
## Déploiement d’un réseau virtuel nommé tf-vNet en 10.0.0.0/1
resource "azurerm_virtual_network" "vnet" {
name = "tf-vNet"
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}
## Déploiement d’un sous-réseau en 10.0.2.0/24 pour la machine virtuelle
resource "azurerm_subnet" "subnet" {
name = "Internal"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.2.0/24"]
}
## Déploiement d’une interface réseau nommée tf-vmwin-nic et qui récupérera une adresse IP de façon dynamique
resource "azurerm_network_interface" "example" {
name = "tf-vmwin-nic"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
}
}
## Configuration de la machine virtuelle Azure avec un utilisateur administrateur nommé adminuser, son mot de passe, son disque dur , son OS Windows Server 2022
resource "azurerm_windows_virtual_machine" "example" {
name = "tf-vmwin"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
size = "Standard_F2"
admin_username = "nscloud"
admin_password = "P@$$w0rd1234!"
availability_set_id = azurerm_availability_set.DemoAset.id
network_interface_ids = [
azurerm_network_interface.example.id,
]
os_disk {
caching = "ReadWrite"
storage_account_type = "Standard_LRS"
}
source_image_reference {
publisher = "MicrosoftWindowsServer"
offer = "WindowsServer"
sku = "2022-Datacenter"
version = "latest"
}
}

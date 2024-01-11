#!/bin/bash

# Mise à jour des paquets
sudo apt-get update
sudo apt-get upgrade -y

# Installation des dépendances
sudo apt-get install -y software-properties-common curl unzip

# Installation de Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Installation de Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Installation de Vagrant
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant

# --- Ansible ---
# Installer des collections Ansible pour les providers spécifiés
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install community.aws
ansible-galaxy collection install google.cloud
ansible-galaxy collection install community.vmware
ansible-galaxy collection install community.general  # Pour Proxmox, KVM, etc.

# --- Vagrant ---
# Installer des plugins Vagrant pour les providers spécifiés
vagrant plugin install vagrant-vmware-desktop


# --- Terraform ---
# Initialiser un répertoire Terraform pour les providers spécifiés
mkdir temp_terraform_dir
cd temp_terraform_dir

# Créer un fichier Terraform pour les providers
cat <<EOT > main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    aws = {
      source  = "hashicorp/aws"
    }
    google = {
      source  = "hashicorp/google"
    }
    vmware = {
      source  = "hashicorp/vsphere"
    }
    # Vous pouvez ajouter d'autres providers ici
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  # Configuration AWS
}

provider "google" {
  # Configuration GCP
}

provider "vsphere" {
  # Configuration VMware vSphere
}

# Vous pouvez ajouter des modules ou d'autres configurations ici

EOT

# Initialiser Terraform pour télécharger les providers
terraform init

# Nettoyer le répertoire temporaire
cd ..
rm -rf temp_terraform_dir

echo "Configuration terminée pour Terraform, Ansible et Vagrant avec les providers spécifiés."

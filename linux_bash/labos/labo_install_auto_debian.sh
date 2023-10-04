#!/bin/bash

# Préparer une installation automatique de Debian via preseed.cfg
# 1 – Télécharger Debian net-install
# 2 – Télécharger le logiciel xorriso pour modifier l’image ISO
# sudo apt -y install xorriso
# 3 – Télécharger un fichier preseed.cfg d’exemple sur le site de Debian
# sudo apt install curl
# curl -#L https://www.debian.org/releases/stable/example-preseed.txt -o preseed.cfg
# 4 – Modifier le fichier preseed

# Ce fichier devra paramétrer le langue et le clavier en français
# La configuration réseau sera en DHCP
# Le nom de la machine sera votre prénom
# Le domaine sera devops.lan
# Vous devrez indiquer les sites miroir
# Le mot de passe de root sera Admindevops8 sans chiffrement
# Le compte user sera votre prénom et le mot de passe Pa$$word sans chiffrement
# La time zone sera Paris
# Le partitionnement du disque sera automatique
# Les applications à installer seront les standards + gnome
# Les packages supplémentaires seront :
# openssh-server
# build-essential
# sudo
# curl
# git
# python3-pip
# unzip
# unattended-upgrades
# apt-listchanges
# cockpit
# nmap
# tree
# On ne souhaite pas participer au programme popularity-contest
# On installe grub
# On souhaite le reboot automatique

# Exemple pré-configuration file (for bullseye)

# ##Localization
# #Configurer la langue et le pays
# d-i debian-installer/fallbacklocale select fr_FR.UTF-8
# d-i debian-installer/locale select fr_FR.UTF-8
# #Choix du clavier
# d-i console-keymaps-at/keymap select fr-latin9
# d-i debian-installer/keymap string fr-latin9
# d-i keyboard-configuration/toggle select No toggling
# ##Network configuration
# d-i netcfg/choose_interface select auto
# d-i netcfg/get_hostname string debops
# d-i netcfg/get_domain string devops.lan
# d-i netcfg/hostname string debops
# #On désactive le dialogue de la configuration WEP
# d-i netcfg/wireless_wep string
# ##Mirror settings
# d-i mirror/protocol string ftp
# d-i mirror/country string manual
# d-i mirror/http/hostname string ftp.fr.debian.org
# d-i mirror/http/directory string /debian
# d-i mirror/http/proxy string
# ##Account setup password in clear text
# #Root
# d-i passwd/root-password password Pa$$word
# d-i passwd/root-password-again password Pa$$word
# #user account
# d-i passwd/user-fullname string pierre
# d-i passwd/username string pierre
# d-i passwd/user-password password Pa$$word
# d-i passwd/user-password-again password Pa$$word
# ##Clock and time zone setup
# d-i time/zone string Europe/Paris
# d-i clock-setup/ntp boolean true
# d-i clock-setup/ntp-server string 0.debian.pool.ntp.org
# ##Partitioning
# d-i partman-auto/init_automatically_partition select biggest_free
# d-i partman-auto/disk string /dev/sda
# d-i partman-auto/method string regular
# #On valide sans confirmation la configuration de partman
# d-i partman-md/confirm boolean true
# d-i partman-partitioning/confirm_write_new_label boolean true
# d-i partman/choose_partition select finish
# d-i partman/confirm boolean true
# d-i partman/confirm_nooverwrite boolean true
# ##Apt setup
# #On peut choisir d’installer non-free et contrib software
# d-i apt-setup/non-free boolean true
# d-i apt-setup/contrib boolean true
# #Package selection
# tasksel tasksel/first multiselect standard gnome-desktop
# #additional packages à installer
# d-i pkgsel/include string openssh-server build-essential sudo curl git python3-pip unzip unattended-upgrades apt-listchanges cockpit tuned nmap tree
# #On ne souhaite pas participer au programme
# popularity-contest popularity-contest/participate boolean false
# ##On installe le programme GRUB
# d-i grub-installer/only_debian boolean true
# d-i grub-installer/with_other_os boolean true
# d-i grub-installer/bootdev string default
# ##Évitez le dernier message indiquant que l’installation est terminée
# d-i finish-install/reboot_in_progress note
# ##script post installation
# d-i preseed/late_command string \
# in-target apt update; \

# 5 – Faire un script cre-iso.sh contenant :
# L’extraction des fichiers de l’ISO
# L’ajout des permissions en écriture sur install.amd
# La décompression initrd.gz
# L’Ajout du nouveau preseed.cfg dans l’image initrd
# La recompression initrd
# La suppression des permissions en écriture sur install.amd
# La création de la nouvelle image iso avec genisoimage
# La nouvelle image sera copiée sur une clé usb

# 6 – Vous devrez installer cette nouvelle image dans une machine virtuelle et la tester

# 7 – Vous créerez une clé usb bootable pour l’installation avec rufus par exemple

# E-mail
# Politique de confidentialité
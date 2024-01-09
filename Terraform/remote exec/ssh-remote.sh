#!/bin/bash

# Lire les variables utilisateur
read -p "Entrez l'hôte: " host
read -p "Entrez l'utilisateur: " user
read -sp "Entrez le mot de passe: " password
echo

# Copier la clé SSH sur le serveur distant
sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no "$user@$host"

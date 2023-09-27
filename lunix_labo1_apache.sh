#!/bin/bash

#Travail 1 – Mettre en place un script d’installation d’un site de base d’Apache

# * Vérifier qu’Apache (et DNS)  n’est pas déjà installé
# * Installer Apache en mode silencieux
# * Faire les mises à jour
if systemctl is-active --quiet bind9; then
  echo "Le service Bind9 est déjà installé et actif."
else
  # Mettre à jour les paquets
  echo "Mise à jour des paquets..."
  sudo apt update && sudo apt upgrade -y
  #Installer Bind9 et se outils
  echo "Installation de Bind9 et de ses outils..."
  sudo apt install bind9 bind9-utils -y
fi

# Verifier si Apache2 est déjà installeé et actif
if systemctl is-active --quiet apache2; then
  echo "Le service Apace est déjà installé et actif."
else 
  # Installer Apache2 et se outils
  echo "Installation de Apache et de ses outils..." 
  apt-get install apache2 -y
fi

# Saisir l'adresse IP et FQDN 
read -p "Saisir l'adresse  IP (par exemple 192.168.1.0) : " IP
read -p "Saisir FQDN : " ServerName

# Verification et ecriture l'information dqns fichier hosts
if [[ ! -z "$IP" && ! -z "$ServerName" ]]; then
  echo "Ecriture l'information dans le fishier HOSTS..."
  echo "$IP $FQDN" >> /etc/hosts
else 
  echo "IP et FQDN doivent être spécifiés."
  exit 1
fi

# * Sauvegarder le fichier 000-default.conf (creation de backup)
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak

# * Ecrire le nouveau fichier 000-default.conf en indiquant les valeurs pour la section VirtualHost
#    ServerName
#    ServerAlias
#    ServerAdmin
#    DocumentRoot /var/www/html 
#    ErrorLog ${APACHE_LOG_DIR}/error.log 
#    CustomLog ${APACHE_LOG_DIR}/access.log combined

APACHE_LOG_DIR="/var/log/apache2"
cat <<EOF>> "/etc/apache2/sites-available/000-default.conf" 
<VirtualHost *:80>
  ServerName $ServerName 
  ServerAlias $SeverName
  ServerAdmin email@$ServerAdmin
  DocumentRoot /var/www/html 
  ErrorLog ${APACHE_LOG_DIR}/error.log 
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# * Sauvegarder le fichier index.html
sudo cp /var/www/html/index.html /var/www/html/index.html.bak

# * Créer un nouveau fichier index.html qui affiche le nom du site et le message de bienvenue
cat <<EOF>> "/var/www/html/index.html" 
<html>
  <body>
    <h1>Bienvenue sur $ServerName</h1>
  </body>
</html>
EOF

# * Redémarrer Apache
if systemctl is-active --quiet apache2; then
  echo "Apache est maintenant actif et fonctionne."
else
  echo "L'installation d'Apache a peut-être rencontré des problèmes."
fi

# * Vérifier le fonctionnement

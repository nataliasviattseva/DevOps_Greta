#!/bin/bash
sudo apt-get --purge remove apache2 sudo apt-get autoremove

# Travail 3 – Mettre en place un script d’installation d’un site supplémentaire

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
  echo "Le service Apache est déjà installé et actif."
else 
  # Installer Apache2 et se outils
  echo "Installation de Apache et de ses outils..." 
  apt-get install apache2 -y
fi

# Saisir l'adresse IP  
# read -p "Saisir l'adresse  IP (par exemple 192.168.27.135) : " IP
#----------------------
IP="192.168.27.135"
#----------------------

# Verification de l'adresse IP 
if [[ ! "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid IP address format. Please enter a valid IP address."
  exit 1
fi

# Saisir FQDN 
# read -p "Saisir FQDN : " ServerName
# --------------------
ServerName="natalia.com"
#----------------------

# Verification de FQDN 
if [[ ! "$ServerName" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo "Invalid FQDN. Please enter a valid Fully Qualified Domain Name."
  exit 1
fi

# Verification et ecriture l'information dqns fichier hosts
if [[ ! -z "$IP" && ! -z "$ServerName" ]]; then
  echo "Ecriture l'information dans le fishier HOSTS..."
  echo "$IP $ServerName" >> /etc/hosts
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
  ServerAlias $ServerName
  ServerAdmin admin@$ServerName
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
sudo systemctl restart apache2
if systemctl is-active --quiet apache2; then
  echo "Apache est maintenant actif et fonctionne."
else
  echo "L'installation d'Apache a peut-être rencontré des problèmes."
fi

# * Vérifier le fonctionnement

# * Sauvegarder le fichier index.html
sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak

# Suppression de fichier default-ssl.conf pour configurer de 0
# rm - r /etc/apache2/sites-available/default-ssl.conf

# Configuration d’Apache pour utiliser SSL
# cat <<EOF> "/etc/apache2/sites-available/default-ssl.conf"
# <VirtualHost 192.168.27.135:443> 
# ServerName $ServerName 
# SSLEngine on 
# SSLCertificateFile /etc/ssl/certs/autosigne.crt 
# SSLCertificateKeyFile /etc/ssl/private/autosigne.key
# </VirtualHost>
# EOF

#Configuration d'Apache pour utiliser SSL
cd /etc/apache2/sites-available
echo '<IfModule mod_ssl.c>' >default-ssl.conf
echo '<VirtualHost *:443>' >>default-ssl.conf
echo 'DocumentRoot /var/www/html' >>default-ssl.conf
echo 'ServerName www.devops.com' >>default-ssl.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >>default-ssl.conf
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >>default-ssl.conf
echo 'SSLEngine on'>>default-ssl.conf
echo 'SSLCertificateFile /etc/ssl/certs/autosigne.crt' >>default-ssl.conf
echo 'SSLCertificateKeyFile /etc/ssl/private/autosigne.key' >>default-ssl.conf
echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">' >>default-ssl.conf
echo 'SSLOptions +StdEnvVars' >>default-ssl.conf
echo '</FilesMatch>' >>default-ssl.conf
echo '<Directory /usr/lib/cgi-bin>' >>default-ssl.conf
echo 'SSLOptions +StdEnvVars' >>default-ssl.conf
echo '</Directory>' >>default-ssl.conf
echo '</virtualhost>' >>default-ssl.conf
echo '</IfModule>' >>default-ssl.conf

# Activation le module ssl
sudo a2enmod ssl

# Création du Certificat SSL
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/autosigne.key -out /etc/ssl/certs/autosigne.crt -subj "/CN=$ServerName"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/autosigne.key -out /etc/ssl/certs/autosigne.crt -subj "/C=FR/ST=IDF/L=PARIS/O=SOCIETE/OU=IT Department/CN=devops.com"
# * Redémarrer Apache
sudo a2ensite default-ssl.conf
sudo systemctl restart apache2
if systemctl is-active --quiet apache2; then
  echo "Apache est maintenant actif et fonctionne."
else
  echo "L'installation d'Apache a peut-être rencontré des problèmes."
fi

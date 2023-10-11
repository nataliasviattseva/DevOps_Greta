#!/bin/bash

servername="jbnr"

# Tout d’abord, mettez à jour la liste de dépôts APT comme suit
apt update && sudo apt upgrade -y

# Dès que cela sera fait, nous vous recommandons d’installer SSH pour copier-coller les commandes et configurations que nous allons effectuer
apt install ssh -y

# Ensuite, il faudra installer php, mysql et apache2 comme suit :

# Apache2 :
apt install apache2 -y

# Installation curl
apt install curl -y

# Php 8.1 :
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
apt install php8.1 -y
apt install libapache2-mod-php8.1 -y
apt install php8.1-gd -y
apt install php8.1-curl -y
apt install php8.1-zip -y
apt install php8.1-dom -y
apt install php8.1-xml -y
apt install php8.1-simplexml -y
apt install php8.1-mbstring -y
apt install php8.1-intl -y
apt install php8.1-bcmath -y
apt install php8.1-gmp -y
apt install php8.1-imagick -y
apt install php8.1-mysql -y
apt install php8.1-fpm -y

# Mariadb :
apt install mariadb-server -y

# Pour configurer le serveur MariaDB, connectez-vous à MariaDB avec la commande suivante
mariadb

# Dès que vous serez dans MariaDB, il faudra créer une base de données nextcloud avec la commande suivante
CREATE DATABASE nextcloud;
CREATE USER nextclouduser@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nextcloud.* TO nextclouduser@localhost IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;

# Tout d’abord, avec nano, créez un fichier nextcloud.conf dans '/etc/apache2/sites-available' comme suit
cat <<EOF > "/etc/apache2/sites-available/nextcloud.conf"
<VirtualHost *:80>
	DocumentRoot "/var/www/nextcloud"
	ServerName nextcloud.$servername.com
	ErrorLog \${APACHE_LOG_DIR}/nextcloud.error
	CustomLog \${APACHE_LOG_DIR}/nextcloud.access combined
	<Directory /var/www/nextcloud/>
		Require all granted
		Options FollowSymLinks MultiViews
		AllowOverride All
		<IfModule mod_dav.c>
			Dav off
		</IfModule>
		SetEnv HOME /var/www/nextcloud
		SetEnv HTTP_HOME /var/www/nextcloud
		Satisfy Any
	</Directory>
</VirtualHost>
EOF

# Enfin, il faudra activer le vhost et redémarrer Apache comme suit :
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime setenvif ssl
sudo apache2ctl -t
sudo systemctl restart apache2

# Pour configurer votre serveur Nextcloud via l’adresse IP au lieu d'un nom de domaine, il faut aller dans /etc/apache2/sites-available/000-default.conf et modifier la section DocumentRoot pour rediriger vers le chemin d'accès de Nextcloud.

# Tout d'abord, il faudra installer le package unzip pour pouvoir décompresser l'archive que nous allons télécharger
sudo apt install unzip -y

# Ensuite, rendez-vous dans le dossier /tmp
cd /tmp

# Ensuite, téléchargez les fichiers de Nextcloud comme suit
wget https://download.nextcloud.com/server/releases/nextcloud-25.0.3.zip

# Dès que cela sera fait, vous devrez décompresser l'archive vers /var/www/
unzip nextcloud-25.0.3.zip -d /var/www
sudo chown www-data:www-data /var/www/nextcloud -R
sudo chmod 755 /var/www/nextcloud -R

# Une fois que cela sera fait, et que vous aurez ajouté la redirection de votre domaine vers votre serveur dans votre fichier host, vous aurez accès à Nextcloud avec votre vhost.

# Avant d'effectuer l'installation de Nextcloud, il faudra créer un dossier nextcloud-data dans /var/www, puis attribuer les droits à www-data comme suit :
sudo mkdir /var/www/nextcloud-data
sudo chown www-data:www-data /var/www/nextcloud-data -R
sudo chmod 755 /var/www/nextcloud-data -R

# Dès que cela sera fait, redémarrez le service Apache
# sudo systemctl restart apache2 # ne fonctionne pas
sudo service apache2 restart

# Pour activer le certificat Let’s Encrypt, il faudra tout d’abord installer le package certbot python3-certbot-apache avec la commande suivante
sudo apt install certbot python3-certbot-apache

read -p "Saisissez l'email : " email
# Ensuite, vous devrez créer le certificat SSL avec la commande suivante en modifiant bien l’adresse email et le nom de domaine. Attention, il faudra rendre votre serveur accessible depuis l’extérieur pour que la configuration se déroule correctement, et vous devrez notamment avoir réservé votre domaine et avoir redirigé les domaines et sous-domaines vers l'IP publique de votre routeur.
sudo certbot --apache --agree-tos --redirect --staple-ocsp --email $email -d nextcloud.$servername.com

# Enfin, rendez-vous dans le fichier de configuration suivant avec nano !
# Et ajoutez la commande suivante dans le fichier de configuration juste après le certificat et avant '</VirtualHost>'
cat <<EOF > "/etc/apache2/sites-enabled/nextcloud-le-ssl.conf"
<IfModule mod_ssl.c>
	<VirtualHost *:443>
		DocumentRoot /var/www/nextcloud
		ServerName nextcloud.$servername.com
		ErrorLog \${APACHE_LOG_DIR}/nextcloud.error
		CustomLog \${APACHE_LOG_DIR}/nextcloud.access combined

		<Directory /var/www/nextcloud>
			Require all granted
			Options FollowSymLinks MultiViews
			AllowOverride All

			<IfModule mod_dav.c>
				Dav off
			</IfModule>

			SetEnv HOME /var/www/nextcloud
			SetEnv HTTP_HOME /var/www/nextcloud
			Satisfy Any
		</Directory>
		SSLCertificateFile /etc/ssl/certs/autosigne.crt
		SSLCertificateKeyFile /etc/ssl/private/autosigne.key

		Header always set Strict-Transport-Security "max-age=31536000"
	</VirtualHost>
</IfModule>
EOF

# Créez le répertoire de stockage de toutes les données pour code-server :
mkdir ~/code-server

# Naviguez jusqu’à lui :
cd ~/code-server

# Visitez la page des versions Github de code-server et choisissez la dernière version de Linux. Téléchargez-le en utilisant :
wget https://github.com/cdr/code-server/releases/download/2.1692-vsc1.39.2/code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz

# Déballez les archives :
tar -xzvf code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz

# Naviguez jusqu’au répertoire contenant l’exécutable de code-server :
cd code-server2.1692-vsc1.39.2-linux-x86_64

# Pour accéder à l’exécutable de code-server sur votre système, copiez-le avec :
sudo cp code-server /usr/local/bin

# Créez un dossier pour code-server afin de stocker les données de l’utilisateur :
sudo mkdir /var/lib/code-server

sudo tee /lib/systemd/system/code-server.service > /dev/null << EOF
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=password
ExecStart=/usr/local/bin/code-server --host 127.0.0.1 --user-data-dir /var/lib/code-server --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Démarrez code-server :
sudo systemctl start code-server

# Activez code-server pour qu’il démarre automatiquement après un redémarrage du serveur :
sudo systemctl enable code-server

# Créez un fichier de configuration pour Nginx :
sudo tee /etc/nginx/sites-available/code-server.conf > /dev/null << EOF
server {
	listen 80;
	listen [::]:80;

	server_name code.lan;

	location / {
		proxy_pass http://localhost:8080/;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection upgrade;
		proxy_set_header Accept-Encoding gzip;
	}
}
EOF

# Pour rendre cette configuration du site active, créez un lien symbolique de celle-ci :
sudo ln -s /etc/nginx/sites-available/code-server.conf /etc/nginx/sites-enabled/code-server.conf

# Install nginx
sudo apt-get update
sudo apt-get install -y nginx

# Testez la validité de la configuration :
sudo nginx -t

# Pour que la configuration prenne effet, redémarrez Nginx :
sudo systemctl restart nginx

# Ajoutez le dépôt de paquets Certbot à votre serveur :
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

# Installez Certbot et son plugin Nginx :
sudo apt-get install python3-certbot-nginx

# Configurez l’ufw pour qu’il accepte le trafic crypté :
sudo apt-get install ufw
sudo apt-get udpate
sudo ufw allow https

# Rechargez-le pour que la configuration prenne effet :
sudo ufw reload

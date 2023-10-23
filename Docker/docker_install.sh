# on exécute les mises à jour
sudo apt update && apt full-upgrade -y

# on installe les dépendances
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# de shooga.ovh mais ce commande ne marche pas 
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg -–dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# j'utilise ca
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# marche
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# ne marche pas
echo \
“deb [arch=$(dpkg –print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable” | tee /etc/apt/sources.list.d/docker.list > /dev/null

# on exécute les mises à jour
sudo apt update -y

# on télécharge le paquet Docker depuis les sources
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

# on attribue le groupe à notre utilisateur :
sudo usermod -aG docker $USER

# on active docker au démarrage de l’OS
sudo systemctl enable docker

# on liste les containers
sudo docker ps

# on teste le fonctionnement
docker run hello-world

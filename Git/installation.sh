# Tous d’abord il faut mettre à jour des paquets
sudo apt update && sudo apt -y upgrade

# Puis installer les dépendances nécessaires
sudo apt -y install curl openssh-server ca-certificates postfix

# Configuration de Postfix (choisissez "Site Internet" lors de la configuration) Si vous avez besoin d'une configuration spécifique, vous devrez la définir ici.

# Puis Installer GitLab Community Edition
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt -y install gitlab-ce

# Ensuite il faudra effectuer la configuration de GitLab
sudo gitlab-ctl reconfigure

# Installation d'Apache
sudo apt -y install apache2

# vous devez ensuite configure le vhost pour avoir accès a gitlab via l’url souhaiter ex : git.easyformer.fr

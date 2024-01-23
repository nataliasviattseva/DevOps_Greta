#!/bin/bash

#--------------Prérequis : (les trois serveurs)
#Installation des paquets et des référentiels pour installer kubernetes
cd

apt install curl apt-transport-https -y

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg| gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg -y

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt update

#--------------cmdlet kube: (toujours les trois serveurs)

#Installer les éléments pour gérer le cluster
apt install wget git kubelet kubeadm kubectl -y

#Empêche la suppression automatique d'un des paquets
apt-mark hold kubelet kubeadm kubectl

#Vérifie l'installation des paquets
kubectl version --output=yaml

kubeadm version

#--------------Swap:
#possible dégradation des perf si on laisse la swap
swapoff -a
free -h

#--------------sysctl.conf



#Modules chargés par le kernel au moment du boot

echo "# Enable kernel modules
modprobe overlay 
modprobe br_netfilter 
# Add some settings to sysctl 
tee /etc/sysctl.d/kubernetes.conf<<EOF 
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward = 1 EOF 
# Reload sysctl 
sysctl --system" >> /etc/sysctl.conf

--------------Docker
apt install -y gnupg2 software-properties-common ca-certificates

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update

apt install -y containerd.io docker-ce docker-ce-cli

mkdir -p /etc/systemd/system/docker.service.d


#config du service docker

tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

#reboot les services
systemctl daemon-reload 
systemctl restart docker
systemctl enable docker


#chargement des modules pour k8s
tee /etc/modules-load.d/k8s.conf <<EOF 
overlay br_netfilter 
EOF

modprobe overlay
modprobe br_netfilter

#routage et filtrage réseau
tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF


#--------------CRI:
#Récupération de la version de CRI
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')

echo $VER


#Téléchargement de l'archive et extraction
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz

tar xvf cri-dockerd-${VER}.amd64.tgz

#Déplacement vers le dossier des binaires
mv cri-dockerd/cri-dockerd /usr/local/bin/

#Vérification de l'installation
cri-dockerd --version

#Configuration du service CRI et du socket
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service

wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket

mv cri-docker.socket cri-docker.service /etc/systemd/system/

sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

#reboot des services
systemctl daemon-reload 
systemctl enable cri-docker.service 
systemctl enable --now cri-docker.socket

#vérification de la bonne installation
systemctl status cri-docker.socket
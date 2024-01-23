#!/bin/bash

#--------------Le control plane:

#module de NAT et balancing
lsmod | grep br_netfilter

#active le service au boot
systemctl enable kubelet

#création d'un socket pour "écouter" les worker
kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock

#Création du cluster
kubeadm init --cri-socket unix:///run/cri-dockerd.sock --pod-network-cidr=10.244.0.0/16

    
#dossier de config de kube avec appels API
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#--------------Flannel:

#Récupération de la config du réseau virtuel
wget https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

#création de la ressource
kubectl apply -f kube-flannel.yml

#Vérification de la création de la ressource
kubectl get pods -n kube-flannel

#Vérification du master
kubectl get nodes -o wide

#Vérification du cluster
kubectl cluster-info

#Envoie du token dans un fichier
kubeadm token create --print-join-command > token.txt

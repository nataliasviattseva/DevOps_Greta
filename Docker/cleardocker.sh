#/bin/bash
clear
echo -e "\e[1;31m"
read -p "ATTENTION !! VOULEZ-VOUS UN NETTOYAGE COMPLET ? (O/N) " choix
if [[ $choix == O || $choix == o ]];then
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
echo Tous les conteneurs sont supprimés
docker rmi $(docker images -a -q)
echo Toutes les images sont supprimées
docker network prune -f
echo Tous les réseaux sont supprimés
docker system prune -f
fi
echo -e "\e[0m"
echo TERMINE


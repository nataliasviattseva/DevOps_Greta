#!/bin/bash

#----APPEL FONCTIONS EXTERNES----
. fonctions.sh

no_color

PS3="
 Action : (1-Infos) (2- Convertir IP) (3-Ajout IP) (4-Ajout Profil) (5-Scan IP)>
 select reponse in infos convert ajout profil scan web dhcp cve retour
 do
 case $reponse in 
 
x )
clear
;;


y )
clear
;;


x )
clear
;;


x )
clear
;;


x )
clear
;;


x )
clear
;;


retour )
clear
red
echo TRAITEMENT TERMINE
echo
no_color
break
;;
 
 
 esac
 
 done

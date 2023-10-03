#!/bin/bash

PS3="Action : (1-INFO_User) (2-PASS_User) (3-ADD_User) (4-DEL_User) (5-DELDATA_User) (6-END)"

#options=("INFO_User"
#         "PASS_User"
#         "ADD_User"
#         "DEL_User"
#         "DELDATA_User"
#         "END")

select reponse in INFO_User PASS_User ADD_User DEL_User DELDATA_User END
do
case $reponse in  

INFO_User)
clear
echo "Option 1: INFO_User selected"
echo "Dernière connexion : "
last | head -n 1
read -p "Saisissez l'utilisateur : " USER
echo "Date de changement de mot de passe pour $USER: "
chage -l "$USER" |  head -n 1
#tail -n 2 /etc/shadow
;;

PASS_User)
clear
echo "Option 2: PASS_User selected"
read -p "Saisissez l'utilisateur : " USER
sudo passwd "$USER"

;;

ADD_User)
clear
echo "Option 3: ADD_User selected"
;;

DEL_User)
clear
echo "Option 4: DEL_User selected"
;;

DELDATA_User)
clear
echo "Option 5: DELDATA_User selected"
;;

END)
clear
echo "Option 6: END selected"
echo TRAITEMENT TERMINE
break
;;

esac
 
done

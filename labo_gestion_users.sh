#!/bin/bash

PS3="Action : (1-INFO_User) (2-PASS_User) (3-ADD_User) (4-DEL_User) (5-DELDATA_User) (6-END) "

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

PS3="CHOIX: (1-UNIQUE) (2-PAR_LOT) (3-END) "
select rep in UNIQUE PAR_LOT END
do

case $rep in  

UNIQUE)

;;

PAR_LOT)

file="/exercises/users.csv"

tail -n +2 "$file" | while IFS=";" read -r user pw home_dir group shell
do
  # Verification de l'existance d'utilisateur
  if id "$user" >/dev/null 2>&1; then 
    echo "Utilisateur existe deja"
  else
    if [ ! $(getent group "$group") ]; then
      sudo groupadd "$group"
    fi 
    sudo useradd "$user" -p "$pw" -m -d "$home_dir" -g "$group" -s "$shell" 
  fi
done 

echo "-----------------------------"
echo "Utilisateurs : "
cut -d: -f1 /etc/passwd

;;

END)
clear
echo "Option 3: END selected"
echo TRAITEMENT TERMINE
;;

esac

done

;;

DEL_User)
clear
echo "Option 4: DEL_User selected"

read -p "Saisissez npm d'utilisateur à supprimer : " del_user
sudo userdel "$del_user"
dir_name=`cat /etc/passwd | grep deluser | cut -d":" -f6`
rm -r "$dir_name"

echo "Utilisateurs : "
cut -d: -f1 /etc/passwd


;;

DATA_User)
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

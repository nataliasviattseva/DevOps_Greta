# fonctione mais mal testé, le bag avec le menu connu

#!/bin/bash

PS3="Action : (1-INFO_User) (2-PASS_User) (3-ADD_User) (4-DEL_User) (5-DELDATA_User) (6-END) "

select reponse in INFO_User PASS_User ADD_User DEL_User DELDATA_User END;do
  case $reponse in  
    INFO_User)
      clear
      echo "Option 1: INFO_User selected"
      echo "Dernière connexion : "
      last | head -n 1
      read -p "Saisissez l'utilisateur : " USER
      echo "Date de changement de mot de passe pour $USER: "
      chage -l "$USER" |  head -n 1
      #tail -n 2 /etc/shadow # l'autre possibilite
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
      select rep in UNIQUE PAR_LOT END;do
        case $rep in  
          UNIQUE)
            clear
            read -p "Saisissez le nom d'utilisateur : " user
            if [ -z "$user" ]; then
              echo "Nom d'utilisateur est obligatoire"
              read -p "Saisissez le nom d'utilisateur : " user
            fi
            read -p "Saisissez le mot de passe : " pw
            read -p "Saisissez le home directory : " home_dir
            read -p "Saisissez le group : " group
            read -p "Saisissez le shell : " shell
            # Verification ci le home directory est vide et faire le par default
            if [ -z "$home_dir" ];then
              home_dir="/home/${user}"
            fi
            # Verification ci le shell est vide et faire le par default
            if [ -z "$shell" ];then
              shell = "/bin/bash"
            fi
            # Si le group est vide creation l'utilisateur sans groupe
            if [ -z "$group" ]; then
              sudo useradd "$user" -p "$pw" -m -d "$home_dir" -s "$shell"
            else 
              # Creation de grope ci elle n'existe pas
              if [ ! $(getent group "$group") ]; then
                sudo groupadd "$group"
              fi
              sudo useradd "$user" -p "$pw" -m -d "$home_dir" -g "$group" -s "$shell"
            fi
            ;;
          PAR_LOT)
            clear
            file="/exercises/users.csv"
            tail -n +2 "$file" | while IFS=";" read -r user pw home_dir group shell;do
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
            break 2
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

      echo "-----------------------------"
      echo "Utilisateurs : "
      cut -d: -f1 /etc/passwd
      ;;

    DELDATA_User)
      clear
      echo "Option 5: DELDATA_User selected"
      read -p "Saisissez npm d'utilisateur à supprimer : " del_user
      sudo userdel "$del_user"
      dir_name=`cat /etc/passwd | grep deluser | cut -d":" -f6`
      rm -r "$dir_name"

      echo "-----------------------------"
      echo "Utilisateurs : "
      cut -d: -f1 /etc/passwd

      ;;

    END)
      clear
      echo "Option 6: END selected"
      echo TRAITEMENT TERMINE
      break 1 
      ;;

  esac
done

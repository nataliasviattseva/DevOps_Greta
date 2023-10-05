#!/bin/bash

PS3="
Choix: (1-Find FIC) (2- Del DIR) (3-Del FIC) (4-Copy DIR) (5-Save) (6-END) "

select reponse in Find_FIC Del_DIR Del_FIC Copy_DIR SAVE END;do

  case $reponse in  
    Find_FIC)
    # Choix 1 – Trouver des fichiers
    # Résultat attendu choix 2
    # on peut chercher un ou plusieurs fichiers 
    # on affiche le nombre de fichiers trouvés
      clear
      echo "Choix 1 – Trouver des fichiers"
      read -p "Saisissez le nom du fichier à rechercher : " fichier

      if [ ! -f “$fichier” ]; then
        echo "Le fichier n'existe pas ($fichier)"
      else
        find . / -type f -name $fichier
      fi
      ;;

    Del_DIR)
      # Choix 2 – Supprimer un répertoire
      # Résultat attendu choix 2
      # on peut supprimer un répertoire et tout son contenu
      # on demande une confirmation avant
      clear
      echo "Choix 2 – Supprimer un répertoire"
      read -p "Saisissez le nom du répertoire à supprimer : " dossier
      echo "Voulez-vous vraiment supprimer le repertoire $dossier et ce contenu ? "
      sudo rm -r "$dossier"
      # to skip 'permitions denied'
      # find / -name foo 2>/dev/null
      echo "Doddier $fichier a été supprimé"
      ;;

    Del_FIC)
      # Choix 3 – Supprimer des fichiers
      # Résultat attendu choix 3
      # On recherche les fichiers et on les supprime
      # on demande une confirmation avant
      clear
      read -p "Saisissez le nom du fichier à supprimer : " fichier
      find / -name foo 2>/dev/null
      echo "Voulez-vous vraiment supprimer le repertoire $dossier et ce contenu ? "
      sudo rm -r "$dossier"
      echo "Fichier $fichier a été supprimé"
      ;;

    Copy_DIR)
      # Choix 4 – Copier des répertoires
      # Résultat attendu
      # On peut copier un répertoire et son contenu dans un autre répertoire
      clear
      read -p  "Saisissez le repertoire à copier : " copier
      read -p "Saisissez l'endroit pour copier le repertoire : " coller
      cp $copier $coller
      ;;

    SAVE)
      # Choix 5 – Archiver des données
      # Résultat attendu
      # L’archive est créée et porte le nom de la machine et la date du jour
      read -p "Saisissez le fichier à archiver : " archive
      nom=find
      tar -cvf $(nom).tar archive 
      clear

      ;;

    END)
      clear
      echo "Option 6: END selected"
      echo TRAITEMENT TERMINE
      break  
      ;;

  esac
  done

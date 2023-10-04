#!/bin/bash

# Gestion des fichiers et répertoires

# Tester l’existence ou non d’un fichier

FICHIER="../etc/passwd"

if [ -f $FICHIER ]; then
echo "Le fichier existe $FICHIER"
fi

if [ ! -f $FICHIER ]; then
echo "Le fichier n’existe pas $FICHIER"
fi

# Commande CUT

# Exercice A

# 1-Afficher le contenu du fichier /etc/passwd 
#   sauf le 2 premières lignes avec la commande AWK

echo -------------------------------------------------------------
echo le contenu du fichier /etc/passwd sauf le 2 premières lignes :
echo -------------------------------------------------------------
awk 'NR > 2' /etc/passwd 
echo -------------------------------------------------------------

# 2-Afficher uniquement les deux premiers caractères de 
#   chaque ligne du fichier /etc/passwd avec la commande CUT

echo -------------------------------------------------------------
echo les deux premiers caractères de chaque ligne du fichier /etc/passwd :
echo -------------------------------------------------------------
cut -b -2 /etc/passwd 
echo -------------------------------------------------------------

# 3-Trouver le même résultat avec CUT et AWK pour afficher 
#   la première colonne du fichier /etc/passwd

echo -------------------------------------------------------------
echo afficher la première colonne du fichier /etc/passwd :
echo -------------------------------------------------------------
cut -d ":" -f 1 /etc/passwd 
echo -------------------------------------------------------------


# Tester l’existence ou non d’un répertoire

DOSSIER="../exercises"
if [ -d "$DOSSIER" ];then
echo "Le dossier existe !";
fi

if [ ! -d "$DOSSIER" ];then
echo "Le dossier n’existe pas !";
fi


# Créer un fichier complexe

# Exemple 1

cat>'/exercises/default.conf'<<EOF
ServerName www.devops.lan
ServerAlias www.devops.lan
ServerAdmin webmaster@localhost
DocumentRoot /var/www/html
EOF

# Exemple 2

echo 'ServerName www.devops.lan' >> /exercises/default.conf
echo 'ServerAlias www.devops.lan' >> /exercises/default.conf
echo 'ServerAdmin webmaster@localhost' >> /exercises/default.conf
echo 'DocumentRoot /var/www/html' >> /exercises/default.conf


# Ajouter une ligne à un endroit particulier dans un fichier (SED option a)

# On ajoute le texte près la 3ème lignes du fichier liste.txt

touch liste.txt
sed -i '3 a ceci est un texte' liste.txt


# Renommer des fichiers en changeant leur suffixe via une boucle

for file in *.txt; do mv -v "$file" "${file%.txt}.doc"; done


# La commande WC

# Permet de compter le nombre de lignes ou de mots dans un fichier

echo "Compter le nombre de lignes d'un fichier : " `wc -l /etc/hosts`
echo "Compter le nombre de fichiers dans répertoire : " `find . -type f | wc -l`
echo "Compter le nombre d'utilisateurs : " `getent /etc/passwd | wc -l`


# La commande AWK

echo "Imprimer le login et le temps de connexion :" 
who | awk '{print $1,$4}'

echo "Rechercher nsviattseva dans le fichier passwd et afficher la 3ème colonne : "
awk '/nsviattseva/ { print $1 }' /etc/passwd


#!/bin/bash

# Commande CUT

# Exercice A

# 1-Afficher le contenu du fichier /etc/passwd 
#   sauf le 2 premières lignes avec la commande AWK

echo -------------------------------------------------------------
echo le contenu du fichier /etc/passwd sauf le 2 premières lignes :
echo -------------------------------------------------------------
awk 'NR > 2' /etc/passwd 
echo -------------------------------------------------------------
echo -------------------------------------------------------------

# 2-Afficher uniquement les deux premiers caractères de 
#   chaque ligne du fichier /etc/passwd avec la commande CUT

echo -------------------------------------------------------------
echo les deux premiers caractères de chaque ligne du fichier /etc/passwd :
echo -------------------------------------------------------------
cut -b -2 /etc/passwd 
echo -------------------------------------------------------------
echo -------------------------------------------------------------

# 3-Trouver le même résultat avec CUT et AWK pour afficher 
#   la première colonne du fichier /etc/passwd

echo -------------------------------------------------------------
echo afficher la première colonne du fichier /etc/passwd :
echo -------------------------------------------------------------
cut -d":" -f1 | awk 'NR > 0 && NR <2' /etc/passwd 
echo -------------------------------------------------------------
echo -------------------------------------------------------------


/#!/bin/bash
noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'

neutre='\e[0;m'

clear
tentatives=10
VARIABLE=`echo $(( $RANDOM % 20 + 1))`
echo -e "${bleuclair} Variable aleatoire : $VARIABLE ${neutre}"

while [[ $reponse != $VARIABLE ]] || [[ $tentatives -ge 0 ]] 
read -p "$(echo -e ${grisclair}Saisir le chiffe entre 1 et 20 : ${neutre})" reponse
do
if [[ $reponse -lt 1 || $reponse -gt 20 ]] 
then
read -p "$(echo -e ${orange}Saisir le chiffe entre 1 et 20 : ${neutre})" reponse
fi
if [[ $reponse -lt $VARIABLE ]]
then
echo -e "${orange}  Le chiffre est plus grand${neutre}"
elif [[ $reponse -gt $VARIABLE ]]
then
echo -e "${rose}  Le chiffre est plus petit${neutre}"
else
break
fi
((tentatives -= 1 ))
echo -e "${violetfonce}Reste de tentatives : $tentatives${neutre}"

if [[ $tentatives -eq 0 ]]
then
echo -e "${rougefonce}Tentatives sont finis ${neutre}" 
break
fi

done

((tentatives_total=11-$tentatives))

if [[ $reponse -eq $VARIABLE ]]
then
echo -e "${vertfonce}Bravo vous avez trouvé en $tentatives_total tentatives ${neutre}"
fi

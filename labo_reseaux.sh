#!/bin/bash
clear

echo "Saisir votre choix :"

options=("Infos"
         "Convertir IP"
         "Gestion des IP"
         "Gestion Profil"
         "Scan IP"
         "Scan HTTP(s)"
         "Scan DHCP"
         "Scan CVE"
         "Infos wan"
         "FIN")

select opt in "${options[@]}"
do
  case $opt in
    "Infos")
      clear
      echo "Affichage des paramètres réseau : "
#      echo "Noms des cartes réseau : " `ip a | grep UP | cut -d " " -f 2 | cut -d ":" -f 1`
      echo "Noms des cartes réseau : " 
      ls /sys/class/net
      echo "Liste des adresses IPvK4 : " 
      ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $2" "$4}'
      echo "Liste des adresses IPvK6 : " 
      ip -o addr | awk '/^[0-9]*: ?[^lo].*inet6/ {print $2" "$4}'
      echo "Liste des serveurs DNS : " 
      cat /etc/resolv.conf | grep 'nameserver' | awk '{print $2}'
      echo "Affichage adresse du serveur DHCP :" 
      cat /var/lib/dhcp/dhclient.leases | grep 'dhcp-server-identifier' | tail -n 1 | awk '{print $3}'
      echo "Affichage adresse MAC de la carte réseau : " 
      ip link | awk '/link\/ether/ {print $2}'
      echo "Affichage table de routage : " 
      ip route
      ;;

    "Convertir IP")
      clear
      function convip()
      {
        CONV=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
        ip=""
        for byte in `echo ${1} | tr "." " "`; do
          ip="${ip}.${CONV[${byte}]}"
        done
        echo ${ip:1}
      }
    
      echo -n "Enter your ip address: "; read ip1
      echo -n "Enter your subnet mask: "; read ip2

      a=`convip "${ip1}"`
      b=`convip "${ip2}"`

      IFS=. read -r i1 i2 i3 i4 <<< $ip1
      IFS=. read -r m1 m2 m3 m4 <<< $ip2

      echo "Adresse ${a}"
      echo " valeur de a $a et valeur de b $b"
      echo "Masque  ${b}"
 
      printf "Votre réseau est le %d.%d.%d.%d\n" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))"
      ;;

    "Gestion des IP")
      clear
      ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $2" "$4}'
      echo
      while [ "$answer" != "n" ]; do
        read -p "Voulez-vous ajouter (a) ou supprimer (s) l'adress IP ? " as
        if [[ "$as" =~ "a" ]]; then 
          read -p "Saisir l'IP pour ajouter: " IP_READ
          read -p "Saisir le nom de reseau pour $IP_READ : " RES_READ
          sudo ip addr add $IP_READ dev $RES_READ
          echo "L'adresse IP $IP_READ est ajouté" 
        elif [[ "$as" =~ "s" ]]; then 
          read -p "Saisir l'IP pour supprimer: " IP_READ
          read -p "Saisir le nom de reseau pour $IP_READ : " RES_READ
          sudo ip addr del $IP_READ dev $RES_READ
          echo "L'adresse IP $IP_READ est supprimé"
        fi
        read -p "Voulez-vous continuer ? (y/n) " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
      done
      ;;

    "Gestion Profil")
      clear
      nmcli connection show
      echo
      while [ "$answer" != "n" ]; do
        read -p "Voulez-vous ajouter (a) ou supprimer (s) le profile ? " as
        if [[ "$as" =~ "a" ]]; then 
          read -p "Saisir le con-name : " CON_NAME
          read -p "Saisir le ifname : " IFNAME
          sudo nmcli connection add con-name $CON_NAME type ethernet ifname $IFNAME
          read -p "Saisir l'IPv4 pour ajouter dans le profil $CON_NAME (exemple 192.168.1.100/24) : " IP_PROFIL
          read -p "Saisir le gateaway pour ajouter dans le profil $CON_NAME (exemple 192.168.1.1) : " GA_PROFIL
          sudo nmcli connection modify $CON_NAME ipv4.method manual ipv4.address $IP_PROFIL ipv4.gateway $GA_PROFIL ipv4.dns 8.8.8.8,8.8.4.4
        elif [[ "$as" =~ "s" ]]; then 
          read -p "Saisir le con-name : " CON_NAME
          read -p "Saisir le ifname : " IFNAME
          sudo nmcli connection delete $CON_NAME
        read -p "Voulez-vous continuer ? (y/n) " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
      done
      ;;

    "Scan IP")
      # Ajoutez le code pour l'option "Scan IP" ici
      ;;
    "Scan HTTP(s)")
      # Ajoutez le code pour l'option "Scan HTTP(s)" ici
      ;;
    "Scan DHCP")
      # Ajoutez le code pour l'option "Scan DHCP" ici
      ;;
    "Scan CVE")
      # Ajoutez le code pour l'option "Scan CVE" ici
      ;;
    "Infos wan")
      # Ajoutez le code pour l'option "Infos wan" ici
      ;;
    "FIN")
      echo "Fin du programme."
      break
      ;;
    *)
      echo "Choix invalide, veuillez réessayer."
      ;;
  esac
done

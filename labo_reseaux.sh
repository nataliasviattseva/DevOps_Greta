#!/bin/bash

reseau="192.168.27.0/24"

verifier_nmap(){
  if ! command -v nmap &>/dev/null; then
    echo "Nmap n'est pas installé, installation en cours..."
    sudo apt-get install nmap || {
      echo "Échec de l'installation de Nmap. Veuillez l'installer manuellement et relancer le script."
      exit 1
    }
  fi
}

clear

echo "Sélectionnez une option : "

options=("Afficher les informations réseau"
         "Convertir une adresse IP"
         "Gérer les adresses IP"
         "Gestion les profils réseau"
         "Scanner les adresses IP"
         "Scaner les ports HTTP(s)"
         "Scaner le serveur DHCP"
         "Scanner les CVE"
         "Afficher les informations WAN"
         "Quitter")

select opt in "${options[@]}"
do
  case $opt in
    "Afficher les informations réseau")
      clear
      echo "Affichage des paramètres réseau : "
#      echo "Noms des cartes réseau : " `ip a | grep UP | cut -d " " -f 2 | cut -d ":" -f 1`
      echo "Noms des interfaces réseau : " 
      ls /sys/class/net
      echo "Liste des adresses IPvK4 : " 
      ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $2" "$4}'
      echo "Liste des adresses IPvK6 : " 
      ip -o addr | awk '/^[0-9]*: ?[^lo].*inet6/ {print $2" "$4}'
      echo "Liste des serveurs DNS : " 
      cat /etc/resolv.conf | grep 'nameserver' | awk '{print $2}'
      echo "Affichage adresse du serveur DHCP :" 
      cat /var/lib/dhcp/dhclient.leases | grep 'dhcp-server-identifier' | tail -n 1 | awk '{print $3}'
      echo "Affichage adresse MAC de l'interface réseau : " 
      ip link | awk '/link\/ether/ {print $2}'
      echo "Affichage table de routage : " 
      ip route
      ;;

    "Convertir une adresse IP")
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

    "Gérer les adresses IP")
      clear
      ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {print $2" "$4}'
      echo
      while [ "$answer" != "n" ]; do
        read -p "Voulez-vous ajouter (a) ou supprimer (s) l'adress IP ? " as
        if [[ "$as" =~ "a" ]]; then 
          read -p "Saisir l'adresse IP à ajouter: " IP_READ
          read -p "Saisir le nom de l'interface pour $IP_READ : " RES_READ
          sudo ip addr add "$IP_READ" dev "$RES_READ"
          echo "L'adresse IP $IP_READ est ajoutée" 
        elif [[ "$as" =~ "s" ]]; then 
          read -p "Saisir l'adresse IP à supprimer: " IP_READ
          read -p "Saisir le nom de l'interface pour $IP_READ : " RES_READ
          sudo ip addr del "$IP_READ" dev "$RES_READ"
          echo "L'adresse IP $IP_READ est supprimée"
        fi
        read -p "Voulez-vous continuer ? (o/n) " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
      done
      ;;

    "Gérer les profils réseau")
      clear
      nmcli connection show
      echo
      while [ "$answer" != "n" ]; do
        read -p "Voulez-vous ajouter (a) ou supprimer (s) un profil réseau ? " as
        if [[ "$as" =~ "a" ]]; then 
          read -p "Saisir le nom de la connexion : " CON_NAME
          read -p "Saisir le nom de l'interface : " IFNAME
          sudo nmcli connection add con-name "$CON_NAME" type ethernet ifname "$IFNAME"
          read -p "Saisir l'adresse IPv4 à ajouter au le profil $CON_NAME (exemple 192.168.1.100/24) : " IP_PROFIL
          read -p "Saisir le passerelle à ajouter au le profil $CON_NAME (exemple 192.168.1.1) : " GA_PROFIL
          sudo nmcli connection modify "$CON_NAME" ipv4.method manual ipv4.address "$IP_PROFIL" ipv4.gateway "$GA_PROFIL" ipv4.dns 8.8.8.8,8.8.4.4
        elif [[ "$as" =~ "s" ]]; then 
          read -p "Saisir le nom de la connexion à supprimer : " CON_NAME
          sudo nmcli connection delete "$CON_NAME"
        fi
        read -p "Voulez-vous continuer ? (o/n) " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
      done
      ;;

    "Scanner les adresses IP")
      clear
      verifier_nmap
      echo "Balayage du réseau en cours..." 
      nmap -sn "$reseau" --script broadcast-dhcp-discover  
      ;;

    "Scanner les ports HTTP(s)")
      clear
      verifier_nmap
      echo "Balayage des ports HTTS(s) en cours..." 
      nmap -p 80,443 "$network" | grep host 
      ;;

    "Scanner le serveur DHCP")
      clear
      check_nmap
      nmcli connection show
      reap -p "Saisir le nom de la connexition" CON_NAME
      sudo nmap --script broadcast-dhcp-discover -e "$CON_NAME"
      ;;

    "Scanner les CVE")
      clear
      check_nmap
      echo "Balayage des vulnérabilités de resea $network en cours..." 
      nmap -Pn --script vuln "$network"
      ;;

    "Afficher les informations WAN")
      # Adresse du site que vous souhaitez interroger
      site="debian.org"

      # Utilisation de la commande dig pour récupérer les informations DNS
      result=$(dig "$site")

      # Affichage des résultats
      echo "Résultats DNS pour le site $site :"
      echo "$result"
      ;;

    "Quitter")
      echo "Fin du programme."
      break
      ;;
    *)
      echo "Choix invalide, veuillez réessayer."
      ;;
  esac
done

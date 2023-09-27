#!/bin/bash
# Étape 1: Tester l’existence du service DNS (Bind9) avant de lancer l’installation
if systemctl is-active --quiet bind9; then
    echo "Le service Bind9 est déjà installé et actif."
    exit 0
fi

# Étape 2: Mise à jour des paquets et installation de Bind9 et de ses outils
echo "Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "Installation de Bind9 et de ses outils..."
sudo apt install bind9 bind9-utils -y

# Étape 3: Modification des fichiers de configuration de Bind9 (named.conf)

# Use variables for network configuration (NETWORK and NETMASK)
read -p "Quelle est votre adresse de réseau ? (exemple 10.0.0.0): " NETWORK
read -p "Quel est le masque (CIDR)de votre réseau ? (exemple /8): " NETMASK

# Calculate network and broadcast addresses
IFS=. read -r -a NETWORK_PARTS <<< "$NETWORK"
NETMASK=$((0xFFFFFFFF << (32 - CIDR_MASK) & 0xFFFFFFFF))
IFS=. read -r -a NETMASK_PARTS <<< "$NETMASK"
REVERSED_IP=""
for ((i=0; i<4; i++)); do
    REVERSED_IP="$REVERSED_IP.$((NETWORK_PARTS[$i] & NETMASK_PARTS[$i]))"
done
REVERSED_IP="${REVERSED_IP:1}"


# Create the root hint file
echo 'dig NS . @a.root-servers.net > /etc/bind/db.root' >> /etc/bind/db.root

echo 'debian.example.com' >> /etc/hosts

# Use double quotes for zone names and file paths in named.conf
cat <<EOF >> "/etc/bind/named.conf.options"
options{ 
directory "/var/cache/bind";
listen-on-v6 { any; };
listen-on { any; };
};
EOF

cat <<EOF >> "/etc/bind/named.conf.local"
//include " /etc/bind/zones.rfc1918 " ;
zone “example.com” {
  type master ;
  file “/etc/bind/db.example.com” ;
} ;
zone “$NETWORK_IP.in-addr.arpa” {
  type master ;
  file “/etc/bind/db.$NETWORK_IP.in-addr.arpa” ;
} ;
EOF

# Create the zone file for example.com with variable IP addresses
cat <<EOF >> "/etc/bind/db.example.com"
$TTL 9600
$ORIGIN example.com. 
@   IN  SOA debian.example.com. root.example.com. (
    20230925; #Serial 
    3h; #Refresh 
    1h; #Retry 
    1w; #Expire 
    1h); #Negative cache TTL 
    
 @  IN  NS  debian.example.com. 
 debian IN A $NETWORK
 routeur IN A $NETWORK
 www IN A $NETWORK
EOF

# Étape 4: Création des fichiers de zone (standard et inversée)

# Create the reverse zone file with calculated PTR records
cat <<EOF >> "/etc/bind/db.$NETWORK_IP.in-addr.arpa"
$TTL 9600 @ IN SOA debian.example.com. root.example.com. ( 
20230925; 
3h; 
1h;/ 
1w; 
1h); 
@ IN NS debian.example.com. 
243 IN PTR debian.example.com. 
254 IN PTR routeur.example.com.
EOF

# Calculate and add PTR records for all IP addresses in the network range
for ((i=1; i<255; i++)); do
    IP=$((i1 & m1)).$((i2 & m2)).$((i3 & m3)).$i
    echo "$i IN PTR host$i.example.com." >> "/etc/bind/db.$NETWORK_IP"
done

# Étape 5: Modification de l’adresse DNS de la carte réseau avec nmcli

# TO DO

# Étape 6: Redémarrage du service Bind9 pour appliquer les modifications
echo "Redémarrage du service Bind9..."
sudo systemctl restart bind9

# Étape 7: Test de l’installation du service Bind9
if systemctl is-active --quiet bind9; then
    echo "Bind9 a été installé avec succès et est actif."
else
    echo "L'installation de Bind9 a échoué. Veuillez vérifier les configurations et les fichiers de zone."
fi

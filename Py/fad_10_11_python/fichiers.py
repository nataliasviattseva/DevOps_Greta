# Etant donné un fichier texte nommé ‘F_IPV4.txt’ contenant dans chaque ligne une adresse IPV4.
# On se propose de vérifier la validité des adresses IPV4 stockés dans ce fichier, de déterminer
# la classe à laquelle appartient chacune des adresses valides, de les faire migrer vers le système
# IPV6 et de stocker dans un fichier d’enregistrements nommé ‘F_IPV6.txt’ chaque adresse IPV4 valide
# ainsi que la classe à laquelle elle appartient et son équivalent en IPV6.
#
# 1. Ecrire une fonction est_valide(ip) qui permet de vérifier la validité d’une adresseIPV4 qui
# retournera un booléen.
#
# 2. Ecrire une fonction classe(ip) qui retourne la classe d’une adresse ip.
#
# 3. Ecrire une fonction adresse_ip6(ip) qui permet de convertir une adresse ip en V4 vers une adresse IPV6
#
# 4. Ecrire la fonction Genere() qui permet de générer le fichier ‘F_IPV6.txt’
#
# · La fonction bin(nb) permet de convertir en binaire un nombre nb (bin(155) à 0b10011011)
#
# · La fonction hex(nb) permet de convertir un nombre décimal en hexadécimal (hex(155) à 0x9b)

import re
from ipaddress import IPv6Address, ip_address
# import netaddr # not implemented in method adresse_ip6()

# not used
# To test ip address via ipaddress.ip_address method
# Could be uses for IPv4 and IPv6 addresses
def validate_ip_address(ip_string):
    try:
        ip_object = ip_address(ip_string)
        print("The IP address '{ip_object}' is valid.")
    except ValueError:
        print("The IP address '{ip_string}' is not valid")


def est_valide(ip):
    """Permet de vérifier la validité d’une adresse IPV4, retourne un booléen"""
    # https://regex101.com/
    # Any address that has more than 3 dots is invalid.
    if not bool(re.match(r"^(?:\d{1,3}\.){3}\d{1,3}$", ip)):
        return False
    # Any address that begins with a 0 is invalid (except as a default route).
    if re.search(r"^0", ip) and ip not in "0.0.0.0":
        return False
    # Any address with a number above 255 in it is invalid.
    for byte in ip.split("."):
        if int(byte) > 255:
            return False
    # Any address that begins with a number between 240 and 255 is reserved, and effectively invalid.
    # (Theoretically, they’re usable, but I’ve never seen one in use.)
    # Not covered - it's necessary to check classes

    # Any address that begins with a number between 224 and 239 is reserved for multicast,
    # and probably invalid.
    # Not covered - it's necessary to check classes

    # Any address that begins with one of the following, is private, and invalid in the public Internet,
    # but you will frequently see them used for internal networks (Note: the *s mean “anything between 0 & 255”) :
    # 10.*.*.*
    # 172.16.*.* through 172.31.*.*
    # 192.168.*.*
    # Not covered - it's necessary to check classes

    return True


def classe(ip):
    """Retourne la classe d’une adresse ip"""
    # https://www.inetdoc.net/articles/adressage.ipv4/adressage.ipv4.class.html
    bytes_list = ip.split(".")
    first_byte = int(bytes_list[0])
    # Classe A
    # Le premier octet a une valeur comprise entre 1 et 126 ; soit un bit de poids fort égal à 0.
    # Ce premier octet désigne le numéro de réseau et les 3 autres correspondent à l'adresse de l'hôte.
    if 0 < first_byte < 127:
        return "Classe A"
    # L'adresse réseau 127.0.0.0 est réservée pour les communications en boucle locale.
    # Classe B
    # Le premier octet a une valeur comprise entre 128 et 191 ; soit 2 bits de poids fort égaux à 10.
    # Les 2 premiers octets désignent le numéro de réseau et les 2 autres correspondent à l'adresse de l'hôte.
    elif 127 < first_byte < 192:
        return "Classe B"
    # Classe C
    # Le premier octet a une valeur comprise entre 192 et 223 ; soit 3 bits de poids fort égaux à 110.
    # Les 3 premiers octets désignent le numéro de réseau et le dernier correspond à l'adresse de l'hôte.
    elif 192 <= first_byte < 224:
        return "Classe C"
    # Classe D
    # Le premier octet a une valeur comprise entre 224 et 239 ; soit 3 bits de poids fort égaux à 1.
    # Il s'agit d'une zone d'adresses dédiées aux services de multidiffusion vers des groupes d'hôtes
    # (host groups).
    elif 224 <= first_byte < 240:
        return "Classe D"
    # Classe E
    # Le premier octet a une valeur comprise entre 240 et 255. Il s'agit d'une zone d'adresses réservées
    # aux expérimentations. Ces adresses ne doivent pas être utilisées pour adresser des hôtes ou des
    # groupes d'hôtes.
    elif 240 <= first_byte < 255:
        return "Classe D"


def adresse_ip6(ip):
    """Converte une adresse ip en V4 vers une adresse IPV6"""
    # another way, but it is necessary to install netaddr
    # addr = netaddr.IPAddress('192.168.1.1')
    # addr = addr.ipv6()
    # addr = addr.ipv(ipv4_compatible=True)
    return IPv6Address(int(ip_address(ip))).compressed


def genere():
    """Permet de générer le fichier ‘F_IPV6.txt’"""
    with open("F_IPV4.txt") as file:
        my_list = file.read().split("\n")
    with open("F_IPV6.txt", "w") as file:
        for ip in my_list:
            if est_valide(ip):
                # ffff - is 6to4 notation (https://en.wikipedia.org/wiki/6to4)
                file.write(adresse_ip6(ip).replace("::", "::ffff:") + "\n")


genere()

# Test
# with open("F_IPV4.txt") as file:
#     my_list = file.read().split("\n")
#     for ip in my_list:
# if est_valide(ip):
#     print(f"{ip} :  {classe(ip)}")
#     print(f"IPv6 : {adresse_ip6(ip)}\n")
# else:
#     print(f"IP address {ip} is not valid.")

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m' 

# Manages Keyboard Interrupt (CTRL + C)
function ctr_c() {
    echo -e "$RED\n\n[!] Terminando Escaneo...$RESET\n"
    exit 1
}
trap ctr_c SIGINT
 
# Extracts the hosts detected under the same SSL certificate
function extract_crtSh() {
    
    host=$1
    curl "https://crt.sh/?q=$host" 2>/dev/null | sed 's/<[^>]*>/\n/g' | grep $host | sort -u | grep -v ';\|*\|crt.sh'
}

# Extracts data with assetfinder
function extract_asset() {
    
    host=$1
    assetfinder $host | grep -v "*" | sort -u | grep $host
}

# Extracts data with subfinder
function extract_subfinder() {
    
    host=$1
    subfinder -d $host 2>/dev/null | grep $host | sort -u
}

# Tests the status of a given web domain, and separates them in two groups
function status() {

    rm alive_hosts.txt 2>/dev/null; rm dead_hosts.txt 2>/dev/null # Cleaning

    IFS=$'\n' host_list=($1)     # Splits the string into an array using '\n' as Internal Field Separator (IFS)

    for host in "${host_list[@]}"; do

        code=$(curl -Is --max-time 1 $host 2>/dev/null | grep -oP 'HTTP/\d*\.*\d* \K\d+' &)

        if [ "$code" != "" ]; then
            if ((code/100 == 1)) || ((code/100 == 2)); then
                echo -e "\t$CYAN[+] [$code] - $host"
            elif ((code/100 == 3)); then
                echo -e "\t$YELLOW[+] [$code] - $host"
            elif ((code/100 == 4)) || ((code/100 == 5)); then
                echo -e "\t$RED[+] [$code] - $host"
            fi
            echo "$host:$code" >> alive_hosts.txt
        else
            echo "$host" >> dead_hosts.txt
        fi
        
    done
}

# Main function
function main() {
    # Variables
    host=$1
    n=0

    # Extracts all the data
    echo -e "\n$GREEN[+] Empezando a Escanear $YELLOW$host...$RESET\n"

    echo -e "\n$GREEN[+] Verificando Certificado SSL...$RESET"
    crtHosts=$(extract_crtSh $host)
    n=$(echo "$crtHosts" | wc -l)
    echo -e "\n\t$CYAN[i] Hosts Detectados: $n$RESET\n"

    echo -e "\n$GREEN[+] Ejecutando Assetfinder...$RESET"
    assetHosts=$(extract_asset $host)
    n=$(echo "$assetHosts" | wc -l)
    echo -e "\n\t$CYAN[i] Hosts Detectados: $n$RESET\n"

    echo -e "\n$GREEN[+] Ejecutando Subfinder...$RESET"
    subHosts=$(extract_subfinder $host)
    n=$(echo "$subHosts" | wc -l)
    echo -e "\n\t$CYAN[i] Hosts Detectados: $n$RESET\n"

    # Creates a pre-report
    echo -e "\n$GREEN[+] Creando reporte preliminar...$RESET"

    preReport=$(echo -e "$crtHosts\n$assetHosts\n$subHosts" | sort -u) 
    n=$(echo "$preReport" | wc -l)

    echo -e "\n\t$CYAN[i] Hosts totales Detectados: $n$RESET\n"

    # Creates the final report
    echo -e "\n$GREEN[-] Verificando hosts activos...\n$RESET"
    status "$preReport" 

    n=$(wc -l < alive_hosts.txt)
    echo -e "\n$GREEN[+] Total de hosts activos: $n\n"
    echo -e "[+] Reporte final guardado en:$RESET ./alive_hosts.txt\n$GREEN"
    echo -e "[i] Para filtrar por codigo de estado:$RESET cat ./alive_hosts.txt | grep "200" | cut -d":" -f1\n"
}

if [ "$1" == "" ] || [ "$2" != "" ]; then
    echo -e "$RED\n[!] Modo de uso: ./subAlive example.com$RESET"
    exit 1
else
    main $1
fi

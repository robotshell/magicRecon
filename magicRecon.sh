#!/bin/bash

#Colors
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[92m"
RED="\e[30m"
MAGENTA="\e[95m"
CYAN="\e[36m"
YELLOW="\e[93m"

echo -e "${BOLD}${GREEN}[+] Starting Subdomain Enumeration" 

#Sublist3r

sublist3r -d $1 -v -o domains.txt

#Assetfinder

~/go/bin/assetfinder --subs-only $1 | tee -a domains.txt

#removing duplicate entries

sort -u domains.txt -o domains.txt

#Alive domains

echo -e ""
echo "[+] Checking for alive domains.."
cat domains.txt | ~/go/bin/httprobe | tee -a alive.txt

#Parse data jo JSON 

cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json

cat domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > domains.json

##############################################################

echo -e ""
echo -e "${BOLD}${GREEN}[+] Storing subdomain headers and response bodies"

mkdir headers
mkdir responsebody

CURRENT_PATH=$(pwd)

for x in $(cat alive.txt)
do
        NAME=$(echo $x | awk -F/ '{print $3}')
        curl -X GET -H "X-Forwarded-For: evil.com" $x -I > "$CURRENT_PATH/headers/$NAME"
        curl -s -X GET -H "X-Forwarded-For: evil.com" -L $x > "$CURRENT_PATH/responsebody/$NAME"
done

##############################################################

echo -e ""
echo -e "${BOLD}${GREEN}[+] Collecting JavaScript files and Hidden Endpoints"

mkdir scripts
mkdir scriptsresponse

RED='\033[0;31m'
NC='\033[0m'
CUR_PATH=$(pwd)

for x in $(ls "$CUR_PATH/responsebody")
do
        printf "\n\n${RED}$x${NC}\n\n"
        END_POINTS=$(cat "$CUR_PATH/responsebody/$x" | grep -Eoi "src=\"[^>]+></script>" | cut -d '"' -f 2)
        for end_point in $END_POINTS
        do
                len=$(echo $end_point | grep "http" | wc -c)
                mkdir "scriptsresponse/$x/"
                URL=$end_point
                if [ $len == 0 ]
                then
                        URL="https://$x$end_point"
                fi
                file=$(basename $end_point)
                curl -X GET $URL -L > "scriptsresponse/$x/$file"
                echo $URL >> "scripts/$x"
        done
done

mkdir endpoints

CUR_DIR=$(pwd)

for domain in $(ls scriptsresponse)
do
        #looping through files in each domain
        mkdir endpoints/$domain
        for file in $(ls scriptsresponse/$domain)
        do
                ruby ~/relative-url-extractor/extract.rb scriptsresponse/$domain/$file >> endpoints/$domain/$file 
        done
done

##############################################################

echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Nmap Scan"

mkdir nmapscans

for domain in $(cat domains.txt)
do
        nmap -sC -sV $domain | tee nmapscans/$domain
done

##############################################################

echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Aquatone to take screenshots"

mkdir screenshots

CUR_DIR=$(pwd)

mkdir endpoints/$1

cat alive.txt | aquatone -out ~/$1/screenshots/



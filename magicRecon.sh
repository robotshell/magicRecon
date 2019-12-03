#!/bin/bash

#Colors
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[92m"

echo -e "${BOLD}${GREEN}[+] Starting Subdomain Enumeration" 

#Sublist3r

sublist3r -d $1 -v -o domains.txt

#Assetfinder

~/go/bin/assetfinder --subs-only $1 | tee -a domains.txt

#Removing duplicate entries

sort -u domains.txt -o domains.txt

#Discovering alive domains
echo -e ""
echo "[+] Checking for alive domains.."
cat domains.txt | ~/go/bin/httprobe | tee -a alive.txt

sort alive.txt | uniq -u

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
		
		if [ ! -s endpoints/$domain/$file ] ; 
		then
  			rm endpoints/$domain/$file
		fi
        done
done
##############################################################
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Aquatone to take screenshots"

mkdir screenshots

CUR_DIR=$(pwd)

cat alive.txt | aquatone -screenshot-timeout 50000 -out screenshots/
##############################################################
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Nmap Scan for alive domains"

mkdir nmapscans

for domain in $(cat domains.txt)
do
        nmap -sC -sV -v $domain | tee nmapscans/$domain
done
##############################################################
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Dirsearch to find directories"

mkdir directories

for domain in $(cat alive.txt)
do	
	NAME=$(echo $domain | awk -F/ '{print $3}')
        python3 ~/dirsearch/dirsearch.py -e php,asp,aspx,jsp,html,zip,jar -u $domain -t 100 --plain-text-report=directories/$NAME
done

#!/bin/bash

#########CONFIGURATION#########
#PARAMETERS
subjackThreads=100
subjackTime=30
gobusterDNSThreads=50
gobusterDictionaryPath=~/SecLists/Discovery/DNS/namelist.txt
aquatoneTimeout=50000
gobusterDirThreads=50
gobusterDictionaryPathDir=~/SecLists/Discovery/Web-Content/raft-medium-files-directories.txt
githubToken=YOUR GITHUB TOKEN

#COLORS
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\e[92m"

#########SUBDOMAIN ENUMERATIONS#########
echo -e "${BOLD}${GREEN}[+] Starting Subdomain Enumeration" 

#Amass
echo -e "${GREEN}[+] Starting Amass"
amass enum -norecursive -noalts -d $1 -o domains.txt

#Crt.sh
echo -e "${GREEN}[+] Starting Certsh.py"
python ~/CertificateTransparencyLogs/certsh.py -d $1 | tee -a domains.txt

#Github-Search
echo -e "${GREEN}[+] Starting Github-subdomains.py"
python3 ~/github-search/github-subdomains.py -d $1 -t $githubToken | tee -a domains.txt

#Gobuster
echo -e "${GREEN}[+] Starting Gobuster DNS"
gobuster dns -d $1 -w $gobusterDictionaryPath -t $gobusterDNSThreads -o gobusterDomains.txt
sed 's/Found: //g' gobusterDomains.txt >> domains.txt
rm gobusterDomains.txt

#Assetfinder
echo -e "${GREEN}[+] Starting Assetfinder"
~/go/bin/assetfinder --subs-only $1 | tee -a domains.txt

#Subjack
echo -e "${GREEN}[+] Starting Subjack for search subdomains takevoer"
subjack -w domains.txt -t $subjackThreads -timeout $subjackTime -ssl -c ~/subjack/fingerprints.json -v 3

#Removing duplicate entries

sort -u domains.txt -o domains.txt

#Discovering alive domains
echo -e ""
echo "[+] Checking for alive domains.."
cat domains.txt | ~/go/bin/httprobe | tee -a alive.txt

sort alive.txt | uniq -u

#Aquatone
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Aquatone to take screenshots"

mkdir screenshots

CUR_DIR=$(pwd)

cat alive.txt | aquatone -screenshot-timeout $aquatoneTimeout -out screenshots/

#Parse data jo JSON 

cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json

cat domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > domains.json

#########SUBDOMAIN HEADERS#########
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

#########JAVASCRIPT FILES#########
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

echo -e "${GREEN}[+] Starting Jsearch.py"
organitzationName= sed 's/.com//' <<< "$1" 
mkdir javascript

for domain in $(cat alive.txt)
do	
	NAME=$(echo $domain | awk -F/ '{print $3}')
	cd javascript/
	mkdir $NAME
	echo -e "${GREEN}[+] Searching JS files for $NAME"
	echo -e ""
	python3 ~/jsearch/jsearch.py -u $domain -n "$organitzationName" | tee -a $NAME.txt

	if [ -z "$(ls -A $NAME/)" ] ; 
	then
		rmdir $NAME
	fi

	if [ ! -s $NAME.txt ] ; 
	then
		rm $NAME.txt
	fi	

	cd ..
done
#########FILES AND DIRECTORIES#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Gobuster to find directories and hidden files"

mkdir directories

for domain in $(cat alive.txt)
do	
	NAME=$(echo $domain | awk -F/ '{print $3}')
	gobuster dir -u $domain -w $gobusterDictionaryPathDir -t $gobusterDirThreads -o directories/$NAME
	
	if [ ! -s directories/$NAME ] ; 
	then
		rm directories/$NAME
	fi
done
#########NMAP#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] Starting Nmap Scan for alive domains"

mkdir nmapscans

for domain in $(cat domains.txt)
do
        nmap -sC -sV -v $domain | tee nmapscans/$domain
done

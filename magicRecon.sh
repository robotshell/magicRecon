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
testsslParameters="--quiet --fast -p -s -S -h -U --color 3 --htmlfile"

#COLORS
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\033[1;32m"
MAGENTA="\e[95m"
YELLOW="\e[33m"
DEFAULT="\e[39m"

#########HELP SECTION#########
if [ "$1" == "-h" ]; then
	echo -e "${BOLD}${GREEN}[+] MagicRecon is a powerful shell script to maximize the data collection process of an objective. Has 5 steps:" 
	echo -e "${NORMAL}${GREEN}[+] STEP 1: Subdomain Enumeration"
	echo -e "${DEFAULT}${NORMAL}Amass, Certsh.py, Gobuster DNS and Assetfinder tools are used to find the maximum possible number of subdomains. httprobe is used to probe for working http and https servers. Then Subjack is used to quickly check if it exists subdomains takeover. Corsy tool is used to find CORS missconfigurations. Finally, Aquatone takes screenshots of each subdomain."
	echo -e "${NORMAL}${GREEN}[+] STEP 2: Scan for missing headers and bugs in SSL/TLS protocols" 
	echo -e "${DEFAULT}${NORMAL}securityheaders is used to check quickly and easily the security of HTTP response headers and testssl.sh is used to check the TLS/SSL ciphers, protocols and cryptographic flaws."
	echo -e "${NORMAL}${GREEN}[+] STEP 3: Scan if a domain can be spoofed" 
	echo -e "${DEFAULT}${NORMAL}spoofcheck is used to check SPF and DMARC records for weak configurations that allow spoofing."
	echo -e "${NORMAL}${GREEN}[+] STEP 4: JavaScript files and hidden endpoints"
	echo -e "${DEFAULT}${NORMAL}LinkFinder is used to discover endpoints and their parameters in JavaScript files."
	echo -e "${NORMAL}${GREEN}[+] STEP 5: Find directories and hidden files" 
	echo -e "${DEFAULT}${NORMAL}Gobuster DIR is used to collect hidden files and directories through a dictionary. You can change the dictionary in the script configuration."
	echo -e "${NORMAL}${GREEN}[+] STEP 6: Port scan for alive domains" 
	echo -e "${DEFAULT}${NORMAL}Nmap is used to scan ports and services quiclky."
	echo -e "" 
	echo -e "${BOLD}${GREEN}You have more information in https://github.com/robotshell/magicRecon"
	echo -e "" 
	echo -e "${BOLD}${YELLOW}[+] DON'T FORGET -> If you found the tool useful please consider donating to support it's development. You can help me to develop more useful tools. THANKS :)" 
	echo -e "" 
	echo -e "${BOLD}${GREEN}[+] AUTHOR: ROBOTSHELL" 
	echo -e "${BOLD}${GREEN}[+] TWITTER: https://twitter.com/robotshelld" 
  exit 0
fi

#########SUBDOMAIN ENUMERATIONS#########
printf "${MAGENTA}"
figlet "MagicRecon"
echo -e ""

echo -e ""
echo -e "${BOLD}${GREEN}[+] STEP 1: Starting Subdomain Enumeration" 

#Amass
echo -e "${BOLD}${YELLOW}[+] Starting Amass${DEFAULT}${NORMAL}"
amass enum -norecursive -noalts -d $1 -o domains.txt

#Crt.sh
echo -e "${BOLD}${YELLOW}[+] Starting Certsh.py${DEFAULT}${NORMAL}"
python ~/CertificateTransparencyLogs/certsh.py -d $1 | tee -a domains.txt

#Gobuster
echo -e "${BOLD}${YELLOW}[+] Starting Gobuster DNS${DEFAULT}${NORMAL}"
gobuster dns -d $1 -w $gobusterDictionaryPath -t $gobusterDNSThreads -o gobusterDomains.txt
sed 's/Found: //g' gobusterDomains.txt >> domains.txt
rm gobusterDomains.txt

#Assetfinder
echo -e "${BOLD}${YELLOW}[+] Starting Assetfinder${DEFAULT}${NORMAL}"
~/go/bin/assetfinder --subs-only $1 | tee -a domains.txt

#Subjack
echo -e "${BOLD}${YELLOW}[+] Starting Subjack for search subdomains takevoer${DEFAULT}${NORMAL}"
subjack -w domains.txt -t $subjackThreads -timeout $subjackTime -ssl -c ~/subjack/fingerprints.json -v 3

#Removing duplicate entries

sort -u domains.txt -o domains.txt

#Discovering alive domains
echo -e ""
echo "[+] Checking for alive domains..${DEFAULT}${NORMAL}"
cat domains.txt | ~/go/bin/httprobe | tee -a alive.txt

sort alive.txt | uniq -u

#Removing http/https protocol from alive.txt
cp alive.txt alive-subdomains.txt
sed -i 's#^http://##; s#/score/$##' alive-subdomains.txt
sed -i 's#^https://##; s#/score/$##' alive-subdomains.txt
sort -u alive-subdomains.txt -o alive-subdomains.txt

#Corsy
echo -e ""
echo -e "${BOLD}${YELLOW}[+] Starting Corsy to find CORS missconfigurations${DEFAULT}${NORMAL}"
python3 ~/Corsy/corsy.py -i alive.txt -o CORS.txt

#Aquatone
echo -e ""
echo -e "${BOLD}${YELLOW}[+] Starting Aquatone to take screenshots${DEFAULT}${NORMAL}"

if [ -d screenshots ]; then rm -Rf screenshots; fi

mkdir screenshots

CUR_DIR=$(pwd)

cat alive.txt | ~/aquatone/aquatone -screenshot-timeout $aquatoneTimeout -out screenshots/


#Parse data jo JSON 

cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json

cat domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > domains.json

cat alive-subdomains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive-subdomains.json

#########MISSING HEADERS AND SSL/TLS PROTOCOLS#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] STEP 2: Scan for missing headers and SSL/TLS protocols${DEFAULT}${NORMAL}"
echo -e "${BOLD}${YELLOW}[+] Starting securityheaders for search missing headers${DEFAULT}${NORMAL}"

#Scan for missing headers 
if [ -d headers ]; then rm -Rf headers; fi

mkdir headers

CURRENT_PATH=$(pwd)

for x in $(cat alive-subdomains.txt)
do
        NAME=$(echo $x)
	echo -e "${YELLOW}Analyzing headers to" $x
        python ~/securityheaders/securityheaders.py $x --skipcheckers InfoCollector --formatter markdown > "$CURRENT_PATH/headers/$NAME"
done

if [ -d ssl ]; then rm -Rf ssl; fi

echo -e ""

#Scan for vulns in SSL/TLS protocols
echo -e "${BOLD}${YELLOW}[+] Starting testssl.sh for search bugs in TLS/SSL ciphers, protocols and cryptographic flaws${DEFAULT}${NORMAL}"
mkdir ssl

CURRENT_PATH=$(pwd)

cd ssl/

for x in $(cat ../alive-subdomains.txt)
do
        NAMEFILE=$x
	EXTENSION=".html"
	NAMEEXTENSION="$NAMEFILE$EXTENSION"
	echo -e "${YELLOW}Analyzing SSL/TLS ciphers, protocols and cryptographic flaws to" $x
	~/testssl.sh/./testssl.sh $testsslParameters $NAMEEXTENSION $x > /dev/null

done

cd ..

#########SPF and DMARC records#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] STEP 3: Scan if a domain can be spoofed${DEFAULT}${NORMAL}"
echo -e "${BOLD}${YELLOW}[+] Starting spoofcheck for search SPF and DMARC records${DEFAULT}${NORMAL}"

if [ -d JS ]; then rm -Rf JS; fi

mkdir email

CURRENT_PATH=$(pwd)

for domain in $(cat alive-subdomains.txt)
do	
	NAMEFILE=$domain
	EXTENSION=".txt"
	NAMEEXTENSION="$NAMEFILE$EXTENSION"
	echo -e "${YELLOW}Analyzing SPF and DMARC records for weak configurations that allow spoofing to" $domain
	python ~/spoofcheck/spoofcheck.py $domain >> "$CURRENT_PATH/email/$NAMEEXTENSION"
done
#########JAVASCRIPT FILES#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] STEP 4: Collecting JavaScript files and Hidden Endpoints${DEFAULT}${NORMAL}"
echo -e "${BOLD}${YELLOW}[+] Starting LinkFinder for discover endpoints in JavaScript files${DEFAULT}${NORMAL}"

if [ -d JS ]; then rm -Rf JS; fi

mkdir JS

CURRENT_PATH=$(pwd)

for domain in $(cat alive.txt)
do	
	NAMEFILE=$(echo $domain | awk -F/ '{print $3}')
	EXTENSION=".txt"
	NAMEEXTENSION="$NAMEFILE$EXTENSION"
	echo -e "${YELLOW}Analyzing JS files for endpoints, API Keys and many more to" $domain
	python ~/LinkFinder/linkfinder.py -d -i $domain -o cli >> "$CURRENT_PATH/JS/$NAMEEXTENSION"
done

#########FILES AND DIRECTORIES#########
echo -e ""
echo -e "${BOLD}${GREEN}[+] STEP 5: Starting Gobuster to find directories and hidden files${DEFAULT}${NORMAL}"

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
echo -e "${BOLD}${GREEN}[+]STEP 6: Starting Nmap Scan for alive domains${DEFAULT}${NORMAL}"

mkdir nmapscans

for domain in $(cat domains.txt)
do
        nmap -sC -sV -v $domain | tee nmapscans/$domain
done

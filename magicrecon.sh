#!/bin/bash

. ./configuration.cfg

actualDir=$(pwd)

##############################################
############### PASSIVE RECON ################
##############################################
passive_recon(){

	printf "${BOLD}${GREEN}[*] STARTING FOOTPRINTING${NORMAL}\n\n"
	printf "${BOLD}${GREEN}[*] TARGET URL:${YELLOW} $domain ${NORMAL}\n"
	ip_adress=$(dig +short $domain)
	printf "${BOLD}${GREEN}[*] TARGET IP ADDRESS:${YELLOW} $ip_adress ${NORMAL}\n\n"
	
	domain=$1
	domainName="https://"$domain
	company=$(echo $domain | awk -F[.] '{print $1}')
	
	cd targets
	
	if [ -d $domain ]; then rm -Rf $domain; fi
	mkdir $domain
	
	cd $domain
	
	if [ -d footprinting ]; then rm -Rf footprinting; fi
	mkdir footprinting
	
	cd footprinting
	
	printf "${GREEN}[+] Checking if the target is alive...${NORMAL}\n"
	if ping -c 1 -W 1 "$domain" &> /dev/null; 
	then
		printf "\n${BOLD}${YELLOW}$domain${NORMAL} is alive!${NORMAL}\n\n"
	else
		if [ $mode == "more" ]
		then
			printf "\n${BOLD}${YELLOW}$domain${RED} is not alive.${NORMAL}\n\n"
			return
		else
			printf "\n${BOLD}${YELLOW}$domain${RED} is not alive. Aborting passive reconnaissance${NORMAL}\n\n"
			exit 1
		fi	
	fi
	
	printf "${GREEN}[+] Whois Lookup${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching domain name details, contact details of domain owner, domain name servers, netRange, domain dates, expiry records, records last updated...${NORMAL}\n\n"
	whois $domain | grep 'Domain\|Registry\|Registrar\|Updated\|Creation\|Registrant\|Name Server\|DNSSEC:\|Status\|Whois Server\|Admin\|Tech' | grep -v 'the Data in VeriSign Global Registry' | tee whois.txt
	
	printf "\n${GREEN}[+] Nslookup ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching DNS Queries...${NORMAL}\n\n"
	nslookup $domain | tee nslookup.txt
	
	printf "\n${GREEN}[+] Horizontal domain correlation/acquisitions ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching horizontal domains...${NORMAL}\n\n"
	email=$(whois $domain | grep "Registrant Email" | egrep -ho "[[:graph:]]+@[[:graph:]]+")
	curl -s -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" "https://viewdns.info/reversewhois/?q=$email" | html2text | grep -Po "[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" | tail -n +4  | head -n -1 
	
	printf "\n${GREEN}[+] ASN Lookup ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching ASN number of a company that owns the domain...${NORMAL}\n\n"
	python3 ~/tools/Asnlookup/asnlookup.py -o $company | tee -a asn.txt
	
	printf "\n${GREEN}[+] WhatWeb ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching platform, type of script, google analytics, web server platform, IP address, country, server headers, cookies...${NORMAL}\n\n"
	whatweb $domain | tee whatweb.txt
	
	printf "\n${GREEN}[+] SSL Checker ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Collecting SSL/TLS information...${NORMAL}\n\n"
	python3 ~/tools/ssl-checker/ssl_checker.py -H $domainName | tee ssl.txt
	
	printf "\n${GREEN}[+] Aquatone ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Taking screenshot...${NORMAL}\n\n"
	echo $domainName | aquatone -screenshot-timeout $aquatoneTimeout -out screenshot &> /dev/null
	
	printf "\n${GREEN}[+] TheHarvester ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching emails, subdomains, hosts, employee names...${NORMAL}\n\n"
	python3 ~/tools/theHarvester/theHarvester.py -d $domain -b all -l 500 -f theharvester.html > theharvester.txt
	printf "${NORMAL}${CYAN}Users found: ${NORMAL}\n\n"
	cat theharvester.txt | awk '/Users/,/IPs/' | sed -e '1,2d' | head -n -2 | anew -q users.txt
	cat users.txt
	printf "${NORMAL}${CYAN}IP's found: ${NORMAL}\n\n"
	cat theharvester.txt | awk '/IPs/,/Emails/' | sed -e '1,2d' | head -n -2 | anew -q ips.txt
	cat ips.txt
	printf "${NORMAL}${CYAN}Emails found: ${NORMAL}\n\n"
	cat theharvester.txt | awk '/Emails/,/Hosts/' | sed -e '1,2d' | head -n -2 | anew -q emails.txt
	cat emails.txt
	printf "${NORMAL}${CYAN}Hosts found: ${NORMAL}\n\n"
	cat theharvester.txt | awk '/Hosts/,/Trello/' | sed -e '1,2d' | head -n -2 | anew -q hosts.txt
	cat hosts.txt
	
	printf "\n${GREEN}[+] CloudEnum ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching public resources in AWS, Azure, and Google Cloud....${NORMAL}\n\n"
	key=$(echo $domain | sed s/".com"//)
	python3 ~/tools/cloud_enum/cloud_enum.py -k $key --quickscan | tee cloud.txt
		
	printf "\n${GREEN}[+] GitDorker ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching interesting data on GitHub...${NORMAL}\n\n"
	domainName="https://"$domain
	python3 ~/tools/GitDorker/GitDorker.py -t $github_token -d ~/tools/GitDorker/Dorks/alldorksv3 -q $domain -o dorks.txt
	
	if [ "$2" = true ];
	then 
		printf "\n${GREEN}[+] Whois results: ${NORMAL}\n" | notify -silent | cat whois.txt | notify -silent
		printf "\n${GREEN}[+] Nslookup results: ${NORMAL}\n" | notify -silent | cat nslookup.txt | notify -silent
		printf "\n${GREEN}[+] ASN Lookup results: ${NORMAL}\n" | notify -silent | cat asn.txt | notify -silent
		printf "\n${GREEN}[+] WhatWeb results: ${NORMAL}\n" | notify -silent | cat whatweb.txt | notify -silent
		printf "\n${GREEN}[+] SSL Checker results: ${NORMAL}\n" | notify -silent | cat ssl.txt | notify -silent
		printf "\n${GREEN}[+] TheHarvester users results: ${NORMAL}\n" | notify -silent | cat users.txt | notify -silent
		printf "\n${GREEN}[+] TheHarvester ips results: ${NORMAL}\n" | notify -silent | cat ips.txt | notify -silent
		printf "\n${GREEN}[+] TheHarvester emails results: ${NORMAL}\n" | notify -silent | cat emails.txt | notify -silent
		printf "\n${GREEN}[+] TheHarvester hosts results: ${NORMAL}\n" | notify -silent | cat hosts.txt | notify -silent
		printf "\n${GREEN}[+] CloudEnum results: ${NORMAL}\n" | notify -silent | cat cloud.txt | notify -silent
		printf "\n${GREEN}[+] GitDorker results: ${NORMAL}\n" | notify -silent | cat dorks.txt | notify -silent
		
	fi
	
	cd $actualDir
}

##############################################
############### ACTIVE RECON #################
##############################################
active_recon(){
	printf "${BOLD}${GREEN}[*] STARTING FINGERPRINTING${NORMAL}\n\n"
	printf "${BOLD}${GREEN}[*] TARGET URL:${YELLOW} $domain ${NORMAL}\n"
	ip_adress=$(dig +short $domain)
	printf "${BOLD}${GREEN}[*] TARGET IP ADDRESS:${YELLOW} $ip_adress ${NORMAL}\n\n"
	
	domain=$1
	domainName="https://"$domain
	
	cd targets
	
	if [ -d $domain ]; then rm -Rf $domain; fi
	mkdir $domain
	
	cd $domain
	
	if [ -d fingerprinting ]; then rm -Rf fingerprinting; fi
	mkdir fingerprinting
	
	cd fingerprinting
	
	printf "\n${GREEN}[+] Robots.txt ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Checking directories and files from robots.txt...${NORMAL}\n\n"
	python3 ~/tools/robotScraper/robotScraper.py -d $domain -s output_robot.txt 
	
	printf "\n${GREEN}[+] Hakrawler & gau ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Gathering URLs and JavaSript file locations...${NORMAL}\n\n"
	echo $domainName | hakrawler | tee -a paths.txt
	gau $domain >> paths.txt
	sort -u paths.txt -o paths.txt
	
	printf "\n${GREEN}[+] Arjun ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Finding query parameters for URL endpoints....${NORMAL}\n\n"
	arjun -u $domainName -oT parameters.txt
	
	printf "\n${GREEN}[+] Vulnerability: Secrets in JS${NORMAL}\n"
	printf "${NORMAL}${CYAN}Obtaining all the JavaScript files of the domain ...${NORMAL}\n\n"	
	echo $domain | gau | grep '\.js$' | httpx -mc 200 -content-type -silent | grep 'application/javascript' | awk -F '[' '{print $1}' | tee -a js.txt
	printf "\n${NORMAL}${CYAN}Discovering sensitive data like apikeys, accesstoken, authorizations, jwt, etc in JavaScript files...${NORMAL}\n\n"
	for url in $(cat js.txt);do
		python3 ~/tools/SecretFinder/SecretFinder.py --input $url -o cli | tee -a secrefinder.txt
	done
	
	printf "\n${GREEN}[+] DirSearch ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching interesting directories and files...${NORMAL}\n\n"
	sudo dirsearch -u $domain --deep-recursive --random-agent --exclude-status $excludeStatus -w $dictionary -o dirsearch
	
	printf "\n${GREEN}[+] Nmap ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching open ports...${NORMAL}\n\n"
	nmap -p- --open -T5 -v -n $domain -oN nmap.txt
	
	if [ "$2" = true ]; 
	then
		printf "\n${GREEN}[+] Robots.txt results: ${NORMAL}\n" | notify -silent | cat output_robot.txt | notify -silent
		printf "\n${GREEN}[+] Hakrawler & gau results: ${NORMAL}\n" | notify -silent | cat paths.txt | notify -silent
		printf "\n${GREEN}[+] Arjun results: ${NORMAL}\n" | notify -silent | cat parameters.txt | notify -silent
		printf "\n${GREEN}[+] Secrets in JS results: ${NORMAL}\n" | notify -silent | cat secrefinder.txt | notify -silent
		printf "\n${GREEN}[+] Dirsearch results: ${NORMAL}\n" | notify -silent | cat dirsearch | notify -silent
		printf "\n${GREEN}[+] Nmap results: ${NORMAL}\n" | notify -silent | cat nmap.txt | notify -silent		
	fi

	cd $actualDir
}

##############################################
############### ALL MODES ####################
##############################################
all(){
	passive_recon $domain
	active_recon $domain
	vulnerabilities $domain
}

##############################################
############### ALL RECON ####################
##############################################
all_recon(){
	passive_recon
	active_recon
}

##############################################
############### MASSIVE RECON ################
##############################################
massive_recon(){
	printf "${BOLD}${GREEN}[*] STARTING MASSIVE VULNERABILITY ANALYSIS${NORMAL}\n\n"
	printf "${BOLD}${GREEN}[*] WILDCARD:${YELLOW} *.$wildcard ${NORMAL}\n"
	
	if [ -d automatic_recon ]; 
	then 
		rm -Rf automatic_recon; 
	fi
	
	mkdir automatic_recon
	cd automatic_recon
	
	while true; 
	do
		subfinder -d $wildcard | anew subdomains.txt | httpx | nuclei -t ~/tools/nuclei-templates/ | notify ; sleep $massiveTime; 		
		printf "${NORMAL}${CYAN}[+] The vulnerabilities found have been notified. Waiting $massiveTime seconds for the new scan.${NORMAL}\n\n"
	done
	
	cd $actualDir	
}

##############################################
############### VULNERABILITIES ##############
##############################################
vulnerabilities(){
	
	printf "${BOLD}${GREEN}[*] STARTING VULNERABILITY SCAN${NORMAL}\n\n"
	printf "${BOLD}${GREEN}[*] TARGET URL:${YELLOW} $domain ${NORMAL}\n"
	ip_adress=$(dig +short $domain)
	printf "${BOLD}${GREEN}[*] TARGET IP ADDRESS:${YELLOW} $ip_adress ${NORMAL}\n\n"
	
	domain=$1
	domainName="https://"$domain
	
	cd targets
	
	if [ -d $domain ]; then rm -Rf $domain; fi
	mkdir $domain
	
	cd $domain
	
	if [ -d vulnerabilities ]; then rm -Rf vulnerabilities; fi
	mkdir vulnerabilities
	
	cd vulnerabilities
	
	printf "\n${GREEN}[+] Vulnerability: Missing headers${NORMAL}\n"
	printf "${NORMAL}${CYAN}Cheking security headers...${NORMAL}\n\n"
	python3 ~/tools/shcheck/shcheck.py $domainName | tee headers.txt | grep 'Missing security header:\|There are\|--'
	
	printf "\n${GREEN}[+] Vulnerability: Email spoofing ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Cheking SPF and DMARC record...${NORMAL}\n\n"
	mailspoof -d $domain | tee spoof.json
	
	printf "\n${GREEN}[+] Vulnerability: Subdomain takeover ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Checking if sub-domain is pointing to a service that has been removed or deleted...${NORMAL}\n\n"
	subjack -d $domain -ssl -v | tee takeover.txt
	
	printf "\n${GREEN}[+] Vulnerability: CORS${NORMAL}\n"
	printf "${NORMAL}${CYAN}Checking all known misconfigurations in CORS implementations...${NORMAL}\n\n"
	python3 ~/tools/Corsy/corsy.py -u $domainName | tee cors.txt
	
	printf "\n${GREEN}[+] Vulnerability: 403 bypass${NORMAL}\n"
	printf "${NORMAL}${CYAN}Gathering endpoints that they return 403 status code...${NORMAL}\n\n"
	touch endpoints_403.txt
	save_ouput=$actualDir"/targets/"$domain"/vulnerabilities/endpoints_403.txt"
	sudo dirsearch -u $domainName --random-agent --include-status 403 -w $dictionary --format plain -o $save_ouput
	printf "\n${NORMAL}${CYAN}Trying to bypass 403 status code...${NORMAL}\n\n"
	for url in $(cat endpoints_403.txt);
	do
		domainAWK=$domain":443"
		endpoint=$(echo $url | awk -F $domainAWK '{print $2}') 
		if [ -n "$endpoint" ]
		then
	      		python3 ~/tools/403bypass/4xx.py $domainName $endpoint | tee -a bypass403.txt
		fi
	done
	
	printf "\n${GREEN}[+] Vulnerability:  Cross Site Request Forgery (CSRF/XSRF)${NORMAL}\n"
	printf "${NORMAL}${CYAN}Checking all known misconfigurations in CSRF/XSRF implementations...${NORMAL}\n\n"
	python3 ~/tools/Bolt/bolt.py -u $domainName -l 2 | tee -a csrf.txt
	
	printf "\n${GREEN}[+] Vulnerability: Open Redirect${NORMAL}\n"
	printf "${NORMAL}${CYAN}Finding Open redirect entry points in the domain...${NORMAL}\n\n"
	gau $domain | gf redirect archive | qsreplace | tee or_urls.txt
	printf "\n"
	printf "${NORMAL}${CYAN}Checking if the entry points are vulnerable...${NORMAL}\n\n"
	cat or_urls.txt | qsreplace "https://google.com" | httpx -silent -status-code -location
	cat or_urls.txt | qsreplace "//google.com/" | httpx -silent -status-code -location
	cat or_urls.txt | qsreplace "//\google.com" | httpx -silent -status-code -location
	
	printf "\n${GREEN}[+] Vulnerability: SSRF${NORMAL}\n"
	printf "${NORMAL}${CYAN}Trying to find SSRF vulnerabilities...${NORMAL}\n\n"
	printf "${RED}[!] Remember to enter your Burp Collaborator link in the configuration.cfg file \n\n${NORMAL}"
	findomain -t $domain | httpx -silent -threads 1000 | gau |  grep "=" | qsreplace $burpCollaborator | tee -a ssrf.txt
	
	printf "\n${GREEN}[+] Vulnerability: XSS${NORMAL}\n"
	printf "${NORMAL}${CYAN}Trying to find XSS vulnerabilities...${NORMAL}\n\n"
	gau $domain | gf xss | sed 's/=.*/=/' | sed 's/URL: //' | dalfox pipe -o xss.txt
	
	printf "\n${GREEN}[+] Vulnerability: SQLi${NORMAL}\n"
	printf "${NORMAL}${CYAN}Finding SQLi entry points in the domain...${NORMAL}\n\n"
	gau $domain | gf sqli | tee sqli_paramaters.txt
	printf "\n"
	printf "${NORMAL}${CYAN}Checking if the entry points are vulnerable...${NORMAL}\n\n"
	sqlmap -m sqli_paramaters.txt --batch --random-agent --level 1 | tee -a sqli.txt
	
	printf "\n${GREEN}[+] Vulnerability: Multiples vulnerabilities${NORMAL}\n"
	printf "${NORMAL}${CYAN}Running multiple templates to discover vulnerabilities...${NORMAL}\n\n"
	nuclei -u $domain -t ~/tools/nuclei-templates/ -severity low,medium,high,critical -silent -o mutiple_vulnerabilities.txt
	
	if [ "$2" = true ];
	then 
		printf "\n${GREEN}[+] Missing headers results: ${NORMAL}\n" | notify -silent | cat headers.txt | notify -silent
		printf "\n${GREEN}[+] Email spoofing results: ${NORMAL}\n" | notify -silent | cat spoof.json | notify -silent
		printf "\n${GREEN}[+] Subdomain takeover results: ${NORMAL}\n" | notify -silent | cat takeover.txt | notify -silent
		printf "\n${GREEN}[+] CORS results: ${NORMAL}\n" | notify -silent | cat cors.txt | notify -silent
		printf "\n${GREEN}[+] 403 bypass results: ${NORMAL}\n" | notify -silent | cat bypass403.txt | notify -silent
		printf "\n${GREEN}[+] Cross Site Request Forgery (CSRF/XSRF) results: ${NORMAL}\n" | notify -silent | cat csrf.txt | notify -silent
		printf "\n${GREEN}[+] Open Redirect results: ${NORMAL}\n" | notify -silent | cat or_urls.txt | notify -silent
		printf "\n${GREEN}[+] SSRF results: ${NORMAL}\n" | notify -silent | cat ssrf.txt | notify -silent
		printf "\n${GREEN}[+] XSS results: ${NORMAL}\n" | notify -silent | cat xss.txt | notify -silent	
		printf "\n${GREEN}[+] SQLi results: ${NORMAL}\n" | notify -silent | cat sqli.txt | notify -silent
		printf "\n${GREEN}[+] Nuclei results: ${NORMAL}\n" | notify -silent | cat mutiple_vulnerabilities.txt | notify -silent		
	fi
	
	cd $actualDir
}

##############################################
############### WILDCARD RECON ###############
##############################################
wildcard_recon(){
	printf "${BOLD}${RED}[!] This mode does not accept any arguments${NORMAL}\n"
	printf "${BOLD}${RED}[!] A complete analysis will be carried out on all the subdomains found of the entered wildcard ${NORMAL}\n\n"
	
	printf "${BOLD}${GREEN}[*] STARTING SUBDOMAIN ENUMERATION${NORMAL}\n\n"
	printf "${BOLD}${GREEN}[*] WILDCARD:${YELLOW} *.$wildcard ${NORMAL}\n"
	
	if [ -d subdomains ]; then rm -Rf subdomains; fi
	mkdir subdomains
	cd subdomains
	
	printf "\n${GREEN}[+] Subfinder ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching subdomains...${NORMAL}\n\n"
	subfinder -silent -d $wildcard -o subdomains.txt
	
	printf "\n${GREEN}[+] Amass ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Searching subdomains with bruteforce...${NORMAL}\n\n"	
	amass enum -d $wildcard -w $dnsDictionary -o bruteforce.txt
	cat bruteforce.txt >> subdomains.txt
	rm bruteforce.txt
	sort -u subdomains.txt -o subdomains.txt
	
	printf "\n${GREEN}[+] Httpx ${NORMAL}\n"
	printf "${NORMAL}${CYAN}Checking alive subdomains...${NORMAL}\n\n"
	httpx -l subdomains.txt -silent -o alive.txt
	
	#Removing http/https word from alive.txt
	cp alive.txt alive_subdomains.txt
	sed -i 's#^http://##; s#/score/$##' alive_subdomains.txt
	sed -i 's#^https://##; s#/score/$##' alive_subdomains.txt
	sort -u alive_subdomains.txt -o alive_subdomains.txt
	
	cat alive_subdomains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json
	cat subdomains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > subdomains.json
	
	sed 's/ \+/,/g' alive_subdomains.txt > alive.csv
	sed 's/ \+/,/g' subdomains.txt > subdomains.csv
	
	mode="more"
	
	for domain in $(cat alive_subdomains.txt);do
		all $domain $more
	done
	
	cd $actualDir
}

##############################################
############### HELP SECTION #################
##############################################

help(){
	printf "\n"
	printf "${BOLD}${GREEN}USAGE${NORMAL}\n"
	printf "$0 [-d domain.com] [-w domain.com] [-l listdomains.txt]"
	printf "\n           	      [-a] [-p] [-x] [-r] [-v] [-m] [-n] [-h] \n\n"
	printf "${BOLD}${GREEN}TARGET OPTIONS${NORMAL}\n"
	printf "   -d domain.com     Target domain\n"
	printf "   -w domain.com     Wildcard domain\n"
	printf "   -l list.txt       Target list\n"
	printf " \n"
	printf "${BOLD}${GREEN}MODE OPTIONS${NORMAL}\n"
	printf "   -a, --all         All mode - Full scan with full target recognition and vulnerability scanning\n"
	printf "   -p, --passive     Passive reconnaissance (Footprinting) - Performs only passive recon with multiple tools\n"
	printf "   -x, --active      Active reconnaissance (Fingerprinting) - Performs only active recon with multiple tools\n"
	printf "   -r, --recon       Reconnaissance - Perform active and passive reconnaissance\n"
	printf "   -v, --vulnerabilities         Vulnerabilities - Check multiple vulnerabilities in the domain/list domains\n"
	printf "   -m, --massive     Massive recon - Massive vulnerability analysis with repetitions every X seconds\n"
	printf " \n"
	printf "${BOLD}${GREEN}EXTRA OPTIONS${NORMAL}\n"
	printf "   -n, --notify      Notify - This option is used to receive notifications via Discord, Telegram or Slack\n"
	printf "   -h, --help                Help - Show this help\n"
	printf " \n"
	printf "${BOLD}${GREEN}EXAMPLES${NORMAL}\n"
	printf " ${CYAN}All:${NORMAL}\n"
	printf " ./magicrecon.sh -d domain.com -a\n"
	printf " \n"
	printf " ${CYAN}Passive reconnaissance to a list of domains:${NORMAL}\n"
	printf " ./magicrecon.sh -l domainlist.txt -p\n"
	printf " \n"
	printf " ${CYAN}Active reconnaissance to a domain:${NORMAL}\n"
	printf " ./magicrecon.sh -d domain.com -x\n"
	printf " \n"
	printf " ${CYAN}Full reconnaissance:${NORMAL}\n"
	printf " ./magicrecon.sh -d domain.com -r\n"
	printf " \n"
	printf " ${CYAN}Full reconnaissance and vulnerabilities scanning:${NORMAL}\n"
	printf " ./magicrecon.sh -d domain.com -r -v\n"
	printf " \n"
	printf " ${CYAN}Full reconnaissance and vulnerabilities scanning to a wildcard:${NORMAL}\n"
	printf " ./magicrecon.sh -w domain.com \n"
	printf " \n"
	printf " ${CYAN}Massive reconnaissance and vulnerabilities scanning:${NORMAL}\n"
	printf " ./magicrecon.sh -w domain.com -m \n"

}

##############################################
###############LAUNCH SCRIPT##################
##############################################

usage(){
	printf "\n"
	printf "Usage: $0 [-d domain.com] [-w domain.com] [-l listdomains.txt]"
	printf "\n           	      [-a] [-p] [-x] [-r] [-v] [-m] [-n] [-h] \n\n"
  exit 2
}

printf "${BOLD}${YELLOW}"
figlet "MagicRecon"
printf "${BOLD}${MAGENTA}MagicRecon v.3.0 - Open Source Project | Author: Robotshell | Twitter: @robotshelld\n\n${NORMAL}"

PARSED_ARGUMENTS=$(getopt -a -n magicrecon -o "d:w:l:apxrvmnh" --long "domain:,wildcard:,list:,all,passive,active,recon,vulnerabilities,massive,notify,help" -- "$@")
VALID_ARGUMENTS=$?

if [ $VALID_ARGUMENTS != "0" ]; 
then
  usage
fi

if [ $# == 0 ]
then
    printf "${RED}[!] No arguments detected \n${NORMAL}"
    exit 1
fi

eval set -- "$PARSED_ARGUMENTS"

mode_recon=0
vulnerabilitiesMode=false
notifyMode=false

while :
do
    case "$1" in	    
		'-d' | '--domain')
			domain=$2
			shift
			shift
			continue
		;;
		'-w' | '--wildcard')
			wildcard=$2
			shift
			shift
			continue
		;;
		'-l' | '--list')
			domainList=$2
			shift
			shift
			continue
		;;
		'-a' | '--all')
			mode_recon=1
			shift
			continue
		;;
		'-p' | '--passive')
			mode_recon=2
			shift
			continue
		;;
		'-x' | '--active')
			mode_recon=3
			shift
			continue
		;;
		'-r' | '--recon')
			mode_recon=4
			shift
			continue
		;;
		'-v' | '--vulnerabilities')
			vulnerabilitiesMode=true
			shift
			continue
		;;
		'-m' | '--massive')
			mode_recon=5
			shift
			continue
		;;
		'-n' | '--notify')
			notifyMode=true
			shift
			continue
		;;
		'-h' | '--help')
			help
			exit
		;;
	        '--')
			shift
			break
	        ;;
	        *) 
        	    	printf "${RED}[!] Unexpected option: $1 - this should not happen. \n${NORMAL}"
       			usage 
       		;;
    esac
done

if [ -z "$domain" ] && [ -z "$wildcard" ] && [ -z "$domainList" ]
then
    printf "${RED}[!] Please specify a domain (-d | --domain), a wildcard (-w | --wildcard) or a list of domains(-l | --list) \n${NORMAL}"
    exit 1
fi

if [ ! -d targets ]; 
then 
	mkdir targets 
fi

if [ ! -z "$wildcard" ] && [ $mode_recon != 5 ]
then
	wildcard_recon $wildcard
	exit 1
fi

case $mode_recon in
	0)
		if [ -z "$domainList" ]
		then
			if [ $vulnerabilitiesMode == true ]
			then
				vulnerabilities $domain $notifyMode
			fi
		else
			if [ $vulnerabilitiesMode == true ]
			then
				for domain in $(cat $domainList);do
					vulnerabilities $domain $notifyMode
				done
			fi	
		fi
	;;
	1)
		if [ -z "$domainList" ]
		then
			all $domain $notifyMode
		else
			for domain in $(cat $domainList);do
				all $domain $notifyMode
			done
		fi
	;;
	2)
		if [ -z "$domainList" ]
		then
			passive_recon $domain $notifyMode $vulnerabilitiesMode
		else
			for domain in $(cat $domainList);do
				passive_recon $domain $notifyMode $vulnerabilitiesMode
			done
		fi
	;;
	3)
		if [ -z "$domainList" ]
		then
			active_recon $domain $notifyMode $vulnerabilitiesMode
		else
			for domain in $(cat $domainList);do
				active_recon $domain $notifyMode $vulnerabilitiesMode
			done
		fi
	;;
	4)
		if [ -z "$domainList" ]
		then
			all_recon $domain $notifyMode 
		else
			for domain in $(cat $domainList);do
				all_recon $domain $notifyMode 
			done
		fi
	;;
	5)
		if [ ! -z "$wildcard"  ]
		then
			massive_recon $wildcard 	    	
		else
			printf "${RED}[!] This mode only works with a wildcard (-w | --wildcard) \n${NORMAL}"
    			exit 1	
		fi
	;;
        *)
            help
            exit 1
    ;;
esac		
						

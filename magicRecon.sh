#!/bin/bash

#########CONFIGURATION#########
#PARAMETERS
gobusterDNSThreads=50
gobusterDictionaryPath=/home/kali/Tools/SecLists/Discovery/DNS/namelist.txt
aquatoneTimeout=50000
gobusterDirThreads=50
gobusterDictionaryPathDir=/home/kali/Tools/SecLists/Discovery/Web-Content/raft-medium-files.txt
testsslParameters="--quiet --fast -p -s -S -h -U --color 3 --htmlfile"
toolsPath=/home/kali/Tools

#COLORS
BOLD="\e[1m"
NORMAL="\e[0m"
GREEN="\033[1;32m"
MAGENTA="\e[95m"
YELLOW="\e[33m"
DEFAULT="\e[39m"

##############################################
#########INSTALLATION FUNCTION################
##############################################

#INSTALLATION FUNCTION
installation(){
	printf "${DEFAULT}"
	echo -e "Starting installation"
	printf "${NORMAL}"

	sudo apt-get -y update
	sudo apt-get -y upgrade

	#Installatino Python
	sudo apt-get install -y python3-pip
	sudo apt-get install -y python-pip
	sudo apt-get install -y python-dnspython

	#Installation GO
	sudo apt install -y golang

	export GOROOT=/usr/lib/go
	export GOPATH=$HOME/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

	echo "export GOROOT=/usr/lib/go" >> ~/.bashrc
	echo "export GOPATH=$HOME/go" >> ~/.bashrc
	echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc

	source ~/.bashrc

	#Install Subfinder
	GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder

	#Install HTTPX
	GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx

	#Install Notify
	GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify

	#Install nuclei
	GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

	#Install nuclei-templates, SecLists, Corsy, Security Headers, Ssl checker, SecretFinder, spoof-check, Linkfinder
	cd $HOME
	mkdir Tools
	cd Tools
	git clone https://github.com/projectdiscovery/nuclei-templates.git
	git clone https://github.com/danielmiessler/SecLists
	git clone https://github.com/s0md3v/Corsy.git
	cd Corsy
	pip3 install requests
	cd ..	
	git clone https://github.com/koenbuyens/securityheaders.git
	cd securityheaders
	pip install -r requirements.txt
	cd ..
	git clone https://github.com/narbehaj/ssl-checker
	cd ssl-checker
	pip3 install -r requirements.txt
	cd ..
	git clone https://github.com/m4ll0k/SecretFinder.git secretfinder
	cd secretfinder
        pip install -r requirements.txt
	cd ..
	git clone https://github.com/BishopFox/spoofcheck
	cd spoofcheck
	pip install -r requirements.txt
	cd ..
	git clone https://github.com/GerbenJavado/LinkFinder.git
	cd LinkFinder
	python setup.py install
	cd ..
	cd ..

	#Install GoBuster
	go get github.com/OJ/gobuster

	#Install Wfuzz
	pip install wfuzz

	#Install Aquatone
	go get -u github.com/michenriksen/aquatone

	#Install Html-tool
	go get -u github.com/tomnomnom/hacks/html-tool

	#Install waybackurls
	go get github.com/tomnomnom/waybackurls

	#Install kxss
	go get github.com/Emoe/kxss

	#Install anew
	go get -u github.com/tomnomnom/anew

	#Install qsreplace
	go get -u github.com/tomnomnom/qsreplace

	#Install urlprobe
	go get -u github.com/1ndianl33t/urlprobe
	
	#Install Gf
	go get -u github.com/tomnomnom/gf
	echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
	mkdir ~/.gf
	cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
	cd ~/.gf
	touch sqli.json
	echo -e "{
	    "flags": "-iE",
	     "patterns": [
		 "id=",
		"select=",
		"report=",
		"role=",
		"update=",
		"query=",
		"user=",
		"name=",
		"sort=",
		"where=",
		"search=",
		"params=",
		"process=",
		"row=",
		"view=",
		"table=",
		"from=",
		"sel=",
		"results=",
		"sleep=",
		"fetch=",
		"order=",
		"keyword=",
		"column=",
		"field=",
		"delete=",
		"string=",
		"number=",
		"filter="
	]
	}" >> sqli.json
	
	touch redirect.json
	echo -e "{
	    	"flags": "-iE",
	        "patterns": [
		"Lmage_url=",
		"Open=",
		"callback=",
		"cgi-bin/redirect.cgi",
		"cgi-bin/redirect.cgi?",
		"checkout=",
		"checkout_url=",
		"continue=",
		"data=",
		"dest=",
		"destination=",
		"dir=",
		"domain=",
		"feed=",
		"file=",
		"file_name=",
		"file_url=",
		"folder=",
		"folder_url=",
		"forward=",
		"from_url=",
		"go=",
		"goto=",
		"host=",
		"html=",
		"image_url=",
		"img_url=",
		"load_file=",
		"load_url=",
		"login?to=",
		"login_url=",
		"logout=",
		"navigation=",
		"next=",
		"next_page=",
		"out=",
		"page=",
		"page_url=",
		"path=",
		"port=",
		"redir=",
		"redirect=",
		"redirect_to=",
		"redirect_uri=",
		"redirect_url=",
		"reference=",
		"return=",
		"returnTo=",
		"return_path=",
		"return_to=",
		"return_url=",
		"rt=",
		"rurl=",
		"show=",
		"site=",
		"target=",
		"to=",
		"uri=",
		"url=",
		"val=",
		"validate=",
		"view=",
		"window="
		]
		}" >> redirect.json

	touch ssrf.json

	echo -e "{
	         "flags": "-iE",
	        "patterns": [
		"access=", 
		"admin=", 
		"dbg=", 
		"debug=", 
		"edit=", 
		"grant=", 
		"test=", 
		"alter=", 
		"clone=", 
		"create=", 
		"delete=", 
		"disable=", 
		"enable=", 
		"exec=", 
		"execute=", 
		"load=", 
		"make=", 
		"modify=", 
		"rename=", 
		"reset=", 
		"shell=", 
		"toggle=", 
		"adm=", 
		"root=", 
		"cfg=",
		"dest=", 
		"redirect=", 
		"uri=", 
		"path=", 
		"continue=", 
		"url=", 
		"window=", 
		"next=", 
		"data=", 
		"reference=", 
		"site=", 
		"html=", 
		"val=", 
		"validate=", 
		"domain=", 
		"callback=", 
		"return=", 
		"page=", 
		"feed=", 
		"host=", 
		"port=", 
		"to=", 
		"out=",
		"view=", 
		"dir=", 
		"show=", 
		"navigation=", 
		"open=",
		"file=",
		"document=",
		"folder=",
		"pg=",
		"php_path=",
		"style=",
		"doc=",
		"img=",
		"filename="

		]
		}" >> ssrf.json
	cd ..
	
	#Install Findomain
	cd Tools
	wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux
	chmod +x findomain-linux
	./findomain-linux
	cd ..
}

##############################################
#########AUTOMATIC RECON FUNCTIONS############
##############################################
massive_automatic_recon(){
	printf "${DEFAULT}"
	echo -e "1) First run"
	echo -e "2) Second run (find new subdomains, check alive status, scan it with nuclei and notify us the output)"
	printf "${NORMAL}"
	read -p "Choose one of the following options: " options
    	case $options in
		[1]* ) massive_automatic_recon_first_run break;;
		[2]* ) massive_automatic_recon_second_run break;;
	esac
}

massive_automatic_recon_first_run(){
	printf "${DEFAULT}"
	read -p "Enter the path of the file containing a list of domains to enumerate: " path
	read -p "Enter the update time (in seconds): " time
	printf "${NORMAL}"
	
	if [ -d automatic_recon ]; then rm -Rf automatic_recon; fi
	mkdir automatic_recon
	cd automatic_recon
	
	printf "${YELLOW}"
	echo "[+] Starting Subdomain Enumeration"
	printf "${NORMAL}"
	subfinder -silent -dL $path | anew subdomains.txt

	while true; 
		printf "${YELLOW}"
		echo "[+] Checking for alive domains and searching vulnerabilities"
		printf "${NORMAL}"
		do 
			subfinder -dL $path -all | anew subdomains.txt | httpx | nuclei -t $toolsPath/nuclei-templates/ | notify ; sleep $time; 
		printf "${YELLOW}"
		echo "[+] The vulnerabilities found have been notified. Waiting $time seconds for the new scan."
		printf "${NORMAL}"
	done
	
	cd ..

}

massive_automatic_recon_second_run(){
	printf "${DEFAULT}"
	read -p "Enter the path of the file containing a list of domains to enumerate: " path
	read -p "Enter the update time (in seconds): " time
	printf "${NORMAL}"
	
	cd automatic_recon
	
	printf "${YELLOW}"
	echo "[+] Checking for alive domains and searching vulnerabilities"
	printf "${NORMAL}"
	while true; 
		do subfinder -dL $path -all | anew subdomains.txt | httpx | nuclei -t $toolsPath/nuclei-templates/ | notify ; sleep $time; 
	done
	printf "${YELLOW}"
	echo "[+] The vulnerabilities found have been notified. Waiting $time seconds for the new scan."
	printf "${NORMAL}"
	
	cd ..
}

##############################################
######SUBDOMAIN ENUMERATION FUNCTIONS#########
##############################################
subdomain_enumeration(){
	printf "${DEFAULT}"
	echo -e "1) Scan a domain"
	echo -e "2) Scan a file containing list of domains"
	printf "${NORMAL}"
	read -p "Choose one of the following options: " options
    	case $options in
		[1]* ) domain_message break;;
		[2]* ) list_domains_message break;;
	esac
}

subdomain_enumeration_only(){
	if [ -d subdomains ]; then rm -Rf subdomains; fi
	mkdir subdomains
	cd subdomains
	
	printf "${YELLOW}"
	echo "[+] Using Subfinder for subdomain enumeration"
	printf "${NORMAL}"
	subfinder -silent -d $1 -o subdomains.txt
	
	printf "${YELLOW}"
	echo ""
	echo "[+] Using Gobuster DNS for subdomain enumeration"
	printf "${NORMAL}"
	gobuster dns -d $1 -w $gobusterDictionaryPath -t $gobusterDNSThreads -o gobusterDomains.txt
	sed 's/Found: //g' gobusterDomains.txt >> subdomains.txt
	rm gobusterDomains.txt

	more_subdomain
}

subdomain_enumeration_file(){
	if [ -d subdomains ]; then rm -Rf subdomains; fi
	mkdir subdomains
	cd subdomains
	
	printf "${YELLOW}"
	echo "[+] Using Subfinder for subdomain enumeration"
	printf "${NORMAL}"
	subfinder -silent -dL $1 -o subdomains.txt
	
	printf "${YELLOW}"
	echo ""
	echo "[+] Using Gobuster DNS for subdomain enumeration"
	printf "${NORMAL}"

	for domain in $(cat $1)
	do	
		gobuster dns -d $domain -w $gobusterDictionaryPath -t $gobusterDNSThreads -o gobusterDomains.txt
	done

	more_subdomain

}

domain_message(){
	printf "${NORMAL}"
	read -p "Enter a domain: " domain
	printf "${YELLOW}"
	echo "[+] Starting Subdomain Enumeration"
	printf "${NORMAL}"
	
	subdomain_enumeration_only $domain
}


list_domains_message(){
	printf "${NORMAL}"
	read -p "Enter the path of the file containing a list of domains: " list_domains

	printf "${YELLOW}"
	echo ""
	echo "[+] Starting Subdomain Enumeration"
	printf "${NORMAL}"

	subdomain_enumeration_file $list_domains
}

more_subdomain(){
	printf "${YELLOW}"
	echo ""
	echo "[+] Checking for alive domains..."
	printf "${NORMAL}"
	httpx -l subdomains.txt -silent -o alive.txt

	#Removing http/https protocol from alive.txt
	cp alive.txt alive-subdomains.txt
	sed -i 's#^http://##; s#/score/$##' alive-subdomains.txt
	sed -i 's#^https://##; s#/score/$##' alive-subdomains.txt
	sort -u alive-subdomains.txt -o alive-subdomains.txt
	
	if [ -d screenshots ]; then rm -Rf screenshots; fi
	mkdir screenshots
	
	printf "${YELLOW}"
	echo ""
	echo -e "[+] Starting Aquatone to take screenshots"
	printf "${NORMAL}"
	cat alive.txt | aquatone -screenshot-timeout $aquatoneTimeout -out screenshots/

	#Parse data jo JSON 
	printf "${YELLOW}"
	echo ""
	echo "[+] Converting retrieved data to JSON..."
	printf "${NORMAL}"
	cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive.json
	cat subdomains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > subdomains.json
	cat alive-subdomains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > alive-subdomains.json
	
	printf "${YELLOW}"
	echo "[+] Success"
	printf "${NORMAL}"
	cd ..
}

##############################################
###################NUCLEI#####################
##############################################
vulnerabilities_nuclei(){
	if [ -d nuclei ]; then rm -Rf nuclei; fi
	mkdir nuclei
	cd nuclei
	domains=../subdomains/alive.txt

	printf "${YELLOW}"
	echo -e ""
	echo -e "[+] Using Nuclei to search for vulnerabilities "
	printf "${NORMAL}"	
	
	nuclei -l $domains -t $toolsPath/nuclei-templates -o nuclei.txt
}
##############################################
#####COMMON VULNERABILITIES FUNCTIONS#########
##############################################
vulnerabilities(){
	if [ -d vulnerabilities ]; then rm -Rf vulnerabilities; fi
	mkdir vulnerabilities
	cd vulnerabilities
	domains=../subdomains/alive.txt
	domainsAux=../subdomains/alive-subdomains.txt
	domainsAux2=../../subdomains/alive.txt
	domainsAuxAA=../../../subdomains/alive.txt
	domainsAux3=../../subdomains/alive-subdomains.txt
	
	printf "${YELLOW}"
	echo ""
	echo "[+] Starting the vulnerability scan"
	printf "${NORMAL}"
	
	#Searching for missing headers
	printf "${YELLOW}"
	echo -e "[+] Starting securityheaders for search missing headers"
	printf "${NORMAL}"
	
	if [ -d headers ]; then rm -Rf headers; fi
	mkdir headers
	cd headers
	
	for x in $(cat $domainsAux2)
	do	
		NAMEFILE=$(echo $x | awk -F/ '{print $3}')
		printf "${NORMAL}"
		echo "Analyzing headers to" $x
		python3 $toolsPath/securityheaders/securityheaders.py $x --skipcheckers InfoCollector --formatter markdown --file $NAMEFILE
	done
	cd ..
	
	# Searching for invalid certificates
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting SSL Checker for collects SSL/TLS information"
	printf "${NORMAL}"
	
	if [ -d ssl ]; then rm -Rf ssl; fi
	mkdir ssl
	cd ssl
	
	for x in $(cat $domainsAux2)
	do	
		NAMEFILE=$(echo $x | awk -F/ '{print $3}')
		EXTENSION=".txt"
		NAMEEXTENSION="$NAMEFILE$EXTENSION"
		printf "${NORMAL}"
		echo "Analyzing SSL certificate to" $x
		python3 $toolsPath/ssl-checker/./ssl_checker.py -H $x > $NAMEEXTENSION

	done
	cd ..

	# Extract urls from source code comments
	if [ -d comments ]; then rm -Rf comments; fi
	mkdir comments
	cd comments
	
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting html-tool with others tools to extracting urls from source code comments"
	printf "${NORMAL}"

	cat $domainsAux2 | html-tool comments | grep -oE '\b(https?|http)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' > urls.txt
	
	printf "${YELLOW}"
	echo "[+] Success"
	printf "${NORMAL}"
	
	cd ..

	#Search Open Redirect
	if [ -d open_redirect ]; then rm -Rf open_redirect; fi
	mkdir open_redirect
	cd open_redirect
	
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Searching possible open redirect vulnerabilities"
	printf "${NORMAL}"

	cat $domainsAux2  | waybackurls | httpx -silent -timeout 2 -threads 100 | gf redirect | anew | qsreplace google.com | urlprobe -c 1000 -t 05 | tee -a openredirect.txt

	cd ..

	#Search param XSS
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting Kxss with others tools to search XSS parameters"
	printf "${NORMAL}"
	
	if [ -d XSS ]; then rm -Rf XSS; fi
	mkdir XSS
	cd XSS
	
	for x in $(cat $domainsAux2)
	do	
		NAMEFILE=$(echo $x | awk -F/ '{print $3}')
		EXTENSION=".txt"
		NAMEEXTENSION="$NAMEFILE$EXTENSION"
		printf "${NORMAL}"
		echo "Searching XSS parameters to " $x
		echo $x | waybackurls | kxss | tee -a $NAMEEXTENSION
		if [ ! -s $NAMEEXTENSION ] ; then
			echo "[X] No XSS parameters found"
			rm $NAMEEXTENSION
		else
			echo "[✓] XSS parameters found!"
		fi
	done

	cd ..

	#Search SQLi
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting Sqlmap with others tools to search possible SQLi"
	printf "${NORMAL}"

	if [ -d SQLi ]; then rm -Rf SQLi; fi
	mkdir SQLi
	cd SQLi

	cat $domainsAux2 | httpx -silent | anew | waybackurls | gf sqli >> sqli ; sqlmap -m sqli -batch --random-agent --level 1 | tee -a sqlinjection.txt

	cd ..

	#Search SSRF
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Searching possible SSRF vulnerabilities"
	printf "${NORMAL}"

	if [ -d SSRF ]; then rm -Rf SSRF; fi
	mkdir SSRF
	cd SSRF
	
	cat $domainsAux2  | httpx -silent -status-code | grep 200 | cut -d [ -f1 | tee targets.txt | waybackurls | gf ssrf | tee -a ssrf.txt

	cd ..

	# Check CORS missconfigurations
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting Corsy to find CORS missconfigurations"
	printf "${NORMAL}"
	python3 $toolsPath/Corsy/corsy.py -i $domains -o CORS.txt

	#File and directories scan
	files_list_domains $domainsAux2

	#Analyzing JS files
	javascript_list_domains $domainsAux2
	
	cd ..
}

##############################################
########JAVASCRIPT FILES FUNCTIONS############
##############################################
javascript(){
	printf "${DEFAULT}"
	echo -e "1) Scan a domain"
	echo -e "2) Scan a file containing list of domains"
	printf "${NORMAL}"
	read -p "Choose one of the following options: " options
    	case $options in
		[1]* ) javascript_domain_message break;;
		[2]* ) javascript_list_domains_message  break;;
	esac
}
javascript_domain(){	
	if [ -d JS ]; then rm -Rf JS; fi
	mkdir JS
	cd JS

	domainName="https://"$1
	printf "${YELLOW}"
	echo -e "Analyzing JS files for endpoints, API Keys and many more to" $1
	printf "${NORMAL}"

	python3 $toolsPath/LinkFinder/linkfinder.py -i $domainName -o cli >> "endpoints_$1.txt"
	python3 $toolsPath/secretfinder/SecretFinder.py -i $domainName -o cli >> "keys_$1.txt"

	printf "${YELLOW}"
	echo -e "[✓] Finished scanning of JS files for" $1
	printf "${NORMAL}"

	cd ..
}

javascript_list_domains(){
	if [ -d JS ]; then rm -Rf JS; fi
	mkdir JS
	cd JS

	for domain in $(cat $1)
	do	
		EXTENSION=".txt"
		NAMEEXTENSION="$domain$EXTENSION"

		printf "${YELLOW}"
		echo -e "Analyzing JS files for endpoints, API Keys and many more to" $domain
		printf "${NORMAL}"

		domainName="https://"$domain

		python3 $toolsPath/LinkFinder/linkfinder.py -i $domainName -o cli >> "endpoints_$NAMEEXTENSION"
		python3 $toolsPath/secretfinder/SecretFinder.py -i $domainName -o cli >> "keys_$NAMEEXTENSION"

		printf "${YELLOW}"
		echo -e "[✓] Finished scanning of JS files for" $domain
		printf "${NORMAL}"
	done

	cd ..
}

javascript_domain_message(){
	printf "${NORMAL}"
	read -p "Enter a domain (without https://): " domain
	
	javascript_domain $domain
}

javascript_list_domains_message(){
	printf "${NORMAL}"
	read -p "Enter the path of the file containing a list of domains (without https://): " list_domains
	
	javascript_list_domains $list_domains
}

##############################################
######FILES AND DIRECTORIES FUNCTIONS#########
##############################################
files_directories(){

	printf "${DEFAULT}"
	echo -e "1) Scan a domain"
	echo -e "2) Scan a file containing list of domains"
	printf "${NORMAL}"
	read -p "Choose one of the following options: " options
    	case $options in
		[1]* ) files_domain_message break;;
		[2]* ) files_list_domains_message  break;;
	esac
}

files_domain_message(){
	printf "${NORMAL}"
	read -p "Enter a domain (without https://): " domain
	printf "${YELLOW}"
	echo -e "Starting Wfuzz to find directories and juicy files" $domain
	printf "${NORMAL}"
	domainName="https://"$domain
	
	files_domain $domainName	
}

files_domain(){
	if [ -d directories ]; then rm -Rf directories; fi
	mkdir directories
	cd directories
	
	domain=$(echo $1 | awk -F/ '{print $3}')
	wfuzz -c -w $gobusterDictionaryPathDir --hc 404 -f $domain $domain/FUZZ
	
	cd ..
}

files_list_domains_message(){
	printf "${NORMAL}"
	read -p "Enter the path of the file containing list of domains: " list_domains
	printf "${YELLOW}"
	echo -e "Starting Wfuzz to find directories and juicy files" $domain
	printf "${NORMAL}"
	
	files_list_domains $list_domains
}

files_list_domains(){
	
	if [ -d directories ]; then rm -Rf directories; fi
	mkdir directories
	cd directories

	for domain in $(cat $1)
	do	
		domainName="https://"$domain
		wfuzz -c -w $gobusterDictionaryPathDir --hc 404 -f $domain $domainName/FUZZ
	done

	cd ..
}

spoof_check(){
	#Search SQLi
	echo -e ""
	printf "${YELLOW}"
	echo -e "[+] Starting spoofcheck for search SPF and DMARC records"
	printf "${NORMAL}"

	if [ -d Spoof ]; then rm -Rf Spoof; fi
	mkdir Spoof
	cd Spoof
	
	printf "${YELLOW}"
	echo -e "Analyzing SPF and DMARC records for weak configurations that allow spoofing to" $1
	printf "${NORMAL}"
	python $toolsPath/spoofcheck/spoofcheck.py $1 >> "spoofcheck_$1.txt"
	
	cd ..
	
}

all_in_one(){
	printf "${NORMAL}"
	read -p "Enter a domain (without https://): " domain
	
	subdomain_enumeration_only $domain
	spoof_check $domain
	vulnerabilities
	vulnerabilities_nuclei
}

##############################################
###############MENU FUNCTION##################
##############################################
menu () {
	printf "${MAGENTA}"
	figlet "MagicRecon"
	echo -e ""

	while true; do
	    printf "${GREEN}"
	    echo -e "MENU"
	    echo -e "1) Install dependencies"
	    echo -e "2) Massive vulnerability analysis with notifications via Discord, Telegram or Slack"
	    echo -e "3) Subdomain enumeration"
            echo -e "4) Subdomain enumeration and vulnerability scanning with nuclei"
	    echo -e "5) Subdomain enumeration with common vulnerabilities scanning"
	    echo -e "6) Scan for javascript files"
	    echo -e "7) Scan for files and directoires"
	    echo -e "8) All in one! (original MagicRecon)"
	    echo -e "q) Exit"
	    printf "${NORMAL}"
	    read -p "Choose a option: " op
	    case $op in
		[1]* ) installation break;;
		[2]* ) massive_automatic_recon break;;
		[3]* ) subdomain_enumeration break;;
		[4]* ) subdomain_enumeration; vulnerabilities_nuclei break;;
		[5]* ) subdomain_enumeration; vulnerabilities break;;
		[6]* ) javascript break;;
		[7]* ) files_directories break;;
		[8]* ) all_in_one break;;  
		[qQ]* ) exit;;      
		* ) echo "Choose a option: ";;
	    esac
	done
}

#LAUNCH SCRIPT
menu

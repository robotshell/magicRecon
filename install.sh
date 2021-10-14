#!/bin/bash

. ./configuration.cfg

printf "${BOLD}${YELLOW}##########################################################\n"
printf "##### Welcome to the MagicRecon dependency installer #####\n"
printf "##########################################################\n\n${NORMAL}"

sudo apt-get -y update

printf "${BOLD}${MAGENTA}Installing programming languages\n${NORMAL}"
 
printf "${CYAN}Installing Python\n${NORMAL}"
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get install -y dnspython

printf "${CYAN}Installing GO\n\n${NORMAL}"
sudo apt install -y golang
export GOROOT=/usr/lib/go
export GOPATH=~/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

echo "export GOROOT=/usr/lib/go" >> ~/.bashrc
echo "export GOPATH=~/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc

source ~/.bashrc

printf "${CYAN}Installing Cargo\n\n${NORMAL}"
sudo apt install cargo

printf "${CYAN}Installing html2text\n\n${NORMAL}"
sudo apt install html2text

printf "${BOLD}${MAGENTA}Installing repositories\n${NORMAL}"
cd $HOME
mkdir tools
cd tools

printf "${CYAN}Cloning ASNLookup\n${NORMAL}"
git clone https://github.com/yassineaboukir/Asnlookup
cd Asnlookup
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning ssl-checker\n${NORMAL}"
git clone https://github.com/narbehaj/ssl-checker
cd ssl-checker
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning CloudEnum\n${NORMAL}"
git clone https://github.com/initstring/cloud_enum
cd cloud_enum
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning GitDorker\n${NORMAL}"
git clone https://github.com/obheda12/GitDorker
cd GitDorker
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning RobotScraper\n${NORMAL}"
git clone https://github.com/robotshell/robotScraper.git

printf "${CYAN}Install Arjun\n${NORMAL}"
pip3 install arjun

printf "${CYAN}Cloning nuclei-templates\n${NORMAL}"
git clone https://github.com/projectdiscovery/nuclei-templates.git
	
printf "${CYAN}Cloning SecLists\n${NORMAL}"
git clone https://github.com/danielmiessler/SecLists

printf "${CYAN}Cloning Corsy\n${NORMAL}"
git clone https://github.com/s0md3v/Corsy.git
cd Corsy
pip3 install requests
cd ..	

printf "${CYAN}Cloning SecretFinder\n${NORMAL}"
git clone https://github.com/m4ll0k/SecretFinder.git secretfinder
cd secretfinder
pip install -r requirements.txt
cd ..

printf "${CYAN}Cloning CMSeek\n${NORMAL}"
git clone https://github.com/Tuhinshubhra/CMSeeK
cd CMSeeK
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning Findomain\n${NORMAL}"
git clone https://github.com/findomain/findomain.git
cd findomain
cargo build --release
sudo cp target/release/findomain /usr/bin/
cd ..

printf "${CYAN}Cloning anti-burl\n${NORMAL}"
git clone https://github.com/tomnomnom/hacks
cd hacks/anti-burl/
go build main.go
sudo mv main ~/go/bin/anti-burl
cd ..

printf "${CYAN}Cloning XSRFProbe\n${NORMAL}"
git clone https://github.com/s0md3v/Bolt
cd Bolt
pip3 install -r requirements.txt
cd ..

printf "${CYAN}Cloning Gf-Patterns\n${NORMAL}"
git clone https://github.com/1ndianl33t/Gf-Patterns
mkdir ~/.gf
cp -r Gf-Patterns/* ~/.gf
cd ..
cd ..

	
printf "${BOLD}${MAGENTA}Installing tools\n${NORMAL}"

printf "${CYAN}Installing WhatWeb\n\n${NORMAL}"
sudo apt-get install whatweb

printf "${CYAN}Installing TheHarvester\n\n${NORMAL}"
sudo apt-get install theharvester

printf "${CYAN}Installing Nmap\n\n${NORMAL}"
sudo apt-get install nmap

printf "${CYAN}Installing Dirsearch\n\n${NORMAL}"
sudo apt-get install dirsearch

printf "${CYAN}Installing SqlMap\n\n${NORMAL}"
sudo apt-get install sqlmap 

printf "${CYAN}Installing Amass\n${NORMAL}"
go get -v github.com/OWASP/Amass/v3/..
sudo cp ~/go/bin/amass /usr/local/bin 

printf "${CYAN}Installing Aquatone\n${NORMAL}"
go get -u github.com/michenriksen/aquatone
sudo cp ~/go/bin/aquatone /usr/local/bin 

printf "${CYAN}Installing Subfinder\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
sudo cp ~/go/bin/subfinder /usr/local/bin 

printf "${CYAN}Installing Hakrawler\n${NORMAL}"
go install github.com/hakluke/hakrawler@latest
sudo cp ~/go/bin/hakrawler /usr/local/bin 

printf "${CYAN}Installing anew\n${NORMAL}"
go get -u github.com/tomnomnom/anew
sudo cp ~/go/bin/anew /usr/local/bin 

printf "${CYAN}Installing HTTPX\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx
sudo cp ~/go/bin/httpx /usr/local/bin

printf "${CYAN}Installing Notify\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify
sudo cp ~/go/bin/notify /usr/local/bin

printf "${CYAN}Installing Nuclei\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
sudo cp ~/go/bin/nuclei /usr/local/bin

printf "${CYAN}Installing Shcheck\n${NORMAL}"
git clone https://github.com/santoru/shcheck

printf "${CYAN}Installing MailSpoof\n${NORMAL}"
sudo pip3 install mailspoof

printf "${CYAN}Installing MailSpoof\n${NORMAL}"
go get github.com/haccer/subjack
sudo cp ~/go/bin/subjack /usr/local/bin

printf "${CYAN}Installing gau\n${NORMAL}"
GO111MODULE=on go get -u -v github.com/lc/gau
sudo cp ~/go/bin/gau /usr/local/bin

printf "${CYAN}Installing gf\n${NORMAL}"
go get -u github.com/tomnomnom/gf
echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
sudo cp ~/go/bin/gf /usr/local/bin

printf "${CYAN}Installing qsreplace\n${NORMAL}"
go get -u github.com/tomnomnom/qsreplace
sudo cp ~/go/bin/qsreplace /usr/local/bin

printf "${CYAN}Installing Dalfox\n${NORMAL}"
GO111MODULE=on go get -v github.com/hahwul/dalfox/v2
sudo cp ~/go/bin/dalfox /usr/local/bin

printf "${CYAN}Installing html-tool\n${NORMAL}"
go get -u github.com/tomnomnom/hacks/html-tool
sudo cp ~/go/bin/html-tool /usr/local/bin

printf "${CYAN}Installing waybackurls\n${NORMAL}"
go get github.com/tomnomnom/waybackurls

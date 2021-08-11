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
sudo apt-get install -y python-dnspython

printf "${CYAN}Installing GO\n\n${NORMAL}"
sudo apt install -y golang
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

echo "export GOROOT=/usr/lib/go" >> ~/.bashrc
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc

source ~/.bashrc

printf "${BOLD}${MAGENTA}Installing repositories\n${NORMAL}"
cd $HOME
mkdir Tools
cd Tools

printf "${CYAN}Cloning nuclei-templates\n${NORMAL}"
git clone https://github.com/projectdiscovery/nuclei-templates.git
	
printf "${CYAN}Cloning SecLists\n${NORMAL}"
git clone https://github.com/danielmiessler/SecLists

printf "${CYAN}Cloning Corsy\n${NORMAL}"
git clone https://github.com/s0md3v/Corsy.git
cd Corsy
pip3 install requests
cd ..	

printf "${CYAN}Cloning securityheaders\n${NORMAL}"
git clone https://github.com/koenbuyens/securityheaders.git
cd securityheaders
pip install -r requirements.txt
cd ..

printf "${CYAN}Cloning ssl-checker\n${NORMAL}"
git clone https://github.com/narbehaj/ssl-checker
cd ssl-checker
pip3 install -r requirements.txt
cd ..
	
printf "${CYAN}Cloning secretfinder\n${NORMAL}"
git clone https://github.com/m4ll0k/SecretFinder.git secretfinder
cd secretfinder
pip install -r requirements.txt
cd ..

printf "${CYAN}Cloning spoofcheck\n${NORMAL}"
git clone https://github.com/BishopFox/spoofcheck
cd spoofcheck
pip install -r requirements.txt
cd ..

printf "${CYAN}Cloning LinkFinder\n${NORMAL}"
git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
python setup.py install
cd ..

printf "${CYAN}Cloning Bug-Bounty-Toolz\n${NORMAL}"
git clone https://github.com/m4ll0k/Bug-Bounty-Toolz

printf "${CYAN}Cloning anti-burl\n${NORMAL}"
git clone https://github.com/tomnomnom/hacks
cd hacks/anti-burl/
go build main.go
sudo mv main ~/go/bin/anti-burl
cd ..

printf "${CYAN}Cloning Gf-Patterns\n${NORMAL}"
git clone https://github.com/1ndianl33t/Gf-Patterns
mkdir ~/.gf
cp -r Gf-Patterns/* ~/.gf
cd ..
cd ..
	
printf "${BOLD}${MAGENTA}Installing tools\n${NORMAL}"

printf "${CYAN}Installing Gosipder\n${NORMAL}"
sudo apt install gospider 

printf "${CYAN}Installing Subfinder\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder

printf "${CYAN}Installing HTTPX\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx

printf "${CYAN}Installing Notify\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify

printf "${CYAN}Installing Nuclei\n${NORMAL}"
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

printf "${CYAN}Installing gau\n${NORMAL}"
GO111MODULE=on go get -u -v github.com/lc/gau

printf "${CYAN}Installing GoBuster\n${NORMAL}"
go get github.com/OJ/gobuster

printf "${CYAN}Installing Wfuzz\n${NORMAL}"
pip install wfuzz

printf "${CYAN}Installing Aquatone\n${NORMAL}"
go get -u github.com/michenriksen/aquatone

printf "${CYAN}Installing html-tool\n${NORMAL}"
go get -u github.com/tomnomnom/hacks/html-tool

printf "${CYAN}Installing waybackurls\n${NORMAL}"
go get github.com/tomnomnom/waybackurls

printf "${CYAN}Installing kxss\n${NORMAL}"
go get github.com/Emoe/kxss

printf "${CYAN}Installing anew\n${NORMAL}"
go get -u github.com/tomnomnom/anew

printf "${CYAN}Installing qsreplace\n${NORMAL}"
go get -u github.com/tomnomnom/qsreplace

printf "${CYAN}Installing urlprobe\n${NORMAL}"
go get -u github.com/1ndianl33t/urlprobe

printf "${CYAN}Installing gf\n${NORMAL}"
go get -u github.com/tomnomnom/gf
echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf

printf "${CYAN}Installing rush\n${NORMAL}"
go get -u github.com/shenwei356/rush/


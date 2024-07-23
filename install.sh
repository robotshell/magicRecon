#!/bin/bash

. ./configuration.cfg

BOLD=$(tput bold)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)

printf "${BOLD}${YELLOW}##########################################################\n"
printf "##### Welcome to the MagicRecon dependency installer #####\n"
printf "##########################################################\n\n${NORMAL}"

sudo apt-get -y update

printf "${BOLD}${MAGENTA}Installing programming languages and essential packages\n${NORMAL}"
sudo apt-get install -y python3-pip dnspython golang cargo html2text whatweb theharvester nmap dirsearch sqlmap cargo subjack

printf "${BOLD}${MAGENTA}Cloning repositories and installing dependencies\n${NORMAL}"
cd $HOME
mkdir -p tools
cd tools

declare -A REPOS=(
  ["Asnlookup"]="https://github.com/yassineaboukir/Asnlookup"
  ["ssl-checker"]="https://github.com/narbehaj/ssl-checker"
  ["cloud_enum"]="https://github.com/initstring/cloud_enum"
  ["GitDorker"]="https://github.com/obheda12/GitDorker"
  ["robotScraper"]="https://github.com/robotshell/robotScraper.git"
  ["nuclei-templates"]="https://github.com/projectdiscovery/nuclei-templates.git"
  ["SecLists"]="https://github.com/danielmiessler/SecLists"
  ["Corsy"]="https://github.com/s0md3v/Corsy.git"
  ["SecretFinder"]="https://github.com/m4ll0k/SecretFinder.git"
  ["CMSeeK"]="https://github.com/Tuhinshubhra/CMSeeK"
  ["findomain"]="https://github.com/findomain/findomain.git"
  ["hacks"]="https://github.com/tomnomnom/hacks"
  ["Bolt"]="https://github.com/s0md3v/Bolt"
  ["Gf-Patterns"]="https://github.com/1ndianl33t/Gf-Patterns"
)

for repo in "${!REPOS[@]}"; do
  printf "${CYAN}Cloning ${repo}\n${NORMAL}"
  git clone "${REPOS[$repo]}"
  cd "$repo"
  if [ -f requirements.txt ]; then
    pip3 install -r requirements.txt --break-system-packages
  fi
  cd ..
done

pip3 install arjun

printf "${CYAN}Building findomain\n${NORMAL}"
cd findomain
cargo build --release
sudo cp target/release/findomain /usr/bin/
cd ..

printf "${CYAN}Building anti-burl\n${NORMAL}"
cd hacks/anti-burl/
go build main.go
sudo mv main ~/go/bin/anti-burl
cd ../..

mkdir -p ~/.gf
cp -r Gf-Patterns/* ~/.gf

printf "${BOLD}${MAGENTA}Installing GO tools\n${NORMAL}"
declare -a GO_TOOLS=(
  "github.com/OWASP/Amass/v3/..."
  "github.com/michenriksen/aquatone"
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
  "github.com/hakluke/hakrawler"
  "github.com/tomnomnom/anew"
  "github.com/projectdiscovery/httpx/cmd/httpx"
  "github.com/projectdiscovery/notify/cmd/notify"
  "github.com/projectdiscovery/nuclei/v2/cmd/nuclei"
  "github.com/lc/gau"
  "github.com/tomnomnom/gf"
  "github.com/tomnomnom/qsreplace"
  "github.com/hahwul/dalfox/v2"
  "github.com/tomnomnom/hacks/html-tool"
  "github.com/tomnomnom/waybackurls"
)

for tool in "${GO_TOOLS[@]}"; do
  printf "${CYAN}Installing $(basename $tool)\n${NORMAL}"
  go install "$tool@latest"
  sudo cp "$HOME/go/bin/$(basename $tool)" /usr/local/bin/
done

echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
cp -r ~/go/src/github.com/tomnomnom/gf/examples ~/.gf

printf "${CYAN}Installing MailSpoof\n${NORMAL}"
sudo pip3 install mailspoof

printf "${CYAN}Installing Shcheck\n${NORMAL}"
git clone https://github.com/santoru/shcheck

printf "${BOLD}${YELLOW}Installation completed successfully!\n${NORMAL}"

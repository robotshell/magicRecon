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
sudo apt-get install -y \
python3-pip \
python3-venv \
python3-dnspython \
golang-go \
cargo \
rustc \
html2text \
whatweb \
theharvester \
nmap \
dirsearch \
sqlmap \
jq \
curl \
wget \
git

printf "${BOLD}${MAGENTA}Cloning repositories and installing dependencies\n${NORMAL}"
cd "$HOME"
mkdir -p tools
cd tools

declare -A REPOS=(
  ["Asnlookup"]="https://github.com/fang0654/Asnlookup.git"
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
  if [ ! -d "$repo" ]; then
    git clone "${REPOS[$repo]}"
  fi
  cd "$repo"
  if [ -f requirements.txt ]; then
    python3 -m pip install -r requirements.txt --break-system-packages --ignore-installed
  fi
  cd ..
done

python3 -m pip install arjun --break-system-packages --ignore-installed

printf "${CYAN}Building findomain\n${NORMAL}"
cd findomain
if command -v cargo >/dev/null; then
  cargo build --release
  sudo cp target/release/findomain /usr/local/bin/
fi
cd ..

printf "${CYAN}Building anti-burl\n${NORMAL}"
cd hacks/anti-burl/
go build main.go
mkdir -p ~/go/bin
mv main ~/go/bin/anti-burl
sudo cp ~/go/bin/anti-burl /usr/local/bin/
cd ../..

# ---- gf patterns / examples / shell completion ----
printf "${CYAN}Setting up gf patterns\n${NORMAL}"
mkdir -p ~/.gf
cp -r Gf-Patterns/* ~/.gf

GF_TMP=$(mktemp -d)
if git clone --depth 1 https://github.com/tomnomnom/gf "$GF_TMP/gf"; then
  [ -d "$GF_TMP/gf/examples" ] && cp -r "$GF_TMP/gf/examples" ~/.gf
  if [ -f "$GF_TMP/gf/gf-completion.bash" ]; then
    cp "$GF_TMP/gf/gf-completion.bash" ~/.gf/
    grep -qxF 'source ~/.gf/gf-completion.bash' ~/.bashrc 2>/dev/null || \
      echo 'source ~/.gf/gf-completion.bash' >> ~/.bashrc
  fi
else
  printf "Could not clone gf repo for examples/completion, skipping.\n"
fi
rm -rf "$GF_TMP"

# ---- Amass ----
printf "${CYAN}Installing Amass v5.1.1\n${NORMAL}"
AMASS_TMP=$(mktemp -d)
if wget -q -O "$AMASS_TMP/amass.tar.gz" \
    https://github.com/owasp-amass/amass/releases/download/v5.1.1/amass_linux_amd64.tar.gz; then
  tar -xzf "$AMASS_TMP/amass.tar.gz" -C "$AMASS_TMP"
  AMASS_BIN=$(find "$AMASS_TMP" -type f -iname amass | head -n1)
  if [ -n "$AMASS_BIN" ]; then
    sudo cp "$AMASS_BIN" /usr/local/bin/amass
    sudo chmod +x /usr/local/bin/amass
  else
    printf "Amass binary not found inside the archive, skipping.\n"
  fi
else
  printf "Amass download failed (asset name may have changed upstream), skipping.\n"
fi
rm -rf "$AMASS_TMP"

# ---- Go tools ----
printf "${BOLD}${MAGENTA}Installing GO tools\n${NORMAL}"
declare -a GO_TOOLS=(
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder|subfinder"
  "github.com/hakluke/hakrawler|hakrawler"
  "github.com/tomnomnom/anew|anew"
  "github.com/projectdiscovery/httpx/cmd/httpx|httpx"
  "github.com/projectdiscovery/notify/cmd/notify|notify"
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei|nuclei"
  "github.com/lc/gau|gau"
  "github.com/tomnomnom/gf|gf"
  "github.com/tomnomnom/qsreplace|qsreplace"
  "github.com/hahwul/dalfox/v2|dalfox"
  "github.com/tomnomnom/hacks/html-tool|html-tool"
  "github.com/tomnomnom/waybackurls|waybackurls"
)

mkdir -p ~/go/bin

for entry in "${GO_TOOLS[@]}"; do
  module="${entry%%|*}"
  binary="${entry##*|}"

  printf "${CYAN}Installing ${binary}\n${NORMAL}"
  go install "${module}@latest"

  if [ -f "$HOME/go/bin/$binary" ]; then
    sudo cp "$HOME/go/bin/$binary" /usr/local/bin/
  else
    printf "Warning: %s binary not found at ~/go/bin after install, skipping copy.\n" "$binary"
  fi
done

printf "${CYAN}Installing MailSpoof (isolated, to avoid downgrading system requests/dnspython/idna)\n${NORMAL}"
if ! command -v pipx >/dev/null; then
  sudo apt-get install -y pipx
fi
pipx install mailspoof || pipx install --force mailspoof
pipx ensurepath >/dev/null 2>&1 || true

printf "${CYAN}Installing Shcheck\n${NORMAL}"
if [ ! -d shcheck ]; then
  git clone https://github.com/santoru/shcheck
fi

printf "${BOLD}${YELLOW}Installation completed successfully!\n${NORMAL}"
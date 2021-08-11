<h1 align="center">
  <br>
  <a href="https://github.com/robotshell/magicRecon"><img src="https://github.com/robotshell/magicRecon/blob/master/images/logo.png" alt="magicRecon"></a>
  <br>
  MagicRecon
  <br>
</h1>


<p align="center">
  <a href="https://github.com/robotshell/magicRecon/releases">
    <img src="https://img.shields.io/github/v/release/robotshell/magicrecon?include_prereleases">
  </a>
  <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">
    <img src="https://img.shields.io/github/license/robotshell/magicrecon">
  </a>
  <a href="https://github.com/robotshell/magicRecon/issues?q=is%3Aissue+is%3Aclosed">
    <img src="https://img.shields.io/github/issues-closed/robotshell/magicrecon">
  </a>
  <a href="https://github.com/robotshell/magicRecon/commits/master">
    <img src="https://img.shields.io/github/last-commit/robotshell/magicrecon">
  </a>
  <a href="https://github.com/robotshell/magicRecon/commits/master">
    <img src="https://img.shields.io/github/languages/code-size/robotshell/magicrecon">
  </a>
  <a href="">
    <img src="https://img.shields.io/twitter/follow/robotshelld?style=social">
  </a>
</p>

Hi hacker 😉

Welcome to the MagicRecon tool repository!

MagicRecon is a powerful shell script to maximize the recon and data collection process of an objective and finding common vulnerabilities, all this saving the results obtained in an organized way in directories and with various formats.

With Magic Recon you can perform passive and active reconnaissance, vulnerability analysis, subdomain scan and much more!

-------------------------------------

# Disclaimer :warning:
**The author of this document take no responsibility for correctness. This project is merely here to help guide security researchers towards determining whether something is vulnerable or not, but does not guarantee accuracy.**
**Warning: This code was originally created for personal use, it generates a substantial amount of traffic, please use with caution.**

-------------------------------------

# Features
To run the project, you will need to install the following tools:
* [Subfinder](https://github.com/projectdiscovery/subfinder)
* [Httpx](https://github.com/projectdiscovery/httpx)
* [Notify](https://github.com/projectdiscovery/notify)
* [Nuclei](https://github.com/projectdiscovery/nuclei)
* [Nuclei-templates](https://github.com/projectdiscovery/nuclei-templates)
* [SecLists](https://github.com/danielmiessler/SecLists)
* [Corsy](https://github.com/s0md3v/Corsy)
* [Securityheaders](https://github.com/koenbuyens/securityheaders)
* [Ssl-checker](https://github.com/narbehaj/ssl-checker)
* [Secretfinder](https://github.com/m4ll0k/SecretFinder)
* [Wfuzz](https://github.com/xmendez/wfuzz)
* [Aquatone](https://github.com/michenriksen/aquatone)
* [Html-tool](https://github.com/tomnomnom/hacks/tree/master/html-tool)
* [Waybackurls](https://github.com/tomnomnom/waybackurls)
* [Kxss](https://github.com/Emoe/kxss)
* [Anew](https://github.com/tomnomnom/anew)
* [Qsreplace](https://github.com/tomnomnom/qsreplace)
* [Urlprobe](https://github.com/1ndianl33t/urlprobe)
* [Anew](https://github.com/tomnomnom/anew)
* [Gf](https://github.com/tomnomnom/gf)
* [Gobuster](https://github.com/OJ/gobuster)
* [Findomain](https://github.com/Findomain/Findomain)
* [spoofcheck](https://github.com/BishopFox/spoofcheck)
* [linkfiner](https://github.com/GerbenJavado/LinkFinder)
* [Nmap](https://nmap.org/)

### IMPORTANT: Remember to configure the Notify and Subfinder tools to work properly.

-------------------------------------

# Installation :hammer:

```bash
$ git clone https://github.com/robotshell/magicRecon
$ cd magicRecon
$ chmod +x install.sh
$ ./install.sh
```

-------------------------------------

# Configuration :wrench:
To configure MagicRecon tool you must open the `configuration.cfg` file and change variables defined by user data.

It is also important to correctly configure tools such as `Subfinder` and `Notify` to guarantee the correct functioning of magicRecon.


-------------------------------------

# Usage :eyes:
```
./magicrecon.sh -h                 
 __  __             _      ____                      
|  \/  | __ _  __ _(_) ___|  _ \ ___  ___ ___  _ __  
| |\/| |/ _` |/ _` | |/ __| |_) / _ \/ __/ _ \| '_ \ 
| |  | | (_| | (_| | | (__|  _ <  __/ (_| (_) | | | |
|_|  |_|\__,_|\__, |_|\___|_| \_\___|\___\___/|_| |_|
              |___/                                  
MagicRecon v.3.0 - Open Source Project | Author: Robotshell | Twitter: @robotshelld


USAGE
./magicrecon.sh [-d domain.com] [-w domain.com] [-l listdomains.txt]
                      [-a] [-p] [-x] [-r] [-v] [-m] [-n] [-h] 

TARGET OPTIONS
   -d domain.com     Target domain
   -w domain.com     Wildcard domain
   -l list.txt       Target list
 
MODE OPTIONS
   -a, --all         All mode - Full scan with full target recognition and vulnerability scanning
   -p, --passive     Passive reconnaissance (Footprinting) - Performs only passive recon with multiple tools
   -x, --active      Active reconnaissance (Fingerprinting) - Performs only active recon with multiple tools
   -r, --recon       Reconnaissance - Perform active and passive reconnaissance
   -v, --vulnerabilities         Vulnerabilities - Check multiple vulnerabilities in the domain/list domains
   -m, --massive     Massive recon - Massive vulnerability analysis with repetitions every X seconds
 
EXTRA OPTIONS
   -n, --notify      Notify - This option is used to receive notifications via Discord, Telegram or Slack
   -h, --help                Help - Show this help

```

-------------------------------------

# Sample video: passive reconnaissance :movie_camera:

![Example image](https://github.com/robotshell/magicRecon/blob/master/images/poc.gif)

-------------------------------------


# Contribution & License :family:

You can contribute in following ways:

- [Report bugs & add issues](https://github.com/robotshell/magicRecon/issues)
- Searching for new tools to add
- Give suggestions **(Ideas)** to make it better

Do you want to have a conversation in private? email me : robotshelld@gmail.com

***MagicRecon*** is licensed under [GPL-3.0 License](https://github.com/robotshell/magicRecon/blob/master/LICENSE)

-------------------------------------

# Special thanks
* Special Thanks to Mohd Shibli for his great contributions in the article [Fasten your Recon process using Shell Scripting](https://medium.com/bugbountywriteup/fasten-your-recon-process-using-shell-scripting-359800905d2a#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImRiMDJhYjMwZTBiNzViOGVjZDRmODE2YmI5ZTE5NzhmNjI4NDk4OTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE1NzQxODIxNTUsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNjQzNTQ3NTE5MTA1NzIzOTYzOSIsImVtYWlsIjoicm9ib3RzaGVsbGRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJSb2JvdCBTaGVsbCIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQUF1RTdtQnhZZklJNndVLXQ5OVNxbzFlaElpc1E4dzY4a2VJbWZrbE4yOD1zOTYtYyIsImdpdmVuX25hbWUiOiJSb2JvdCIsImZhbWlseV9uYW1lIjoiU2hlbGwiLCJpYXQiOjE1NzQxODI0NTUsImV4cCI6MTU3NDE4NjA1NSwianRpIjoiODYzMTNhZTQ3YTQ5NjJiNTdhMTBlZDA0NGJhYWUyMGQwZWM2Y2FlNCJ9.obOev9FLt7DWW2NbSIbFwPoUC-vNFrf5nru--6uL6knW1S6CjjqXAP_D0sedfukNC0DcJnqQDz88Yh48ECppB4wEv0ozgunc9Yx24m5OiNaEKvWr0D2WJsMsV9yN7Vxt7gJxTeVIstCLvWDYCl_1JBrDvJ2eXF4V9yamk61KCqmwoAJMjXEpwaDuzITFPIZM9V-nTpIgnsBh-BCERYqAcUc7Si0IpRAlyM9YG78va7o0Pe_zYrt4NbV8Cl--BzAzrFOfhIOxvk3CYWRfc9lrSz09TJRCEn4q-rR9v7LVIboKJAedhbkr8ShClMru8xRsdfne3fRIzV1iZxNn4GuW6A) 
* Special Thanks to @KingOfBugbounty for his great contributions in the repository [KingOfBugBountyTips](https://github.com/KingOfBugbounty/KingOfBugBountyTips)
* [@TomNomNom](https://twitter.com/TomNomNom)
* [@pdiscoveryio](https://twitter.com/pdiscoveryio)
* [@NahamSec](https://twitter.com/NahamSec)
* [@s0md3v](https://twitter.com/s0md3v)
* [@ofjaaah](https://twitter.com/ofjaaah)
* [@KingOfBugbounty](https://twitter.com/KingOfBugbounty)
* 
-------------------------------------

# About me
[Twitter](https://twitter.com/robotshelld)

-------------------------------------

# Donation
* If you've earned a bug bounty using this tool, please consider donating to support it's development. You can help me to develop more useful scripts and tools. Thanks :heart_eyes:

[<img src="https://www.paypalobjects.com/en_US/ES/i/btn/btn_donateCC_LG.gif">](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F4YABU5AH3NTQ&source=url)

# MagicRecon          
MagicRecon is a powerful shell script to maximize the recon and data collection process of an objective and finding common vulnerabilities, all this saving the results obtained in an organized way in directories and with various formats.

The new version of MagicRecon has a large number of new tools to automate as much as possible the process of collecting data from a target and searching for vulnerabilities. It also has a menu where the user can select which option he wants to execute.

This new version also has the option of "Install dependencies" with which the user can easily install all the tools and dependencies that are needed to run MagicRecon. The script code has been made in a modular way so that any user can modify it to their liking. 
With MagicRecon you can easily find:

* Sensitive information disclosure.
* Missing HTTP headers.
* Open S3 buckets.
* Subdomain takeovers.
* SSL/TLS bugs.
* Open ports and services.
* Email spoofing.
* Endpoints.
* Directories.
* Juicy files.
* Javascript files with senstive info.
* CORS missconfigurations.
* Cross-site scripting (XSS).
* Open Redirect.
* SQL Injection.
* Server-side request forgery (SSRF).
* CRLF Injection.
* Remote Code Execution (RCE).
* Other bugs.

# Disclaimer :warning:
**The author of this document take no responsibility for correctness. This project is merely here to help guide security researchers towards determining whether something is vulnerable or not, but does not guarantee accuracy.**
**Warning: This code was originally created for personal use, it generates a substantial amount of traffic, please use with caution.**

# Requirements
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

### IMPORTANT: YOU NEED TO INSTALL MAGICRECON IN YOUR HOME FOLDER.

# Usage
```
./magicRecon.sh

Output:

 __  __             _      ____                      
|  \/  | __ _  __ _(_) ___|  _ \ ___  ___ ___  _ __  
| |\/| |/ _` |/ _` | |/ __| |_) / _ \/ __/ _ \| '_ \ 
| |  | | (_| | (_| | | (__|  _ <  __/ (_| (_) | | | |
|_|  |_|\__,_|\__, |_|\___|_| \_\___|\___\___/|_| |_|
              |___/                                  

MENU
1) Install dependencies
2) Massive vulnerability analysis with notifications via Discord, Telegram or Slack
3) Subdomain enumeration
4) Subdomain enumeration and vulnerability scanning with nuclei
5) Subdomain enumeration with common vulnerabilities scanning
6) Scan for javascript files
7) Scan for files and directoires
8) All in one! (original MagicRecon)
q) Exit
Choose a option: 
```
![Example image](https://github.com/robotshell/magicRecon/blob/master/magicrecon.gif)

# Special thanks
* Special Thanks to Mohd Shibli for his great contributions in the article [Fasten your Recon process using Shell Scripting](https://medium.com/bugbountywriteup/fasten-your-recon-process-using-shell-scripting-359800905d2a#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImRiMDJhYjMwZTBiNzViOGVjZDRmODE2YmI5ZTE5NzhmNjI4NDk4OTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE1NzQxODIxNTUsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNjQzNTQ3NTE5MTA1NzIzOTYzOSIsImVtYWlsIjoicm9ib3RzaGVsbGRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJSb2JvdCBTaGVsbCIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQUF1RTdtQnhZZklJNndVLXQ5OVNxbzFlaElpc1E4dzY4a2VJbWZrbE4yOD1zOTYtYyIsImdpdmVuX25hbWUiOiJSb2JvdCIsImZhbWlseV9uYW1lIjoiU2hlbGwiLCJpYXQiOjE1NzQxODI0NTUsImV4cCI6MTU3NDE4NjA1NSwianRpIjoiODYzMTNhZTQ3YTQ5NjJiNTdhMTBlZDA0NGJhYWUyMGQwZWM2Y2FlNCJ9.obOev9FLt7DWW2NbSIbFwPoUC-vNFrf5nru--6uL6knW1S6CjjqXAP_D0sedfukNC0DcJnqQDz88Yh48ECppB4wEv0ozgunc9Yx24m5OiNaEKvWr0D2WJsMsV9yN7Vxt7gJxTeVIstCLvWDYCl_1JBrDvJ2eXF4V9yamk61KCqmwoAJMjXEpwaDuzITFPIZM9V-nTpIgnsBh-BCERYqAcUc7Si0IpRAlyM9YG78va7o0Pe_zYrt4NbV8Cl--BzAzrFOfhIOxvk3CYWRfc9lrSz09TJRCEn4q-rR9v7LVIboKJAedhbkr8ShClMru8xRsdfne3fRIzV1iZxNn4GuW6A) 
* Special Thanks to @KingOfBugbounty for his great contributions in the repository [KingOfBugBountyTips](https://github.com/KingOfBugbounty/KingOfBugBountyTips)
* [@TomNomNom](https://twitter.com/TomNomNom)
* [@pdiscoveryio](https://twitter.com/pdiscoveryio)
* [@NahamSec](https://twitter.com/NahamSec)
* [@s0md3v](https://twitter.com/s0md3v)

# About me
[Twitter](https://twitter.com/robotshelld)


# Donation
* If you've earned a bug bounty using this tool, please consider donating to support it's development. You can help me to develop more useful scripts and tools. Thanks :heart_eyes:

[<img src="https://www.paypalobjects.com/en_US/ES/i/btn/btn_donateCC_LG.gif">](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F4YABU5AH3NTQ&source=url)



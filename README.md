# MagicRecon                            

# Description
Recon is an essential element of any penetration testing. This repository contain a powerful shell script to maximize the recon and data collection process of an objective. With this script you can easily find:

* Sensitive information disclosure.
* Missing HTTP headers.
* Heartbleed Bug.
* Open S3 buckets.
* Subdomain takeovers.
* Bugs in TLS/SSL ciphers, protocols and cryptographic flaws.
* Open ports and services.
* Email spoofing.
* Endpoints.
* Directories.
* Javascript files with senstive info.
* CORS missconfigurations.
* Other quick bugs.


# Disclaimer :warning:
**The author of this document take no responsibility for correctness. This project is merely here to help guide security researchers towards determining whether something is vulnerable or not, but does not guarantee accuracy.**
**Warning: This code was originally created for personal use, it generates a substantial amount of traffic, please use with caution.**

# Tools needed
* [Amass](https://github.com/OWASP/Amass)
* [Certsh.py](https://github.com/ghostlulzhacks/CertificateTransparencyLogs)
* [Gobuster](https://github.com/OJ/gobuster)
* [Assetfinder](https://github.com/tomnomnom/assetfinder)
* [Subjack](https://github.com/haccer/subjack)
* [httprobe](https://github.com/tomnomnom/httprobe)
* [Corsy](https://github.com/s0md3v/Corsy)
* [Aquatone](https://github.com/michenriksen/aquatone)
* [securityheaders](https://github.com/koenbuyens/securityheaders)
* [testssl.sh](https://github.com/drwetter/testssl.sh)
* [spoofcheck](https://github.com/BishopFox/spoofcheck)
* [relative-url-extractor](https://github.com/jobertabma/relative-url-extractor)
* [linkfiner](https://github.com/GerbenJavado/LinkFinder)
* [Nmap](https://nmap.org/)
* [SecLists](https://github.com/danielmiessler/SecLists)

### IMPORTANT: YOU NEED TO INSTALL ALL THE TOOLS IN YOUR HOME FOLDER.

# How does it work?
The script has 5 phases:

1. Subdomain enumeration: Amass, Certsh.py, Gobuster DNS and Assetfinder tools are used to find the maximum possible number of subdomains. httprobe is used to probe for working http and https servers. Then Subjack is used to quickly check if it exists subdomains takeover. Corsy tool is used to find CORS missconfigurations. Finally, Aquatone takes screenshots of each subdomain.

2. Scan for missing headers and bugs in SSL/TLS protocols: securityheaders is used to check quickly and easily the security of HTTP response headers and testssl.sh is used to check the TLS/SSL ciphers, protocols and cryptographic flaws.

3. Scan if a domain can be spoofed: spoofcheck is used to check SPF and DMARC records for weak configurations that allow spoofing.

4. JavaScript files and hidden endpoints: LinkFinder is used to discover endpoints and their parameters in JavaScript files.

5. Find directories and hidden files: Gobuster DIR is used to collect hidden files and directories through a dictionary. You can change the dictionary in the script configuration.

6. Nmap: Nmap is used to scan ports and services quiclky.

###  All the data generated in the different processes are saved in different files and directories in different formats.
![Example image](https://raw.githubusercontent.com/robotshell/magicRecon/master/example.png)

# Usage
```
./magicRecon.sh [DOMAIN]

Parameters: 

-h: Show the help message.
```
# Thanks
* Special Thanks to Mohd Shibli for his great contributions in the article [Fasten your Recon process using Shell Scripting](https://medium.com/bugbountywriteup/fasten-your-recon-process-using-shell-scripting-359800905d2a#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImRiMDJhYjMwZTBiNzViOGVjZDRmODE2YmI5ZTE5NzhmNjI4NDk4OTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE1NzQxODIxNTUsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNjQzNTQ3NTE5MTA1NzIzOTYzOSIsImVtYWlsIjoicm9ib3RzaGVsbGRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJSb2JvdCBTaGVsbCIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQUF1RTdtQnhZZklJNndVLXQ5OVNxbzFlaElpc1E4dzY4a2VJbWZrbE4yOD1zOTYtYyIsImdpdmVuX25hbWUiOiJSb2JvdCIsImZhbWlseV9uYW1lIjoiU2hlbGwiLCJpYXQiOjE1NzQxODI0NTUsImV4cCI6MTU3NDE4NjA1NSwianRpIjoiODYzMTNhZTQ3YTQ5NjJiNTdhMTBlZDA0NGJhYWUyMGQwZWM2Y2FlNCJ9.obOev9FLt7DWW2NbSIbFwPoUC-vNFrf5nru--6uL6knW1S6CjjqXAP_D0sedfukNC0DcJnqQDz88Yh48ECppB4wEv0ozgunc9Yx24m5OiNaEKvWr0D2WJsMsV9yN7Vxt7gJxTeVIstCLvWDYCl_1JBrDvJ2eXF4V9yamk61KCqmwoAJMjXEpwaDuzITFPIZM9V-nTpIgnsBh-BCERYqAcUc7Si0IpRAlyM9YG78va7o0Pe_zYrt4NbV8Cl--BzAzrFOfhIOxvk3CYWRfc9lrSz09TJRCEn4q-rR9v7LVIboKJAedhbkr8ShClMru8xRsdfne3fRIzV1iZxNn4GuW6A) 

# About me
[Twitter](https://twitter.com/robotshelld)


# Donation
* If you've earned a bug bounty using this tool, please consider donating to support it's development. You can help me to develop more useful tools. Thanks :heart_eyes:

[<img src="https://www.paypalobjects.com/en_US/ES/i/btn/btn_donateCC_LG.gif">](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F4YABU5AH3NTQ&source=url)



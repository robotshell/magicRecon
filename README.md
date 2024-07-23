<h1 align="center">
  <br>
  <a href="https://ibb.co/kG6XBMQ"><img src="https://i.ibb.co/QJjMQXr/magicrecon.png" alt="magicrecon" style="width:100%"></a>
  <br>
  MagicRecon: Fast, simple and effective 
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

MagicRecon is a powerful shell script to maximize the recon and data collection process of an objective and finding common vulnerabilities, all this saving the results obtained in an organized way in directories and with various formats.

With Magic Recon you can perform passive and active reconnaissance, vulnerability analysis, subdomain scan and many more!

-------------------------------------

# Main features :boom: 
- Save the results in an organized way in different formats.
- Subdomain enumeration.
- Check if the domains are alive.
- Get whois information about every subdomain.
- Get dns information about every subdomain.
- Extract the technologies used in the domain.
- Get information about the certificate used in the domain .
- Take a screenshot on the domain.
- Searches for emails on the domain, users and more things.
- Enumerate public resources in AWS, Azure, and Google Cloud. 
- Search juicy information via GitHub Dorks.
- Check all entrys in robots.txt file.
- Get all endpoints on the web.
- Perform a parameter scan.
- Perform a port scan to discover open ports. 
- Perform a dirsearch to find directories and files.
- Check if is possible to bypass 403 HTTP status code.
- Perform a massive recon and vulnerability scan via Nuclei every X seconds.
- Search missing security headers.
- Check if the domain is vulnerable to Email spoofing.
- Check if the domain is vulnerable to Subdomain takeover.
- Check if the domain is vulnerable to Cross-Origin Resource Sharing (CORS).
- Check if different endpoints are vulnerable to CSRF. 
- Look for entry points in the URL and check if it is vulnerable to Open Redirect.
- Look for entry points in the URL and check if it is vulnerable to Cross-site scripting (XSS). 
- Look for entry points in the URL and check if it is vulnerable to SQL Injection (SQLi).
- Look for entry points in the URL and check if it is vulnerable to Server-side request forgery (SSRF).
- Search all JS files in the domain and perform a scan for API Keys, access tokens, endpoints, etc.
- Check if the domain use a CMS and scan it.
- And many more...

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
**TARGET OPTIONS**
 
| Parameter | Description |
|------|-------------|
| -d | Target domain |
| -w | Wildcard domain |
| -l | Target list  |
 
**MODE OPTIONS**
 
| Parameter | Description |
|------|-------------|
| -a, --all | All mode - Full scan with full target recognition and vulnerability scanning |
| -p, --passive | Passive reconnaissance (Footprinting) - Performs only passive recon with multiple tools |
| -x, --active | Active reconnaissance (Fingerprinting) - Performs only active recon with multiple tools |
| -r, --recon | Reconnaissance - Perform active and passive reconnaissance |
| -v, --vulnerabilities | Vulnerabilities - Check multiple vulnerabilities in the domain/list domains |
| -m, --massive | Massive recon - Massive vulnerability analysis with repetitions every X seconds |
 
**EXTRA OPTIONS**
 
| Parameter | Description |
|------|-------------|
| -n, --notify | Notify - This option is used to receive notifications via Discord, Telegram or Slack |
| -h, --help | Help - Show help |



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
# Example Usage :speak_no_evil:

 All:
 ```
 ./magicrecon.sh -d domain.com -a
  ```
 Passive reconnaissance to a list of domains:
  ```
 ./magicrecon.sh -l domainlist.txt -p
  ```
 Active reconnaissance to a domain:
  ```
 ./magicrecon.sh -d domain.com -x
  ```
 
 Full reconnaissance:
  ```
 ./magicrecon.sh -d domain.com -r
  ```
 
 Full reconnaissance and vulnerabilities scanning:
  ```
 ./magicrecon.sh -d domain.com -r -v
  ```
 
 Full reconnaissance and vulnerabilities scanning to a wildcard:
  ```
 ./magicrecon.sh -w domain.com 
  ```
 
 Massive reconnaissance and vulnerabilities scanning:
  ```
 ./magicrecon.sh -w domain.com -m 
  ```

-------------------------------------

# Sample video: passive reconnaissance :movie_camera:

![Example image](https://github.com/robotshell/magicRecon/blob/master/images/poc.gif)

-------------------------------------

# To do :mage_man:
- [x] Change tool operation to parameters.
- [x] Improve the use of Notify.  
- [ ] Add new interesting tools to find more vulnerabilities.
- [ ] Save results in other formats.
- [ ] Save the results in a document as a report.
- [ ] Check if the emails found by the tool are leaked. 
- [x] Integrate RobotScraper.

-------------------------------------

# Contribution & License :family:

You can contribute in following ways:

- [Report bugs & add issues](https://github.com/robotshell/magicRecon/issues).
- Fix something and open a pull request.
- Give suggestions **(Ideas)** to make it better.
- Spread the word.

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
-------------------------------------

# Disclaimer

This tool is intended for educational and research purposes only. The author and contributors are not responsible for any misuse of this tool. Users are advised to use this tool responsibly and only on systems for which they have explicit permission. Unauthorized access to systems, networks, or data is illegal and unethical. Always obtain proper authorization before conducting any kind of activities that could impact other users or systems.

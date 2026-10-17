
## Overview

The lab server hosts a simple intranet site for client machines in the Users segment. It gives the Users → Servers firewall policy a real service to protect. This page documents how the server was built and secured.

| **Item**   | **Detail**                                                       |
| ---------- | ---------------------------------------------------------------- |
| VM         | Server                                                           |
| OS         | Ubuntu Server 26.04.1 LTS                                        |
| Segment    | Servers (10.10.10.0/24)                                          |
| IP address | 10.10.10.10 (static)                                             |
| Role       | Intranet web server (Apache)                                     |
| Site name  | `intranet.lab.internal` (Unbound DNS override)                   |
| Services   | HTTPS (443/tcp), HTTP (80/tcp, redirects to HTTPS), SSH (22/tcp) |

### Permitted Access

| **Source**                   | **Port**  | **Purpose**       | **Enforced by**                                   |
| ---------------------------- | --------- | ----------------- | ------------------------------------------------- |
| Users (10.10.20.0/24)        | 80, 443   | Intranet access   | OPNsense rule U-3, `ufw`                          |
| Admin Machine (10.10.30.10)  | 22        | SSH administration | OPNsense rule M-2, `ufw`, `sshd` (`AllowUsers`) |

All other traffic to the server is denied.

### Addressing & Name Resolution

* **IP addresses:** The server uses DHCP, and Dnsmasq on OPNsense always hands it 10.10.10.10 through a reservation.
* **Host name:** An Unbound host override on OPNsense resolves `intranet.lab.internal` to 10.10.10.10.

### Security Controls

* **Network:** The server is isolated in the Servers segment and reachable only through OPNsense.
* **Host firewall:** `ufw` allows only the sources and ports listed above.
* **Web service:** HTTP is redirected to HTTPS, directory listing is disabled, and Apache version details are hidden.
* **SSH:** Key-based authentication only, no root login, and access limited to the admin machine.

See also: [IP Addressing](../Architecture/IP-addressing.md), [OPNsense](OPNsense.md), [Firewall Policy](../Architecture/Firewall-policy.md)

---
## Apache

### Set-up

**Installing Apache**

```Shell
sudo apt update
sudo apt install apache2
systemctl status apache2
```

**Created a simple site:**

```Shell
sudo mkdir -p /var/www/intranet
echo '<h1>Lab Intranet</h1><p>Served from the Servers segment :)</p>' | sudo tee /var/www/intranet/index.html

```

**Generating a self-signed SSL certificate:**

```Shell
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/intranet.key \ 
	-out /etc/ssl/certs/intranet.crt \ 
	-subj "/CN=intranet.lab.internal" \ 
	-addext "subjectAltName=DNS:intranet.lab.internal,IP:10.10.10.10"
```

**Virtual Host Config:**

* `/etc/apache2/sites-available/intranet.conf`

```
<VirtualHost *:80>
	 ServerName intranet.lab.local 
	 Redirect permanent / https://intranet.lab.internal/ 
</VirtualHost>

 <VirtualHost *:443> 
	 ServerName intranet.lab.internal 
	 DocumentRoot /var/www/intranet 
	 
	 SSLEngine on 
	 SSLCertificateFile /etc/ssl/certs/intranet.crt 
	 SSLCertificateKeyFile /etc/ssl/private/intranet.key 
	 
	 <Directory /var/www/intranet> 
		 Options -Indexes 
		 AllowOverride None 
		 Require all granted 
	</Directory> 
	
	Header always set X-Content-Type-Options "nosniff"
	 
	ErrorLog ${APACHE_LOG_DIR}/intranet_error.log 
	CustomLog ${APACHE_LOG_DIR}/intranet_access.log combined 
</VirtualHost>
```

**Enabling & Verifying:**

```Shell
sudo a2enmod ssl headers 
sudo a2dissite 000-default 
sudo a2ensite intranet 
sudo apache2ctl configtest 
sudo systemctl reload apache2
```

### Basic Hardening

* `/etc/apache2/conf-available/security.conf`

```
ServerTokens Prod 
ServerSignature Off
```

* Stops Apache from advertising its version and OS in headers and error pages.

### UFW Configuration

```Shell
sudo ufw allow from 10.10.30.10 to any port 22 proto tcp 
sudo ufw allow from 10.10.20.0/24 to any port 80,443 proto tcp 
sudo ufw enable 
sudo ufw status verbose
```

---
## SSH Admin Access

* *The key pair was generated on the admin machine and the public key was copied to the server. The private key never leaves the admin machine*
* *Anything wrapped in `<>` are placeholder values*

**Generating SSH Key Pair:**


```Shell
ssh-keygen -t ed25519 -a 100 -f <KEY_FILE> -C <COMMENT>
```

**Copying the key to the server:**

```Shell
ssh-copy-id -i <PUBLIC_KEY_FILE> <USER>@10.10.10.10
```

**Added a config on the admin machine to make ssh faster:**

* `/.ssh/config`

```
Host <LAB_Server>
	HostName 10.10.10.10
	User <USER>
	IdentityFile <KEYFILE>
	IdentitiesOnly yes
```

### Hardening the SSH daemon (server)

* `/etc/ssh/sshd_config.d/01-hardening-conf`

```
PasswordAuthentication no 
KbdInteractiveAuthentication no 
PubkeyAuthentication yes 
PermitRootLogin no 
AllowUsers <USER>@10.10.30.10 
MaxAuthTries 3 
LoginGraceTime 30 
X11Forwarding no

```



---


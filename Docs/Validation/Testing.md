## Overview

This section covers the testing and validation methodology of this lab. The goal was to create tests that could be easily and reliably repeated and expanded as the lab grows and evolves. 

### Current Scope

| **Area**                        | **Goal**                                                                                                                                                | *Methodology*                                                                                       |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Firewall Configurations & Rules | Verify the OPNsense configurations & firewall rules work as intended and enforce the established [firewall policy](../Architecture/Firewall-policy.md). | Automated testing with [run-tests-script.sh](/Scripts/run-tests-script.sh) & manual review.         |
| Server Configurations           | Verify the security configurations of the lab [server](../Implementation/Server.md),                                                                    | Automated testing with [server-checks-script.sh](/Scripts/server-checks-script.sh) & manual review. |
### Testing Documentation

* **Firewall Policy & Rules:** [Firewall-tests](Firewall-tests.md)
* **Server Security Configurations:** [Server-checks](Server-checks.md)


---
## Firewall Testing Matrix

*The testing matrix table accurately reflects the contents of `tests.csv` used in the `run-tests.sh` script*

| **ID** | **Segment** | **Rule**     | **Type** | **Target**                     | **Port / Resolver** | **Expected** | **Description**                           |
| ------ | ----------- | ------------ | -------- | ------------------------------ | ------------------- | ------------ | ----------------------------------------- |
| TM-01  | Management  | M-1          | tcp      | 10.10.30.254                   | 443                 | open         | Firewall GUI reachable from Management    |
| TM-02  | Management  | M-1          | tcp      | 10.10.30.254                   | 22                  | open         | Firewall SSH reachable from Management    |
| TM-03  | Management  | M-2          | tcp      | 10.10.10.10                    | 22                  | open         | Admin machine reaches server SSH          |
| TM-04  | Management  | M-2 + ufw    | tcp      | 10.10.10.10                    | 443                 | closed       | M-2 allows 443 but ufw only permits Users |
| TM-05  | Management  | M-3          | icmp     | 10.10.10.10                    | -                   | open         | Ping to Servers for troubleshooting       |
| TM-06  | Management  | M-4          | dns      | intranet.lab.internal          | 10.10.30.254        | 10.10.10.10  | Unbound override resolves intranet name   |
| TM-07  | Management  | M-5          | tcp      | 1.1.1.1                        | 443                 | open         | Outbound HTTPS for patching               |
| TM-08  | Management  | default deny | tcp      | 1.1.1.1                        | 22                  | closed       | Only 80/443 allowed to the Internet       |
| TM-09  | Management  | default deny | dns      | example.com                    | 8.8.8.8             | timeout      | UDP 53 to external resolver blocked       |
| TM-10  | Management  | default deny | tcp      | 8.8.8.8                        | 53                  | closed       | TCP 53 to external resolver blocked       |
| TM-11  | Management  | default deny | tcp      | 8.8.8.8                        | 853                 | closed       | DNS over TLS blocked                      |
| TM-12  | Management  | M-4          | dns      | example.com                    | 10.10.10.254        | timeout      | Other segment resolver not usable         |
| TU-01  | Users       | U-1          | dns      | intranet.lab.internal          | 10.10.20.254        | 10.10.10.10  | DNS via Users gateway                     |
| TU-02  | Users       | U-2          | tcp      | 1.1.1.1                        | 443                 | open         | Internet HTTPS from Users                 |
| TU-03  | Users       | U-3          | tcp      | 10.10.10.10                    | 443                 | open         | Intranet over HTTPS                       |
| TU-04  | Users       | U-3          | http     | http://intranet.lab.internal/  | -                   | 301          | HTTP redirects to HTTPS                   |
| TU-05  | Users       | U-3          | http     | https://intranet.lab.internal/ | -                   | 200          | Intranet page served                      |
| TU-06  | Users       | U-4          | tcp      | 10.10.10.10                    | 22                  | closed       | Users must not reach server SSH           |
| TU-07  | Users       | U-4          | tcp      | 10.10.30.10                    | 22                  | closed       | Users must not reach Management           |
| TU-08  | Users       | U-4          | tcp      | 10.10.20.254                   | 443                 | closed       | Firewall GUI not exposed to Users         |
| TU-09  | Users       | default deny | dns      | example.com                    | 8.8.8.8             | timeout      | UDP 53 to external resolver blocked       |
| TU-10  | Users       | default deny | tcp      | 8.8.8.8                        | 53                  | closed       | TCP 53 to external resolver blocked       |
| TU-11  | Users       | default deny | tcp      | 8.8.8.8                        | 853                 | closed       | DNS over TLS blocked                      |
| TU-12  | Users       | U-4          | dns      | example.com                    | 10.10.30.254        | timeout      | Cannot use Management resolver            |
| TS-01  | Servers     | S-1          | dns      | example.com                    | 10.10.10.254        | ANY          | DNS via Servers gateway                   |
| TS-02  | Servers     | S-2          | tcp      | 1.1.1.1                        | 443                 | open         | Outbound HTTPS for patching               |
| TS-03  | Servers     | S-3          | tcp      | 10.10.30.10                    | 22                  | closed       | Servers must not reach Management         |
| TS-04  | Servers     | S-3          | tcp      | 10.10.30.254                   | 443                 | closed       | Firewall GUI not exposed to Servers       |
| TS-05  | Servers     | default deny | dns      | example.com                    | 8.8.8.8             | timeout      | UDP 53 to external resolver blocked       |
| TS-06  | Servers     | default deny | tcp      | 8.8.8.8                        | 53                  | closed       | TCP 53 to external resolver blocked       |
| TS-07  | Servers     | default deny | tcp      | 8.8.8.8                        | 853                 | closed       | DNS over TLS blocked                      |
| TS-08  | Servers     | S-3          | dns      | example.com                    | 10.10.20.254        | timeout      | Cannot use Users resolver                 |
| TG-01  | Guests      | G-1          | dns      | example.com                    | 10.10.40.254        | ANY          | DNS via Guests gateway                    |
| TG-02  | Guests      | G-2          | tcp      | 1.1.1.1                        | 443                 | open         | Internet HTTPS from Guests                |
| TG-03  | Guests      | G-3          | tcp      | 10.10.10.10                    | 443                 | closed       | Guests isolated from Servers              |
| TG-04  | Guests      | G-3          | tcp      | 10.10.30.10                    | 22                  | closed       | Guests isolated from Management           |
| TG-05  | Guests      | G-3          | icmp     | 10.10.10.10                    | -                   | closed       | No ping into internal networks            |
| TG-06  | Guests      | G-3          | tcp      | 10.10.40.254                   | 443                 | closed       | Firewall GUI not exposed to Guests        |
| TG-07  | Guests      | design check | dns      | intranet.lab.internal          | 10.10.40.254        | none         | Guests should not resolve internal names  |
| TG-08  | Guests      | default deny | dns      | example.com                    | 8.8.8.8             | timeout      | UDP 53 to external resolver blocked       |
| TG-09  | Guests      | default deny | tcp      | 8.8.8.8                        | 53                  | closed       | TCP 53 to external resolver blocked       |
| TG-10  | Guests      | default deny | tcp      | 8.8.8.8                        | 853                 | closed       | DNS over TLS blocked                      |
| TG-11  | Guests      | G-3          | dns      | example.com                    | 10.10.20.254        | timeout      | Cannot use Users resolver                 |

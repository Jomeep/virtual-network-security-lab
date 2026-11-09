
## Virtual Network Security Lab

A small-scale virtual enterprise network built with VirtualBox and OPNsense to demonstrate practical skills in network segmentation, firewall policy design, traffic control, security monitoring, and defensive security engineering.

**Project status:** Work in progress  

**Current focus:** Firewall policy validation and logging implementation.

____
## Overview

This project simulates a segmented small-scale business network in a virtualised environment. OPNsense acts as the central firewall and routing platform, controlling communication between network segments and providing a foundation for additional security monitoring and detection capabilities.

The lab is being developed as a hands-on project to document the design, implementations, testing, and on-going improvements of a security-focussed network.

____
## Objectives

- Design and implement a segmented enterprise-style network.
- Apply default-deny and least-privilege firewall policies.
- Control and document permitted traffic between network segments.
- Validate network isolation and authorised connectivity.
- Implement centralised logging and SIEM integration.
- Explore network intrusion detection and prevention.
- Develop repeatable security validation and compliance checks.
- Maintain technical documentation and evidence of implementation and testing.

____

## Lab Architecture

The current environment contains the following logical network segments:

| **Segment** | **Intended Purpose**                         |
| ----------- | -------------------------------------------- |
| Users       | User endpoints and client systems            |
| Servers     | Server workloads and services                |
| Management  | Admin access to managed infrastructure       |
| Guests      | Guest devices with restricted network access |

Each segment is implemented using a VirtualBox internal network adapter and a corresponding OPNsense interface. DHCP scopes are configured individually for the segments.

See [Network Architecture](Docs/Architecture/Network-architecture.md) for the topology, IP addressing, firewall policy, and traffic-flow documentation.

___

## Technology Stack

**Virtualisation and network**
* **Oracle VirtualBox** - virtualisation and virtual network infrastructure
* **OPNsense 26.7** - firewall, routing, and network security policy enforcement
  * **Dnsmasq** - DHCP, including address reservations
  * **Unbound** - DNS resolution and local host overrides

**Server (Servers segment)**
* **Ubuntu Server 26.04 LTS** - operating system of the lab server
* **Apache** - intranet web server, HTTPS with a self-signed certificate (OpenSSL)
* **UFW** - host-based firewall
* **OpenSSH** - key-based administrative access from the Management segment

**Endpoints**
* **Windows 11** - user workstation (Users segment)
* **Ubuntu 26.04 LTS** - administration machine (Management segment)
* **Kali 2026.2** - guest workstation (Guests segment)

Additional technologies will be documented as they are implemented.

___

## Current Implementation Status

| **Component**                                              | **Status**  |
| ---------------------------------------------------------- | ----------- |
| VirtualBox environment                                     | Completed   |
| OPNsense interface configuration                           | Completed   |
| Network segment creation                                   | Completed   |
| DHCP configuration                                         | Completed   |
| Initial firewall policies                                  | Completed   |
| Internal server configuration                              | Completed   |
| Configuration & firewall policy validation & documentation | In progress |
| Centralized logging                                        | Planned     |
| SIEM integration                                           | Planned     |
| IDS/IPS                                                    | Planned     |
| Compliance detection                                       | Planned     |
| Expanding the lab to include more technologies             | Planned     |

____
## Security Design Principles

The lab is being developed with the following principles in mind:

- **Network segmentation:** Separate systems according to their intended roles.
- **Default deny:** Deny traffic that is not explicitly authorised by policy.
- **Least privilege:** Permit only the network access required for documented use cases.
- **Restricted administration:** Limit administrative access to designated management paths.
- **Verification:** Test both permitted and prohibited traffic flows.
- **Monitoring:** Develop visibility into network activity and security-relevant events.
- **Documentation:** Record design decisions, configuration changes, test results, and known limitations.

___

## Documentation

**Architecture:**
* [Network Architecture](Docs/Architecture/Network-architecture.md)
* [Firewall Policy & Traffic Flow](Docs/Architecture/Firewall-policy.md)
* [IP Addressing](Docs/Architecture/IP-addressing.md)

**Implementation:**
* [VirtualBox Implementation](Docs/Implementation/VirtualBox.md)
* [OPNsense Implementation](Docs/Implementation/OPNsense.md)
* [Lab Server](/Docs/Implementation/Server.md)

**Validation:**
* [Testing](/Docs/Validation/Testing.md)
* [Scripts](/Docs/Validation/Scripts)
* [OPNsense Config & Firewall Rule Testing](/Docs/Validation/Firewall-tests)
* [Server Config Checks](/Docs/Validation/Server-checks.md)

**Change log**
* [Change Log](Change-log.md)

____

## Project Scope and Limitations

This is a virtualised learning and demonstration environment. It is not intended to represent a production deployment or a formally audited compliance environment.

___

## Disclaimer

This project is provided for educational and portfolio purposes. Testing is conducted within the authorised lab environment.

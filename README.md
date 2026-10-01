
## Virtual Network Security Lab

A small-scale virtual enterprise network built with VirtualBox and OPNsense to demonstrate practical skills in network segmentation, firewall policy design, traffic control, security monitoring, and defensive security engineering.

**Project status:** Work in progress  

**Current focus:** Network architecture, segmentation, DHCP, and firewall policy implementation.

____
## Overview

This project simulates a segmented enterprise network in a virtualized environment. OPNsense acts as the central firewall and routing platform, controlling communication between network segments and providing a foundation for additional security monitoring and detection capabilities.

The lab is being developed as a hands-on project to document the design, implementations, testing, and on-going improvements of a security-focussed network.

____
## Objectives

- Design and implement a segmented enterprise-style network.
- Apply default-deny and least-privilege firewall policies.
- Control and document permitted traffic between network segments.
- Validate network isolation and authorized connectivity.
- Implement centralized logging and SIEM integration.
- Explore network intrusion detection and prevention.
- Develop repeatable security validation and compliance checks.
- Maintain technical documentation and evidence of implementation and testing.

____

## Lab Architecture

The current environment contains the following logical network segments:

| **Segment** | **Intended Purpose**                         |
| ----------- | -------------------------------------------- |
| LAN         | Backup firewall access                       |
| Users       | User endpoints and client systems            |
| Servers     | Server workloads and services                |
| Management  | Admin access to managed infrastructure       |
| Guests      | Guest devices with restricted network access |

Each segment is implemented using a VirtualBox internal network adapter and a corresponding OPNsense interface. DHCP scopes are configured individually for the segments.

See [Network Architecture](Docs/Architecture/Network-architecture.md) for the topology, IP addressing, firewall policy, and traffic-flow documentation.

___

## Technology Stack

* **Oracle VirtualBox** - virtualization and virtual network infrastructure
* **OPNsense** - firewall, routing, DHCP, and network security policy enforcement

Additional monitoring and detection technologies will be documented as they are implemented

___

## Current Implementation Status

| **Component**                                  | **Status**  |
| ---------------------------------------------- | ----------- |
| VirtualBox environment                         | Completed   |
| OPNsense interface configuration               | Completed   |
| Network segment creation                       | Completed   |
| DHCP configuration                             | Completed   |
| Initial firewall policies                      | Implemented |
| Firewall policy validation & documentation     | In progress |
| Centralized logging                            | Planned     |
| SIEM integration                               | Planned     |
| IDS/IPS                                        | Planned     |
| Compliance detection                           | Planned     |
| Expanding the lab to include more technologies | Planned     |

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

* [Network Architecture](Docs/Architecture/Network-architecture.md)
* [VirtualBox Implementation](Docs/Implementation/VirtualBox.md)
* [OPNsense Implementation](Docs/Implementation/OPNsense.md)
* [Firewall Policy & Traffic Flow](Docs/Architecture/Firewall-policy.md)
* [IP-addressing](Docs/Architecture/IP-addressing.md)

____

## Project Scope and Limitations

This is a virtualized learning and demonstration environment. It is not intended to represent a production deployment or a formally audited compliance environment.

___

## Disclaimer

This project is provided for educational and portfolio purposes. Testing is conducted within the authorized lab environment.

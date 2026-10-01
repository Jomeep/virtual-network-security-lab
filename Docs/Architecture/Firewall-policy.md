
## Purpose

The purpose of this firewall policy is to outline the requirements for the configuration, management, monitoring, and maintenance of this lab network. 

The policy establishes a consistent approach to firewall management based on principle of least privilege, defence in depth, and default-deny access.

____

## General Policy Statements

1. Default Deny - Traffic must be denied unless explicitly allowed by a firewall rule.

2. Least Privilege - Rules should only allow the protocols, ports, sources, and destination which are required for legitimate operational purposes.

3. Inbound traffic - Unsolicited connections to internal systems are prohibited.

4. Outbound traffic - Should only be allowed when required and may be restricted by application, destination, or category.

5. Firewall administration - Administrative access is restricted to authorised administrators from the designated management network.

6. Logging - Denied traffic and security-relevant outbound traffic  (denied, administrative, crosses trust boundaries towards a more sensitive segment) should be logged and monitored.

7. Reviewing rules - Firewall rules must be reviewed as the lab progresses and updated if needed so that only required rules are in place.

8. Change control - Permanent rule changes require authorization and documentation.


____

## Traffic Flow Table

* *Inbound - Default Deny*
* *Outbound - Default Deny*

| **Source** | **Destination**   | **Service**                        | **Action** | **Purpose**                                   |
| ---------- | ----------------- | ---------------------------------- | ---------- | --------------------------------------------- |
| Management | Maneged Networks  | Authorized administrative services | Allow      | Network infrastructure administration<br>     |
| Management | Internet          | Required outbound services         | Allow      | Internet connectivity from Management network |
| LAN        | Firewall          | Firewall administration            | Allow      | Failsafe firewall admin access                |
| Users      | Internet          | Required outbound services         | Allow      | Internet connectivity from User network       |
| Users      | Servers           | Specified required services        | Allow      | Application Access                            |
| Guests     | Internet          | Required outbound services         | Allow      | Internet connectivity from Guest network      |
| Guests     | Internal Networks | Any                                | Block      | Guest network isolation                       |

For specific firewall rules see [OPNsense](/Docs/Implementation/OPNsense.md).
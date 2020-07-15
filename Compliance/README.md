## DNS Server Vulnerability (CVE-2020-1350) Workaround

Implements the workaround for the CVE-2020-1350 wormable exploit.
A POC is already available on github: https://github.com/ZephrFish/CVE-2020-1350/blob/master/exploit.sh

## Tree

```bash
.
+-- CB - DNS Server Vulnerability (CVE-2020-1350).cab (MEMCM Configuration Baseline)
+-- Get-CVE-2020-1350_Compliance.ps1
+-- Set-TcpReceivePacketSize.ps1
```

## Google Meet Webhook

You can send remediation data to a google meet webhook if you edit the remediation script $URI parameter.
I don't know why you would want it, DCs usually do not have internet access.

## Installation

Just download the `CB - DNS Server Vulnerability (CVE-2020-1350).cab` file to your site server and import it within the Configuration Item/Baseline node via the `Import Configuration Data` right click menu.
There is no need to target a specific collection since this workaround will only apply on servers that have the DNS service installed.

## DNS Servers CMPivot Query

```kusto
Service
| where (Name == 'DNS')
```

## DNS Servers WQL Query

```WQL
SELECT SMS_R_SYSTEM.ResourceID
    ,SMS_R_SYSTEM.ResourceType
    ,SMS_R_SYSTEM.Name
    ,SMS_R_SYSTEM.SMSUniqueIdentifier
    ,SMS_R_SYSTEM.ResourceDomainORWorkgroup
    ,SMS_R_SYSTEM.Client
FROM SMS_R_System
    INNER JOIN SMS_G_System_SERVICE ON SMS_G_System_SERVICE.ResourceId = SMS_R_System.ResourceId
WHERE SMS_G_System_SERVICE.Name = "DNS"
```

## Disclaimer

I've implemented this in production but as with anything, I am not responsible if this breaks anything.
It's up to you to test it properly.

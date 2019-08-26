---
title: "Cleaning the SCCM Cache the right way with PowerShell"
author: "Ioan Popovici"
date: 2015-11-19T22:04:03.961Z
lastmod: 2019-08-23T12:33:04+03:00

description: ""

subtitle: "Hundreds of low disk space alerts in SCOM after Patch Tuesday? I know the feeling…"

image: "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/1.png" 
images:
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/1.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/2.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/3.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/4.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/5.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/6.png" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/7.gif" 
 - "/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/8.gif" 


aliases:
    - "/deleting-the-sccm-cache-the-right-way-3c1de8dc4b48"
---

![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/1.png)



Hundreds of low disk space alerts in SCOM after Patch Tuesday? I know the feeling…

[**_Script release history_**](https://SCCM.Zone/Clean-CMClientCache-CHANGELOG)


I’
ve been struggling a bit to find a good solution for the cache cleanup problem. The cache is supposed to clean itself but that’s not always the case. I have three year old cache items that te not deleted when needed. Deleting the files directly is not supported because the Client is not notified, and the SCCM SDK is quite limited. There are some scripts out there but none of them check if the cache item is actually needed before deleting it. This approach generates a lot of **unnecessary** network traffic.

We can do better with a PowerShell script that deletes **only unused cache items.** Also, it can be added to a **CI** and scheduled to run after Patch Tuesday. I’ve added some nifty parameters and switches that could come in handy!

### **_Important_**

If you just need to clean all the cache indiscriminately this script is overkill.  
You can do it with the 5 lines of code below.
`## Initialize the CCM resource manager com object  
[__comobject]$CCMComObject = New-Object -ComObject &#39;UIResource.UIResourceMgr&#39;``## Get the CacheElementIDs to delete  
$CacheInfo = $CCMComObject.GetCacheInfo().GetCacheElements()``## Remove cache items  
ForEach ($CacheItem in $CacheInfo) {  
    $null = $CCMComObject.GetCacheInfo().DeleteCacheElement([string]$($CacheItem.CacheElementID))  
}`

### Script

#### Script parameters

*   **CleanupActions**
_Specifies cleanup action to perform. (‘All’, ‘Applications’, ‘Packages’, ‘Updates’, ‘Orphaned’). Default is: ‘All’.
If it’s set to ‘All’ all cleaning actions will be performed._
*   **LowDiskSpaceThreshold
**_Specifies the low disk space threshold percentage after which the cache is cleaned. Default is: ‘100’.
If it’s set to ‘100’ Free Space Threshold Percentage is ignored._
*   **ReferencedThreshold**
_Specifies to remove cache element only if it has not been referenced in specified number of days. Default is: 0.
If it’s set to ‘0’ Last Referenced Time is ignored._
*   **SkipSuperPeer
**_This switch specifies to skip cleaning if the client is a super peer (Peer Cache). Default is: $false._
*   **RemovePersisted
**_This switch specifies to remove content even if it’s persisted. Default is: $false._
*   **LoggingOptions
**_Specifies logging options: (‘Host’, ‘File’, ‘EventLog’, ‘None’). Default is: (‘Host’, ‘File’, ‘EventLog’)._
*   **LogName
**_Specifies log folder name and event log name. Default is: ‘Configuration Manager’._
*   **LogSource
**_Specifies log file name and event source name. Default is: ‘Clean-CMClientCache’._
*   **LogDebugMessages
**_This switch specifies to log debug messages. Default is: $false._> **Notes**  
> You need to suppress the output when using it in a CI (You have to omit ‘Host’ in the -LoggingOptions parameter value).  
> Pro tip: Use it as a ‘Discovery’ script, it will save some time and there are not advantages to use remediation in this case.

Clean configuration manager client cache



### Screenshots




![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/2.png)

Progress indicator





![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/3.png)

Result





![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/4.png)

Verbose





![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/5.png)

File log





![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/6.png)

Event log





![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/7.gif)

Users seen by Sysadmins…

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2015-11-19_cleaning-the-sccm-cache-the-right-way-with-powershell/images/8.gif)

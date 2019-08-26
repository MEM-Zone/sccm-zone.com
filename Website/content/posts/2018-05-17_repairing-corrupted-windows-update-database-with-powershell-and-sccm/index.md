---
title: "Repairing corrupted Windows Update Database with PowerShell and SCCM"
author: "Ioan Popovici"
date: 2018-05-17T17:43:31.100Z
lastmod: 2019-08-23T12:36:39+03:00

description: ""

subtitle: "When a botched software update corrupts half of your fleet windows update database this script might come in handy…"

image: "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/1.jpeg" 
images:
 - "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/1.jpeg" 
 - "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/2.png" 
 - "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/3.png" 
 - "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/4.jpeg" 
 - "/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/5.gif" 


aliases:
    - "/repairing-corrupted-windows-update-database-with-sccm-bb7b25a15daa"
---

![image](/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/1.jpeg)



When a botched software update corrupts half of your fleet windows update database this script might come in handy…

[**_Script release history_**](https://SCCM.Zone/repair-wudatastore-changelog)


L
 ast month lot of complains about slowness started pouring in and an angry mob began to assemble outside of my office. Somehow the WUDatastore got corrupted on a few thousand machines causing severe slowdowns.

In my case the application event log was full of ESENT errors (event id 623).
`wuaueng.dll (2160) SUS20ClientDataStore: The version store for this  
instance (0) has reached its maximum size of 16Mb. It is likely that a  
long-running transaction is preventing cleanup of the version store and  
causing it to build up in size. Updates will be rejected until the  
long-running transaction has been completely committed or rolled back.`

The solution was to remove and reinitialize the WUDatastore. Nuking the whole database seems a bit extreme but so is being hanged by an angry mob. I could not find another solution so I added a script to a baseline with automatic remediation. This workaround should take care of any future occurrences. You can also use the run script feature if time is of the essence.

### Script

#### **Script parameters**

*   **DetectAndRepair**
_Performs detection and then performs repairs if necessary._
*   **Detect**
_Performs detection and returns the result._
*   **Repair**
_Performs repairs and flushes the specified EventLog._
*   **RepairStandalone** _Performs repairs only._> **Notes**  
> Like with any other WUDatastore reinitialization the **update** **history will be lost**. The update install history however will remain untouched in **Programs and Features \View installed installed updates**. **** Keep in mind that the Eventlog used in the detection will also be cleared if **RepairStandalone** is not specified.

Repair WUDataStore corruption



#### Using the run script feature




![image](/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/2.png)

Using the run script feature





![image](/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/3.png)

Configuration item Compliance Rule





![image](/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/4.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2018-05-17_repairing-corrupted-windows-update-database-with-powershell-and-sccm/images/5.gif)

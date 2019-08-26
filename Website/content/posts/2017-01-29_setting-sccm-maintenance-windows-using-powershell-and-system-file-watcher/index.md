---
title: "Setting SCCM Maintenance Windows using PowerShell and System File Watcher"
author: "Ioan Popovici"
date: 2017-01-29T13:01:55.530Z
lastmod: 2019-08-23T12:34:51+03:00

description: ""

subtitle: "Don’t wanna give access to the console just because a client wants to set his own maintenance windows? Here’s how to do it…"

image: "/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/1.jpeg" 
images:
 - "/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/1.jpeg" 
 - "/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/2.jpeg" 
 - "/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/3.gif" 


aliases:
    - "/setting-sccm-maintenance-windows-using-file-watcher-with-powershell-abaef5bf007b"
---

![image](/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/1.jpeg)



Don’t wanna give access to the console just because a client wants to set his own maintenance windows? Here’s how to do it…

[**_Script release history_**](https://SCCM.Zone/Set-CSVMaintenanceWindows-CHANGELOG)


T
he script will use two CSV files containing mail and maintenance window configuration. Feel free to adjust the templates and script provided bellow to suit your needs.

### Script

#### Maintenance windows configuration file parmeters

*   **CollectionName
**_Maintenance windows collection (_**_Collection Name_**_)._
*   **Date
**_Maintenance window date (_[**_yyyy-MM-dd_**](https://en.wikipedia.org/wiki/ISO_8601)_)._
*   **StartTime
**_Maintenance window start time (_**_HH:mm_**_)._
*   **StopTime
**Maintenance window stop time (**HH:mm**).
*   **RemoveExisting
**_Remove existing maintenance window (_**_Yes/No_**_)._
*   **ApplyTo
**_Maintenance window type (_**_Any/SoftwareUpdates/TaskSequences_**_)._

#### Mail configuration file parameters

*   **SendMail
**_Specifies to send mail after the script is run (_**_Yes/No_**_)._
*   **From
**_Specifies mail sender to impersonate (_**_SCCM &lt;noreply@test.com&gt;_**_)._
*   **To
**_Specifies send mail to address (&lt;_**_sccm-team@test.com&gt;_**_)._
*   **CC
**_Specifies carbon copy address (&lt;_**_No&gt;/&lt;test@test.com&gt;_**_)._
*   **SMTPServer
**_Specifies the SMTP enabled server FQDN (&lt;_**_mail.test.com&gt;_**_)._
*   **SMTPPort
**_Specifies the SMTP server port (&lt;_**_25&gt;_**_)_.> **Notes  
> **You can add this script to task scheduler and run it on system startup.  
> The Set-CSVMaintenanceWindows.csv must reside on local file storage in order for SystemFileWatcher to work.

Create maintenance windows



#### Configuration files template


Maintenance windows configuration file



Mail configuration file





![image](/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-01-29_setting-sccm-maintenance-windows-using-powershell-and-system-file-watcher/images/3.gif)

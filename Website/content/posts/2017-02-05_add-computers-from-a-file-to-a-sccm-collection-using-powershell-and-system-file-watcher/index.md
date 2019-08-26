---
title: "Add computers from a file to a SCCM Collection using PowerShell and System File Watcher"
author: "Ioan Popovici"
date: 2017-02-05T12:32:50.264Z
lastmod: 2019-08-23T12:34:54+03:00

description: ""

subtitle: "Add computers from a file to a collection just by saving…"

image: "/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/1.jpeg" 
images:
 - "/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/1.jpeg" 
 - "/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/2.jpeg" 
 - "/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/3.gif" 


aliases:
    - "/add-computers-from-a-file-to-a-sccm-collection-using-system-file-watcher-with-powershell-4670de34e1b1"
---

![image](/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/1.jpeg)



Add computers from a file to a collection just by saving…

[**_Script release history_**](https://SCCM.Zone/Add-CMDeviceDirectMemebershipRules-CHANGELOG)


T
he script will use two CSV files containing mail notification settings and computer names. Collection direct membership rules are removed before adding new computers. Feel free to adjust the templates and script provided bellow to suit your needs.

### Script

#### Membership rules configuration file parameters

*   **DeviceName
**_Computer name (_**_NetBios Name_**_)._
*   **CollectionName
**_Maintenance windows collection (_**_Collection Name_**_)._

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
> The Add-CMDeviceDirectMemebership.csv must reside on local file storage in order for SystemFileWatcher to work.  
> Existing collection direct membership rules are removed prior to adding new collection members.



#### Configuration files template


Membership rules configuration file



Mail configuration file





![image](/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-02-05_add-computers-from-a-file-to-a-sccm-collection-using-powershell-and-system-file-watcher/images/3.gif)

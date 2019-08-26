---
title: "Disable Push Install for a SCCM Collection"
author: "Ioan Popovici"
date: 2016-11-14T19:35:48.035Z
lastmod: 2019-08-23T12:34:46+03:00

description: ""

subtitle: "Have you ever wished that you could disable push install for a specific collection? Welp there is a supported way of doing it…"

image: "/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/1.jpeg" 
images:
 - "/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/1.jpeg" 
 - "/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/2.jpeg" 
 - "/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/3.gif" 


aliases:
    - "/disable-push-install-for-a-sccm-collection-8db79fd3a33e"
---

![image](/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/1.jpeg)



Have you ever wished that you could disable push install for a specific collection? Welp there is a supported way of doing it…

[**_Script release history_**](https://SCCM.Zone/disable-cmdevicecollectionpush-changelog)


T
urns out there is a [**_registry key_**](https://technet.microsoft.com/en-us/library/bb693996.aspx) you can use for this purpose, it’s not perfect but it’s the best option I could find.

The following script is adding computers from a specified device collection to the **_ExcludeServers_** registry list and optionally sends a mail report with the help of a csv **_configuration_** file.

You can run this script on a daily basis using the task scheduler, and deploy an app that uninstalls both SCEP and SCCM client on this collection.
> **Notes**  
> When you add a computer to the **ExcludeServers** list, it is flagged with a status of installed, which prevents the client from reinstalling by using the automatic site-wide client push installation method. If you later remove the computer from the exclude list, this flag remains. To change this status to uninstalled, you must run the clear install flag task.  
> If you need to remove a computer from the **ExcludeServers** registry list you must **remove it manually** as the value is never replaced, only merged with the collection device members.

### Script

#### Script parameters

*   **CMSiteServer** 
_Specifies the NetBios name of the SCCM site server._
*   **CMCollection
**_Specifies the collection name to exclude from push install._
*   **DeleteAllCollectionMembers
**_Optional switch used to delete all collection device members and their discovery data using CIM (blazing fast :P)._

#### Script configuration file parameters

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
**_Specifies the SMTP server port (&lt;_**_25&gt;_**_)_.

Disable SCCM push install for a specified device collection, using CIM



#### Script configuration file template






![image](/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2016-11-14_disable-push-install-for-a-sccm-collection/images/3.gif)

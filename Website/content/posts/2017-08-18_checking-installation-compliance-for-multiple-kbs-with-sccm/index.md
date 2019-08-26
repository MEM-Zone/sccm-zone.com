---
title: "Checking Installation Compliance for multiple KBs with SCCM"
author: "Ioan Popovici"
date: 2017-08-18T15:13:16.363Z
lastmod: 2019-08-23T12:35:07+03:00

description: ""

subtitle: "Compliance report and expired updates make you WannaCry? Captain SCCM to the rescue!"

image: "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/1.jpeg" 
images:
 - "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/1.jpeg" 
 - "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/2.png" 
 - "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/3.png" 
 - "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/4.jpeg" 
 - "/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/5.gif" 


aliases:
    - "/checking-installation-compliance-for-multiple-kbs-with-sccm-b63428966ab0"
---

![image](/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/1.jpeg)



Compliance report and expired updates make you WannaCry? Captain SCCM to the rescue!

[**_Report release history_**](https://SCCM.Zone/SU-KB-Compliance-by-ArticleID-CHANGELOG)


T
he WannaCry outbreak continues to be a pain, because some clients are still unpatched. Since most of us expire the updates after a while, reporting can become a challenge.
> **Notes**  
> The sql user defined function is needed as a pre-requisite.### Import the SSRS Report

*   Download the report file`**## KB Compliance by ArticleID and Client State** [_SU KB Compliance by ArticleID.rdl_](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Updates/SU%20KB%20Compliance%20by%20ArticleID/SU%20KB%20Compliance%20by%20ArticleID.rdl)`

*   Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files.
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports. You can use just one datasource if your CM and Reporting DBs are on the same server.

### Install Support Function

You can create a new database to host the support function or just add it to the CM database. Fair **warning**, this counts as **‘modifying the CM database’**to Microsoft and they might **deny support** because of it. The right way to do this is to create a separate database for this purpose.

#### Create the ‘CM_Tools’ database

*   Create the **_‘CM_Tools’_** database by executing the following code in your SQL Management Studio:`**/* Create support function database */**  
CREATE DATABASE CM_TOOLS`

*   If you change the **_‘CM_Tools’_** __ name to something else you will need to modify the hardcoded function calls in report **_‘DeviceAndBoundaryData’_**dataset and **‘_ufn_IsIPInSubnet’_** support function.`**## Modify hardcoded function calls**  
...  
**/* Support function */**  
...**CM_TOOLS**.dbo.ufn...  
...`

#### **_Create the ufn_csv_String_Parser function_**

Parses a CSV string and returns individual substrings.


String Parser support function





![image](/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/2.png)

You should end up with something like this

> **Notes** Please **read** the instructions **carefully** before asking for help!

### Report Query

For reference only, since the report includes this query.


Compliance by ArticleID.



### Report Preview




![image](/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/3.png)

The collection selection is not shown here. It’s also kind of scrubbed…





![image](/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/4.jpeg)

Captain SCCM to the rescue!

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏


![image](/posts/2017-08-18_checking-installation-compliance-for-multiple-kbs-with-sccm/images/5.gif)

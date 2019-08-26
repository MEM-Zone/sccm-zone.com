---
title: "Installed Software Reporting with SCCM"
author: "Ioan Popovici"
date: 2018-12-06T19:05:27.062Z
lastmod: 2019-08-23T12:37:41+03:00

description: "Lists installed software by computer or publisher. Supports filtering and exclusions by multiple software names using comma separated values and wildcards."

subtitle: "Installed software reporting made easy…"

image: "/posts/2018-12-06_installed-software-reporting-with-sccm/images/1.jpeg" 
images:
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/1.jpeg" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/2.png" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/3.png" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/4.png" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/5.png" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/6.png" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/7.jpeg" 
 - "/posts/2018-12-06_installed-software-reporting-with-sccm/images/8.gif" 


aliases:
    - "/installed-software-reporting-with-sccm-5c70108a11c4"
---

![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/1.jpeg)



Installed software reporting made easy…

[**_Report release history_**](http://SCCM.Zone/sw-installed-software-by-user-selection-changelog)


I
 was sitting on this one for a while for no good reason. I built it and then completely forgot about it. A few days ago I was trying to find a part of the query, used in this report realized that I forgot to publish it.

Most software reports out there are pretty basic so I decided to buid something new. The idea was to allow filtering by multiple software names and SQL wildcards. This principle applies to both inclusions and exclusions. The only drawback is that you have to use a SQL string parser for splitting the CSV strings. There is no need to re-invent the wheel, you can use the one created by [**_Michelle Ufford_**](http://hadoopsie.com)**.**

At first, I built two reports, one displaying the data by device name and the other by publisher. In the end I ended up by merging them since it does not make sense to have to maintain two reports using the same query.

Also I’ve updated my report template since the old one was an over-designed pile of c**p, too hard to maintain and to reuse. My other reports will also get the upgrade in time.
> **Notes**  
> The reports have two data sources since my CM DB in on a HA cluster. I need access to the ReportServer DB to get the report description in the ReportDescription dataset. Feel free to switch to one dataset.

### Import the SSRS Report

*   Download the report file`**## Installed Software Report**  
[_SW Installed Software by User Selection.rdl_](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Software/SW%20Installed%20Software%20by%20User%20Selection/SW%20Installed%20Software%20by%20User%20Selection.rdl)`

*   Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files.
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports. You can use just one datasource if your CM and Reporting DBs are on the same server.

### Install String Parser

You can create a new database to host the support function or just add it to the CM database. Fair **warning**, this counts as **‘modifying the CM database’** to Microsoft and they might **deny support** because of it. The right way to do this is to create a separate database for this purpose.

#### Create the _‘CM_Tools’_ database

*   Create the **_‘CM_Tools’_** database by executing the following code in your SQL Management Studio:`**/* Create support function database */  
**CREATE DATABASE CM_TOOLS`

*   If you change the **_‘CM_Tools’_** __ name to something else you will need to modify the hardcoded function calls in the SoftwareData dataset report query:`/* Populate SoftwareLike table */  
...  
FROM **CM_Tools**.dbo.ufn_csv_String_Parser(@SoftwareNameLike, &#39;,&#39;);  
...``/* Populate SoftwareNotLike table */  
...  
FROM **CM_Tools**.dbo.ufn_csv_String_Parser(@SoftwareNameNotLike, &#39;,&#39;);  
...`

#### Create the string parser function

*   Create the **_‘ufn_csv_String_Parser’_** __ function by executing the following code in your SQL Management Studio:

Custom string parser





![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/2.png)

You should end up with something like this

> **Notes**  
> Please **read** the instructions **carefully** before asking for help!

### Report Query

For reference only, since the report includes this query.


Installed software reprort query



### Report Preview




![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/3.png)

Installed software by device





![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/4.png)

Installed software by publisher (1)





![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/5.png)

Installed software by publisher (2)





![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/6.png)

Installed software by name





![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/7.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2018-12-06_installed-software-reporting-with-sccm/images/8.gif)

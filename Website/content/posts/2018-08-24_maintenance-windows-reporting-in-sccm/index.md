---
title: "Maintenance Windows Reporting in SCCM"
author: "Ioan Popovici"
date: 2018-08-24T16:23:26.463Z
lastmod: 2019-08-23T12:37:05+03:00

description: ""

subtitle: "Sometimes you just need all maintenance windows in one place…"

image: "/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/1.jpeg" 
images:
 - "/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/1.jpeg" 
 - "/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/2.png" 
 - "/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/3.jpeg" 


aliases:
    - "/maintenance-windows-reporting-in-sccm-2196784d0e2c"
---

![image](/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/1.jpeg)



Sometimes you just need all maintenance windows in one place…

[**_Report release history_**](https://github.com/JhonnyTerminus/SCCMZone/blob/master/Reporting/Software/SD%20Maintenance%20Windows/CHANGELOG.md)


T
here comes a time when you need to cleanup or view all maintenance windows for your environment. I had this for a while but realized only today that there is no builtin report that can show you all maintenance windows in SCCM. Without further ado…

#### Import the SSRS Report

*   Download the report file`**## Maintenance windows report**  
[**_SD Maintenance Windows by Collection and Type_**](https://raw.githubusercontent.com/JhonnyTerminus/SCCMZone/master/Reporting/Software/SD%20Maintenance%20Windows/SD%20Maintenance%20Windows%20by%20Collection%20and%20Type.rdl)`

*   Start Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports
*   If you don’t add a logo, delete the placeholder on the top left.> **Notes**  
> This report was created with SQL 2014 Reporting Services, you might need to remove some report elements if you use an older version.

#### Report Query

For reference only, since the report includes this query.


Maintenance window report query



#### Report Preview




![image](/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/2.png)

Maintenance windows report by collection and type with filters





![image](/posts/2018-08-24_maintenance-windows-reporting-in-sccm/images/3.jpeg)

#### Please use [Github](https://github.com/JhonnyTerminus/SCCMZone) for 🐛 reporting and feature requests 🌈

---
title: "BIOS version Reporting by Manufacturer and Model with SCCM"
author: "Ioan Popovici"
date: 2018-01-25T11:35:30.718Z
lastmod: 2019-08-23T12:36:11+03:00

description: ""

subtitle: "With the Meltdown and Spectre looming on the horizon you might need to have a BIOS version report ready…"

image: "/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/1.jpeg" 
images:
 - "/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/1.jpeg" 
 - "/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/2.png" 
 - "/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/3.gif" 


aliases:
    - "/bios-version-reporting-by-manufacturer-and-model-with-sccm-83f14dcd7225"
---

![image](/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/1.jpeg)



With the Meltdown and Spectre looming on the horizon you might need to have a BIOS version report ready…

[**_Report release history_**](https://github.com/JhonnyTerminus/SCCMZone/blob/master/Reporting/Hardware/HW%20BIOS%20by%20Company%20or%20Manufacturer/CHANGELOG.md)


A
 few days ago I was asked to provide a BIOS version report for our Lenovo and Dell machines. Since you guys might find it useful I decided to publish it.

#### Import the SSRS Report

*   Download the report files`**## Without Company information**  
[**_HW BIOS by Manufacturer and Model for Collection.rdl_**](https://github.com/JhonnyTerminus/SCCMZone/blob/master/Reporting/Hardware/HW%20BIOS%20by%20Company%20or%20Manufacturer/HW%20BIOS%20by%20Manufacturer%20and%20Model%20for%20Collection.rdl)``**## With Company information _!! DEPRECATED No longer supported !!_**  
[**_HW BIOS by Company and Manufacturer for Collection.rdl_**](https://raw.githubusercontent.com/JhonnyTerminus/SCCMZone/master/Reporting/Hardware/HW%20BIOS%20by%20Company%20or%20Manufacturer/HW%20BIOS%20by%20Company%20and%20Manufacturer%20for%20Collection.rdl)`

*   Start Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the report
*   Enable **_Win32_Computer_System_Product_** class gathering in HWI
*   If you don’t add a logo, delete the placeholder on the top left> **Notes**  
> This report was created with **SQL 2014 Reporting Services**, you might need to remove some report elements if you use an older version.  
> You need to enable the **Company** attribute gathering in **System Discovery** if you choose the report with company information.

#### Report Query

For reference only, since the report includes this query.


For reference only, you can download the report above



#### Report Preview




![image](/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/2.png)

Report screenshoot





![image](/posts/2018-01-25_bios-version-reporting-by-manufacturer-and-model-with-sccm/images/3.gif)

#### Please use [Github](https://github.com/JhonnyTerminus/SCCMZone) for 🐛 reporting and feature requests 🌈

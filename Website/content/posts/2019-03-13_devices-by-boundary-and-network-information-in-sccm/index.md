---
title: "Devices by Boundary and Network Information in SCCM"
author: "Ioan Popovici"
date: 2019-03-13T18:42:18.921Z
lastmod: 2019-08-23T12:39:14+03:00

description: ""

subtitle: "Got to have this report for boundaries review :)"

image: "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/1.jpeg" 
images:
 - "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/1.jpeg" 
 - "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/2.png" 
 - "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/3.png" 
 - "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/4.gif" 
 - "/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/5.gif" 


aliases:
    - "/devices-by-boundary-and-network-information-in-sccm-45323b50b080"
---

![image](/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/1.jpeg)



Got to have this report for boundaries review :)

[**_Report release history_**](https://SCCM.Zone/SIT-Devices-by-Boundary-and-Network-CHANGELOG)


T
his all started with a simple boundary review when I figured It might be handy to have a boundary report. After some research It started to dawn on me that this would not be an easy task.

In the SCCM DB there is no correlation between boundaries and IP’s so there goes the easy way. After a lot of banging my head on the desk this is what I came up with. It’s not pretty but I did my best considering my limited SQL knowledge.

Here goes nothing…
> **Notes**  
> Three sql user defined functions are needed as a pre-requisite.

### Import the SSRS Report

*   Download the report file`**## Device by Boundary and Network Report** [_SIT Devices by Boundary and Network.rdl_](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Site/SIT%20Device%20by%20Boundary%20and%20Network/SIT%20Devices%20by%20Boundary%20and%20Network.rdl)`

*   Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files.
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports. You can use just one datasource if your CM and Reporting DBs are on the same server.

### Install Support Functions

You can create a new database to host the support function or just add it to the CM database. Fair **warning**, this counts as **‘modifying the CM database’**to Microsoft and they might **deny support** because of it. The right way to do this is to create a separate database for this purpose.

#### Create the ‘CM_Tools’ database

*   Create the** _‘CM_Tools’_** database by executing the following code in your SQL Management Studio:`**/* Create support function database */**  
CREATE DATABASE CM_TOOLS`

*   Create a new role and give it execute rights.`**/* Grant EXECUTE rights */**  
USE CM_TOOLS  
CREATE ROLE dbo_execute  
GRANT EXECUTE `ON SCHEMA::dbo `TO dbo_execute`

*   Add SSRS reporting user to the newly created role. Remember to add your own SSRS service account below.`**/* Add user to db_execute role */**  
`EXECUTE sp_addrolemember N&#39;db_execproc&#39;, &#39;Domain\SSRS_Service_User&#39;``

*   If you change the **_‘CM_Tools’_** __ name to something else you will need to modify the hardcoded function calls in report **_‘DeviceAndBoundaryData’_ **dataset and **‘_ufn_IsIPInSubnet’_ **support function.`**## Modify hardcoded function calls  
...  
/* Support function** */  
**...CM_TOOLS**.dbo.ufn**...**  
...`

#### Create the ufn_CIDRFromIPMask function

Gets the CIDR (‘/’) from a IP Subnet Mask.


Gets the CIDR (‘/’) from a IP Subnet Mask.



#### Create the ufn_IsIPInRange function

Checks if the IP is in the specified IP range.


Checks if the IP is in the specified IP range.



#### Create the ufn_IsIPInSubnet function

Checks if the IP is in the specified subnet using the subnet mask.


Checks if the IP is in the specified subnet using the subnet mask.





![image](/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/2.png)

You should end up with something like this

> **Notes**  
> Please **read** the instructions **carefully** before asking for help!

### Add report view permissions

By default some of the views I’m using for reporting are restricted for reporting purposes. You will need to add reporting access.
`GRANT SELECT ON vSMS_Boundary TO smsschm_users;  
GRANT SELECT ON vSMS_BoundaryGroup TO smsschm_users;  
GRANT SELECT ON vSMS_BoundaryGroupMembers TO smsschm_users;`

### Report Query

For reference only, since the report includes this query.


List devices by boundary and network information.



### Report Preview




![image](/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/3.png)

The collection selection is not shown here. It’s also kind of scrubbed…





![image](/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/4.gif)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏


![image](/posts/2019-03-13_devices-by-boundary-and-network-information-in-sccm/images/5.gif)

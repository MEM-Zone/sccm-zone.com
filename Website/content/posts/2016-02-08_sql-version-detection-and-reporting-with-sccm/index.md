---
title: "SQL Version Detection and Reporting with SCCM"
author: "Ioan Popovici"
date: 2016-02-08T13:37:36.777Z
lastmod: 2019-08-23T12:34:13+03:00

description: ""

subtitle: "SQL version reporting with SCCM done right…"

image: "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/1.jpeg" 
images:
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/1.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/2.png" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/3.png" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/4.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/5.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/6.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/7.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/8.jpeg" 
 - "/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/9.gif" 


aliases:
    - "/sql-version-detection-and-report-sccm-2012-r2-12f299b5e63b"
---

![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/1.jpeg)



SQL version reporting with SCCM done right…

[**_New version here_**](https://SCCM.Zone/SW-SQL-Server-Products)


By
 default, the SQL information that can be gathered with SCCM is incomplete. The version, service pack and cumulative update information are available in WMI, but are not stored in the cimv2 namespace. In order to be able to gather the relevant SQL information, a hardware inventory extension is required.
> **Notes**> **ALWAYS BACK-UP YOUR CONFIGURATION.MOF FILE BEFORE ANY CHANGES!  
> TEST THE CONFIGURATION.MOF USING MOFCOMP.EXE ON A TEST MACHINE FIRST!  
> HWI EXTENSION NEEDS TO BE DONE ON THE TOP OF YOUR HIERARCHY, CAS IF YOU USE ONE, PSS IF YOU DON’T.**

### Add SQL extensions to the Configuration.mof file

You can find the the [**_Configuration.mof_**](https://technet.microsoft.com/en-us/library/bb680858.aspx) file in **_&lt;CMInstallLocation&gt;\Inboxes\clifiles.src\hinv\_**

Look for the following section at the end of the _Configuration.mof_ file:
`//========================  
// Added extensions start   
//========================``//========================  
// Added extensions end   
//========================`

Inside this section paste the following extension:

#### SQL Information extension


SCCM HWI Extension for SQL Version Detection to paste in the **Configuration.mof** file

> **Notes**  
> Never create any extensions outside of the “Added extensions start/end” headers.  
> Try to have consistent formatting inside these headers.  
> Never modify anything outside these headers.  
> Watch for other previous extensions and use clear delimitation between them.

### Add Custom Classes to Hardware Inventory

#### SQL Information Definitions

Code posted only for reference, you can download the file below.


Code posted just for reference, you can download the file below



### Test and Implement HWI extension

Use [**_mofcomp.exe_**](http://mofcomp.exe%20configuration.mof)** __ **to check if configuration.mof was correctly modified, and implement the changes.

**Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.**

Either use a test environment or compile the file on a test machine first. After the file complies successfully you can check the WMI to see if the classes were created.

#### Compile configuration.mof
`**## Check syntax**  
mofcomp.exe -check {Configuration.mof Location}\Configuration.mof``**## Compile file**   
/*   
Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.  
*/``mofcomp.exe {Configuration.mof Location}\Configuration.mof`



![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/2.png)

Compling the configuration.mof is done on a test environment here



#### Check WMI for the new classes
`**## Check if the new classes are present in WMI** /* The machine must have at least one version of SQL installed in order for these classes to be created */``**#  Get SQL 2017 class**  
Get-CimClass -ClassName SQL_2017``**#  Get SQL 2014 class**  
Get-CimClass -ClassName SQL_2014``**#  Get SQL 2012 class**  
Get-CimClass -ClassName SQL_2012``**#  Get SQL 2008 class**  
Get-CimClass -ClassName SQL_2008``**#  Get SQL Legacy class**  
Get-CimClass -ClassName SQL_2000_And_2005`

### Implement changes on the CAS/PSS

#### Compile the configuration.mof file
`**## Compile file** /*   
Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.  
*/``mofcomp.exe &lt;CMInstallLocation&gt;\Inboxes\clifiles.src\hinv\Configuration.mof`



![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/3.png)

Implement HWI extension in production



#### Import the new HWI definitions

You need to add the new class definitions to the Default Client Settings.

**Download Definitions**
`**## SQL classes definition file**  
[_HWI DEF SQL Classes.mof_](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/6981a6523957fd5e288ebd959b84a0fc4df71ce5/Reporting/Software/SW%20SQL%20Server%20Products/HWI%20DEF%20SQL%20Classes.mof)`

**Import definitions**




![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/4.jpeg)

Click on Import and select the **_HWI DEF SQL Classes.mof_** file





![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/5.jpeg)

Review the classes and click on Import





![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/6.jpeg)

Make sure the SQL Classes are enabled and click OK



### Import the SSRS Report

#### Download the report file
`**## SQL version information report (**[**Octavian Cordos**](https://medium.com/u/ab05c8e0143f)**)**  
[_SW SQL Server Products.sql_](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/6981a6523957fd5e288ebd959b84a0fc4df71ce5/Reporting/Software/SW%20SQL%20Server%20Products/SW%20SQL%20Server%20Products.rdl)`

#### Upload reports to SSRS

*   Start Internet Explorer and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report file.

#### Configure imported reports

*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports.> **Notes** Allow some time for the policy to be downloaded of force a policy refresh to get the new WMI classes.  
> Allow some time for the data to be gathered or force a HWI collection.  
> This report was created with SQL 2014 Reporting Services, you might need to remove some report elements if you use an older version.

#### Report Query

For reference only, since the report includes this query.


Report query posted just for reference, you can download the **Report** above.



#### Report Preview




![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/7.jpeg)

Report preview





![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/8.jpeg)

#### **Please, Subscribe and Clap for this article! It makes a difference. Thanks!**




![image](/posts/2016-02-08_sql-version-detection-and-reporting-with-sccm/images/9.gif)

> Use [Github](http://SCCM.Zone/GIT) for 🐛 reporting, or 🌈 and🦄 requests

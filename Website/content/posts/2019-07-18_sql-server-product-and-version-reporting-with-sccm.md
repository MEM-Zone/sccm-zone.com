---
title: SQL Server Product and Version Reporting with SCCM
author: Ioan Popovici
date: 2019-07-18T14:46:56.069+00:00
lastmod: 2019-08-23T09:39:26.000+00:00
description: ''
subtitle: SQL licensing is always a pain but this report should make it a little easier…
images:
- "/uploads/1.jpeg"
- "/uploads/2.png"
- "/uploads/3.png"
- "/uploads/4.png"
- "/uploads/5.png"
- "/uploads/6.png"
- "/uploads/7.png"
- "/uploads/8.png"
- "/uploads/9.gif"
- "/uploads/10.gif"

---
SQL licensing is always a pain but this report should make it a little easier…

[**_Report release history_**](https://SCCM.Zone/SW-SQL-Server-Products-CHANGELOG)

[**_Previous report version_**](https://sccm-zone.com/sql-version-detection-and-report-sccm-2012-r2-12f299b5e63b)

[**_Originaly published on sccmf12twice.com_**](https://SCCM.Zone/SW-SQL-Server-Products-EXT)

This is the second iteration of my SQL version report. When I look back on my previous work I always cringe and this was no exception. A while back, I received a request to add the SQL key to the report, so I began examining the old code. Horrified by the things that I found laying dormant there, I scrapped everything and started anew. The result is a brand new report with a lot more info, smaller database footprint and much better coding.

## Recommendations

* Do not modify or remove the previous extension version until you thoroughly test the new version.
* Use a test environment for validation!
* Back-up your [configuration.mof](https://technet.microsoft.com/en-us/library/bb680858.aspx) file before any changes!
* Use [mofcomp.exe](https://docs.microsoft.com/en-us/windows/win32/wmisdk/mofcomp) to validate the [configuration.mof](https://technet.microsoft.com/en-us/library/bb680858.aspx) on a test machine first!

> **Notes**
> This version is compatible with the previous version, they can live side by side.
> Hardware inventory extension needs to be done on the top of your hierarchy.

## Installation

### Prerequisites

* Test environment
* Downloads (Right click → Download linked file)
  * [HWI EXT SQL Server Products.mof](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Software/SW%20SQL%20Server%20Products/HWI%20EXT%20SQL%20Server%20Products.mof) (HWI Extension)
  * [HWI DEF SQL Server Products.mof](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Software/SW%20SQL%20Server%20Products/HWI%20DEF%20SQL%20Server%20Products.mof) (HWI Definitions)
  * [SW SQL Server Products.rdl](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Software/SW%20SQL%20Server%20Products/SW%20SQL%20Server%20Products.rdl) (SSRS Report)
* SQL Stored Procedure → [Create the SQL Stored Procedure](Create-the-SQL-Stored-Procedure)

### HWI Extension

The extension needs to be added to the **&lt;CMInstallLocation&gt;\\Inboxes\\clifiles.src\\hinv\\configuration.mof** file

* Insert the extension at the end of the **configuration.mof** file and between the following headers:

``` bash
//========================
// Added extensions start
//========================

//========================
// Added extensions end
//========================
```

* Uncomment the '**Old SQL extension cleanup'** section to remove the old extension classes from the clients repositories if needed.
* Use a test environment for validation as described in the [Test and Validation](#test-and-validation) section.

> **Notes**
> Always use a test environment before any changes in production!
> Never create any extensions outside of the “Added extensions start/end” headers.
> Try to have consistent formatting inside these headers.
> Never modify anything outside these headers.
> Watch for other previous extensions and use clear delimitation between them.

### Apply changes

Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment on the next machine policy evaluation.

``` bash
mofcomp.exe <CMInstallLocation>\Inboxes\clifiles.src\hinv\Configuration.mof
```

![image](/uploads/2.png)

Implement HWI extension in production

### HWI Definitions

You need to add the new class definitions to the Default Client Settings

* Import definitions.

![image](/uploads/3.png)

Click on Import and select the **HWI DEF SQL Server Products.mof** file

![image](/uploads/4.png)

Review the classes and click on Import.

![image](/uploads/5.png)

Make sure the new extension classes are enabled and click OK

> **Notes**
> DO NOT DELETE the old extension definitions if you still want to use the old report!

## Test and Validation

### Configuration.mof

Use [**_mofcomp.exe_**](https://docs.microsoft.com/en-us/windows/win32/wmisdk/mofcomp) to check if [**_configuration.mof_**](https://technet.microsoft.com/en-us/library/bb680858.aspx) was correctly modified and implement the changes.

``` powershell
## Check syntax
mofcomp.exe -check <Configuration.mof_Directory>\Configuration.mof

## Compile file
/*
Compiling the configuration.mof file in the hinv folder on the CAS/PSS,
will trigger the distribution and compilation on all machines in your
environment on the next machine policy evaluation.
*/

mofcomp.exe <Configuration.mof_Directory>\Configuration.mof
```

![image](/uploads/6.png)

Compling the configuration.mof is done on a test environment here!

> **Notes**
> Saving and compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment on the next machine policy evaluation.

### WMI

Use PowerShell to check if the new classes have been created in WMI

``` powershell
## Check if the new classes are present in WMI
/* The machine must have at least one version of SQL installed in
order for these classes to be created */

#  Get SQL 2017 class
Get-CimClass -ClassName SQL_2017_Property

#  Get SQL 2014 class
Get-CimClass -ClassName SQL_2014_Property

#  Get SQL 2012 class
Get-CimClass -ClassName SQL_2012_Property

#  Get SQL 2008 class
Get-CimClass -ClassName SQL_2008_Property

#  Get SQL Legacy class
Get-CimClass -ClassName SQL_Legacy_Property

#  Get SQL ProductID class
Get-CimClass -ClassName SQL_ProductID
```

### Database

Use SSMS (SQL Server Management Studio) to check if the views are created in the CM database

![image](/uploads/7.png)

## Import the SSRS Report

### Upload Report to SSRS

* Start Internet Explorer and navigate to [**http://&lt;YOUR_REPORT_SERVER_FQDN&gt;Reports**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
* Choose a path and upload the previously downloaded report file.

### Configure Imported Report

* [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the report.

## Create the SQL Stored Procedure

The usp_PivotWithDynamicColumns is needed in order to maximize code reuse and have a more sane and sanitized data source.

* Copy paste the code below in SSMS
* Change the **&lt;SITE_CODE&gt;** in the **USE** statement to match your Site Code.
* Click **Execute** to add the [**_usp_PivotWithDynamicColumns_**](#vb-support-function) stored procedure to your database.

> **Notes**
> **You might need additional DB access to install the support function!**
> **Allow** some time for the policy to be downloaded or force a policy refresh.
> **Allow** some time for the data to be gathered or force a HWI collection.
> This report was created with SQL 2017 Reporting Services, you might need to remove some report elements if you use an older version.

## Preview

![image](/uploads/8.png "Report preview")

## Code

### Extension

For reference only, you can download the file in the [**Prerequisites**](#prerequisites) section.

### Definitions

For reference only, you can download the file in the [**Prerequisites**](#prerequisites) section.

### SQL Query

For reference only, the report includes this query.

### VB Support Function

For reference only, the report includes this function.

<script src="https://embed.cacher.io/83576ed10a66f816abf812925f284fa17d58fc14.js?a=dac2e390b609c7b9b8c4f97ff5b0a4cc&t=atom_one_dark&r=0"></script>

<script src="https://gist.github.com/Ioan-Popovici/db8228de1d96def7a455fdbf1b59f165.js"></script>

> **Notes**
> Credit to Jakob Bindslet and Chrissy LeMaire.

***

<center>![image](/uploads/9.gif "Random gif")</center>

***

## Please use [Github](http://SCCM.Zone/GIT) for 🐛 reporting, or 🌈 and 🦄 requests

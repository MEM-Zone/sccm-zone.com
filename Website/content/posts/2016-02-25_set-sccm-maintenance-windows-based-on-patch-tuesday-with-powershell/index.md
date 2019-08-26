---
title: "Set SCCM Maintenance Windows based on Patch Tuesday with PowerShell"
author: "Ioan Popovici"
date: 2016-02-25T17:17:07.174Z
lastmod: 2019-08-23T12:34:28+03:00

description: ""

subtitle: "This is a well known limitation SCCM but it can be addressed with non-recurrent Maintenance Windows."

image: "/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/1.jpeg" 
images:
 - "/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/1.jpeg" 
 - "/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/2.jpeg" 
 - "/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/3.gif" 


aliases:
    - "/setting-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell-c4cf76f0eb29"
---

![image](/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/1.jpeg)



This is a well known limitation SCCM but it can be addressed with non-recurrent Maintenance Windows.

[**_Script release history_**](https://SCCM.Zone/new-cmmaintenancewindows-changelog)

### Script

#### Configuration file parameters

The script is using a _“configuration”_ CSV where you can specify the script parameters.

*   **CollectionName** Specifies the collection name for which to set maintenance windows.
*   **Year**  _Specifies the maintenance window year._
*   **Month**
_Specifies the maintenance window month._
*   **OffsetWeeks** _Specifies the maintenance window offset number of weeks after patch Tuesday._
*   **OffsetDays**  _Specifies the maintenance window offset number of days after path Tuesday._
*   **StartTime** _Specifies the maintenance window start time._
*   **StopTime** Specifies the maintenance window stop time.
*   **SetForWholeYear** _Specifies if to set the maintenance windows for the whole year._
*   **RemoveExisting** _Specifies if to remove existing maintenance windows._
*   **ApplyTo** _Specifies the maintenance window type ( Any | SoftwareUpdates | TaskSequences)._

Create maintenance windows based on patch Tuesday





![image](/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2016-02-25_set-sccm-maintenance-windows-based-on-patch-tuesday-with-powershell/images/3.gif)

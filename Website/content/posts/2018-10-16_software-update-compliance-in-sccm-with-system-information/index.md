---
title: "Software Update Compliance in SCCM with System information"
author: "Ioan Popovici"
date: 2018-10-16T17:09:40.259Z
lastmod: 2019-08-23T12:37:28+03:00

description: ""

subtitle: "Sometimes you need all the data in one place…"

image: "/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/1.gif" 
images:
 - "/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/1.gif" 
 - "/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/2.png" 
 - "/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/3.png" 
 - "/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/4.png" 


aliases:
    - "/software-update-compliance-in-sccm-with-system-information-71881295d21a"
---

![image](/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/1.gif)



Sometimes you need all the data in one place…

[**_Report release history_**](https://github.com/Ioan-Popovici/SCCMZone/blob/master/Reporting/Updates/SU%20Compliance%20by%20Computer%20Classification%20and%20Severity/CHANGELOG.md)


I
 hate software update reports but a customer wanted a lot more data than any reports we had. My limited SQL skillset was a real pain here.

I struggled with the ‘Pending Restart Reason’ until I read in some obscure forum that the value is in fact a bit-mask. The bit-mask is then used to get all the available states for a machine.

Why oh why is the documentation for these features so poorly maintained?
> **Notes**  
> For this report you will need a string parser. I’ve included the code below to create that custom function.

#### Import the SSRS Report

*   Download the report file`**## Software update compliance report**  
[**_SU Compliance by Computer Classification and Severity_**](https://raw.githubusercontent.com/Ioan-Popovici/SCCMZone/master/Reporting/Updates/SU%20Compliance%20by%20Computer%20Classification%20and%20Severity/SU%20Compliance%20by%20Computer%20Classification%20and%20Severity.rdl)`

*   Start Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports
*   Create the **_ufn_csv_String_Parser_** function using the SQL query below. Don’t forget to replace the {Your_Site_Code} with your site code!> **Notes  
> **The default exclusions are for antivirus definitions. Selecting ‘ShowInstalledUpdates’ wi  
> This report was created with SQL 2014 Reporting Services, you might need to remove some report elements if you use an older version.#### **SQL Helper Function**


String parser helper function



#### Report Query

For reference only, since the report includes this query.


Software update compliance query



#### Report Preview




![image](/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/2.png)

Computer and Compliance status — Part 1





![image](/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/3.png)

Computer and Compliance status — Part 2





![image](/posts/2018-10-16_software-update-compliance-in-sccm-with-system-information/images/4.png)

---
title: "BitLocker Compliance and Policy Reporting with SCCM"
author: "Ioan Popovici"
date: 2018-11-02T13:03:15.290Z
lastmod: 2019-08-23T12:37:33+03:00

description: ""

subtitle: "If you are looking for a comprehensive BitLocker report, look no more…"

image: "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/1.jpeg" 
images:
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/1.jpeg" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/2.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/3.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/4.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/5.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/6.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/7.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/8.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/9.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/10.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/11.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/12.png" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/13.jpeg" 
 - "/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/14.gif" 


aliases:
    - "/bitlocker-compliance-and-policy-reporting-with-sccm-86539b6940a6"
---

![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/1.jpeg)



If you are looking for a comprehensive BitLocker report, look no more…

[**_Report release history_**](https://github.com/Ioan-Popovici/SCCMZone/blob/master/Reporting/Updates/SU%20Compliance%20by%20Computer%20Classification%20and%20Severity/CHANGELOG.md)


My
 vague promises of publishing a BitLocker report based on HWI seem to have come true. This is a complete report that also displays BitLocker GPO settings. In order to get the BitLocker and Policy data, you need to extend the SCCM Hardware Inventory. If you don’t want to do that you can use my [**_BitLocker Configuration Baseline_**](https://sccm-zone.com/create-bitlocker-encryption-compliance-reports-for-c-drive-in-sccm-764dc097bc9c) together with the [**_Baseline Report with Actual Values_**](https://sccm-zone.com/baseline-reporting-with-actual-values-output-in-sccm-73fec334ba8f).
> **Notes**> **ALWAYS BACK-UP YOUR CONFIGURATION.MOF FILE BEFORE ANY CHANGES!  
> TEST THE CONFIGURATION.MOF USING MOFCOMP.EXE ON A TEST MACHINE FIRST!  
> HWI EXTENSION NEEDS TO BE DONE ON THE TOP OF YOUR HIERARCHY, CAS IF YOU USE ONE, PSS IF YOU DON’T.**

### **Add SQL extensions to the _Configuration.mof_ file**

You can find the the [**_Configuration.mof_**](https://technet.microsoft.com/en-us/library/bb680858.aspx) file in **_&lt;CMInstallLocation&gt;\Inboxes\clifiles.src\hinv\_**

Look for the following section at the end of the _Configuration.mof_ file:
`//========================  
// Added extensions start   
//========================``//========================  
// Added extensions end   
//========================`

Inside this section paste the following extensions:

#### **BitLocker Status extension**


BitLocker status extension



#### **BitLocker Policy extension**


BitLocker Policy extension

> **Notes**  
> Never create any extensions outside of the “Added extensions start/end” headers.  
> Try to have consistent formatting inside these headers.  
> Never modify anything outside these headers.  
> Watch for other previous extensions and use clear delimitation between them.

### Test and Implement HWI extension

Use [**_mofcomp.exe_**](http://mofcomp.exe%20configuration.mof) **__** to check if configuration.mof was correctly modified, and implement the changes.

**Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.**

Either use a test environment or compile the file on a test machine first. After the file complies successfully you can check the WMI to see if the classes were created.

#### **Compile configuration.mof**
`**## Check syntax**  
mofcomp.exe -check {Configuration.mof Location}\Configuration.mof``**## Compile file**   
_/*   
Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.  
*/_``mofcomp.exe {Configuration.mof Location}\Configuration.mof`



![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/2.png)

Compling the configuration.mof is done on a test environment here



#### **Check WMI for the new classes**
`**## Check if the new classes are present in WMI**``**#  Get BitLocker Status class**  
Get-CimClass -ClassName Win32_EncryptableVolume_Ext``**#  Get BitLocker Policy class**  
Get-CimClass -ClassName Win32Reg_BitLockerPolicy`



![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/3.png)

Check if the new classes are present in WMI



### **Implement changes on the CAS/PSS**

#### Compile the configuration.mof file
`**## Compile file**   
_/*   
Compiling the configuration.mof file in the hinv folder on the CAS/PSS, will trigger the distribution and compilation on all machines in your environment.  
*/_``mofcomp.exe &lt;CMInstallLocation&gt;\Inboxes\clifiles.src\hinv\Configuration.mof`



![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/4.png)

Implement HWI extension in production



#### Import the new HWI definitions

You need to add the new class definitions to the Default Client Settings.

**Download definitions**
`**## BitLocker Status**  
[_HWI DEF Win32_EncryptableVolume_Ext.mof_](https://raw.githubusercontent.com/Ioan-Popovici/SCCM-Zone/master/Reporting/Security/SEC%20BitLocker%20Compliance%20and%20Policy/HWI%20DEF%20Win32_EncryptableVolume_Ext.mof)``**## BitLocker Policy  
**[_HWI DEF Win32Reg_BitlockerPolicy.mof_](https://raw.githubusercontent.com/Ioan-Popovici/SCCM-Zone/master/Reporting/Security/SEC%20BitLocker%20Compliance%20and%20Policy/HWI%20DEF%20Win32Reg_BitlockerPolicy.mof)`

**Import definitions**




![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/5.png)

BitLocker Status definitions





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/6.png)

BitLocker Policy definitions





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/7.png)

BitLocker Status definitions import summary





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/8.png)

BitLocker Policy definitions import summary





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/9.png)

The new imported classes





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/10.png)

The DB tables should be created immediately after import



### Import the SSRS Report

The report has two parts, one main report and a policy sub-report. If you rename the sub-report you will have to change the hard coded value in the main report. Report and sub-report need to be located in the same folder.

#### Download the report files
`**## BitLocker Main Report**  
[_SEC Bitlocker Compliance and Policy.rdl_](https://raw.githubusercontent.com/Ioan-Popovici/SCCM-Zone/master/Reporting/Security/SEC%20BitLocker%20Compliance%20and%20Policy/SEC%20Bitlocker%20Compliance%20and%20Policy.rdl)``**## BitLocker Policy Sub-Report  
**[_SR Display Formatted Text.rdl_](https://github.com/Ioan-Popovici/SCCM-Zone/blob/master/Reporting/Security/SEC%20BitLocker%20Compliance%20and%20Policy/SR%20Display%20Formatted%20Text.rdl)`

#### Upload reports to SSRS

*   Start Internet Explorer and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files.

#### Configure imported reports

*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports.
*   If you don’t add a logo, delete the placeholder on the top left.> **Notes**  
> This report was created with SQL 2014 Reporting Services, you might need to remove some report elements if you use an older version.

#### Report Query

For reference only, since the report includes this query.


BitLocker Compliance and Policy report query



#### Report Preview




![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/11.png)

BitLocker Compliance and Policy report





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/12.png)

BitLocker Policy sub-report (Settings without values are filtered automatically)





![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/13.jpeg)

**Please, Subscribe and Clap for this article! It makes a difference. Thanks!**




![image](/posts/2018-11-02_bitlocker-compliance-and-policy-reporting-with-sccm/images/14.gif)

> Use [Github](http://SCCM.Zone/GIT) for 🐛 reporting, or 🌈 and🦄 requests

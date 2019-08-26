---
title: "Create a BitLocker Encryption Compliance Report for all Drives in SCCM"
author: "Ioan Popovici"
date: 2015-01-28T13:39:53.348Z
lastmod: 2019-08-23T12:31:56+03:00

description: "BitLocker Encryption Status SCCM"

subtitle: "This can be achieved fairly easy using SCCM Configuration Items (CI) and Configuration Baselines (CB)."

image: "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/1.jpeg" 
images:
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/1.jpeg" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/2.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/3.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/4.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/5.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/6.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/7.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/8.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/9.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/10.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/11.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/12.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/13.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/14.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/15.png" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/16.jpeg" 
 - "/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/17.gif" 


aliases:
    - "/create-bitlocker-encryption-compliance-reports-for-c-drive-in-sccm-764dc097bc9c"
---

![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/1.jpeg)



This can be achieved fairly easy using SCCM Configuration Items (CI) and Configuration Baselines (CB).

[**_Script release history_**](https://SCCM.Zone/get-bitlockerstatus-changelog)

### Script

#### Script parameters

*   **DriveType** _Specifies the drive type(s) for which to get the bitlocker status. Default is: ‘3’._
*   **DriveLetter** _Specifies the drive letter(s) for which to get the bitlocker status. Default is: ‘All’._

Gets the BitLocker protection status



#### Configuration Item




![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/2.png)

Create the CI





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/3.png)

Set the Operating System on which the CI can run





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/4.png)

Create a new setting and add the PowerShell script





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/5.png)

Create the first Compliance Rule for Script Error Detection





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/6.png)

Create the second Compliance Rule for BitLocker Status Detection





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/7.png)

You should end up with something like this



#### Baseline




![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/8.png)

Create a new Baseline and add the Configuration item to it





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/9.png)

Deploy the Configuration Baseline



#### Validation




![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/10.png)

On the machine where you deployed the Baseline run Machine Policy Retrieval &amp; Evaluation Cycle





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/11.png)

The Configuration Baseline should show up in a couple of minutes in the Configurations tab





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/12.png)

You can view a local report to check the compliance





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/13.png)

See “Instance Data” for the compliance check results





![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/14.png)

Or you can check the deployment results in the Monitoring node on the Site Server



#### Reporting




![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/15.png)

Report preview



You can download my **_Configuration Baseline_** report from [**_here_**](https://SCCM.Zone/cb-configuration-baseline-compliance)



![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/16.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2015-01-28_create-a-bitlocker-encryption-compliance-report-for-all-drives-in-sccm/images/17.gif)

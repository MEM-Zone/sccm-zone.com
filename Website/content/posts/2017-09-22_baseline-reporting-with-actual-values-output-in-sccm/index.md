---
title: "Baseline Reporting with Actual Values output in SCCM"
author: "Ioan Popovici"
date: 2017-09-22T16:47:12.989Z
lastmod: 2019-08-23T12:35:37+03:00

description: ""

subtitle: "If you need a simple report for all your baselines, search no more!"

image: "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/1.png" 
images:
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/1.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/2.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/3.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/4.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/5.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/6.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/7.png" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/8.jpeg" 
 - "/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/9.gif" 


aliases:
    - "/baseline-reporting-with-actual-values-output-in-sccm-73fec334ba8f"
---

![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/1.png)



If you need a simple report for all your baselines, search no more!

[**_Report release history_**](https://SCCM.Zone/cb-configuration-baseline-compliance-changelog)


A
 few days ago I got an interesting request on my blog for a BitLocker report based on a Configuration Baseline. So I figured it was high time to update and publish my own Baseline Compliance Report.

### Import the SSRS Report

*   Download the report file`**## Configuration Baseline Compliance by CI with Values**  
[**_CB Configuration Baseline Compliance by Configuration Item with Values.rdl_**](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Compliance/CB%20Configuration%20Baseline%20Compliance/CB%20Configuration%20Baseline%20Compliance%20by%20Configuration%20Item%20with%20Values.rdl)`

*   Start Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports
*   If you don’t add a logo, delete the placeholder on the top left.> **Notes** Only non-compliant settings return a value so the configuration item setting needs to have a non-compliant rule!> Be patient… I’ve tested it on a 1500 device collection and it works but it’s slow since there is a lot of data to process. It will take about 5–10 minutes for that number depending on your configuration and the number of settings that the configuration item has.

### Report Query

For reference only, since the report includes this query.


Configuration Baseline Compliance query



### **Get Registry Keys Sample Script**


Get registry key values



### Report Preview




![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/2.png)

New report template





![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/3.png)

Non-Compliant





![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/4.png)

Error





![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/5.png)

Compliant





![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/6.png)

Registry keys values (Old report template version)





![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/7.png)

Configuration baseline report on machine



#### BitLocker Compliance

If you want to check out my BitLocker Encryption Status for all Drives using a Configuration Baseline you can find it [**_here_**](https://ioan.in/2fFObha)



![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/8.jpeg)

No Comment…

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏


![image](/posts/2017-09-22_baseline-reporting-with-actual-values-output-in-sccm/images/9.gif)

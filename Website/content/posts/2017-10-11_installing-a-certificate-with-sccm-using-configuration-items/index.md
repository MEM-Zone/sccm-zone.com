---
title: "Installing a Certificate with SCCM using Configuration Items"
author: "Ioan Popovici"
date: 2017-10-11T16:08:10.013Z
lastmod: 2019-08-23T12:35:45+03:00

description: ""

subtitle: "Is a expired certificate is giving you a hard time? SCCM to the rescue!"

image: "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/1.jpeg" 
images:
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/1.jpeg" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/2.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/3.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/4.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/5.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/6.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/7.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/8.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/9.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/10.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/11.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/12.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/13.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/14.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/15.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/16.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/17.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/18.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/19.png" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/20.jpeg" 
 - "/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/21.gif" 


aliases:
    - "/installing-a-certificate-with-sccm-configuration-items-53832b099c51"
---

![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/1.jpeg)



Is a expired certificate is giving you a hard time? SCCM to the rescue!

[**_Select-Certificate release history_**](https://SCCM.Zone/Select-Certificate-CHANGELOG) **__** [**_Add-Certificate release history_**](https://SCCM.Zone/Add-Certificate-CHANGELOG)


A
 while back a WSUS self-signed certificate expired for one of our clients. Instead of modifying 50+ GPOs I created a Configuration Item and solved the problem in ~30 minutes.

### Certificate

#### Certificate Serial Number




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/2.png)

Get the Certificate Serial Number



#### Certificate Base-64 key




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/3.png)

Export the certificate in Base-64 format





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/4.png)

Open the exported file with Notepad and get the Certificate Key



### Discovery Script

#### Script Variables

*   cerStores = The _Certificate Stores_ where the certificate needs to be added.
*   cerSertialNumber = The Certificate _Serial Number_ to match.> **Notes**  
> You need to put in your own variables!

Discovery Script



### Remediation Script

#### Script Variables

*   cerStores = The _Certificate Stores_ where the certificate needs to be added.
*   cerStringBase64 = The _Certificate Key_ in base-64 format to be added.

Remediation script

> **Notes**  
> You need to put in your own variables!

### Configuration Item




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/5.png)

Create the CI





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/6.png)

Set the Operating System on which it can run





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/7.png)

Create a new setting and add the PowerShell Scripts





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/8.png)

Create the Compliance Rule



### Baseline




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/9.png)

Create a new Configuration Baseline and add the Configuration Item





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/10.png)

Deploy the Configuration Baseline



### Validation




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/11.png)

On the machine where you deployed the Baseline run Machine Policy Retrieval &amp; Evaluation Cycle





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/12.png)

The Configuration Baseline should show up in a couple of minutes in the Configurations tab. Hit “Refresh” if you don’t see it.





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/13.png)

If compliance is still unknown hit “Evaluate” and afterwards “View Report”





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/14.png)

See “Instance Data” for remediation results





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/15.png)

If the remediation fails you’ll see something like this





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/16.png)

You can also check the DcmWmiProvider.log





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/17.png)

Or you can check the deployment results in the Monitoring node on the Site Server





![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/18.png)

Click “View Status”, select a machine and click “More Details” to see individual details



### Reporting




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/19.png)

Report Preview



If you want a Baseline report you can download my [**_Configuration Baseline Report_**](https://SCCM.Zone/cb-configuration-baseline-compliance)**_._**



![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/20.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-10-11_installing-a-certificate-with-sccm-using-configuration-items/images/21.gif)

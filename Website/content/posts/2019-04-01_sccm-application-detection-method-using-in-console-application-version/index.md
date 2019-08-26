---
title: "SCCM Application Detection Method using in Console Application Version"
author: "Ioan Popovici"
date: 2019-04-01T16:19:15.931Z
lastmod: 2019-08-23T12:39:20+03:00

description: ""

subtitle: "Say no to application version hardcoded in the detection script."

image: "/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/1.jpeg" 
images:
 - "/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/1.jpeg" 
 - "/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/2.jpeg" 
 - "/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/3.gif" 


aliases:
    - "/sccm-application-detection-method-using-in-console-application-version-59a755995942"
---

![image](/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/1.jpeg)



Say no to application version hardcoded in the detection script.


T
This method is valid for any application. In this case I will use the configuration manager client upgrade application. You might ask yourself, why not use the automatic client upgrade? Well, because the client upgrade can only run during a maintenance window. I won’t go into details, but unless this behavior changes, I cannot use this feature with my current configuration.

Without further ado, here is how to do it…

### Create the Application

I wanted to make this as simple as possible so I don’t have to tinker with it every time there’s a new update.

#### Set the configuration manager application version

The version will be used by the discovery method, make sure you use the correct one.

#### Set the application source

This path will remain the same, so there is no need to touch this ever again.
`_%ConfigMgrServer%\%ConfigMgrPath%\Client_`

#### Create the installation script

In order to be able to specify the local installation source we need to use a script. Useful in low bandwidth environments.


Configuration manager client installation script.



#### Set the discovery method

Remember to change the application name accordingly.


Configuration manager discovery method



#### Set the Install String
`_Powershell.exe -File Install-CMClient.ps1 -ExecutionPolicy ‘Bypass’ -WindowStyle ‘Hidden’_`

#### **Set the uninstall string**
`CCMSETUP.EXE /Uninstall`

### Deploy the application

The only thing to do now is to deploy the newly created application. If a new version of the client becomes available you just need to change the application version and update the content.
> **Notes** The production version of the configuration manager client is always used, so make sure you promote the pilot to production if you want to use the latest version.



![image](/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏


![image](/posts/2019-04-01_sccm-application-detection-method-using-in-console-application-version/images/3.gif)

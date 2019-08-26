---
title: "Cleaning the Windows Image before Sysprep during an SCCM B&C Task Sequence"
author: "Ioan Popovici"
date: 2017-08-01T14:53:25.805Z
lastmod: 2019-08-23T12:35:04+03:00

description: ""

subtitle: "Cleaning update caches and other junk before Sysprep was always a hurdle… until now :)"

image: "/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/1.jpeg" 
images:
 - "/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/1.jpeg" 
 - "/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/2.png" 
 - "/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/3.jpeg" 
 - "/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/4.gif" 


aliases:
    - "/cleaning-the-windows-image-before-sysprep-during-a-sccm-b-c-task-sequence-214b0bdb4088"
---

![image](/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/1.jpeg)



Cleaning update caches and other junk before Sysprep was always a hurdle… until now :)

[**_Script release history_**](https://SCCM.Zone/Clean-WindowsImage-CHANGELOG)


I
 was creating a Windows image some time ago and wanted to slim down the image before capturing it.

After some research, I found the [_Action-CleanupBeforeSysprep_](https://github.com/DeploymentBunny/Files/tree/master/Tools/Action-CleanupBeforeSysprep) script by [**_Mikael Nystrom_**](https://anothermike2.wordpress.com/)

It’s a very nice script but it has MDT dependencies and for some reason whenever I see VBScript I get shivers down my spine. This led me to re-write and optimize it using PowerShell. One nice thing about it that you still have some error reporting in **_smsts.log_** without using MDT.
> **Notes**  
> This is an on-line cleanup script, an can be run independently from SCCM TS environment.

### Script


Cleaning Drive and Update Caches with PowerShell



#### **Run from Task Sequence**




![image](/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/2.png)

Build and Capture Task Sequence, Cleanup script step

> **Notes** You can run the script manually to see if it works, please let me know if you find bugs :)



![image](/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/3.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-08-01_cleaning-the-windows-image-before-sysprep-during-an-sccm-bc-task-sequence/images/4.gif)

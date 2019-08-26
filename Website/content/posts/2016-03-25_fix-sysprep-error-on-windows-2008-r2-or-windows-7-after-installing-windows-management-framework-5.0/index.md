---
title: "Fix Sysprep Error on Windows 2008 R2 or Windows 7 after installing Windows Management Framework 5.0"
author: "Ioan Popovici"
date: 2016-03-25T18:48:35.180Z
lastmod: 2019-08-23T12:34:35+03:00

description: ""

subtitle: "I always hate it when sysprep fails but this time it had a happy ending…"

image: "/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/1.png" 
images:
 - "/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/1.png" 
 - "/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/2.jpeg" 
 - "/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/3.gif" 


aliases:
    - "/fix-sysprep-error-on-windows-2008-r2-after-windows-management-framework-5-0-installation-b9e86b4c41e4"
---

![image](/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/1.png)



I always hate it when sysprep fails but this time it had a happy ending…

### **Problem**

*   Install Windows Management Framework 5.0 (Contains PowerShell 5.0)
on Windows 2008 R2 or Windows 7.
*   Run sysprep.
*   Sysprep fails with:`Sysprep_Generalize_MiStreamProv: RegDeleteValue for target uri failed with error = 2[gle=0x00000002]  
Sysprep_Generalize_MiStreamProv: RegDeleteValue for full payload time failed with error = 2[gle=0x00000002]`

### **Solution**

*   Add the following key to registry:`[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\StreamProvider] “LastFullPayloadTime”=dword:00000000`

*   Try sysprep again it should work.



![image](/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/2.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2016-03-25_fix-sysprep-error-on-windows-2008-r2-or-windows-7-after-installing-windows-management-framework-5.0/images/3.gif)

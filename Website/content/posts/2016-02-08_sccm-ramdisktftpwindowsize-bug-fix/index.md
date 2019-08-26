---
title: "SCCM RamDiskTFTPWindowSize Bug Fix"
author: "Ioan Popovici"
date: 2016-02-08T12:09:48.035Z
lastmod: 2019-08-23T12:33:09+03:00

description: ""

subtitle: "This is a long standing bug in SCCM, the RamDiskTFTPWindowSize should be the way to speed up PXE boot but…"

image: "/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/1.jpeg" 
images:
 - "/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/1.jpeg" 
 - "/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/2.png" 
 - "/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/3.jpeg" 
 - "/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/4.gif" 


aliases:
    - "/sccm-ramdisktftpwindowsize-bug-fix-28979bcb2ec7"
---

![image](/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/1.jpeg)



This is a long standing bug in SCCM, the RamDiskTFTPWindowSize should be the way to speed up PXE boot but…

#### **!!! UPDATE !!! — Finally fixed in SCCM 1603—!!! UPDATE !!!**

[VMware PXE Limitations](http://www.bctechnet.com/vmware-pxe-limitations/)
### **In order to speed up PXE booting in SCCM you have two options**

*   Most of the articles I’ve read suggest increasing [RamDiskTFTPBlockSize](http://windowsdeployments.net/how-to-speed-up-pxe-boot-in-wds-and-sccm/) but it’s obviously the wrong option because it causes [_IP Fragmentation_](http://en.wikipedia.org/wiki/IP_fragmentation)_._
*   Using RamDiskTFTPWindowSize should be the right way to do it, but after tinkering with it I’ve experienced no speed improvements. After a lot of searching I’ve finally learned that there is a **bug** in SCCM 2012/R2 and that value is not parsed by the **smspxe.dll**. **_(This method is not supported or recommended by Microsoft)_**

### **Implementing the fix**

In order to fix this we need to patch the **smspxe.dll** so it uses the **RamDiskTFTPBlockSize** value as the **RamDiskTFTPWindowSize** value.

*   Back-up your **smspxe.dll**, it should be in the **\BIN\I386\smspxe.dll**, **\BIN\X64\smspxe.dll** or **\BIN\smspxe.dll** folder of your currently PXE enabled DP.
*   Stop the **Windows Deployment Services** service to remove the lock from the file.
*   Open it with a hex editor like [_Hex Workshop_](http://www.hexworkshop.com) select **Type** as **Hex Values** check in **Options** **_Find All Instances_ **and search for **07000035** as value. You should find just one instance. If you find more than one search for **BA07000035**.
*   Change the **07000035** value to **08000035** or the **BA07000035** value to **BA08000035** and save the **smspxe.dll**.



![image](/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/2.png)



*   Create the following **DWORD** registry key: **_HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\DP\RamdiskTFTPBlockSize_** and set the value to **4** or **8** (**8** is faster).
*   Start the **Windows Deployment Services** service.> **_Notes  
> _**_Setting the labeled_ **_RamdiskTFTPBlockSize_** _key in registry is intentional, as this is key the_ **_smspxe.dll_** _is looking for, the DLL hack changes how that key is interpreted._

**_Keep in mind that this method is not supported or recommended by Microsoft._**



![image](/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/3.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2016-02-08_sccm-ramdisktftpwindowsize-bug-fix/images/4.gif)

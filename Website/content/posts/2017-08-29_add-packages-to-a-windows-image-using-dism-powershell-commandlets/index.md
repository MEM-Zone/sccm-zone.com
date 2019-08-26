---
title: "Add packages to a Windows Image using DISM PowerShell commandlets"
author: "Ioan Popovici"
date: 2017-08-29T09:40:30.373Z
lastmod: 2019-08-23T12:35:10+03:00

description: ""

subtitle: "Stop using DISM.exe, use PowerShell DISM commandlets instead…"

image: "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/1.jpeg" 
images:
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/1.jpeg" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/2.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/3.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/4.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/5.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/6.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/7.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/8.png" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/9.jpeg" 
 - "/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/10.gif" 


aliases:
    - "/add-packages-to-a-windows-image-using-dism-powershell-commandlets-71769c303a1a"
---

![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/1.jpeg)



Stop using DISM.exe, use PowerShell DISM commandlets instead…

[**_Script release history_**](http://Update-OfflineWindowsImage-CHANGELOG)


L
ast week, I was working on a post on how to get a updated Windows 7 image using SCCM Offline Servicing and DISM. I spent a few hours making and testing a batch file, writing the post and simplifying the language. I was about to press _“Publish”_ when my idiotic brain began to wonder why I’m posting a batch file in 2017. I could not let it go, so I am publishing this post instead. The windows 7 update saga will follow later this week :)

### Prerequisites

*   Download and install __ [**_Windows ADK_**](https://go.microsoft.com/fwlink/p/?LinkId=845542) __ for Windows 10, version 1703.
*   Download the latest OS images from [**_MSDN_**](https://my.visualstudio.com/downloads/featured)**_._**
*   Mount the images and copy the **_[MountedImage]\sources\install.wim_** to a local drive (D:\Temp).
*   Download the desired packages from [**_Windows Update Catalog_**](https://www.catalog.update.microsoft.com/Home.aspx) __ or some other trusted source and copy them in a **“_Updates_”** subfolder located in the same folder as the WIM images (D:\Temp\Updates).
*   Copy the **_Update-OfflineWindowsImage.ps1_** script in the same folder as the images.
*   Run the **_Update-OfflineWindowsImage.ps1_** script from an elevated PowerShell console and follow the instructions.

### Script


Add packages to a WIM using DISM commandlets



### Screenshots




![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/2.png)

The “Work” folder should look something like this, in this case I use just one x86 image





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/3.png)

Updates folder, numbering is intentional as packages are processed in sequence





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/4.png)

WIM Image selection, you can select multiple images but only the first one will be processed





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/5.png)

Windows version selection, you can select multiple versions but only the first one will be processed





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/6.png)

Packages selection, you use multiple selection here





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/7.png)

PowerShell console output





![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/8.png)

The final image will have **_“_Serviced”_ **_added to the filename._

> **_Notes_**> Original WIM file was also modified, so if you want to run the process again rename the back-up file.  
> Back-up file will be overwritten on a second pass!  
> $Env:Path **** variable must be changed as seen in the script in order to use the latest version of DISM.  
> Do not use the -Optimize switch when mounting the image



![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/9.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-08-29_add-packages-to-a-windows-image-using-dism-powershell-commandlets/images/10.gif)

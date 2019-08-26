---
title: "Extend the SCCM Console to show Collection Membership using Console Builder"
author: "Ioan Popovici"
date: 2019-02-28T17:32:05.007Z
lastmod: 2019-08-23T12:38:04+03:00

description: ""

subtitle: "Let’s be frank the collection membership should be visible in the console by default. Here’s how to do it…"

image: "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/1.png" 
images:
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/1.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/2.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/3.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/4.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/5.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/6.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/7.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/8.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/9.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/10.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/11.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/12.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/13.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/14.png" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/15.gif" 
 - "/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/16.gif" 


aliases:
    - "/extend-the-sccm-console-to-show-collection-membership-using-console-builder-c6db52b408d8"
---

![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/1.png)



Let’s be frank the collection membership should be visible in the console by default. Here’s how to do it…


U
sing RCT to show the collection membership is slow and awkward. In my search to find a better option I stumbled onto the SCCM Console Builder. This is an amazing tool that is already built-in and allows a wide range of customization. I used Zeng Yinghua’s [**_blog post_**](https://www.scconfigmgr.com/2017/11/09/customizing-configmgr-admin-console-add-details-tab-to-content-status/) as a guide when creating this extension.

Without further ado let’s get to it!

### Start the Console Builder

Start PowerShell on any machine that has the SCCM console installed and run the following command:
`**## Start SCCM Console Builder**  
&amp;$env:SMS_ADMIN_UI_PATH.Replace(&#39;i386&#39;,&#39;AdminUI.ConsoleBuilder.exe&#39;)`> **Notes** Console builder path %ConfigMgrInstallPath%\AdminConsole\Bin\AdminUI.ConsoleBuilder.exe  
> THE CONSOLE BUILDER HAS NO SAVE FUNCTION! ANY CHANGES WILL BE COMMITTED WHEN THE CONSOLE BUILDER IS CLOSED.  
> Remember to backup your **XmlStorage** folder in the **.\AdminConsole** root.  
> You can overwrite this folder on any system that needs the extension.  
> _In this particular case you only need to back-up the_ **AssetManagementNode.xml** and **ConnectedConsole.xml** files.



![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/2.png)

XmlStorage folder



### Open the Connected Console




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/3.png)

Open the connected console



### Add a New Tab to the Devices Detail Panel




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/4.png)

Add a new tab page in the Devices Detail Panel





![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/5.png)

Configure tab to run a query



### Configure the Tab Query Settings




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/6.png)

Configure query settings



### Add the Tab Query


Tab query





![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/7.png)

Add the tab query and press OK



### Open the Navigation Alias Table




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/8.png)

Open the Navigation Alias Table and edit the MemberOfCollection Alias





![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/9.png)

Edit the Devices View



### Add a New Tab to the Devices View Detail Panel




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/10.png)

Add a new tab to the devices view detail panel



### Configure the Tab Query Settings




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/11.png)

Configure query settings



### Add the Tab Query


Tab query





![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/12.png)

Add the tab query and press OK



### Apply Modifications

Click Ok on all open settings, close the Console Builder and start/restart the SCCM Console.
> **Notes** _THE CONSOLE BUILDER HAS NO SAVE FUNCTION! ANY CHANGES WILL BE COMMITTED WHEN THE CONSOLE BUILDER IS CLOSED.  
> Remember to backup your_ **_XmlStorage_** _folder in the_**_.\AdminConsole_** _root.  
> You can overwrite this folder on any system that needs the extension.  
> In this particular case you only need to back-up the_ **AssetManagementNode.xml** and **ConnectedConsole.xml** files.

### Extension Preview




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/13.png)

Device View extension preview





![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/14.png)

Collection Device View extension preview



### **Links**

#### **Official Documentation**

[_https://msdn.microsoft.com/en-us/library/hh948631.aspx_](https://msdn.microsoft.com/en-us/library/hh948631.aspx)

#### Blogs

*   Covers the subject in-depth and is really everything you need
[Extending the Configuration Manager (Current Branch) Console - Part 1](https://blog.itsdelivers.com/productive-it-insights/extending-the-configuration-manager-current-branch-console-part-1)


*   A very good example by Zeng Yinghua
[Customizing ConfigMgr Admin Console - Add Details tab to Content Status](https://www.scconfigmgr.com/2017/11/09/customizing-configmgr-admin-console-add-details-tab-to-content-status/)




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/15.gif)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2019-02-28_extend-the-sccm-console-to-show-collection-membership-using-console-builder/images/16.gif)

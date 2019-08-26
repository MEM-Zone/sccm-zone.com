---
title: "Creating an Updated Windows 7 OSD Image with SCCM Build and Capture"
author: "Ioan Popovici"
date: 2017-08-31T14:50:31.923Z
lastmod: 2019-08-23T12:35:17+03:00

description: ""

subtitle: "Creating a OSD Image can be a hassle but with a bit of automation you can drop a lot of overhead"

image: "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/1.png" 
images:
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/1.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/2.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/3.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/4.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/5.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/6.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/7.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/8.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/9.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/10.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/11.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/12.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/13.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/14.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/15.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/16.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/17.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/18.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/19.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/20.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/21.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/22.png" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/23.jpeg" 
 - "/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/24.gif" 


aliases:
    - "/creating-a-updated-windows-7-osd-image-with-sccm-build-and-capture-d629b5561413"
---

![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/1.png)



Creating a OSD Image can be a hassle but with a bit of automation you can drop a lot of overhead


T
he recommendation is to use MDT for creating your OSD Image, but I achieved the same results using SCCM.

Here I’m using Windows 7 with Office 2010, but the process is similar for every OS and Office Version.

### Image specs

#### Injected in the Base Image

*   Windows 7, fully updated
*   Internet Explorer 11

#### Installed during Build and Capture

*   Office 2010, fully updated
*   .Net Framework 4.7
*   WMF 5.1
*   Redistributables

### Important things to remember when creating a OSD Image

*   ALWAYS use a Vanilla WIM for your BASE Image. The BASE Image consists of a Vanilla WIM updated using Offline Servicing.
*   IMPORT the WIM from the latest version of the OS Image downloaded from MSDN. Deploying the MSDN image and using the captured version is not the proper procedure.
*   USE Offline Servicing only on your BASE Image. Offline Servicing your OSD Image is easier but it can get you in a lot of trouble.
*   DO B&amp;C every month for all OSD Images after performing Offline Servicing on the BASE Images.
*   INCLUDE your core applications in the OSD Image. The OSD Image is the final image used by the Customer for OSD. This will shorten de deployment time, and reduce the complexity of the OSD Task Sequence. Remember not to go overboard with it though.
*   INCLUDE Office Updates in the OSD Image. Office 2010 has a ton of updates and no recent service pack, so including them saves time during OSD.

### Step 1 — Download Patches

#### [**Download IE11 and prerequisites**](https://support.microsoft.com/en-us/help/2847882/prerequisite-updates-for-internet-explorer-11)

*   **x86
**[_Windows6.1-KB2729094-v2-x86.msu_](https://download.microsoft.com/download/B/6/B/B6BF1D9B-2568-406B-88E8-E4A218DEA90A/Windows6.1-KB2729094-v2-x86.msu)_
_[_Windows6.1-KB2731771-x86.msu_](https://download.microsoft.com/download/A/0/B/A0BA0A59-1F11-4736-91C0-DFCB06224D99/Windows6.1-KB2731771-x86.msu)_
_[_Windows6.1-KB2533623-x86.msu_](https://download.microsoft.com/download/2/D/7/2D78D0DD-2802-41F5-88D6-DC1D559F206D/Windows6.1-KB2533623-x86.msu)_
_[_Windows6.1-KB2670838-x86.msu_](https://download.microsoft.com/download/1/4/9/14936FE9-4D16-4019-A093-5E00182609EB/Windows6.1-KB2670838-x86.msu)_
_[_Windows6.1-KB2786081-x86.msu_](https://download.microsoft.com/download/4/8/1/481C640E-D3EE-4ADC-AA48-6D0ED2869D37/Windows6.1-KB2786081-x86.msu)_
_[_Windows6.1-KB2834140-v2-x86.msu_](https://download.microsoft.com/download/F/1/4/F1424AD7-F754-4B6E-B0DA-151C7CBAE859/Windows6.1-KB2834140-v2-x86.msu)_
_[_IE11-Windows6.1-KB2841134-x86.cab_](http://download.microsoft.com/download/C/0/1/C0186BE0-0ADB-4AF3-B97D-11FCEBE6BD68/IE11-Windows6.1-KB2841134-x86.cab)
*   **x64
**[_Windows6.1-KB2729094-v2-x64.msu_](http://download.microsoft.com/download/6/C/A/6CA15546-A46C-4333-B405-AB18785ABB66/Windows6.1-KB2729094-v2-x64.msu)_
_[_Windows6.1-KB2731771-x64.msu_](http://download.microsoft.com/download/9/F/E/9FE868F6-A0E1-4F46-96E5-87D7B6573356/Windows6.1-KB2731771-x64.msu)_
_[_Windows6.1-KB2533623-x64.msu_](http://download.microsoft.com/download/F/1/0/F106E158-89A1-41E3-A9B5-32FEB2A99A0B/Windows6.1-KB2533623-x64.msu)_
_[_Windows6.1-KB2670838-x64.msu_](http://download.microsoft.com/download/1/4/9/14936FE9-4D16-4019-A093-5E00182609EB/Windows6.1-KB2670838-x64.msu)_
_[_Windows6.1-KB2786081-x64.msu_](http://download.microsoft.com/download/1/8/F/18F9AE2C-4A10-417A-8408-C205420C22C3/Windows6.1-KB2786081-x64.msu)_
_[_Windows6.1-KB2834140-v2-x64.msu_](http://download.microsoft.com/download/5/A/5/5A548BFE-ADC5-414B-B6BD-E1EC27A8DD80/Windows6.1-KB2834140-v2-x64.msu)_
_[_IE11-Windows6.1-KB2841134-x64.cab_](http://download.microsoft.com/download/C/0/1/C0186BE0-0ADB-4AF3-B97D-11FCEBE6BD68/IE11-Windows6.1-KB2841134-x64.cab)> **Notes**  
> Check if the downloaded files are not corrupted. (Size biger than 2kb)

#### **Download Support for Future Updates**

*   **x86
**[_Windows6.1-kb3020369-x86.msu_](https://www.microsoft.com/en-us/download/confirmation.aspx?id=46827)_
_[_Windows6.1-kb3172605-x86.msu_](https://www.microsoft.com/en-us/download/confirmation.aspx?id=53335)
*   **x64 
**[_Windows6.1-kb3020369-x64.msu_](https://download.microsoft.com/download/5/D/0/5D0821EB-A92D-4CA2-9020-EC41D56B074F/Windows6.1-KB3020369-x64.msu)_
_[_Windows6.1-kb3172605-x64.msu_](https://download.microsoft.com/download/5/6/0/560504D4-F91A-4DEB-867F-C713F7821374/Windows6.1-KB3172605-x64.msu)

#### **Download Office 2010 SP2**

*   **x86
**[officesp2010-kb2687455-fullfile-x86-en-us.exe](https://download.microsoft.com/download/4/9/9/499A1B0D-6FF3-466E-888E-DC7D7C788A61/officesp2010-kb2687455-fullfile-x86-en-us.exe)

### Step 2— Inject IE11 and prerequisites

*   Follow the instructions in my [_Add packages to a Windows Image using DISM PowerShell commandlets_](https://SCCM.Zone/update-offlinewindowsimage) post to inject IE11.

### Step 3— Import the WIM images

*   Add the vanilla install.wim images to the Operating System Images. We won’t modify these images the are used only for reference (Optional).



![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/2.png)

Reference Vanilla Images



*   Add the previously serviced images to the Operating System Images. We will modify these images by injecting updates.



![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/3.png)

Base Images



### Step — 4 Download the updates for Windows 7

If you don’t have a properly configured update system this is a **must**!  
You need to download the updates for Windows 7 in a temporary package, selecting **_“ALL LANGUAGES”_**. The package does not need to be pushed to a distribution point, you can create a dummy **_“Distribution Point Group”_ **without any members.

#### **Download updates in a package**




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/4.png)

If you don’t have properly configured update system you might need to do this





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/5.png)

Temporary Deployment Package





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/6.png)

Select all languages. I know it’s stupid but trust me on this…



**Why _“All Languages”_?  
**Because otherwise you might get the **_“Content not found in library error”_** in your log when trying to service the image.




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/7.png)

Content not found error

`--# Get Content ID Query #--  
SELECT *   
FROM dbo.v_UpdateCIs   
WHERE CI_UniqueID LIKE &#39;[YourContentID]&#39;`



![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/8.png)

Get Content ID Query result





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/9.png)

WTF Korean Language? I don’t have that deployed!

> **Notes**  
> If you still get this error after downloading all languages try downloading them again in a different package. SCCM sometimes returns success but the package is not actually downloaded (True story :). The package where the content is downloaded doesn’t actually matter, after the files are picked up by SCCM SIS they will e available no matter which package is storing them.

### Step — 5 Offline Servicing

You can now service the images with select** _“Schedule Updates”_**_. S_elect all and then exclude the **_“Preview”_ **and “**_Security Only”_** updates.

*   **_“Preview”_** because these updates are updates for the next month.
*   “**_Security Only”_** because the **_“Quality Rollups”_ **include** __ **the **“_Security Only”_** updates.

You can include all updates If you want to though.




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/10.png)

I’m only showing only 4 updates, because my image is already serviced



#### Problems you might encounter

*   **Error: Not all selected software updates are currently available on current site
**You probably downloaded the uptades in a package for a different site, see Step 4.



![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/11.png)

Packages need to be stored on the site which is servicing the image, see step 4 :)



*   **Error: InstallUpdate returned code 0x800f082f~
**Use the [_Repair-ServicingError_800f082f.ps1_](http://Repair-ServicingError_800f082f) __ script.



![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/12.png)

Because f**k you that’s why!



#### **Repair Servicing Error 800f082f~**


Repair Servicing Error 800f082f~





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/13.png)

Repair operation console output



#### **Servicing result**




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/14.png)

Work folder





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/15.png)

Serviced image in the SCCM Console

> **Notes**  
> Do not service a non-Vanilla Image.  
> If SCCM servicing fails with error 800f082f, repair the image already imported in SCCM. If you re-import the image in SCCM after repairing the error SCCM will not recognize the already injected updates and will try to re-inject them.

### Step — 6 Applications

I’m assuming that everyone knows how to package an application so I will just give you some guidelines here.

#### **Office 2010**

The problem with office 2010 is that it has no recent service pack and the installer source has not been updated in ages. You need to drop any updates that you want applied during setup in the instalaton source “_Updates”_ folder. In my case I have about 205 patches there. You need to add a prefix to the file name because they are processed in sequence.




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/16.png)

Office 2010 **“Updates”** folder



**Service Pack 2**  
Use the following PowerShell commands to extract office 2010 SP2, remove the stuff you don’t need and add the _“02SP2_”._ prefix to the file names.
`## Extract service pack files  
[YourOfficeSP2Folder]\officesp2010-kb2687455-fullfile-x86-en-us.exe /Extract:[YourExtractPathFolder]\Microsoft-Office-2010-SP2-EN-X86 /Q /F``## Remove Junk  
Remove-Item -Path F:\Temp\Microsoft-Office-2010-SP2-EN-X86\*.xml  
Remove-Item -Path F:\Temp\Microsoft-Office-2010-SP2-EN-X86\*.txt``## Prefix service pack files  
$Path = &#39;F:\Temp\Updates\*.*&#39;  
Get-Item -Path $Path | Rename-Item -NewName {$_.BaseName.Insert(0,’02SP2_’) + $_.Extension }`

**Other updates  
**For the remaining updates you need to install Office 2010 with SP2 and use SCCM to deploy all Office 2010 updates that are not expired or superseded on a test machine. After installing all office updates you can simply get all the downloaded patches from the SCCM cache folder.  
Use the following PowerShell commands to consolidate the files from all those folders.
`## Set source and destination paths  
$SourcePath = &#39;[YourUpdatesPath]&#39;  
$Destination = &#39;[YourUpdatesDestinationPath]&#39;``## Create destination path if it does not exist  
If (-not (Test-Path  -Path $Destination)){  
   New-Item $Destination -Type Directory  
}``## Get all the files  
Get-ChildItem $SourcePath -Recurse | `  
   Where-Object { $_.PSIsContainer -eq $False } | ForEach-Object {  
   Copy-Item -Path $_.Fullname -Destination $Destination -Force  
}``## Remove Junk  
Remove-Item -Path &#34;$Destination\*.xml&#34;  
Remove-Item -Path &#34;$Destination\*.txt&#34;``## Prefix the files  
$Path = &#34;$Destination\*.*&#34;  
Get-Item -Path $Path | Rename-Item -NewName {$_.BaseName.Insert(0,’03PostSP2_’) + $_.Extension }`

You can copy now all the files in the Office 2010 _“Updates”_ folder and create a new app revision to redistribute content.

#### .Net Framework 4.7

Unpack and use the .msi because there is a bug in the x86 exe installer and you might get an error.

#### **WMF 5.2**

Just use the .msu and the detection method below
`## WMF 5.2 Detection Method  
If (($PSVersionTable.PSVersion | Select-Object -ExpandProperty Major) -eq 5 -and ($PSVersionTable.PSVersion | Select-Object -ExpandProperty Minor) -eq 2){   
   Write-Host &#34;Installed&#34;  
}`

### Step — 7 Build and Capture

Create a standard Build and Capture Task Sequence

#### Apply Operating System




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/17.png)

Apply Operating System



#### Install Redistributables




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/18.png)

Install Redistributables



#### Install Core Applications




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/19.png)

Install Core Applications



#### Clean the image before SysPrep

Use the [**_Clean-ImageBeforeSysprep.ps1_**](https://SCCM.Zone/clean-windowsimage) script from my post.




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/20.png)

Clean the Image before Sysprep



#### Capture the Reference Image




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/21.png)

Capture the Reference Image

> **Notes**  
> You can see here that there is no “**Install Updates”** step, because it’s not needed. My image was missing only 4 updates after this procedure.

### Step — 8 Import the Captured Image into SCCM




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/22.png)

Updated (Base) and Captured (OSD) Images





![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/23.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-08-31_creating-an-updated-windows-7-osd-image-with-sccm-build-and-capture/images/24.gif)

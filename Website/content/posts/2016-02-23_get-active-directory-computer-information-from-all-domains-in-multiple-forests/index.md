---
title: "Get Active Directory Computer information from all domains in multiple forests"
author: "Ioan Popovici"
date: 2016-02-23T22:20:43.708Z
lastmod: 2019-08-23T12:34:23+03:00

description: "If you have a multiple forest structure and need to collect computer information from all domains in those forests you might find this script useful. The following script takes a list of forests as…"

subtitle: "Collect computer information from all domains in multiple forests."

image: "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/1.png" 
images:
 - "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/1.png" 
 - "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/2.png" 
 - "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/3.png" 
 - "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/4.jpeg" 
 - "/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/5.gif" 


aliases:
    - "/get-active-directory-computer-information-from-all-domains-in-multiple-forests-5ac9615b70d4"
---

![image](/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/1.png)



If you have a multiple forest structure and need to collect computer information from all domains in those forests you might find this script useful.

[**_Script release history_**](https://SCCM.Zone/get-adforestcomputers-changelog)


T
he following script takes a list of forests as input via GUI. It then parses all domains in these forests collecting **_Host_** **_Name_**, **_Operating System_** and **_Domain_** information for all non disabled computer accounts. The collected information will then be exported to a CSV file.

### Script


Get ad forest computer script



#### Screenshoots




![image](/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/2.png)

Input





![image](/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/3.png)

Processing progress





![image](/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/4.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2016-02-23_get-active-directory-computer-information-from-all-domains-in-multiple-forests/images/5.gif)

---
title: "Application and Package Deployments Reporting by Collection with SCCM"
author: "Ioan Popovici"
date: 2018-05-23T16:51:00.786Z
lastmod: 2019-08-23T12:36:41+03:00

description: ""

subtitle: "Deployments reports for all collection members available get it while it’s hot…"

image: "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/1.png" 
images:
 - "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/1.png" 
 - "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/2.png" 
 - "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/3.png" 
 - "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/4.jpeg" 
 - "/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/5.gif" 


aliases:
    - "/package-and-application-deployments-reporting-by-collection-with-sccm-64199bbcdc6c"
---

![image](/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/1.png)



Deployments reports for all collection members available get it while it’s hot…

[**_Report release history_**](https://SCCM.Zone/de-deployments-by-device-or-user-changelog)


T
here are no default reports that can display results for each collection member. There is a report that lists deployments for a specific collection but that’s it. If a collection member has a deployment on a different collection you are out of luck. Well not anymore…

I used the ‘_All package and program deployments to a specified user/device’_ as reference. One of the problem was that the _‘User’_ report has a bug and returns _‘NULL’_ for most packages. Since the views are **_so well documented_**, it took a while to get it right.

### Import the SSRS Report

*   Download the report file`**## Software deployments by Device or User**  
[**_DE Software Deployments by Device or User.rdl_**](https://raw.githubusercontent.com/SCCM-Zone/sccm-zone.github.io/master/Reporting/Deployments/DE%20Software%20Deployments%20by%20Device%20or%20User/DE%20Software%20Deployments%20by%20Device%20or%20User.rdl)`

*   Start Internet Explorer on and navigate to [**_http://YOUR_REPORT_SERVER_FQDN/Reports_**](http://en.wikipedia.org/wiki/Fully_qualified_domain_name)
*   Choose a path and upload the previously downloaded report files
*   [**_Replace the DataSource_**](https://joshheffner.com/how-to-import-additional-software-update-reports-in-sccm/) in the reports> **Notes**  
> I’ve merged the original two reports in one unified report.

#### Report Queries

For reference only, reports already include these queries.


Application deployments query



Package deployments query



### Report Preview




![image](/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/2.png)

User application deployments





![image](/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/3.png)

Device application deployments

> **Notes**  
> I did not post screenshots with package deployments because of severe laziness but you get the picture.



![image](/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/4.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2018-05-23_application-and-package-deployments-reporting-by-collection-with-sccm/images/5.gif)

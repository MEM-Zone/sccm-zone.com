---
title: "Test Network Connectivity on TCP Ports using Multiline Input with PowerShell"
author: "Ioan Popovici"
date: 2017-09-14T10:38:34.363Z
lastmod: 2019-08-23T12:35:32+03:00

description: ""

subtitle: "How to use the new shiny PowerShell commandlets to perform TCP port tests…"

image: "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/1.jpeg" 
images:
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/1.jpeg" 
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/2.png" 
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/3.png" 
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/4.png" 
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/5.jpeg" 
 - "/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/6.gif" 


aliases:
    - "/how-to-check-tcp-ports-and-get-multiline-input-with-powershell-d4d17b563cc6"
---

![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/1.jpeg)



How to use the new shiny PowerShell commandlets to perform TCP port tests…

[**_Script release history_**](https://SCCM.Zone/test-tcpports-changelog)


D
iscovery and Publishing have always been a pain, because of their many requirements. One of these requirements is a bunch of TCP ports that need to be open for the Discovery and Publishing to work. In a perfect world this wouldn’t be a problem, the networking team would take care of it, end of story. But we are not living in a perfect world and you may end up neck deep in logs because of closed ports.

I’m currently integrating about 55 domains in SCCM, and to make my life easier I made a PowerShell script. You can feed it your Domains and TCP ports, and it then cycles trough them and performs TCP port tests on each DC. Afterwards it churns out a csv file containing the test results.

I had some trouble with the multiline input box, and ended up reusing code from a _PowerShell App Deployment Toolkit_ function_._ I modified it to support multiline input and removed unneeded stuff to slim down the code. Also some input cleanup was needed because of Copy/Paste artifacts.
> **Notes** You can also use a list of machines instead of domains.

### Script


Test TCP Ports on all DC’s from a list of Domains



### Screenshots




![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/2.png)

Domain input box





![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/3.png)

Port input box





![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/4.png)

Console output





![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/5.jpeg)

> Use [Github](https://SCCM.Zone/Issues) for 🐛 reporting, or 🌈 and🦄 requests

#### 🙏 Please subscribe or clap for this article, it makes a difference! 🙏




![image](/posts/2017-09-14_test-network-connectivity-on-tcp-ports-using-multiline-input-with-powershell/images/6.gif)

---
title: "@peroeriksson99
I’m pretty sure that’s incorrect, I don’t have most versions and all the views have…"
author: "Ioan Popovici"
date: 2018-04-16T17:41:59.984Z
lastmod: 2019-08-23T12:36:35+03:00

description: ""

subtitle: "You can create the view like this:"

image: "/posts/2018-04-16_peroeriksson99-im-pretty-sure-thats-incorrect-i-dont-have-most-versions-and-all-the-views-have/images/1.png" 
images:
 - "/posts/2018-04-16_peroeriksson99-im-pretty-sure-thats-incorrect-i-dont-have-most-versions-and-all-the-views-have/images/1.png" 


aliases:
    - "/im-pretty-sure-that-s-incorrect-don-t-have-most-versions-and-all-the-views-have-been-created-71c0ea6f6db5"
---

@peroeriksson99  
I’m pretty sure that’s incorrect, I don’t have most versions and all the views have been created. Maybe I’m missing something though.

You can create the view like this:
`USE [CM_SITECODE]``GO``/****** Object:  View [SCCM_Ext].[vex_GS_CUSTOM_SQL_2017_Property_2_00]    Script Date: 4/16/2018 7:37:48 PM ******/``SET ANSI_NULLS ON``GO``SET QUOTED_IDENTIFIER ON``GO``create view [SCCM_Ext].[vex_GS_CUSTOM_SQL_2017_Property_2_00] as select &#39;U&#39; as [ChangeAction],MachineID as [ResourceID],MachineID as [BatchingKey],InstanceKey as [GroupKey],TimeKey as [TimeStamp],rowversion as [rowversion],IsReadOnly00 as [IsReadOnly0],PropertyIndex00 as [PropertyIndex0],PropertyName00 as [PropertyName0],PropertyNumValue00 as [PropertyNumValue0],PropertyStrValue00 as [PropertyStrValue0],PropertyValueType00 as [PropertyValueType0],ServiceName00 as [ServiceName0],SqlServiceType00 as [SqlServiceType0] from dbo.[CUSTOM_SQL_2017_Property_2_0_DATA] union all select &#39;D&#39; ,MachineID,MachineID,InstanceKey,NULL,rowversion,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL from SCCM_Ext.[CUSTOM_SQL_2017_Property_2_0_DATA_DD]``GO`

Just go to SQL Management Studio




![image](/posts/2018-04-16_peroeriksson99-im-pretty-sure-thats-incorrect-i-dont-have-most-versions-and-all-the-views-have/images/1.png)



Edit what you want and run it.  
   
The one above is for 2017 you just have to put in your SITECODE in [CM_SITECODE]

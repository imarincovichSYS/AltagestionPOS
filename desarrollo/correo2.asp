

<!-- 
METADATA 
 TYPE="typelib" 
 UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" 
 NAME="CDO for Windows 2000 Library" 
 --> 
<%
Set cdoConfig = CreateObject("CDO.Configuration") 

srv = Request.ServerVariables("HTTP_HOST")

 With cdoConfig.Fields 
 .Item(cdoSendUsingMethod) = cdoSendUsingPort 
 .Item(cdoSMTPServer) = "mail.sanchezysanchez.cl" 
 .Update 
 End With 

 Set cdoMessage = CreateObject("CDO.Message") 

 With cdoMessage 
 Set .Configuration = cdoConfig 
 .From = "altagestion@sanchezysanchez.cl" 
 .To = "imarincovich@sanchezysanchez.cl" 
 .Subject = "Sample CDO Message " & srv 
 .TextBody = "This is a test for CDO.message" 
 .Send 
 End With 

 Set cdoMessage = Nothing 
 Set cdoConfig = Nothing 



%>
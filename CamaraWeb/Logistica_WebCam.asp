<%
	Response.addHeader "pragma", "no-cache"
	Response.CacheControl = "Private"
	Response.ExpiresAbsolute = #1/5/2000 12:12:12#

	FechaOld = Request("Fecha")
	Fecha = Replace(Now()," ","")
%>
<html>
<head>
   <title><%=Request("Camara")%>&nbsp;</title>
</head>
<body >
<table border=0 width=100% align=left cellpadding=0 cellspacing=0>
	<tr>
		<td valign=top align=left>
			<APPLET code="JavaCam.class" height=144 width=176  id=Applet1>
				<PARAM name="url" value="http://<%=Request("Ip")%>/imagen.jpg">
				<PARAM name="interval" value="1">
			</APPLET>
		</td>
	</tr>
</table>
</body>
</html>

<script language="JavaScript">
	this.window.focus();
</script>
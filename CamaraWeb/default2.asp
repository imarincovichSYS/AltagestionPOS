<%
	Response.addHeader "pragma", "no-cache"
	Response.CacheControl = "Private"

   ' Selecciona una de las tres opciones siguientes
	'Response.Expires = -1441
	'Response.Expires = 0
	Response.ExpiresAbsolute = #1/5/2000 12:12:12#

	if len(trim(Request("Imagen"))) > 0 then 
	   Imagen = Request("Imagen")
	else
	   Imagen = "BackGround.jpg"
	end if

	FechaOld = Request("Fecha")
	Fecha = Replace(Now()," ","")
%>
<html>
<head>
   <title><%=Request("Camara")%></title>
   <style>
	.FuenteInput
	{
	    FONT-SIZE: 8pt;
	    COLOR: black;
	    FONT-FAMILY: Arial, Copperplate Gothic Light, Verdana, Helvetica, sans-serif
	}

   </style>
</head>
<body background="<%=Imagen%>">
<table border=0 width=100% align=center cellpadding=0 cellspacing=0>
	<tr height=200pt>
		<td valign=middle align=center>
			<APPLET code="JavaCam.class" height=144 width=176  id=Applet1>
				<PARAM name="url" value="http://<%=Request("Ip")%>/imagen.jpg">
				<PARAM name="interval" value="1">
			</APPLET>
		</td>
	</tr>
	<tr>
		<td valign=middle align=center>
			<a class="FuenteInput" href="JavaScript:fCerrar()">Cerrar</a>
		</td>
	</tr>
</table>
</body>
</html>

<script language="JavaScript">
	function fCerrar()
	{
		location.href = "Empty.asp"
	}
</script>
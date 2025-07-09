<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="CSS/Estilos.css">
	</head>
	<body background='<%=Session("ImagenFondo")%>'>
		<form name="Mensajes">
			<table width=95% border=0 align=center>
				<tr><td>
		<%	if Session("Browser") = 1 then 'Explorer%>
				<span class="FuenteAreaMensajes" id="IdMensaje">&nbsp;<%=request("msg")%></span>
		<%	else 'NetScape%>
				<span ID="IdMensaje" STYLE="font-size:9pt; font-family: Arial, Copperplate Gothic Light, Verdana, Helvetica, sans-serif; color: red; position: absolute; left:20px; top:0px; border: 0px "></span>
		<%	end if%>
				</td></tr>
			</table>
		</form>
	</body>
</html>
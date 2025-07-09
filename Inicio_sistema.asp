<%
if Instr(1,Request.ServerVariables( "HTTP_USER_AGENT" ),"PPC;") > 0 Then
	Response.Redirect "Ipaq/Usuario.asp"
else
	website = Request.ServerVariables("SERVER_NAME")
	If website = "www.altahoteleria.cl" or website = "ads2.altahoteleria.cl" then
	   websystem = "AltaHoteleria"
	   webtitle = "AltaHotelería, el primer sistema de control y gestión hotelera por internet."
	elseif website = "www.altarestaurantes.cl" or website = "ads2.altarestaurantes.cl" then
	   websystem = "AltaRestaurantes"
	   webtitle = "AltaRestaurantes, el primer sistema de control y gestión de restaurantes por internet."
	else
	   websystem = "AltaGestion"
	   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
	end if
	%>
	<html>
		<head>
			<title><%=websystem%></title>
		</head>
		<body>
			<center>
			<%=webtitle%>
			<br><br>
			<a href='abonados.asp'>Abonados</a>
			<br>
			<a href='demo.asp'>Demostración</a>
			</center>
		</body>
	</html>
<%end if%>
<%
website = Request.ServerVariables("SERVER_NAME")
   websystem = "AltaGestion"
   webtitle = "AltaGestion, el primer sistema de control y gesti�n por internet."
%>
<html>
<head>
	<title><%=websystem%></title>
</head>
<frameset rows="10%,*,5%,5%" frameborder='0' framespacing='0' border='0'>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="navigation.asp?Usuario=Hoteleria"	noresize scrolling=no	name="Menu"></frame>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="Empty.asp"		noresize scrolling=auto	name="Trabajo"></frame>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="Empty.asp"		noresize scrolling=no	name="Botones"></frame>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="Mensajes.asp"	noresize scrolling=no	name="Mensajes"></frame>
</frameset>
<noframes>
<body>
	Su browser no soporta marcos / Your browser does not support frames.<a href='Index.htm'>start</a>
</body>
</noframes>
</html>
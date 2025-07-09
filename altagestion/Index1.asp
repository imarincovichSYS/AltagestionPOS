<%
website = Request.ServerVariables("SERVER_NAME")
   websystem = "AltaGestion"
   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
   if len(Session("Nombre_usuario")) > 0 then cUser = " (" & Session("Nombre_usuario") & ")"
%>
<html>
<head>
	<title><%=websystem%><%=cUser%></title>
</head>
<frameset rows="*,1" frameborder='0' framespacing='0' border='0'>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="usuario.asp"	noresize scrolling=no	name="Clave"></frame>
	<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="Empty.asp"		noresize scrolling=no	name="Paso"></frame>
</frameset>
<noframes>
<body>
	Your browser does not support frames. <a href='Index.htm'>start</a>
</body></noframes>

</html>
<%
website = Request.ServerVariables("SERVER_NAME")
   websystem = "AltaGestion"
   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
session("websystem")=websystem
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
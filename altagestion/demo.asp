<%
website = Request.ServerVariables("SERVER_NAME")
   websystem = "AltaGestion"
   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
   webdemo = "Demo_AG"
%>
<html>
	<head>
		<title><%=websystem%> - Abonados</title>
	</head>
	<body>
		<form name="Destino" action="Autentificacion.asp" method="POST">
			<input type=hidden name="Abonado" value = "<%=webdemo%>">
		</form>
	</body>
	<Script language="JavaScript">
		document.Destino.submit();
	</Script>
</html>
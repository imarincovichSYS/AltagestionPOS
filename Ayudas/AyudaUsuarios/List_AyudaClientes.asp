<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title>Ayuda de Clientes</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Listado">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>

<%
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	Codigo	= Request("Codigo")
	Nombre			= Request("Nombre")
	
	cSql = "Exec USR_ListaUsuarios '" & codigo & "', '" & nombre & "', 2, '" & Session("empresa_usuario") & "'"
'Response.Write cSql
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.eof then%>
	<table width=100% border=0>
		<tr class="FuenteCabeceraTabla">
			<td class="FuenteInput" align=left width=20%><b>Código</b></td>
			<td class="FuenteInput" width=80%><b>Nombre</b></td>
		</tr>
<%		i = 1
		Do While Not Rs.eof %>
			<tr>
				<td class="FuenteInput" width=20% align=left>
					<a name ='Link<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Codigo<%=i%>" ><%=Rs("IdUsuario")%></DIV></a>
				</td>

				<td class="FuenteInput" width=80%>
					<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Desc<%=i%>"><%=Rs("Nombres_usuario") & " " & Rs("Apellidos_usuario")%></DIV></a>
				</td>
			</tr>
<%			Rs.MoveNext
			i = i + 1
		Loop%>
	</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay usuarios según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
</body>
</html>
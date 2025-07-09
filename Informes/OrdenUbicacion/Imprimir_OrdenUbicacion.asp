<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	Const adUseClient = 3

	NroRecepcion = Request("NroRecep")

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.CommandTimeout = 3600

	cSql = "Exec MOP_Recepcion_y_ubicaciones '" & Session("Empresa_usuario") & "', 0" & NroRecepcion
'Response.Write cSql
	Set Rs = Conn.Execute (cSql)
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	</head>

<body>
<form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
<%	if Not Rs.Eof then %>
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:window.close()"><%=session("title")%></td> 
			</tr>
		</table>

		<table width="99%" border=1 align=center cellpadding=0 cellspacing=0>
			<tr class="FuenteEncabezados">
				<td align=left>Bodega</td>
				<td align=left>Catalogo</td>
				<td align=left>Descripción</td>
				<td align=right>Cantidad</td>
				<td align=center>Estado</td>
				<td align=center>Fecha</td>
				<td align=center>O.C.P.</td>
				<td align=center>R.C.P.</td>
				<td align=left>Ubicación</td>
			</tr>
		<%	Do While Not Rs.Eof %>
				<tr class="FuenteInput">
					<td align=left  ><%=Rs("Bodega")%></td>
					<td align=left  ><%=Rs("Catalogo")%></td>
					<td align=left  ><%=Rs("Descripcion")%></td>
					<td align=right ><%=Rs("Cantidad")%></td>
					<td align=center><%=Rs("Estado")%></td>
					<td align=center><%=Rs("Fecha")%></td>
					<td align=center><%=Rs("nOCP")%></td>
					<td align=center><%=Rs("nRCP")%></td>
					<td align=left  ><%=Rs("Ubicacion")%>&nbsp;</td>
				</tr>
		<%		Rs.MoveNext
			Loop%>
		</table>
<%	Else
		abspage = 0 %>
		<table Width=95% border=0 cellspacing=2 cellpadding=2 >
		    <tr class="FuenteEncabezados">
				<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
			</tr>
		</table>
<%	End If
	rs.Close
	Set rs = Nothing
%>
</form>
</body>
</html>
<%
Conn.Close

else
	Response.Redirect "../../index.htm"
end if%>

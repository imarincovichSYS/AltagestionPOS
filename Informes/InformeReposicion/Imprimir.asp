<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

	Const adUseClient = 3

	Sql = "Exec PRO_Reposicion " &+_
          "'"  & Request("Empresa")			& "'," & +_
          "'"  & Request("BodegaOrigen")	& "'," & +_
          "'"  & Request("BodegaDestino")	& "'," & +_
          "'"  & Request("Medida") & "'"
'Response.Write Sql
	SET Rs	=	Conn.Execute( SQL )

%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<body>
<form name="Listado">
			<%if Not Rs.Eof then %>
				<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
					<tr class="FuenteTitulosFunciones">
						<td colspan=7 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()"><%=session("title")%></a>&nbsp;</td>
					</tr>
				</table>
				
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr  class="FuenteEncabezados">
						<td align=left   width="10%">Ubicación</td>
						<td align=left   width="10%" nowrap>Catálogo</td>
						<td align=left   width="10%">Código</td>
						<td align=center width="10%">Pedido</td>
						<td align=left   width="10%" nowrap>Descripción</td>
						<td align=center width="10%">U/M</td>
						<td align=center width="10%">Caja</td>
						<td align=center width="10%">Origen</td>
						<td align=center width="10%">Crítico</td>
						<td align=center width="10%">Destino</td>
					</tr>
			<%		i=0
					do While Not Rs.Eof%>
							<tr class="FuenteInput">
								<td align=left   width="10%"><%=rs("Ubicacion")%>&nbsp;</td>
								<td align=left   width="10%" nowrap><%=rs("Catalogo")%>&nbsp;</td>
								<td align=left   width="10%"><%=rs("Codigo")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Pedido")%>&nbsp;</td>
								<td align=left   width="10%" nowrap><%=rs("Descripcion")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("UM")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Caja")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Origen")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Critico")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Destino")%>&nbsp;</td>
							</tr>
					<%	rs.MoveNext
						Loop
					%>
				</table>

			<script language="JavaScript">
				this.window.focus();
			</script>
				
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
				</tr>
			</table>
		<%End If
						
		rs.Close
		Set rs = Nothing
%>
</form>
</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
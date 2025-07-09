<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	Request("")

	Agrupacion	= Request("Agrupacion")
	Periodo		= Request("Periodo")
	Documento	= Request("Documento")
	CtoVenta	= Request("Centro_de_Venta")

	cSql = "Exec DOV_Detalle_flujo_de_caja   '"	& Agrupacion	& "', " 		& +_
											"'"	& Periodo		& "', " 		& +_
											"'" & Documento		& "', " 		& +_
											"'" & CtoVenta		& "', " 		& +_
											"'" & Session("Empresa_usuario")	& "'"
'Response.Write (cSql)


	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600
'Response.Write Sql
	SET Rs	=	Conn.Execute( cSql )

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
						<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()">Detalle <%=session("title")%></a>&nbsp;</td>
					</tr>
				</table>
				
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr  class="FuenteCabeceraTabla">
						<td  align=center width=05% NOWRAP >Documento</td>
						<td  align=left   width=30% nowrap >Entidad</td>
						<td  align=left   width=30% nowrap >Ctro vta-cto</td>
						<td  align=center width=05% NOWRAP >Fecha emis.</td>
						<td  align=center width=05% NOWRAP >Fecha venc.</td>
						<td  align=right  width=10% NOWRAP >Monto</td>
						<td  align=left   width=10% NOWRAP >Observaciones</td>
					</tr>
			<%		i=0
					Do While Not Rs.EOF %>
						<tr class="FuenteInput">
							<td align=center width=05% NOWRAP ><%=Rs("Documento_valorizado")%> - <%=Rs("Numero_documento_valorizado")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Entidad")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Centro_venta_costo")%>&nbsp;</td>
							<td align=center width=05% NOWRAP ><%=Rs("Fecha_emision")%>&nbsp;</td>
							<td align=center width=05% NOWRAP ><%=Rs("Fecha_vencimiento")%>&nbsp;</td>
							<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Monto_por_cobrar_o_pagar"),0)%>&nbsp;</td>
							<td align=left   width=05% NOWRAP ><%=Rs("Observaciones")%>&nbsp;</td>
						</tr>
					<%	Rs.MoveNext
						i=i+1
					Loop
					%>
				</table>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No hay información disponible.</B></td>
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
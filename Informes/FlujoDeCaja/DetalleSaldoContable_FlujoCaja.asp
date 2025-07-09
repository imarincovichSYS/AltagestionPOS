<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	Periodo		= Request("Periodo")
	Fecha		= Request("Fecha")
	CtoVenta	= Request("Centro_de_Venta")

	cSql = "Exec DOV_Saldo_inicial_contable_detalle_flujo_caja "
	cSql = cSql & "'" & cambia_fecha(Fecha) & "', "
	cSql = cSql & "'" & Session("Empresa_usuario")	& "', "
	cSql = cSql & "'" & CtoVenta					& "', "
	cSql = cSql & "'" & Periodo						& "'"
'Response.Write (cSql)
'Response.Write Sql
	SET Rs	=	Conn.Execute( cSql )

%>
<html>
<head>
	<title>Detalle Saldo Inicial Contable</title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<body>
<form name="Listado">
			<%if Not Rs.Eof then %>
				<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
					<tr height=50 class="FuenteTitulosFunciones">
						<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()">Detalle Saldo Inicial Contable</a>&nbsp;</td>
					</tr>
				</table>
				
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr  class="FuenteCabeceraTabla">
						<td  align=center width=05% NOWRAP >Cuenta contable</td>
						<td  align=left   width=30% nowrap >Banco</td>
						<td  align=left   width=30% nowrap >Centro de venta</td>
						<td  align=center width=05% NOWRAP >Saldo contable</td>
					</tr>
			<%		i=0
					Do While Not Rs.EOF %>
						<tr class="FuenteInput">
							<td align=center width=05% NOWRAP ><%=Rs("Cuenta_contable")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Banco")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Centro_de_venta")%>&nbsp;</td>
							<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Saldo_contable"),0)%>&nbsp;</td>
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
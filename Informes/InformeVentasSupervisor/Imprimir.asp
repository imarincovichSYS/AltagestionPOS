<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	if len(trim(request("Fecha_Desde"))) > 0 then
		Fecha_Desde	= "'" & Cambia_fecha(Request("Fecha_Desde")) & "'"
	else
		Fecha_Desde = "Null"
	end if
	if len(trim(request("Fecha_hasta"))) > 0 then
		Fecha_hasta	= "'" & Cambia_fecha(Request("Fecha_hasta")) & "'"
	else
		Fecha_hasta = "Null"
	end if

	if len(trim(request("Vendedor"))) > 0 then
		Vendedor	= "'" & Request("Vendedor") & "'"
	else
		Vendedor = "Null"
	end if

	cSql = "Exec DNV_Informe_ventas	'"	& Session("Empresa_usuario") & "', "
	cSql = cSql & Fecha_desde & ", "
	cSql = cSql & Fecha_hasta & ", "
	cSql = cSql & Vendedor

	Set Rs = Conn.Execute(cSql)
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>

<body >
<form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
				<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
					<tr class="FuenteTitulosFunciones">
						<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()"><%=session("title")%></a>&nbsp;</td>
					</tr>
					<tr height=40 class="FuenteInput">
						<td colspan=6 align=left NOWRAP >Emitido por:&nbsp;&nbsp;<b><%=Session("Nombre_Usuario")%></b></td>
						<td align=right NOWRAP >&nbsp;<b><%=left(Now(),16)%></b>&nbsp;</td>
					</tr>
				</table>
<%		If Not rs.EOF Then%>
			<table width="99%" border=1 align=center cellpadding=0 cellspacing=0><thead>
				<tr class="FuenteCabeceraTabla">
					<td colspan=3 width= "12%" align=center NOWRAP >&nbsp;</td>
					<td colspan=3 width= "12%" align=center NOWRAP >&nbsp;Cantidades&nbsp;</td>
					<td colspan=2 width= "12%" align=center NOWRAP >&nbsp;Montos&nbsp;</td>
				</tr>												
				<tr class="FuenteCabeceraTabla">
					<td width= "12%" align=left   NOWRAP >&nbsp;Vendedores&nbsp;</td>
					<td width= "12%" align=center NOWRAP >&nbsp;Notas de ventas&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Total&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Preparándose&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Autorizadas&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Facturadas&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Facturado&nbsp;</td>
					<td width= "12%" align=right  NOWRAP >&nbsp;Por Facturar&nbsp;</td>
				</tr>												
		<%		i=0
				zTotal = 0
				Do While Not Rs.Eof
					Total = Rs("Total")					
					if IsNull(Total) then Total = 0
					if len(trim(Total)) = 0 then Total = 0

					Facturado = Rs("Facturado")
					if IsNull(Facturado) then Facturado = 0
					if len(trim(Facturado)) = 0 then Facturado = 0
					
					Por_facturar = Rs("Por_facturar")
					if IsNull(Por_facturar) then Por_facturar = 0
					if len(trim(Por_facturar)) = 0 then Por_facturar = 0
					
					Notas_de_venta = Rs("Notas_de_venta")
					if IsNull(Notas_de_venta) then Notas_de_venta = 0
					if len(trim(Notas_de_venta)) = 0 then Notas_de_venta = 0
					
					Preparandose = Rs("Preparandose")
					if IsNull(Preparandose) then Preparandose = 0
					if len(trim(Preparandose)) = 0 then Preparandose = 0
					
					Autorizados = Rs("Autorizados")
					if IsNull(Autorizados) then Autorizados = 0
					if len(trim(Autorizados)) = 0 then Autorizados = 0					
					
					Facturadas = Rs("Facturadas")
					if IsNull(Facturadas) then Facturadas = 0
					if len(trim(Facturadas)) = 0 then Facturadas = 0					
					
					%>
					<tr class="FuenteInput">
						<td width= "12%" align=left   NOWRAP >&nbsp;<%=Rs("Vendedores")%>&nbsp;</td>
						<td width= "12%" align=center NOWRAP >&nbsp;<%=Rs("Notas_de_venta")%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Total,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Preparandose")%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Autorizados")%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Facturadas")%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Facturado,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Por_facturar,0)%>&nbsp;</td>
					</tr>
			<%		zNotas_de_venta = zNotas_de_venta + cDbl(Notas_de_venta)
					zPreparandose   = zPreparandose   + cDbl(Preparandose)
					zAutorizados    = zAutorizados    + cDbl(Autorizados)
					zFacturadas     = zFacturadas     + cDbl(Facturadas)
					zTotal          = zTotal          + cDbl(Total)
					zFacturado      = zFacturado      + cDbl(Facturado)
					zPor_facturar   = zPor_facturar   + cDbl(Por_facturar)
					rs.MoveNext					
				Loop%>
					<tr class="FuenteCabeceraTabla">
						<td width= "12%" align=left   NOWRAP >&nbsp;Totales</td>
						<td width= "12%" align=center NOWRAP >&nbsp;<%=zNotas_de_venta%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zTotal,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zPreparandose,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zAutorizados,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zFacturadas,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zFacturado,0)%>&nbsp;</td>
						<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(zPor_facturar,0)%>&nbsp;</td>
					</tr>
			</table>
			<script language="JavaScript">
					this.window.focus();
					//printPage();
					function printPage()
					{
						if (window.print)
						{
							window.print();
						}
						else
						{
							Mensajes ("Este browser no soporta impresión en modo automático, solamente en modo manual CTRL+P.");
						}
					}
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
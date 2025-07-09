<!-- #include file="../../Scripts/Asp/Conecciones.Asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
	
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )

	Id              = Request("Id")
    FechaInicial    = Request("FechaInicial")
        if len(trim(FechaInicial)) = 0 then FechaInicial = "Null" Else FechaInicial = "'" & Cambia_fecha(FechaInicial) & "'"
    CentroVenta     = Request("CentroVenta")
        if len(trim(CentroVenta)) = 0 then CentroVenta = "Null" Else CentroVenta = "'" & CentroVenta & "'"
    Periodo         = Request("Periodo")
        if len(trim(Periodo)) = 0 then Periodo = "Null" Else Periodo = "'" & Periodo & "'"
    Paridad         = Request("Paridad")
        if len(trim(Paridad)) = 0 then Paridad = "Null"

    if Id = 1 then
        Titulo = "Facturas nacionales por cobrar"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_FAV_ODV " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 2 then
        Titulo = "Facturas exportación por cobrar"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_FAE " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 3 then
        Titulo = "Cheques por cobrar"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_CHI " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 4 then
        Titulo = "Otros ingresos"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_Otros_ingresos " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 5 then
        Titulo = "Facturas nacionales por pagar"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_FAC " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 6 then
        Titulo = "Facturas importación por pagar"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_UFC " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 7 then
        Titulo = "Otros egresos"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_Otros_egresos " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 8 then
        Titulo = "Cheques por cobrar US$"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_UCI " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 9 then
        Titulo = "Otros ingresos US$"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_Otros_ingresos_US " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    elseif Id = 10 then
        Titulo = "Otros ingresos US$"
        cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos_Otros_egresos_US " & FechaInicial & ", "
        cSql = cSql & CentroVenta & ", " 
        cSql = cSql & "'" & Session("Empresa_usuario") & "', "
        cSql = cSql & Paridad
    end if

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
						<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()">Detalle <%=Titulo%></a>&nbsp;</td>
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
							<td align=center width=05% NOWRAP ><%=Rs("Documento")%> - <%=Rs("Numero")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Entidad")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Centro_de_venta")%>&nbsp;</td>
							<td align=center width=05% NOWRAP ><%=Rs("Fecha_emision")%>&nbsp;</td>
							<td align=center width=05% NOWRAP ><%=Rs("Fecha_vencimiento")%>&nbsp;</td>
							<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Monto"),0)%>&nbsp;</td>
							<td align=left   width=05% NOWRAP ><%=Rs("Observaciones")%>&nbsp;</td>
						</tr>
					<%	MontoGral = MontoGral + cDbl( "0" & Rs("Monto") ) 
                        Rs.MoveNext
						i=i+1
					Loop
					%>
						<tr class="FuenteCabeceraTabla">
							<td colspan=3 align=right>&nbsp;</td>
							<td colspan=2 align=left >Total</td>
							<td align=right  width=10% NOWRAP ><%=FormatNumber( MontoGral ,0)%>&nbsp;</td>
							<td colspan=1 align=left   width=05% NOWRAP >&nbsp;</td>
						</tr>
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
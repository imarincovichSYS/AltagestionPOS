<!-- #include file="../../Scripts/Asp/Conecciones.Asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
	
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )

	Valor           = Request("Valor")
    CentroVenta     = Request("CentroVenta")
        if len(trim(CentroVenta)) = 0 then CentroVenta = "Null" Else CentroVenta = "'" & CentroVenta & "'"
    Paridad         = Request("Paridad")
        if len(trim(Paridad)) = 0 then Paridad = "Null"

    cSql = "Exec DOV_Flujo_de_caja_detalle_depositos_y_cargos_sin_repaldo "
    cSql = cSql & CentroVenta & ", " 
    cSql = cSql & "'" & Session("Empresa_usuario") & "', "
    cSql = cSql & Paridad & ", '" & Valor & "'"

    if Valor = "Depositos$" then
        Titulo = "Depósitos sin respaldos"
    elseif Valor = "DepositosUS" then
        Titulo = "Depósitos sin respaldos US$"
    elseif Valor = "Cargos$" then
        Titulo = "Cargos sin respaldos"
    elseif Valor = "CargosUS" then
        Titulo = "Cargos sin respaldos US$"
    end if

'Response.Write cSql

	SET Rs	=	Conn.Execute( cSql )


%>
<html>
<head>
	<title><%=Titulo%></title>
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
						<td  align=center width=05% NOWRAP >Fecha emis.</td>
						<td  align=left   width=30% nowrap >Ctro vta-cto</td>
						<td  align=right  width=10% NOWRAP >Monto</td>
						<td  align=left   width=30% NOWRAP >Observaciones</td>
					</tr>
			<%		i=0
					Do While Not Rs.EOF %>
						<tr class="FuenteInput">
							<td align=center width=05% NOWRAP ><%=Rs("Documento")%> - <%=Rs("Numero_documento")%>&nbsp;</td>
							<td align=center width=05% NOWRAP ><%=Rs("Fecha_emision")%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Centro_venta_costo")%>&nbsp;</td>
							<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Monto_total_moneda_oficial"),0)%>&nbsp;</td>
							<td align=left   width=30% nowrap ><%=Rs("Observaciones")%>&nbsp;</td>
						</tr>
					<%	MontoGral = MontoGral + cDbl( "0" & Rs("Monto_total_moneda_oficial") ) 
                        Rs.MoveNext
						i=i+1
					Loop
					%>
						<tr class="FuenteCabeceraTabla">
							<td colspan=2 align=right>&nbsp;</td>
							<td colspan=1 align=left >Total</td>
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
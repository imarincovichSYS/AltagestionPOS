<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	On Error Resume Next
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec PAR_ListaParametros 'PCTGEIVA'"
	Set Rs = Conn.Execute (cSql)
	if Not Rs.Eof then
		nIVA = Rs("Valor_Numerico")
	else
		nIVA = 19
	end if
	Rs.Close
	Set Rs = Nothing

	NroOVT = Request("NroDOV")

	cSql = "Exec MOP_ListaMovimientosProductos_iPaq Null, Null, '" & Session("Empresa_usuario") & "', 'OVT', " & NroOVT & ", Null, Null"
	Set Rs = Conn.Execute ( cSql )
	if Conn.Errors.Count = 0 then
		if Not Rs.Eof then
			Nombrecliente = Rs("Nombre_Cliente")
			NroOc		  = Rs("Numero_orden_de_compra")
			Sucursal	  = Rs("Sucursal")
		else
			Nombrecliente = "Sin Datos"
			NroOc		  = 0
			Sucursal	  = "Sin sucursal"
		end if
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=100% align=left border=0 cellspacing=0 cellpadding=0 >
				<tr CLASS=FuenteTitulosFunciones><td>ORDEN DE VENTA Nº <%=NroOVT%></td></tr>
				<tr CLASS=FuenteInputEtiquetasDatos><td>ORDEN DE COMPRA Nº <%=NroOC%></td></tr>
				<tr CLASS=FuenteInputEtiquetasDatos><td>CLIENTE: <%=Nombrecliente%></td></tr>
				<tr CLASS=FuenteInputEtiquetasDatos><td>SUCURSAL: <%=Sucursal%></td></tr>
				<!-- <tr CLASS=FuenteInput><td>&nbsp;</td></tr> -->
			</table>
			<table width=100% align=left border=0 cellspacing=1 cellpadding=0 >
				<tr class="FuenteCabeceraTabla">
					<td align=left  >Producto/Descripción</td>
					<td align=center>Q</td>
					<td align=right >Pend.</td>
					<td align=right >Total</td>
				</tr>
			
		<%	i = 1
			nTotalPendientes = 0
			Do while Not Rs.Eof
				if i/2 = Int(i/2) then clase = "FuenteLineaNoSeleccionada" Else clase = "FuenteLineaSeleccionada"
				Cantidad 	= Cdbl("0" & Rs("Cantidad_ordenada") )
				Precio	 	= Cdbl("0" & Rs("Precio_de_lista_modificado") )
				Descripcion = Rs("Desc_producto")
				Catalogo	= Rs("Catalogo")
				Pendiente   = Cdbl("0" & Rs("Cantidad_pendiente"))
		%>
				<tr class="<%=clase%>">
					<td valign=top align=left  >&nbsp;<%=Rs("Producto")%>&nbsp;-&nbsp;<%=Rs("Catalogo")%></td>
					<td valign=top align=right >&nbsp;<%=Cantidad%>&nbsp;</td>
					<td valign=top align=right >&nbsp;<%=Pendiente%>&nbsp;</td>
					<td valign=top align=right >&nbsp;<%=Round(Precio*Cantidad,0)%>&nbsp;</td>
				</tr>	
				<tr class="<%=clase%>">
					<td colspan=4 valign=top align=left >&nbsp;<%=Descripcion%>&nbsp;</td>
				</tr>
		<%		Total = Total + ( Precio * Cantidad )
				nTotalPendientes = nTotalPendientes + cDbl( ( Precio * Pendiente ) )
				nQPendientes = nQPendientes + Pendiente
				nQOrdenados = nQOrdenados + Cantidad
				i = i + 1
				Rs.MoveNext
			Loop
			Rs.Close
			Set Rs = Nothing
			Neto  = Total
			Total = Round(Total + (Total * ( cDbl(nIVA)/100 )),0)
			Iva   = Round(Total - Neto,0)

			TotalPendientes = Round(cDbl(nTotalPendientes) * (1+(cDbl(nIVA)/100)),0)
			
		%>
			</table>
			
			<table width=100% align=center border=0 cellspacing=0 cellpadding=0>
				<tr >
					<td colspan=6 width=100% class=FuenteCabeceraTabla>&nbsp;</td>
				</tr>
				<tr >
					<td width=16% class=FuenteInputEtiquetas align=center >Neto</td>
					<td width=16% class=FuenteInputEtiquetas align=right><%=Neto%>&nbsp;</td>
					
					<td width=16% class=FuenteInputEtiquetas align=center >Iva</td>
					<td width=16% class=FuenteInputEtiquetas align=right><%=Iva%>&nbsp;</td>
					
					<td width=16% class=FuenteInputEtiquetas align=center >Total</td>
					<td width=16% class=FuenteInputEtiquetas align=right><%=Total%>&nbsp;</td>
				</tr>
				<tr >
					<td colspan=4 class=FuenteInputEtiquetas align=right >Total Ordenados</td>
					<td class=FuenteInputEtiquetas align=right ><%=nQOrdenados%></td>					
					<td width=16% class=FuenteInputEtiquetas align=right><%=Total%>&nbsp;</td>
				</tr>
				<tr >
					<td colspan=4 class=FuenteInputEtiquetas align=right >Total pendientes</td>
					<td class=FuenteInputEtiquetas align=right ><%=nQPendientes%></td>					
					<td width=16% class=FuenteInputEtiquetas align=right><%=TotalPendientes%>&nbsp;</td>
				</tr>

				<tr class="FuenteEncabezados">
					<td colspan=6 class="FuenteInput" align=center>
		<%			if Request("Eliminar") = "S" Then%>
						<input class=FuenteBotones type=button name="btnEliminar"	value = "Eliminar"	Onclick="Javascript:fEliminar()">&nbsp;&nbsp;&nbsp;
		<%			end if%>
						<input class=FuenteBotones type=button name="btnCancelar"	value = "Volver"	Onclick="Javascript:fCancelar()">
					</td>
				</tr>
			</table>
		</form>
	</body>

	<script language="javascript">
	
		function fCancelar()
		{
			history.back()
		}
		
<%	if Request("Eliminar") = "S" Then%>
		function fEliminar()
		{
			var Rsp = confirm("¿ Está seguro de eliminar la orden ?")
			if ( Rsp )
			{
				document.Formulario.action = "../../Transacciones/OrdenVenta/Eliminar.asp?NroOVT=<%=NroOVT%>"				
				document.Formulario.target = "_top"
				document.Formulario.submit();
			}
		}
<%	end if%>		
	</script>

</html>
<%	else 
		Mensaje = Replace(Replace(Err.Description,",",""),"'","") 
		Mensaje = Replace(Mensaje,"[Microsoft][ODBC SQL Server Driver][SQL Server]","")%>
		<script language="javascript">
			alert ( '<%=Mensaje%>' )
			history.back()
		</script>
<%	end if%>
<% conn.close() %>
<%else
	Response.Redirect "../../index.htm"
end if%>

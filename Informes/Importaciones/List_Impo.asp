<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
	Function NumForm( nNumero , nDecimales )
	    If IsNull(nNumero) Then
	       NumForm = ""
	    Else   
	       NumForm = FormatNumber(cDbl("0" & nNumero ), nDecimales)
	    End If
	End Function
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	Const adUseClient = 3
	Fecha_desde = Request("Fecha_desde")
		if len(trim(Fecha_desde)) = 0 then Fecha_desde = "Null" else Fecha_desde = "'" & cambia_fecha(Fecha_desde) & "'"
	Fecha_hasta = Request("Fecha_hasta")
		if len(trim(Fecha_hasta)) = 0 then Fecha_hasta = "Null" else Fecha_hasta = "'" & cambia_fecha(Fecha_hasta) & "'"

	Rec_desde = Request("Rec_desde")
		if len(trim(Rec_desde)) = 0 then Rec_desde = "Null" else Rec_desde = "'" & cambia_fecha(Rec_desde) & "'"
	Rec_hasta = Request("Rec_hasta")
		if len(trim(Rec_hasta)) = 0 then Rec_hasta = "Null" else Rec_hasta = "'" & cambia_fecha(Rec_hasta) & "'"

	Sql = "Exec INF_Importaciones " &+_
          "'"  & Session("Empresa_usuario")		& "'," & +_
          "'"  & Request("Proveedor")			& "'," & +_
          "'"  & Request("Carpeta")				& "'," & +_
          "0"  & Request("NroOCP")				& ", " & +_
          ""   & Fecha_desde					& "," & +_
          ""   & Fecha_hasta					& "," & +_
          ""   & Rec_desde						& "," & +_
          ""   & Rec_hasta						& "," & +_
          "'"  & Request("Modo")				& "'"

'Response.Write Sql

		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = Session("PageSize")
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open sql , Conn, , , adCmdText 'mejor
		
		ResultadoRegistros=rs.RecordCount
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<%	If Session("Browser") = 1 Then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	Else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	End If%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
<%		
		If Not rs.EOF Then
			If Len(Request("pagenum")) = 0  Then
					rs.AbsolutePage = 1
				Else
					If CInt(Request("pagenum")) <= rs.PageCount Then
							rs.AbsolutePage = Request("pagenum")
						Else
							rs.AbsolutePage = 1
					End If
			End If
		
			Dim abspage, pagecnt
				abspage = rs.AbsolutePage
				pagecnt = rs.PageCount%>
<!--
	Se definen las funciones para el avance de página y para el retroceso de página
-->		
<script language=javascript>
	function PrimeraPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Carpeta=<%=Request("Carpeta")%>&NroOCP=<%=Request("NroOCP")%>&Fecha_desde=<%=Request("Fecha_desde")%>&Fecha_hasta=<%=Request("Fecha_hasta")%>&Rec_desde=<%=Request("Rec_desde")%>&Rec_hasta=<%=Request("Rec_hasta")%>&Modo=<%=Request("Modo")%>&pagenum=1";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Carpeta=<%=Request("Carpeta")%>&NroOCP=<%=Request("NroOCP")%>&Fecha_desde=<%=Request("Fecha_desde")%>&Fecha_hasta=<%=Request("Fecha_hasta")%>&Rec_desde=<%=Request("Rec_desde")%>&Rec_hasta=<%=Request("Rec_hasta")%>&Modo=<%=Request("Modo")%>&pagenum=<%=abspage - 1%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Carpeta=<%=Request("Carpeta")%>&NroOCP=<%=Request("NroOCP")%>&Fecha_desde=<%=Request("Fecha_desde")%>&Fecha_hasta=<%=Request("Fecha_hasta")%>&Rec_desde=<%=Request("Rec_desde")%>&Rec_hasta=<%=Request("Rec_hasta")%>&Modo=<%=Request("Modo")%>&pagenum=<%=abspage + 1%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Carpeta=<%=Request("Carpeta")%>&NroOCP=<%=Request("NroOCP")%>&Fecha_desde=<%=Request("Fecha_desde")%>&Fecha_hasta=<%=Request("Fecha_hasta")%>&Rec_desde=<%=Request("Rec_desde")%>&Rec_hasta=<%=Request("Rec_hasta")%>&Modo=<%=Request("Modo")%>&pagenum=<%=0+pagecnt%>";//'Última Página
	}
</script>

		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				<table width="100%" border=1 align=center cellpadding=1 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td colspan=14>&nbsp;</td>
						<td colspan=2 align=center nowrap >Flete</td>
						<td colspan=2 align=center nowrap >Seguro</td>
						<td colspan=2 align=center nowrap >Ag.Aduana</td>
						<td colspan=4 align=center nowrap >&nbsp;</td>
					</tr>
					<tr class="FuenteCabeceraTabla">
						<td align=center nowrap>OC</td>
						<td align=center nowrap>RC</td>
						<td align=center nowrap>Carpeta</td>
						<td align=left   nowrap>Proveedor</td>
						<td align=left   nowrap>Forward</td>
						<td align=left   nowrap>BL</td>
						<td align=center nowrap>Moneda</td>
						<td align=right  nowrap>Monto</td>
						<td align=right  nowrap>Recibida</td>
						<td align=center nowrap>Embarque</td>
						<td align=center nowrap>ETA</td>
						<td align=center nowrap>Recepción</td>
						<td align=center nowrap>Fecha pago</td>
						<td align=left   nowrap>Forma pago</td>
						<td align=center nowrap>Factura</td>
						<td align=right  nowrap>Monto</td>
						<td align=center nowrap>Factura</td>
						<td align=right  nowrap>Monto</td>
						<td align=center nowrap>Factura</td>
						<td align=left   nowrap>Referencia</td>
						<td align=right  nowrap>Derechos</td>
						<td align=right  nowrap>Gastos y Honorarios</td>
						<td align=right  nowrap>Bodega</td>
						<td align=right  nowrap>Factor</td>
					</tr>
			<%		i=0
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then
                            FactProv = cDbl("0" & Rs("Monto_factura_prov"))
                            FactProvPag = cDbl("0" & Rs("Monto_factura_prov_PAG"))						
                            FactFlete = cDbl("0" & Rs("Monto_factura_flete"))
                            FactFletePag = cDbl("0" & Rs("Monto_factura_flete_PAG"))						
                            FactSeguro = cDbl("0" & Rs("Monto_factura_seguro"))
                            FactSeguroPag = cDbl("0" & Rs("Monto_factura_seguro_PAG"))
                            FactAgAduana = cDbl("0" & Rs("Monto_factura_agente"))
                            FactAgAduanaPag = cDbl("0" & Rs("Monto_factura_agente_PAG"))
						%>
							<tr class="FuenteInput">
								<td align=center nowrap><%=Rs("OC")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("RC")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Carpeta")%>&nbsp;</td>
								<td align=left   nowrap><%=Rs("NomProveedor")%>&nbsp;(<%=Rs("Proveedor")%>)</td>
								<td align=center nowrap><%=Rs("Forward")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("BL")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Moneda")%>&nbsp;</td>
								<td align=right  nowrap><%=NumForm(Rs("Monto"), 2)%>&nbsp;</td>
								
						<%If FactProv = FactProvPag Then%>
								<td align=right  nowrap><%=NumForm(Rs("Recibida"), 2)%>&nbsp;</td>
						<%Else      ' Debe ir en color rojo %>
								<td class="DatoOutputError" align=right nowrap><%=NumForm(Rs("Recibida"), 2)%>&nbsp;</td>
						<%End If%>
								
								<td align=center nowrap><%=Rs("Fecha_embarque")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Fecha_ETA")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Fecha_recepcion")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Fecha_pago")%>&nbsp;</td>
								<td align=left   nowrap><%=Rs("Forma_de_pago")%>&nbsp;</td>
								<td align=center nowrap><%=Rs("Numero_factura_flete")%>&nbsp;</td>

						<%If FactFlete = FactFletePag Then%>
								<td align=right  nowrap><%=NumForm(Rs("Monto_factura_flete"), 2)%>&nbsp;</td>
						<%Else      ' Debe ir en color rojo %>
								<td class="DatoOutputError" align=right nowrap><%=NumForm(Rs("Monto_factura_flete"), 2)%>&nbsp;</td>
						<%End If%>
								<td align=center nowrap><%=Rs("Numero_factura_seguro")%>&nbsp;</td>
						<%If FactSeguro = FactSeguroPag Then%>
								<td align=right  nowrap><%=NumForm(Rs("Monto_factura_seguro"), 2)%>&nbsp;</td>
						<%Else      ' Debe ir en color rojo%>
								<td class="DatoOutputError" align=right  nowrap><%=NumForm(Rs("Monto_factura_seguro"), 2)%>&nbsp;</td>
						<%End If%>

						<%If FactAgAduana = FactAgAduanaPag Then%>
								<td align=center nowrap><%=Rs("Numero_factura_agente")%>&nbsp;</td>
						<%Else      ' Debe ir en color rojo %>
                                <td class="DatoOutputError" align=center nowrap><%=Rs("Numero_factura_agente")%>&nbsp;</td>
						<%End If%>

								<td align=left   nowrap><%=Rs("Referencia_agente_aduana")%>&nbsp;</td>
								<td align=right  nowrap><%=NumForm(Rs("Derechos"), 0)%>&nbsp;</td>
								<td align=right  nowrap><%=NumForm(Rs("Gastos_y_Honorarios"), 0)%>&nbsp;</td>
								<td align=right  nowrap><%=NumForm(Rs("Valor_bodega"), 0)%>&nbsp;</td>
								<td align=right  nowrap><%=NumForm(Rs("Factor"), 2)%>&nbsp;</td>
							</tr>
						<%	rs.MoveNext
						End If
						i=i+1
					Next%>
				</table>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2>
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
<%Else
	Response.Redirect "../../index.htm"
end if%>
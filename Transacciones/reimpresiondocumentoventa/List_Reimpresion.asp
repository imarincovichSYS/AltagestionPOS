<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<%
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	Session("Cliente")				= Request ("CodigoCliente")
	Session("Empresa")				= Request ("CodigoEmpresa")
	Session("Fecha_NotaCredito")	= Request ("Fecha_NotaCredito") 
	Session("Tipo_Documento")		= Request ("CodigoDocumento")
	Session("Numero_Documento")		= Request ("Numero_NotaCredito")
	Session("Bodega")			= Request ("Bodega")

	Cliente							= Request ("CodigoCliente")
	Empresa							= Request ("CodigoEmpresa")
	
	Fecha_NotaCredito				= Request ("Fecha_NotaCredito") 
	Tipo_Documento					= Request ("CodigoDocumento")
	Numero_Documento				= Request ("Numero_NotaCredito")
	Bodega						= Request ("Bodega")

	if len(trim(Cliente)) > 0 then
		Cliente = "'" & Request ("CodigoCliente") & "'"
	else
		Cliente = "Null"
	end if
	if len(trim(Tipo_Documento)) > 0 then
		Tipo_Documento = "'" & Request ("CodigoDocumento") & "'"
	else
		Tipo_Documento = "Null"
	end if
	if len(trim(Empresa)) > 0 then
		Empresa = "'" & Request ("CodigoEmpresa") & "'"
	else
		Empresa = "Null"
	end if
	
	if len(trim(Fecha_NotaCredito)) > 0 then
		Fecha_NotaCredito = "'" & year(Fecha_NotaCredito) & "/" & Month(Fecha_NotaCredito) & "/" & Day(Fecha_NotaCredito) & "'"
	else
		Fecha_NotaCredito = "Null"
	end if
	if len(trim(Numero_Documento)) = 0 then
		Numero_Documento = "Null"
	end if		
	if len(trim(Bodega)) > 0 then	
		Bodega = "'" & Bodega & "'"
	else
		Bodega = "Null"
	end if		

Const adUseClient = 3


Dim conn1

   Sql = "Exec DOV_Lista_DocumentosVenta '" & Session("Empresa_usuario") & "', " & Tipo_Documento & ", " & Numero_Documento & ", " & Fecha_NotaCredito & ", " & Cliente & ", " & Bodega
'Response.Write (sql)

		conn1 = Session("DataConn_ConnectionString")
				
		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = 100
		rs.CacheSize = 100
		rs.CursorLocation = adUseClient

		rs.Open sql , conn1, , , adCmdText 'mejor
		
		ResultadoRegistros=rs.RecordCount
	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
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
<%	end if%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<form name="Listado" Action="Listado_Reimpresion.asp" target="Trabajo" method="post">
		<input type=hidden name="Orden" value="<%=Orden%>">
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
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = 1;
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?CodigoDocumento=<%=Request("CodigoDocumento")%>&CodigoCliente=<%=Request ("CodigoCliente")%>&Fecha_NotaCredito=<%=Request ("Fecha_NotaCredito")%>&Bodega=<%=request("Bodega")%>&pagenum=1&switch=<%=Request("Switch")%>';//'Primera Página
	}

	function repag()
	{
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage-1%>;
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?CodigoDocumento=<%=Request("CodigoDocumento")%>&CodigoCliente=<%=Request ("CodigoCliente")%>&Fecha_NotaCredito=<%=Request ("Fecha_NotaCredito")%>&Bodega=<%=request("Bodega")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}

	function avpag()
	{
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage+1%>;
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?CodigoDocumento=<%=Request("CodigoDocumento")%>&CodigoCliente=<%=Request ("CodigoCliente")%>&Fecha_NotaCredito=<%=Request ("Fecha_NotaCredito")%>&Bodega=<%=request("Bodega")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}
					
	function UltimaPag()
	{
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=0+pagecnt%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?CodigoDocumento=<%=Request("CodigoDocumento")%>&CodigoCliente=<%=Request ("CodigoCliente")%>&Fecha_NotaCredito=<%=Request ("Fecha_NotaCredito")%>&Bodega=<%=request("Bodega")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}

	function MantencionUpdate( valor )
	{	
		//parent.top.frames[2].location.href = "BotonesMantencion_Reimpresion.asp?Nuevo=N&Orden=<%=Orden%>&pagenum=<%=abspage%>";
		parent.top.frames[2].document.Formulario_Botones.Numero_NotaCredito.value	= valor;
		parent.top.frames[2].document.Formulario_Botones.Nuevo.value		= "N";		
   		parent.top.frames[2].document.Formulario_Botones.pagenum.value		= '<%=abspage%>';
   		parent.top.frames[2].document.Formulario_Botones.Orden.value		= '<%=Orden%>';
		parent.top.frames[2].document.Formulario_Botones.submit();
	}	
</script>

	<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
		<tr class=FuenteInput>
			<td width=10% align=left  NOWRAP><b>Nro. Factura inicial</b></td>
			<td width=90% align=left  NOWRAP>
				<input class=FuenteInput type=textbox name="NroFacturaIni" value="" size=10 maxlength=9>
				<input type=hidden name="TDOC" value="<%=Rs("Tipo_documento_zona_franca") %>" size=2 maxlength=2>&nbsp;
			</td>
		</tr>
	</table>
	
		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td width=10% align=left   NOWRAP>&nbsp;Documento&nbsp;&nbsp;</td>
            <td width=5% align=left   NOWRAP>&nbsp;Tipo&nbsp;&nbsp;</td>
						<td width=07% align=center NOWRAP>&nbsp;Número&nbsp;&nbsp;</td>
						<td width=07% align=center NOWRAP>&nbsp;Nº Guía&nbsp;&nbsp;</td>
						<td width=10% align=left   NOWRAP>&nbsp;Bodega&nbsp;&nbsp;</td>
						<td width=10% align=center NOWRAP>&nbsp;Emisión&nbsp;&nbsp;</td>
						<td width=10% align=center NOWRAP>&nbsp;Vencimiento&nbsp;&nbsp;</td>
						<td width=10% align=right  NOWRAP>&nbsp;Monto Total&nbsp;&nbsp;</td>
						<td width=05% align=right  NOWRAP>&nbsp;Estado SII&nbsp;&nbsp;</td>
						<td width=05% align=right  NOWRAP>&nbsp;Nº&nbsp;&nbsp;</td>
						<td width=01% align=center NOWRAP>&nbsp;Imprimir&nbsp;&nbsp;</td>
						<td width=01% align=center NOWRAP>&nbsp;S/Cif&nbsp;&nbsp;</td>
					</tr>
			<%		i=0
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then %>
							<tr class="FuenteInput">
								<td width=10% align=left   NOWRAP>&nbsp;<%=Rs("Documento_valorizado")%>&nbsp;</td>
                <td width=5% align=left   NOWRAP>&nbsp;<%=Rs("Tipo_documento_zona_franca")%>&nbsp;</td>
								<td width=07% align=center NOWRAP>&nbsp;<%=Rs("Numero_documento_valorizado")%>&nbsp;</td>
								<td width=07% align=center NOWRAP>&nbsp;<%=Rs("GuiaDespacho")%>&nbsp;</td>								
								<td width=10% align=left   NOWRAP>&nbsp;<%=Rs("Bodega")%>&nbsp;</td>
								<td width=10% align=center NOWRAP>&nbsp;<%=formatdatetime(Rs("Fecha_emision"),2)%>&nbsp;</td>
								<td width=10% align=center NOWRAP>&nbsp;<%=Rs("Fecha_vencimiento")%>&nbsp;</td>
								<td width=10% align=right  NOWRAP>&nbsp;<%=FormatNumber(Round(Rs("Monto_total_moneda_oficial"),0),0)%>&nbsp;</td>
								<td width=05% align=right  NOWRAP>&nbsp;<%=Rs("Estado_para_SII")%>&nbsp;</td>
								<td width=01% align=center NOWRAP>&nbsp;<input class=FunteInputnumerico type=text size=10 maxlength=9 value="<%=Rs("Numero_documento_valorizado")%>" name="NroFAV_<%=i%>">&nbsp;</td>
								<td width=01% align=center NOWRAP>&nbsp;<input type=checkbox especial="<%=rs("Documento_especial")%>" name="chkImprimir<%=i%>" value="<%=Rs("Numero_documento_valorizado")%>" qvalue="<%=Rs("Numero_interno_documento_valorizado")%>">
									<input type=hidden name="NroInt<%=i%>" value="<%=Rs("Numero_interno_documento_valorizado")%>">&nbsp;
									<input type=hidden name="TDOC<%=i%>" value="<%=Rs("Tipo_documento_zona_franca")%>">&nbsp;
								</td>
								<td width=01% align=right  NOWRAP>&nbsp;<input type=checkbox name="SC">&nbsp;</td>
							</tr>
							
						<%	rs.MoveNext
						End If
						i=i+1
					Next%>
				</table>
				<script language="JavaScript">
					parent.top.frames[2].location.href = "Botones_Reimpresion.asp?HayRegistros=S"
				</script>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
				</tr>
			</table>
				<script language="JavaScript">
					parent.top.frames[2].location.href = "Botones_Reimpresion.asp?HayRegistros=N"
				</script>
		<%End If
						
		rs.Close
		Set rs = Nothing
%>
</form>

	<iframe id="Paso" name="Paso" src="../../empty.asp" width=100% height=0></iframe>

</body>
<%else
	Response.Redirect "../../index.htm"
end if%>
</html>

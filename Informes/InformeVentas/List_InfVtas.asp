<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
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

	Const adUseClient = 3

	cSql = "Exec DNV_Informe_ventas	'"	& Session("Empresa_usuario") & "', "
	cSql = cSql & Fecha_desde & ", "
	cSql = cSql & Fecha_hasta & ", "
	cSql = cSql & Vendedor

'Response.Write(cSql)
	Set rs = Server.CreateObject("ADODB.Recordset")
	
	rs.PageSize = 300
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient

	rs.Open cSql , Conn, , , adCmdText 'mejor
	ResultadoRegistros=rs.RecordCount

%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<%	if Session("Browser") = 1 then %>
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
<form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
<%		If Not rs.EOF Then
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
<script language=javascript>
	function PrimeraPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendedor=<%=Request("Vendedor")%>&Fecha_Desde=<%=request("Fecha_Desde")%>&Fecha_hasta=<%=request("Fecha_hasta")%>&pagenum=1";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendedor=<%=Request("Vendedor")%>&Fecha_Desde=<%=request("Fecha_Desde")%>&Fecha_hasta=<%=request("Fecha_hasta")%>&pagenum=<%=abspage - 1%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendedor=<%=Request("Vendedor")%>&Fecha_Desde=<%=request("Fecha_Desde")%>&Fecha_hasta=<%=request("Fecha_hasta")%>&pagenum=<%=abspage + 1%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendedor=<%=Request("Vendedor")%>&Fecha_Desde=<%=request("Fecha_Desde")%>&Fecha_hasta=<%=request("Fecha_hasta")%>&pagenum=<%=0+pagecnt%>";//'Última Página
	}

</script>


		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				
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
				For intRec=1 To rs.PageSize
					If Not rs.EOF Then %>
						<tr class="FuenteInput">
							<td width= "12%" align=left   NOWRAP >&nbsp;<%=Rs("Vendedores")%>&nbsp;</td>
							<td width= "12%" align=center NOWRAP >&nbsp;<%=Rs("Notas_de_venta")%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Total"),0)%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Preparandose")%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Autorizados")%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=Rs("Facturadas")%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Facturado"),0)%>&nbsp;</td>
							<td width= "12%" align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Por_facturar"),0)%>&nbsp;</td>
						</tr>
				<%	rs.MoveNext
					End If
					i=i+1
				Next %>
			</table>
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
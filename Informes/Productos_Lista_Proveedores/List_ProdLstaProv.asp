<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<%If len(trim( Session( "DataConn_ConnectionString") )) > 0 Then
	JavaScript = "JavaScript:"

	Const adUseClient = 3

	Dim conn1

	Proveedor	= Request("Proveedor")
	if len(trim(Proveedor)) = 0 then Proveedor = "Null" Else Proveedor = "'" & Proveedor & "'"

	ProductoNoEnLista	= Request("ProductoNoEnLista")
	if Trim(ProductoNoEnLista) = "on" then ProductoNoEnLista = "S" Else ProductoNoEnLista = "N"

	Sql = "Exec INF_Productos_en_LPP '" & Session("Empresa_Usuario") & "', " & Proveedor & ", '" & ProductoNoEnLista & "'" 
'Response.Write (sql)

		conn1 = Session("DataConn_ConnectionString")
				
		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = Session("PageSize")
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open sql , conn1, , , adCmdText 'mejor
		
		ResultadoRegistros=rs.RecordCount

	if Session("Browser") = 1 then %>
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
<form name="Listado">
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
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&ProductoNoEnLista=<%=Request("ProductoNoEnLista")%>&pagenum=1&switch=<%=Request("Switch")%>';//'Primera Página
	}

	function repag()
	{
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&ProductoNoEnLista=<%=Request("ProductoNoEnLista")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}

	function avpag()
	{
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&ProductoNoEnLista=<%=Request("ProductoNoEnLista")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&ProductoNoEnLista=<%=Request("ProductoNoEnLista")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}

</script>

		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td align=left   NOWRAP >&nbsp;Código&nbsp;</td>
						<td align=left   NOWRAP >&nbsp;Catálogo&nbsp;</td>
						<td align=left   NOWRAP >&nbsp;Nombre&nbsp;</td>
						<td align=center NOWRAP >&nbsp;Estado&nbsp;</td>
						<td align=right  NOWRAP >&nbsp;Stock Real&nbsp;</td>
						<td align=right  NOWRAP >&nbsp;Disponible&nbsp;</td>
						<td align=right  NOWRAP >&nbsp;Precio LB&nbsp;</td>
						<td align=center NOWRAP >&nbsp;Fec.Ult.Compra&nbsp;</td>
						<td align=left   NOWRAP >&nbsp;Proveedor&nbsp;</td>
						<td align=right  NOWRAP >&nbsp;Precio Proveedor&nbsp;</td>
						<td align=center NOWRAP >&nbsp;Factor U/M&nbsp;</td>
					</tr>
			<%		i=0
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then%>
							<tr class="FuenteInput">
								<td align=left   NOWRAP >&nbsp;<%=Rs("Codigo")%>&nbsp;</td>
								<td align=left   NOWRAP >&nbsp;<%=Rs("Catalogo")%>&nbsp;</td>
								<td align=left   NOWRAP >&nbsp;<%=Rs("Descripcion")%>&nbsp;</td>
								<td align=center NOWRAP >&nbsp;<%=Rs("Estado")%>&nbsp;</td>
								<td align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Stock_real"), 2)%>&nbsp;</td>
								<td align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Stock_disponible"), 2)%>&nbsp;</td>
								<td align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Precio_LB"), 0)%>&nbsp;</td>
								<td align=center NOWRAP >&nbsp;<%=Rs("Fecha_ultima_compra")%>&nbsp;</td>
								<td align=left   NOWRAP >&nbsp;<%=Rs("Proveedor")%>&nbsp;</td>
								<td align=right  NOWRAP >&nbsp;<%=FormatNumber(Rs("Precio_proveedor"), 2)%>&nbsp;</td>
								<td align=center NOWRAP >&nbsp;<%=Rs("Factor_UM")%>&nbsp;</td>
							</tr>
						<%	rs.MoveNext
						End If
						i=i+1
					Next%>
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
<%Else
	Response.Redirect "../../index.htm"
end if%>

</html>

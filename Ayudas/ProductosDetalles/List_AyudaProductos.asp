<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js" -->"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<form name="Formulario">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>
<%
	if Len(trim(Request("Vendible"))) > 0 then
		Vendible = "'" & Request("Vendible") & "'"
	else
		Vendible = "Null"
	end if
		
	SuperFamilia	= Request("SuperFamilia")
	Familia			= Request("Familia")
	SubFamilia		= Request("SubFamilia")
	Descripcion		= Request("Descripcion")
	
	cSql = "Exec PRO_Lista_Ayuda_Productos '" & SuperFamilia & "', '" & Familia & "', '" & SubFamilia & "', '" & Descripcion & "', '" & Session("Empresa_Usuario") & "', " & Vendible

	Const adUseClient = 3
	Dim conn1

	conn1 = Session("DataConn_ConnectionString")

	Set rs = Server.CreateObject("ADODB.Recordset")
		
	rs.PageSize = Session("PageSize")-1
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient

	rs.Open cSql, conn1, , , adCmdText 'mejor
		
	ResultadoRegistros = rs.RecordCount

	If Not Rs.eof then
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
			pagecnt = rs.PageCount %>

<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
			}
		</script>
<%	end if%>

	<script language=javascript>
		function PrimeraPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendible=<%=Request("Vendible")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&SubFamilia=<%=Request("SubFamilia")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=1";//'Primera Página
		}

		function repag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendible=<%=Request("Vendible")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&SubFamilia=<%=Request("SubFamilia")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=abspage - 1%>";//'Página anterior
		}

		function avpag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendible=<%=Request("Vendible")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&SubFamilia=<%=Request("SubFamilia")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=abspage + 1%>";//'Página anterior
		}
						
		function UltimaPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Vendible=<%=Request("Vendible")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&SubFamilia=<%=Request("SubFamilia")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=0+pagecnt%>";//'Última Página
		}
	</script>

	<%Paginacion abspage,pagecnt,rs.PageSize%>
	<%	Dim fldF, intRec %>
	<table width=100% border=0>
		<tr class="FuenteCabeceraTabla">
			<td class="FuenteInput" align=left width=20%><b>Código</b></td>
			<td colspan=2 class="FuenteInput" width=80%><b>Descripción</b></td>
		</tr>
<%		i = 1
		For intRec=1 To rs.PageSize
			If Not rs.EOF Then%>
			<tr>
				<td class="FuenteInput" width=20% align=left>					
					<a name='cLink<%=i%>' href="JavaScript:ClipBoard( 'Formulario', 'IdProd<%=i%>', '', 'c');window.blur()"><SPAN ID="<%=i%>"><%=Rs("Codigo_producto")%></SPAN></a>
				</td>
				<td class="FuenteInput" nowrap width=80%>
					<a name='dLink<%=i%>' href="JavaScript:ClipBoard( 'Formulario', 'IdProd<%=i%>', '', 'c');window.blur()"><SPAN ID="IdDescrip<%=i%>"><%=Rs("Descripcion")%></SPAN></a>
					<SPAN ID="IdProd<%=i%>" style="visibility:hidden"><%=Rs("Codigo_producto")%>¬<%=Rs("Descripcion")%>¬<%=Rs("Unidad")%>¬<%=Rs("Producto_Proveedor")%>¬<%=Rs("Precio")%>¬<%=Rs("Unidad_consumo")%>¬</Span>
				</td>
			</tr>
<%			Rs.MoveNext
			End If
			i = i + 1
		Next%>
	</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay productos según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
</body>
</html>
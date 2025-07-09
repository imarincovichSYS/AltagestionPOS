<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title>Ayuda de Clientes</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Listado">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>

<%
	Const adUseClient = 3
	Dim conn1
	conn1 = Session("DataConn_ConnectionString")

	Codigo	= Request("Codigo")
	Nombre			= Request("Nombre")
	
	cSql = "Exec ECP_ListaClientes '" & session("empresa_usuario") & "', '" & codigo & "', '" & nombre & "', 2,'" & request("tipo") & "'"
'Response.Write cSql
'	Set Rs = Conn.Execute ( cSql )

	Set rs = Server.CreateObject("ADODB.Recordset")
	
	rs.PageSize = Session("PageSize")
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient
	rs.Open cSql , conn1, , , adCmdText 'mejor

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
			pagecnt = rs.PageCount%>
<script language=javascript>
	function PrimeraPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Codigo=<%=request("Codigo")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&pagenum=1";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Codigo=<%=request("Codigo")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&pagenum=<%=abspage - 1%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Codigo=<%=request("Codigo")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&pagenum=<%=abspage + 1%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Codigo=<%=request("Codigo")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&pagenum=<%=0+pagecnt%>";//'Última Página
	}

</script>
	<%Paginacion_Ayuda abspage,pagecnt,rs.PageSize%>
	<table width=100% border=0>
		<tr class="FuenteCabeceraTabla">
			<td class="FuenteInput" align=left width=20%><b>Código</b></td>
			<td class="FuenteInput" width=80%><b>Nombre</b></td>
		</tr>
<%		i = 1
	Dim fldF, intRec
		For intRec=1 To rs.PageSize
			if Not Rs.eof then%>
			<tr>
				<td class="FuenteInput" qwidth=20% align=left>
					<a name ='Link<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'IdProd<%=i%>', '', 'c');window.blur()"><DIV ID="Codigo<%=i%>" ><%=Rs("Entidad_comercial")%></DIV></a>					
				</td>
				<td class="FuenteInput" qwidth=80% nowrap>
					<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'IdProd<%=i%>', '', 'c');window.blur()"><DIV ID="Desc<%=i%>"><%=Rs("Nombre")%></DIV></a>
				</td>
				<td class=oculto>
    				<SPAN ID="IdProd<%=i%>" style="visibility:hidden"><%=Trim(Rs("Entidad_comercial"))%>¬<%=Trim(Rs("Nombre"))%>¬</Span>
				</td>
			</tr>
<%			Rs.MoveNext
			i = i + 1
			end if
		next%>
	</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay Clientes según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
</body>
</html>

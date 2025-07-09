<!-- #include file="../../Scripts/Inc/Paginacion.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

	cSql = "Exec PAR_ListaParametros 'STKALTO'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOF then STKALTO = Rs("Valor_texto") else STKALTO = "Green" end if
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec PAR_ListaParametros 'STKMEDIO'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOF then STKMEDIO = Rs("Valor_texto") else STKMEDIO = "Yellow" end if
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec PAR_ListaParametros 'STKBAJO'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOF then STKBAJO = Rs("Valor_texto") else STKBAJO = "Red" end if
	Rs.Close
	Set Rs = Nothing
	
	cSql = "Exec PAR_ListaParametros 'STKMEDIOALTO'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOF then STKMEDIOALTO = Rs("Valor_texto") else STKMEDIOALTO = "Brown" end if
	Rs.Close
	Set Rs = Nothing
	
	cSql = "Exec PAR_ListaParametros 'STKBAJOMEDIO'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOF then STKBAJOMEDIO = Rs("Valor_texto") else STKBAJOMEDIO = "Purple" end if
	Rs.Close
	Set Rs = Nothing

	Const adUseClient = 3

	Set rs = Server.CreateObject("ADODB.Recordset")
	Producto = Request("Codigo")	
	if len(trim(Producto)) = 0 then Producto = "Null" Else Producto = "'" & Producto & "'"
	
	rs.PageSize = 7
	rs.CacheSize = 7
	rs.CursorLocation = adUseClient

	cSql = "Exec PLP_Productos_en_una_Lista_de_precios "
	cSql = cSql & "'" & Session("Empresa_usuario") & "', '" & Request("ListaPrecios") & "', "
	cSql = cSql & "'" & Request("SuperFamilia") & "', "
	cSql = cSql & "'" & Request("Familia") & "', "
	cSql = cSql & "'" & Request("Subfamilia") & "', "
	cSql = cSql & ""  & Producto & ", "
	cSql = cSql & "'" & Request("Descripcion") & "', "
	cSql = cSql & "'" & Request("Catalogo") & "'"

	rs.Open cSql , Conn, , , adCmdText
		
	ResultadoRegistros=rs.RecordCount
	
%>

<html>

	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Script/Js/Caracteres.js"></script>
	</head>

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
	<form name="Formulario" method="post" action="Paso.asp" target="Paso">
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
	<%PaginacionPocket abspage,pagecnt,rs.PageSize%>

		<table width=100% border=0 cellspacing=1 cellpadding=1  rules=none>
			<tr>
				<td width=20% class=FuenteCabeceraTabla >Código			
					<input type=hidden name="pagenum" value="<%=abspage%>">
				</td>
				<td width=80% class=FuenteCabeceraTabla >Descripción</td>
			</tr>
			<%	Dim fldF, intRec %>
			<%	i = 0
				For intRec=1 To rs.PageSize
					If Not rs.EOF Then
						Descripcion = Replace(Replace(Replace(rs("Descripcion")," ","_"),"-","_"),"/","_")
						if cDbl("0" & Rs("StockReal")) > cDbl("0" & Rs("StockMinimo")) then
							Fondo = STKALTO
							Clase = "FuenteInputInverso"
						elseif cDbl("0" & Rs("StockReal")) > 0 And cDbl("0" & Rs("StockReal")) < cDbl("0" & Rs("StockMinimo")) then
							if cDbl("0" & Rs("StockReal"))+cDbl("0" & Rs("StockTransito")) > cDbl("0" & Rs("StockMinimo")) then
								Fondo = STKMEDIOALTO
								Clase = "FuenteInputInverso"
							else
								Fondo = STKMEDIO
								Clase = "FuenteInput"
							end if
						elseif cDbl("0" & Rs("StockReal")) = 0 then
							if cDbl("0" & Rs("StockTransito")) > cDbl("0" & Rs("StockMinimo")) then
								Fondo = STKBAJOMEDIO
								Clase = "FuenteInputInverso"
							else
								Fondo = STKBAJO
								Clase = "FuenteInputInverso"
							end if
						end if
						Catalogo = rs("Catalogo")
						if IsNull(Catalogo) Then Catalogo = ""
		%>
						<tr bgcolor="<%=Fondo%>" style="">
							<td class=<%=Clase%> align=left><a class=<%=Clase%> href="javascript:parent.top.location.href='Detalle.asp?Producto=<%=rs("Producto")%>&ListaPrecios=<%=Request("ListaPrecios")%>'"><%=Replace(Replace(Replace(Catalogo," ","_"),"-","_"),"/","_")%></a></td>
							<td class=<%=Clase%> >&nbsp;<a class=<%=Clase%> href="javascript:parent.top.location.href='Detalle.asp?Producto=<%=rs("Producto")%>&ListaPrecios=<%=Request("ListaPrecios")%>'"><%=Descripcion%></a></td>
						</tr>
					<%	rs.MoveNext
					End If
				Next
				Rs.Close
				Set Rs = Nothing
			Else
				abspage = 0 %>
				<table Width=95% border=0 cellspacing=2 cellpadding=2 >
				    <tr >
						<td ><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
					</tr>
				</table>
			<%End If 
		Conn.Close 
		Set Conn = Nothing
	%>
		</table>
	</form>

	<script language=javascript>
		function PrimeraPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?ListaPrecios=<%=Request("ListaPrecios")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&Subfamilia=<%=Request("Subfamilia")%>&Codigo=<%=Request("Codigo")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
		}

		function repag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?ListaPrecios=<%=Request("ListaPrecios")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&Subfamilia=<%=Request("Subfamilia")%>&Codigo=<%=Request("Codigo")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}

		function avpag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?ListaPrecios=<%=Request("ListaPrecios")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&Subfamilia=<%=Request("Subfamilia")%>&Codigo=<%=Request("Codigo")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}
							
		function UltimaPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?ListaPrecios=<%=Request("ListaPrecios")%>&SuperFamilia=<%=Request("SuperFamilia")%>&Familia=<%=Request("Familia")%>&Subfamilia=<%=Request("Subfamilia")%>&Codigo=<%=Request("Codigo")%>&Descripcion=<%=Request("Descripcion")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
		}

		function fBoton()
		{
			document.Formulario.target = "Paso"
			document.Formulario.submit();
		}
		
		function fInicio()
		{
			document.Formulario.action = "InicioSession.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}
	</script>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

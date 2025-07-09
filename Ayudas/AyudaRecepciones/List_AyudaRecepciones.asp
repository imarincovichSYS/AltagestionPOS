<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	OrdenCompra = Request("OrdenCompra")
	if len(trim(OrdenCompra)) = 0 then OrdenCompra = "Null"
	Recepcion	= Request("NroRecepcion")
	if len(trim(Recepcion)) = 0 then Recepcion = "Null"
	Proveedor	= Request("Proveedor")
	if len(trim(Proveedor)) = 0 then Proveedor = "Null" Else Proveedor = "'" & Proveedor & "'"
	
	cSql = "Exec DOV_Ayuda_de_Recepciones '" & Session("Empresa_usuario") & "', " & Proveedor & ", " & OrdenCompra & ", " & Recepcion
'Response.Write cSql

	Const adUseClient = 3

	Set Rs = Server.CreateObject("ADODB.Recordset")
		
	Rs.PageSize = Session("PageSize")
	Rs.CacheSize = 3
	Rs.CursorLocation = adUseClient
	Rs.Open cSql , Conn, , , adCmdText 'mejor
	ResultadoRegistros=rs.RecordCount
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Listado">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>
	
		<input class="FuenteCabeceraTabla" type=hidden name="Orden" value="<%=Orden%>">
		<input class="FuenteCabeceraTabla" type=hidden name="pagenum" value="<%=Request("pagenum")%>">
<%	If Not rs.EOF Then
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
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?OrdenCompra=<%=Request("OrdenCompra")%>&NroRecepcion=<%=Request("NroRecepcion")%>&Proveedor=<%=Request("Proveedor")%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?OrdenCompra=<%=Request("OrdenCompra")%>&NroRecepcion=<%=Request("NroRecepcion")%>&Proveedor=<%=Request("Proveedor")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?OrdenCompra=<%=Request("OrdenCompra")%>&NroRecepcion=<%=Request("NroRecepcion")%>&Proveedor=<%=Request("Proveedor")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?OrdenCompra=<%=Request("OrdenCompra")%>&NroRecepcion=<%=Request("NroRecepcion")%>&Proveedor=<%=Request("Proveedor")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}
</script>

		<%	Paginacion abspage,pagecnt,rs.PageSize%>
		<%	Dim fldF, intRec %>

		<table width=100% border=0>
			<tr class="FuenteCabeceraTabla">
				<td width="15%" align=center NOWRAP>&nbsp;Nº recepción&nbsp;</td>
				<td width="15%" align=center NOWRAP>&nbsp;Orden de<br>Cpa.(OCP)&nbsp;</td>
				<td width="40%" align=left   NOWRAP>&nbsp;Proveedor&nbsp;</td>
				<td width="10%" align=center NOWRAP>&nbsp;Moneda<br>OCP&nbsp;</td>
				<td width="15%" align=right  NOWRAP>&nbsp;Tipo cambio<br>Moneda OCP&nbsp;</td>
				<td width="10%" align=right  NOWRAP>&nbsp;Valor en $</td>
			</tr>
	<%		i=0
			For intRec=1 To rs.PageSize
				If Not rs.EOF Then%>
					<tr>
						<td class="FuenteInput" align=center >
							<a name ='Link<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Codigo<%=i%>" ><%=Rs("NroRecepcion")%></DIV></a>
						</td>
						<td class="FuenteInput" align=center >
							<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=Rs("NroOrdenCompra")%></DIV></a>
						</td>
						<td class="FuenteInput" align=left >
							<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=Rs("Nombre_Proveedor")%></DIV></a>
						</td>
						<td class="FuenteInput" align=center >
							<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=Rs("Moneda")%></DIV></a>
						</td>
						<td class="FuenteInput" align=right>
							<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=Rs("TipoCambio")%></DIV></a>
						</td>
						<td class="FuenteInput" align=right>
							<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=FormatNumber(Round(Rs("MontoPesos"),0),0)%></DIV></a>
						</td>
					</tr>
		<%			Rs.MoveNext
				End If
				i=i+1
			Next%>
		</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay codigo según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
</body>
</html>
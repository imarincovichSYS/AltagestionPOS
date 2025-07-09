<!-- #include file="../../Scripts/Inc/Paginacion.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

	Const adUseClient = 3

	Set rs = Server.CreateObject("ADODB.Recordset")
		
	rs.PageSize = 7
	rs.CacheSize = 9
	rs.CursorLocation = adUseClient

	OVT = Request("NroOrdenVta")	
	if len(trim(OVT)) = 0 then OVT = "Null"
	
	Cliente = Request("Cliente")	
	if len(trim(Cliente)) = 0 then Cliente = "Null" Else Cliente = "'" & Cliente & "'"
	
	cSql = "Exec DNV_ListaOrdenesVentas_iPaq Null, '" & Session("Empresa_usuario") & "', " & OVT & ", Null, " & Cliente & ", '" & Session("Login") & "', Null, 'O', Null, Null"

	rs.Open cSql , Conn, , , adCmdText
		
	ResultadoRegistros = rs.RecordCount
	
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
	<!--
		Se definen las funciones para el avance de página y para el retroceso de página
	-->		
			<input type=hidden name="pagenum" value="<%=abspage%>">
			<input type=hidden name="NroDOV" value="">
			
	<script language=javascript>
		function PrimeraPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
		}

		function repag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}

		function avpag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}
						
		function UltimaPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
		}

		function fQry( valor )
		{
			document.Formulario.NroDOV.value = valor;
			document.Formulario.action = "ConsultaOrden.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}		
	</script>

			<%PaginacionPocket abspage,pagecnt,rs.PageSize%>

		<table width=100% border=0 cellspacing=1 cellpadding=1  rules=none>
			<tr class=FuenteCabeceraTabla>
				<td align=center>OVT</td>
				<td align=left  >Cliente</td>
				<td align=center>Estado</td>
			</tr>
			<%	Dim fldF, intRec %>
			<%	i = 0
				For intRec=1 To rs.PageSize
					If Not rs.EOF Then%>
						<tr class=FuenteDetalleTabla>	
							<td align=center>&nbsp;<a class="FuenteDetalleLink" href="javascript:fQry('<%=Rs("Numero_documento_no_valorizado")%>')"><%=rs("Numero_documento_no_valorizado")%></a>&nbsp;</td>
							<td align=left  >&nbsp;<%=Trim(rs("Nombre_cliente"))%>&nbsp;</td>
							<td align=center>&nbsp;<%=rs("Estado_Documento")%>&nbsp;</td>
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
						<td class=FuenteInput><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
					</tr>
				</table>
			<%End If 
		Conn.Close 
		Set Conn = Nothing
	%>
		</table>
	</form>

<script language="javascript">
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

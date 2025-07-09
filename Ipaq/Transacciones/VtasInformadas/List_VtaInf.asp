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
		
	rs.PageSize = 10
	rs.CacheSize = 9
	rs.CursorLocation = adUseClient
	DocVta = Request("DocumentoVenta")
		if len(trim(DocVta)) = 0 then DocVta = "Null" Else DocVta = "'" & DocVta & "'"
	NroDocVta = Request("NroOrdenVta")
		if len(trim(NroDocVta)) = 0 then NroDocVta = "Null"
	Tipo  = Request("Tipo")
		if len(trim(Tipo)) = 0 then Tipo = "Null" Else Tipo = "'" & Tipo & "'"

	cSql = "Exec DOV_Lista_DocumentosVenta_Ipaq '" & Session("Empresa_usuario") & "', " & DocVta & ", " & NroDocVta & ", " & Tipo
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

	<script language=javascript>
		function PrimeraPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?DocumentoVenta=<%=Request("DocumentoVenta")%>&NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
		}

		function repag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?DocumentoVenta=<%=Request("DocumentoVenta")%>&NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}

		function avpag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?DocumentoVenta=<%=Request("DocumentoVenta")%>&NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
		}
						
		function UltimaPag()
		{
			location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?DocumentoVenta=<%=Request("DocumentoVenta")%>&NroOrdenVta=<%=Request("NroOrdenVta")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
		}
		
	</script>

			<%PaginacionPocket abspage,pagecnt,rs.PageSize%>

		<table width=100% border=0 cellspacing=1 cellpadding=1  rules=none>
			<tr class=FuenteCabeceraTabla>
				<td align=center>Sel</td>
				<td align=left  >Cliente</td>
				<td align=center>Documento</td>
				<td align=center>Fecha</td>
			</tr>
			<%	Dim fldF, intRec %>
			<%	i = 0
				For intRec=1 To rs.PageSize
					If Not rs.EOF Then%>
						<tr class=FuenteDetalleTabla>
							<td align=center>
								&nbsp;<input class="FuenteInput" type=checkbox name="Sel_<%=i%>">&nbsp;
								<input type=hidden name="NroIntDOV_<%=i%>" value="<%=Rs("NroIntDOV")%>">
								<input type=hidden name="Doc_<%=i%>" value="<%=Rs("Documento_valorizado")%>">
								<input type=hidden name="NroDoc_<%=i%>" value="<%=Rs("NroDoc")%>">
								<input type=hidden name="Responsable_<%=i%>" value="<%=Rs("Responsable")%>">
							</td>
							<td align=left  >&nbsp;<%=Rs("Nombre_cliente")%>&nbsp;</td>
							<td align=left  >&nbsp;<%=Rs("Documento_valorizado")%>&nbsp;-<%=Rs("Tipo_Doc_ZF")%>&nbsp;<%if Rs("Documento_valorizado") <> "EFI" Then Response.Write "&nbsp;-&nbsp;" & Rs("NroDoc")%>&nbsp;</td>
							<td nowrap align=center><%=Trim(rs("Fecha_emision"))%></td>
						</tr>
					<%	rs.MoveNext
						i = i + 1
					End If
				Next
				Rs.Close
				Set Rs = Nothing
			Else
				abspage = 0 %>
				<table Width=95% border=0 cellspacing=2 cellpadding=2 >
				    <tr>
						<td class=FuenteInput><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
					</tr>
				</table>
			<%End If 
		Conn.Close 
		Set Conn = Nothing
	%>
		</table>
		<input type=hidden name="Lineas" value="<%=i%>">
	</form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

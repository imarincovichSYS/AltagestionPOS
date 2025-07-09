<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

	Const adUseClient = 3


	Sql = "Exec PRO_Reposicion " &+_
          "'"  & Request("Empresa")			& "'," & +_
          "'"  & Request("BodegaOrigen")	& "'," & +_
          "'"  & Request("BodegaDestino")	& "'," & +_
          "'"  & Request("Medida") & "'"

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
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Request("Empresa")%>&BodegaOrigen=<%=Request("BodegaOrigen")%>&BodegaDestino=<%=Request("BodegaDestino")%>&Medida=<%=Request("Medida")%>&pagenum=1";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Request("Empresa")%>&BodegaOrigen=<%=Request("BodegaOrigen")%>&BodegaDestino=<%=Request("BodegaDestino")%>&Medida=<%=Request("Medida")%>&pagenum=<%=abspage - 1%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Request("Empresa")%>&BodegaOrigen=<%=Request("BodegaOrigen")%>&BodegaDestino=<%=Request("BodegaDestino")%>&Medida=<%=Request("Medida")%>&pagenum=<%=abspage + 1%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Request("Empresa")%>&BodegaOrigen=<%=Request("BodegaOrigen")%>&BodegaDestino=<%=Request("BodegaDestino")%>&Medida=<%=Request("Medida")%>&pagenum=<%=0+pagecnt%>";//'Última Página
	}

</script>

		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				<table width="99%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td align=left   width="10%">Ubicación</td>
						<td align=left   width="10%" nowrap>Catálogo</td>
						<td align=left   width="10%">Código</td>
						<td align=center width="10%">Pedido</td>
						<td align=left   width="10%" nowrap>Descripción</td>
						<td align=center width="10%">U/M</td>
						<td align=center width="10%">Caja</td>
						<td align=center width="10%">Origen</td>
						<td align=center width="10%">Crítico</td>
						<td align=center width="10%">Destino</td>
					</tr>
			<%		i=0
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then%>
							<tr class="FuenteInput">
								<td align=left   width="10%"><%=rs("Ubicacion")%>&nbsp;</td>
								<td align=left   width="10%" nowrap><%=rs("Catalogo")%>&nbsp;</td>
								<td align=left   width="10%"><%=rs("Codigo")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Pedido")%>&nbsp;</td>
								<td align=left   width="10%" nowrap><%=rs("Descripcion")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("UM")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Caja")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Origen")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Critico")%>&nbsp;</td>
								<td align=center width="10%"><%=rs("Destino")%>&nbsp;</td>
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
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
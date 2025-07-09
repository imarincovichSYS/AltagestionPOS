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
		<script src="../../Scripts/Js/Ventanas.js"></script>
		<title><%=Ucase(Trim(Session("title")))%></title>
	</head>

<%If len(trim( Session( "DataConn_ConnectionString") )) > 0 Then
	JavaScript = "JavaScript:"

	Const adUseClient = 3

	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )	
	Conn.CommandTimeout = 3600
	
	Proveedor	= Request("Proveedor")
	if len(trim(Proveedor)) = 0 then Proveedor = "Null" Else Proveedor = "'" & Proveedor & "'"

	FechaDesde	= Request("Fecha_Desde")
	if len(trim(FechaDesde)) = 0 then FechaDesde = "Null" Else FechaDesde = "'" & cambia_fecha( FechaDesde ) & "'"

	FechaHasta	= Request("Fecha_Hasta")
	if len(trim(FechaHasta)) = 0 then FechaHasta = "Null" Else FechaHasta = "'" & cambia_fecha( FechaHasta ) & "'"

	Modo = "N"

	Sql = "Exec INF_Antecedentes_compras '" & Session("Empresa_Usuario") & "', " 
	Sql = Sql & Proveedor & ", " 
	Sql = Sql & FechaDesde & ", " 
	Sql = Sql & FechaHasta & ", Null"
'Response.Write sql & "<br>"

	Set rs = Server.CreateObject("ADODB.Recordset")
		
	rs.PageSize = Session("PageSize")
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient

	rs.Open Sql, Conn, , , adCmdText 'mejor
		
	ResultadoRegistros=rs.RecordCount
	
	nBodegas = 0
	nListaPrecios = 0
	nPeriodos = 0
	
	for j = 0 to Rs.Fields.Count-1
		Campo  = Rs.fields(j).name
		if Mid(Campo,1,17) = "Stock_disponible_" then
			nBodegas = nBodegas + 1
		elseif Mid(Campo,1,3) = "LP_" then
			nListaPrecios = nListaPrecios + 1
		elseif Mid(Campo,1,5) = "VTAS_" then
			nPeriodos = nPeriodos + 1
		end if
	next
%>

<body OnLoad="javascript:maximizeWin()">
<form name="Listado">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr height=50 valign=top>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:this.window.close()"><%=Ucase(Trim(Session("title")))%></a></td> 
			</tr>
		</table>
<%	
		If Not rs.EOF Then
				Dim fldF, intRec %>
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td colspan=7 width="10%" align=left   NOWRAP >&nbsp;</td>
						<td colspan=2 width="10%" align=center >&nbsp;Stocks&nbsp;</td>
			<%		For b=0 To Rs.Fields.Count-1
						Campo  = Rs.fields(b).name
						if Mid(Campo,1,17) = "Stock_disponible_" then
							b = b + nBodegas-1
							Response.Write "<td colspan=" & nBodegas & " width=10% align=center >&nbsp;" & Mid(Campo,18) & "&nbsp;</td>"
						elseif Mid(Campo,1,3) = "LP_" then
							b = b + nListaPrecios
							Response.Write "<td colspan=" & nListaPrecios & " width=10% align=center >&nbsp;Listas de precios&nbsp;</td>"
							Response.Write "<td colspan=3 width=10% align=center >&nbsp;</td>"
						elseif Mid(Campo,1,5) = "VTAS_" then
							b = b + nPeriodos
							Response.Write "<td colspan=" & nPeriodos & " width=10% align=center >&nbsp;Períodos&nbsp;</td>"
						end if
					Next%>
					</tr>

					<tr class="FuenteCabeceraTabla">
			<%		For b=0 To Rs.Fields.Count-1
						Campo  = Rs.fields(b).name
						alineacion = "center"
						
						If Mid(Campo,1,17) = "Stock_Disponible" Then							
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Replace(Replace(Mid(Campo,1,16),"_", " "), "Stock", "") & "&nbsp;</td>"
						ElseIf Mid(Campo,1,15) = "Stock_Transito"  Then
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Replace(Replace(Mid(Campo,1,14),"_", " "), "Stock", "") & "&nbsp;</td>"
						elseif Mid(Campo,1,3) = "LP_" then
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Mid(Campo,4) & "&nbsp;</td>"
						elseif Mid(Campo,1,5) = "VTAS_" then							
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Mid(Campo,10) & "-" & Mid(Campo,6,4) & "&nbsp;</td>"
						else
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Campo & "&nbsp;</td>"
						end if
					Next%>
					</tr>
			<%		
					i=0
					Do While Not Rs.EOF 
						Response.Write "<tr class=FuenteInput>"
						For b=0 to Rs.Fields.Count-1
							Campo  = Rs.fields(b).name
							Dato  = Rs.fields(b).value
							alineacion = "center"
							if Mid(Campo,1,17) = "Stock_disponible_" Or Mid(Campo,1,15) = "Stock_transito_" Or Mid(Campo,1,5) = "VTAS_" Or _
								Campo = "Precio_LB" Then
								Response.Write "<td nowrap width=10% align=right >&nbsp;" & formatNumber(Dato,0) & "&nbsp;</td>"
							ElseIf Campo = "Factor_UM" Or Campo = "Peso" Or Campo = "Volumen" Or Campo = "CostoCPP" Or Campo = "Precio_compra" Then
								Response.Write "<td nowrap width=10% align=right >&nbsp;" & formatNumber(Dato,2) & "&nbsp;</td>"
							elseif Campo = "Descripcion" Or Campo = "Catalogo" then
								Response.Write "<td nowrap width=10% align=left >&nbsp;" & Dato & "&nbsp;</td>"
							else
								Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Dato & "&nbsp;</td>"
							end if
						Next
						Response.Write "</tr>"
						Rs.MoveNext
					Loop%>
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

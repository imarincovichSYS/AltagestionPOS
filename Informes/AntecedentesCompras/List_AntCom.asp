<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->

<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>

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

	On Error Resume Next
	
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
	if len(trim(Trim(Err.Description))) > 0 then 
		MsgError = Replace(Replace(Err.Description,"'",""),"[Microsoft][ODBC SQL Server Driver][SQL Server]","")
		%>
		<script language="javascript">
			parent.top.frames[1][1].location.href = "../../empty.asp"
			parent.top.frames[3].location.href = "../../Mensajes.asp?Msg=<%=MsgError%>"
		</script>
<%		Response.End 
	end if
	ResultadoRegistros=rs.RecordCount
	
	nBodegas = 0
	nListaPrecios = 0
	nPeriodos = 0
	
	for j = 0 to Rs.Fields.Count-1
		Campo  = Rs.fields(j).name
		if Mid(Campo,1,17) = "Stock_disponible" then
			nBodegas = nBodegas + 1
		elseif Mid(Campo,1,3) = "LP_" then
			nListaPrecios = nListaPrecios + 1
		elseif Mid(Campo,1,5) = "VTAS_" then
			nPeriodos = nPeriodos + 1
		end if
	Next
'Response.Write nBodegas & " --- " & nListaPrecios & " --- " & nPeriodos
'Response.End 

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
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Fecha_Desde=<%=Request("Fecha_Desde")%>&Fecha_Hasta=<%=Request("Fecha_Hasta")%>&pagenum=1&switch=<%=Request("Switch")%>';//'Primera Página
	}

	function repag()
	{
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Fecha_Desde=<%=Request("Fecha_Desde")%>&Fecha_Hasta=<%=Request("Fecha_Hasta")%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}

	function avpag()
	{
		location.href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Fecha_Desde=<%=Request("Fecha_Desde")%>&Fecha_Hasta=<%=Request("Fecha_Hasta")%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>';//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Proveedor=<%=Request("Proveedor")%>&Fecha_Desde=<%=Request("Fecha_Desde")%>&Fecha_Hasta=<%=Request("Fecha_Hasta")%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}

</script>

		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	
'Response.Write nBodegas & " --- " & nListaPrecios & " --- " & nPeriodos
				Dim fldF, intRec %>
				<table width="80%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
			<%	'	For b=0 To Rs.Fields.Count-1
					'	Campo  = Rs.fields(b).name
					'	if Mid(Campo,1,17) = "Stock_disponible_" then
					'		b = b + nBodegas-1
					'		Response.Write "<td colspan=" & nBodegas & " width=10% align=center >&nbsp;Stocks&nbsp;</td>"
					'	elseif Mid(Campo,1,3) = "LP_" then
					'		b = b + nListaPrecios
					'		Response.Write "<td colspan=" & nListaPrecios & " width=10% align=center >&nbsp;Listas de precios&nbsp;</td>"
					'		Response.Write "<td colspan=3 width=10% align=center >&nbsp;</td>"
					'	elseif Mid(Campo,1,5) = "VTAS_" then
					'		b = b + nPeriodos
					'		Response.Write "<td colspan=" & nPeriodos & " width=10% align=center >&nbsp;Períodos&nbsp;</td>"
					'	end if
					'Next%>
					</tr>

					<tr class="FuenteCabeceraTabla">
			<%		For b=0 To Rs.Fields.Count-2
						Campo  = Rs.fields(b).name
						alineacion = "center"
						
						if Mid(Campo,1,17) = "Stock_Disponible" then							
							Response.Write "<td nowrap width=10% align=right >&nbsp;" & Replace(Replace(Mid(Campo,1,16),"_", " "), "Stock", "") & "&nbsp;</td>"
						elseif Mid(Campo,1,15) = "Stock_Transito"  then
							Response.Write "<td nowrap width=10% align=right >&nbsp;" & Replace(Replace(Mid(Campo,1,14),"_", " "), "Stock", "") & "&nbsp;</td>"
						elseif Mid(Campo,1,3) = "LP_" then
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Mid(Campo,4) & "&nbsp;</td>"
						elseif Mid(Campo,1,5) = "VTAS_" then							
							Response.Write "<td nowrap width=10% align=right >&nbsp;" & Mid(Campo,10) & "-" & Mid(Campo,6,4) & "&nbsp;</td>"
						else
							Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Campo & "&nbsp;</td>"
						end if
					Next%>
					</tr>
			<%		
					i=0
					
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then
						  %>
						  <tr class="FuenteInput" id="Color" name="Color" OnMouseOver="SetColor(this,'#E2EDFC','')" OnMouseOut="SetColor(this,'','')" 
              OnDblClick="javascript:Generar_Informe('<%=rs("Folio")%>','RCP','<%=rs("T.Doc")%>','<%=rs("Fecha recepcion")%>','<%=rs("entidad_comercial")%>','<%=rs("proveedor")%>','<%=rs("fecha_emision")%>','<%=rs("Paridad_conversion_a_dolar")%>','<%=rs("Tot.Cif.Ori")%>','<%=rs("Tot.Cif.Adu")%>','<%=rs("Carpeta")%>')"
              ><%
							'Response.Write "<tr class=FuenteInput>"
							For b=0 to Rs.Fields.Count-2
								Campo  = Rs.fields(b).name
								if (Rs.fields(b).name) = "Tot.Cif.Adu" or (Rs.fields(b).name) = "Tot.Cif.Ori" or (Rs.fields(b).name) ="Paridad_conversion_a_dolar" then
                  Dato  = FormatNumber(Rs.fields(b).value,2)
                  alineacion = "Right"
                else 
								  Dato  = Rs.fields(b).value
								  alineacion = "Left"
								end if
									Response.Write "<td nowrap width=10% align=" & alineacion & " >&nbsp;" & Dato & "&nbsp;</td>"								
							Next
							Response.Write "</tr>"
							rs.MoveNext
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

<script language=javascript>
	function imprimir(numero_guia)
	{
		var winURL		 = "Imprimir_TraspBodega.asp?NumGuia="+numero_guia;
		var winName		 = "Wnd_Productos";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=no," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=800," ;
			winFeatures += "height=500," ;
			winFeatures += "top=30," ;
			winFeatures += "left=0" ;
			window.open(winURL,winName,winFeatures);
			//parent.top.frames[1].location.href = "BotonesMantencion_TraspBodega.asp?consultar=S";
			//this.window.location.href = "List_AyudaProductos.asp?SuperFamilia=<%=Request("SuperFamilia")%>";
	}
	
	function Generar_Informe(v_numero_documento_respaldo,v_documento_no_valorizado,v_documento_respaldo,v_fecha_recepcion,v_proveedor, v_nombre_proveedor,v_fecha_emision,v_paridad,v_total_cif_ori,v_total_cif_adu,v_carpeta)
  {
    parametros ="documento_no_valorizado="+v_documento_no_valorizado+"&numero_documento_respaldo="+v_numero_documento_respaldo
    parametros+="&documento_respaldo="+v_documento_respaldo+"&proveedor="+v_proveedor+"&nombre_proveedor="+escape(v_nombre_proveedor)
    parametros+="&fecha_recepcion="+v_fecha_recepcion+"&fecha_emision="+v_fecha_emision+"&paridad="+v_paridad+"&total_cif_ori="+v_total_cif_ori+"&total_cif_adu="+v_total_cif_adu+"&carpeta="+v_carpeta
    ruta_informe = "compras_listar_detalle"  
    var h = (screen.availHeight - 36), w = (screen.availWidth - 10),  x = 0 , y = 0
    str = "width="+w+", height="+h+", screenX="+x+", screenY="+y+", left="+x+", top="+y+", scrollbars=3,  menubar=no, toolbar=no, status=no"
    WinInforme = open(ruta_informe+".asp?"+parametros, "Inf", str, "replace=1")
  }
</script>

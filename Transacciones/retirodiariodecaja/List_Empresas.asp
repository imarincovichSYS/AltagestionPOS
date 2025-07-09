<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

  Monto_retiro = request("monto_retiro")

	if len(trim(Orden)) = 0 then
		Orden = 1
	end if

  session("Fiscal_actual") = request("Fiscal_actual")

Const adUseClient = 3

'response.write (request("monto_retiro"))
'Response.Write (session("fiscal_actual"))
'response.write (request("Fiscal_actual"))

Dim conn1

   Sql = "Exec RET_Listar_Retiro_caja " +_
          "'"  & session("fiscal_actual") & "'," +_
          "'"  & session("login") & "'"
'Response.Write (Sql)
'Response.end

		conn1 = Session("DataConn_ConnectionString")
				
		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = Session("PageSize")
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open sql , conn1, , , adCmdText 'mejor

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
						<hr width=90%>
<form name="frm_mantencion" target="Trabajo" method="post" action="Save_Empresas.asp" target="Listado">
		<input type=hidden name="Orden" value="<%=Orden%>">
		<input type=hidden name="monto_retiro" value="<%=request("monto_retiro")%>">

<%		
		If Not rs.EOF Then
			If Len(Request("pagenum")) = 0  Then
					rs.AbsolutePage = 1
					monto_retiro = rs("monto_retiro")
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
		parent.top.frames[2].document.Eliminar.pagenum.value = 1;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = 1;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
	}

	function repag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=abspage-1%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage-1%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}

	function avpag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=abspage+1%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage+1%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=0+pagecnt%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=0+pagecnt%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}

	function MantencionUpdate( valor )
	{	
		parent.top.frames[2].location.href = "BotonesMantencion_Empresas.asp?Orden=<%=Orden%>";
		parent.top.frames[2].document.Formulario_Botones.Empresa.value	= valor;
		parent.top.frames[2].document.Formulario_Botones.Nombre.value	= "";
		parent.top.frames[2].document.Formulario_Botones.Nuevo.value		= "N";		
   		parent.top.frames[2].document.Formulario_Botones.pagenum.value		= '<%=abspage%>';
   		parent.top.frames[2].document.Formulario_Botones.Orden.value		= '<%=Orden%>';
		parent.top.frames[2].document.Formulario_Botones.submit();
	}	
</script>

		<%Paginacion abspage,pagecnt,rs.PageSize%>

			<%	Dim fldF, intRec %>
				<table width="90%" border=1 align=center cellpadding=0 cellspacing=0><thead>
				<caption class="FuenteEncabezados">Historial retiros</caption>
					<tr class="FuenteCabeceraTabla">
						<td width= "1%" align=left NOWRAP>&nbsp;Nº retiro</td>
						<!--<td width= "20%" align=left   NOWRAP >&nbsp;<a class="FuenteCabeceraLink" OnMouseMove="JavaScript:Limpia_BarraEstado()" Onfocus="JavaScript:Limpia_BarraEstado()" href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Codigo%>&Nombre=<%=Nombre%>&Orden=1&pagenum=<%=Request("pagenum")%>'>Código</a>&nbsp;&nbsp;<% If Orden = 1 Then Response.Write Session("Simbolo")%></td>
						<td width= "30%" align=left   NOWRAP >&nbsp;<a class="FuenteCabeceraLink" OnMouseMove="JavaScript:Limpia_BarraEstado()" Onfocus="JavaScript:Limpia_BarraEstado()" href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Codigo%>&Nombre=<%=Nombre%>&Orden=2&pagenum=<%=Request("pagenum")%>'>Nombre</a>&nbsp;&nbsp;<% If Orden = 2 Then Response.Write Session("Simbolo")%></td>-->
						<td width= "1%"	 align=left NOWRAP >&nbsp;Fecha</td>
						<td width= "1%"	 align=left NOWRAP >&nbsp;Impresora</td>
						<td width= "1%"	 align=v NOWRAP >&nbsp;Rut</td>
						<td width= "1%"	 align=left NOWRAP >&nbsp;Cajero</td>
						<td width= "1%"	 align=left NOWRAP >&nbsp;Concepto</td>
						<td width= "1%"	 align=left NOWRAP >&nbsp;Medio</td>
						<td width= "1%"	 align=left NOWRAP >&nbsp;Monto</td>
					</tr>
			<%	i=0
				  monto_retiro_total = 0
					For intRec=1 To rs.PageSize
						If Not rs.EOF Then%>
							<tr class="FuenteInput">
								<td width=1% align=right NOWRAP>&nbsp;<%=rs("num_retiro")%></td>
								<td width=1% align=right NOWRAP>&nbsp;<%=rs("Fecha")%></td>
								<td width=1% align=right NOWRAP>&nbsp;<%=rs("Impresora")%></td>
								<td width=1% align=right NOWRAP>&nbsp;<%=rs("Rut_cajero")%></td>
                <td width=1% align=left NOWRAP>&nbsp;<%=rs("nombre_cajero")%></td>
                <td width=1% align=left NOWRAP>&nbsp;<%=rs("obs")%></td>
                <td width=1% align=left NOWRAP>&nbsp;<%=rs("medio")%></td>
                <td width=1% align=right NOWRAP>&nbsp;<%=formatNumber(rs("monto_retiro"),0)%></td>
							</tr>
						<%
              monto_retiro_total = monto_retiro_total + formatnumber(rs("monto_retiro"),0)
            	rs.MoveNext
						End If
						i=i+1
					Next%>
<tr Class="FuenteCabeceraTabla">
<td colspan=7 align=right>Total</td>
<td align=right><%=formatnumber(monto_retiro_total,0)%></td>
</tr>

				</table>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No se han realizado retiros hasta el momento.</B></td>
				</tr>
			</table>
		<%End If
						
		rs.Close
		Set rs = Nothing

		
%>
</form>
</body>
</html>
<%
	
		
	
%>
<%else
	Response.Redirect "../../index.htm"
end if%>

<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Fechas.js"></script>
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
%>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="List_Reimpresion.asp" target="Listado">		
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteEncabezados">
					<td class="FuenteInput" width=10% align=left>
						<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Formulario', '', 'Cliente', 'p');">Cliente</a>
					</td>
					<td class="FuenteInput" align=left>
						<input Class="FuenteInput" type=Text name="Cliente" size=12 maxlength=12 value="<%=Cliente%>" onblur="javascript:validaCaractesPassWord(this.value , this)">
						<input Class="FuenteInput" type=hidden name="CodigoCliente" size=13 maxlength=12 value="<%=Session("Cliente")%>">
						<input Class="FuenteInput" type=hidden name="CodigoEmpresa" size=13 maxlength=12 value="">
					</td>

					<td class="FuenteEncabezados" width=30% align=right><b>Fecha dcto:&nbsp;&nbsp;</b></td>
					<td width=25% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_NotaCredito" size=7 maxlength=10 value="<%=Session("Fecha_NotaCredito")%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_NotaCredito');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
						<input type=hidden name="Orden" value='<%=Request("Orden")%>'>
						<input type=hidden name="pagenum" value='<%=Request("pagenum")%>'>
					</td>

				</tr>
				<tr>
					<td class="FuenteEncabezados" width=11% align=left><b>Documento:&nbsp;&nbsp;</b></td>
					<td class="FuenteEncabezados" width=11% align=left>
						<Select Class="FuenteInput" name="Slct_TipoDocumento">
							<option value='FAV'>Factura de venta&nbsp;(FAV)</option>
							<option value='GDV'>Guía de despacho&nbsp;(GDV)</option>
							<option value='FAE'>Factura de exportación&nbsp;(FAE)</option>
						</select>
						<input Class="FuenteInput" type=hidden name="CodigoDocumento" size=13 maxlength=12 value="<%=Session("Documento")%>">
					</td>

					<td class="FuenteEncabezados" width=11% align=right><b>Número:&nbsp;&nbsp;</b></td>
					<td width=20% align=left>
						<input Class="FuenteInput" type=Text name="Numero_NotaCredito" size=13 maxlength=12 value="<%=Session("Numero_NotaCredito")%>">
					</td>

					<td class="FuenteEncabezados" width=11% align=left><b>Bodega:&nbsp;</b></td>
					<td class="FuenteEncabezados" width=11% align=left>
						<Select Class="FuenteInput" name="Slct_Bodega">
							<option value=""></option>
						<%
							cSql = "Exec HAB_ListaBodega '" & session("empresa_usuario") & "' ,'',''" 
							Set RsBodega = Conn.Execute ( cSql )
							Do While Not RsBodega.eof%>
								<option value='<%=RsBodega("Bodega")%>'><%=RsBodega("Descripcion_breve")%>&nbsp;(<%=RsBodega("Bodega")%>)</option>
						<%		RsBodega.MoveNext
							Loop
							RsBodega.Close
						%>
						</select>
						<input Class="FuenteInput" type=hidden name="Bodega" size=13 maxlength=12 value="<%=Session("Bodega")%>">
					</td>
				</tr>    
			</table>
		</form>
	</body>

<%else
	Response.Redirect "../../index.htm"
end if%>
</html>

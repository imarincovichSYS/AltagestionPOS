<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600
%>

<html>

<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
</head>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Listado" method="post" action="List_Impo.asp" target="Listado">
			<table width=99% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteInput">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha desde</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_desde" size=7 maxlength=10 value="<%=fecha_desde%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha hasta</td>
					<td width=20% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_hasta" size=7 maxlength=10 value="<%=fecha_hasta%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Rec. desde</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Rec_desde" size=7 maxlength=10 value="<%=fecha_desde%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Rec. hasta</td>
					<td width=20% align=left >
						<input Class="FuenteInput" type=Text name="Rec_hasta" size=7 maxlength=10 value="<%=fecha_hasta%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

				<tr class="FuenteInput">
					<td class="FuenteInput" width=10% align=left>
						<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Listado', '', 'Proveedor', 'p');">Proveedor</a>
					</td>
					<td class="FuenteInput" align=left>
						<input Class="FuenteInput" type=Text name="Proveedor" size=13 maxlength=12 value="" onblur="javascript:validaCaractesPassWord(this.value , this)">
					</td>
					
					<td nowrap class="FuenteEncabezados" width=10% align=left >Carpeta</td>
					<td width=20% align=left >
						<input Class="FuenteInput" type=Text name="Carpeta" size=10 maxlength=10 value="">
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Modo</td>
					<td align=left>
						<select style="width:150" class="fuenteinput" name="Modo">
							<option value="T">Todos</option>
							<option value="P">Pendientes de pago</option>
							<option value="R">Pendientes de recepción</option>
						</select>
					</td>
				
					<td nowrap class="FuenteEncabezados" width=10% align=left >Salida</td>
					<td align=left>
					     <select style="width:100" class="fuenteinput" name="Salida">
							<option value="A">Archivo</option>
							<option value="I">Impresora</option>
							<option selected value="P">Pantalla</option>
					     </select>
					</td>
				</tr>
			</table>
		</form>
		
		<iframe id="Paso" name="Paso" width=0 height=0 src="../../empty.asp"></iframe>
		
	</body>
</html>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

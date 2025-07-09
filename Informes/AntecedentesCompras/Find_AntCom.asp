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
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )	
%>
	<body OnLoad="placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="List_AntCom.asp" target="Listado">		
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td class="FuenteInput" width=10% align=left>
						<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Formulario', '', 'Proveedor', 'p');">Proveedor</a>
					</td>
					<td  class="FuenteInput" align=left>
						<input Class="FuenteInput" type=Text name="Proveedor" size=13 maxlength=12 value="<%=Proveedor%>" onblur="javascript:validaCaractesPassWord(this.value , this)">
						<input Class="FuenteInput" type=hidden name="Proveedor_Cotizacion" size=13 maxlength=12 value="<%=Session("Proveedor_Cotizacion")%>">
					</td>


					<td class="FuenteEncabezados" width=10% align=left><b>Salida</td>
					<td width=17% align=left>
						<select class="FuenteInput" name="Salida" style="width:120">
							<option value="P">Pantalla</option>
							<option value="I">Impresora</option>
							<option value="A">Archivo</option>
						</select>
					</td>
				</tr>    

				<tr>
					<td class="FuenteEncabezados" width=8% align=left ><b>Fecha desde</b></td>
					<td width=25% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_Desde" size=13 maxlength=10 value="" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_Desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
						<input type=hidden name="Orden" value='<%=Request("Orden")%>'>
						<input type=hidden name="pagenum" value='<%=Request("pagenum")%>'>
					</td>

					<td class="FuenteEncabezados" width=8% align=left ><b>Fecha hasta</b></td>
					<td width=25% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_Hasta" size=13 maxlength=10 value="" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_Hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>
				</tr>    

			</table>
		</form>
		<IFRAME Id="Paso" name="Paso" FRAMEBORDER=0 SCROLLING=NO SRC="../../Empty.asp" HEIGHT=0 width=100%></IFRAME>

	</body>
</html>

<%else
	Response.Redirect "../../index.htm"
end if%>
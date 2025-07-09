<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	fecha_desde="01/" & mid(date(),4)
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
	</head>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="../../Empty.asp" target="Listado">
			<table width=50% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Desde</td>
					<td width=10% align=left >
						<input type=hidden name="Afectados"   value="">
						<input Class="FuenteInput" type=Text name="Fecha_desde" size=7 maxlength=10 value="<%=fecha_desde%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Hasta</td>
					<td width=10% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_hasta" size=7 maxlength=10 value="<%=date()%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>
				</tr>    
			</table>
		</form>
	</body>
</html>

<%else
	Response.Redirect "../../index.htm"
end if%>
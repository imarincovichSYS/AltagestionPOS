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
	Conn.commandtimeout=3600
	fecha_desde="01/" & mid(date(),4)
	fecha_hasta=date()
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

		<Form name="Listado" method="post" action="List_InfVtas.asp" target="Listado">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=07% align=left >Desde</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_desde" size=7 maxlength=10 value="<%=fecha_desde%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=07% align=left >Hasta</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_hasta" size=7 maxlength=10 value="<%=fecha_hasta%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Responsable</td>
					<td align=left>
				     <%		Sql = "Exec ECP_ListaVendedores '" & Session("Empresa_usuario") & "', Null, Null"
	                    	SET Rs	=	Conn.Execute( SQL ) %>
				          <select Class="FuenteInput" style="width:150" name="Vendedor">
							<option value="">< Todos ></option>
	                    	<%do while not rs.eof%>
	                    	     <option value='<%=rs("Entidad_comercial")%>'><%=Rs("Nombre")%>&nbsp;(<%=rs("Entidad_comercial")%>)</option>
	                    	     <%rs.movenext
	                    	loop
	                    	rs.close
	                    	set rs=nothing%>
				           </select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left ><b>Enviado a</b></td>
					<td align=left>
						<Select class="FuenteInput" name="Salida">
							<option	value="A">Archivo</option>
							<option	value="I">Impresora</option>
							<option Selected value="P">Pantalla</option>
						</Select>
					</td>
				</tr>    
				<input type=hidden name="Accion" value=""	>
			</table>
		</form>

		<iframe id="Paso" Name="Paso" src="../../empty.asp" height=0 width=0></iframe>
		
	</body>
</html>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

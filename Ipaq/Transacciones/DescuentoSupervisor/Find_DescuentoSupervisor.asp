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
	
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td COLSPAN=5 width=100% class="FuenteTitulosFunciones" align=left nowrap>DESCUENTO SUPERVISOR</td> 
				</tr>
				<tr class="FuenteEncabezados">
   					<td nowrap class="FuenteEncabezados" align=left >Cajera&nbsp;</td>
					<td align=right width="80%" nowrap>
						<input type=button class=FuenteInput name="btnBuscar" value="Buscar" OnClick="javascript:fBuscar()">
						<input type=button class=FuenteInput name="btnAplicar" value="Aplicar" OnClick="javascript:fAplicar()">
						<input type=button class=FuenteInput name="btnSalir"  value="Salir"  OnClick="javascript:fSalir()">
					</td>
				</tr>						 

				<tr class="FuenteEncabezados">

					<td align=left colspan="2">
<%
cSql = "select * from entidades_comerciales where Numero_interno_DVT_activa is not null and Numero_interno_DVT_activa <> 0"
Set Rs = Conn.Execute(cSql)%>          
						<Select class="FuenteInput" name="Cajera">
							<option value=""></option>
<%Do while Not Rs.Eof%>
							<option value="<%=rs("Entidad_comercial")%>"><%=rs("Apellidos_persona_o_nombre_empresa")%>&nbsp;(<%=rs("Entidad_comercial")%>)</option>
<%rs.movenext
  loop%>
						</Select>
					</td>
       
				</tr>

			</table>
		</form>
	</body>

	<script language="javascript">
		function fBuscar()
		{
			var Cajera    = document.Formulario.Cajera.value
			var Error = "N"
				if ( Cajera == "" )
				{
					alert ( 'Debe seleccionar una cajera.' )
					Error = "S"
				}
			if ( Error == "N" )
			{
				document.Formulario.action = "List_DescuentoSupervisor.asp";
				document.Formulario.target = "Listado";
				document.Formulario.submit();
			}
		}

		function fAplicar()
		{
			var Error = "N"
			var Pagina = parent.top.frames[1].location.href
			var Afectados = 0;
			
			if ( Pagina.indexOf('List_DescuentoSupervisor.asp') != -1 )
			{
				var nLineas = parent.top.frames[1].document.Formulario.Lineas.value;
				for ( a=1; a<=nLineas; a++ )
				{
					var Descuento_anterior = eval("parent.top.frames[1].document.Formulario.Descuento_anterior_" + a + ".value");
          var Nuevo_descuento = eval("parent.top.frames[1].document.Formulario.Descuento_" + a + ".value");
					if ( Descuento_anterior != Nuevo_descuento )
					{	
						Afectados = 1
						break;
					}
				}				
			}
			else
			{
				Error = "S"
				alert ( 'Primero debe buscar y luego seleccionar los documentos a ser anulados.' )
			}
			
			if ( Error == "N" )
			{
				if ( Afectados == 0 )
				{
					alert ( 'No hay modificación de descuentos.' )
				}
				else
				{
					var Rsp = confirm( '¿ Esta seguro de aplicar los descuentos ingresados ?' )
					if ( Rsp )
					{
						parent.top.frames[1].document.Formulario.action = "Aplicar_DescuentoSupervisor.asp";
						parent.top.frames[1].document.Formulario.target = "_top";
						parent.top.frames[1].document.Formulario.submit();
					}
				}
			}
		}
		
		function fSalir()
		{
			document.Formulario.action = "../../Menu_Ipaq.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}
	</script>

</html>
<% conn.close() %>
<%else
	Response.Redirect "../../index.htm"
end if%>

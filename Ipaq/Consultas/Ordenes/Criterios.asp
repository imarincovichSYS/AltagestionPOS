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
					<td COLSPAN=2 width=100% class="FuenteTitulosFunciones" align=left nowrap>STATUS ORDENES</td> 
				</tr>
				<tr class="FuenteEncabezados">
					<td colspan=2 align=right >
						<input type=button class=FuenteInput name="btnBuscar" value="Buscar" OnClick="javascript:fBuscar()">
						<input type=button class=FuenteInput name="btnSalir"  value="Salir"  OnClick="javascript:fSalir()">
					</td>
				</tr>						 

				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=20% align=left >Nº Orden</td>
					<td align=left>
						<input class="FuenteInput" type=text name="NroOrdenVta" size=9 maxlength=9 value="<%=Request("NroOrdenVta")%>">
					</td>
				</tr>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=20% align=left >Cliente</td>
					<td align=left>
						<input class="FuenteInput" type=text name="Cliente" size=12 maxlength=12 value="<%=Request("Cliente")%>">
					</td>
				</tr>
			</table>
		</form>
	</body>

	<script language="javascript">
		function fCrear()
		{
			document.Formulario.action = "Crear.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}

		function fBuscar()
		{
			var NroOVT = document.Formulario.NroOrdenVta.value
			var Cliente = document.Formulario.Cliente.value
			var Error = "N"
			
			if ( ! validEmpty(NroOVT) )
			{
				if ( ! validNum(NroOVT) )
				{
					alert ( 'El nº de orden debe ser numérico, revise por favor.' )
					Error = "S"
				}
			}
			
			if ( Error == "N" )
			{
				if ( ! validEmpty(Cliente) )
				{
					if ( validaCharNoPermitidos_Txt(Cliente) )
					{
						alert ( 'El cliente contiene caracteres no válidos, revise por favor.' )
						Error = "S"
					}
				}
			}
			
			if ( Error == "N" )
			{
				document.Formulario.action = "Listado.asp";
				document.Formulario.target = "Listado";
				document.Formulario.submit();
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

<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Fechas.js"></script>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	</head>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
'	end if	
%>

<!-- Aqui están las funciones que permiten escribir en el Frame de mensajes.
	¿ Por que hay 2 funciones ?.- 
	Rpt. Segun el Browser que este corriendo la aplicación va ha ser la que se llame,
	Una está desarrollada en VBS y la otra en JS la que está hecha en VBS también puede
	ser llamada de JavaScript, pero la que está hechha en JS no.
	Mensajes ( valor ) es el formato de llamada donde valor va a ser el string que se
	coloca en la sección de los Mensajes.
-->

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

<script language="JavaScript">

	function MensajesStatus( valor )
	{
		window.status = valor;
	}



	function Procesar()
	{		
        parent.top.frames[1][1].document.Listado.submit();
	}
	
	function Buscar()
	{
		Mensajes('');
		var fecha_inicial=parent.top.frames[1][0].document.Formulario.Fecha_inicial;
        if (!validEmpty(fecha_inicial.value))
		{
			if (!validaFecha(fecha_inicial.value))
			{
				Mensajes('La fecha inicial ingresada no es valida.');
				fecha_inicial.focus();
				return;
			}
		}
		else
		{
			Mensajes('Debe Ingresar la fecha inicial, revise por favor.');
			fecha_inicial.focus();
			return;
		}
    
        parent.top.frames[1][0].document.Formulario.submit();
	}
	
	function Cerrar()
	{
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
</script>

<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	<Form name="Formulario_Botones" method="post" action="" target="Trabajo">
	<!--	<Form name="Formulario_Botones" method="post" action="Mant_CambCodProd.asp" target="Trabajo">-->
	<!-- Formulario que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Numero_documento_no_valorizado"		value="">
		<input type="hidden" name="Nuevo"		value="S">
		<%'=request("nomina")%>
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteBotonesLink" width=100%>
				<%if request("nomina") <> "N" then%>
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Procesa los documentos seleccionados.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Procesa los documentos seleccionados.")' Onfocus='<%=JavaScript%>MensajesStatus("Procesa los documentos seleccionados.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Procesar()">Procesar</a></b>
					<!-- <img alt="Ingresa un nuevo CentroVenta" border=0 src="../../imagenes/nuevo.gif"></a></b><br><br><br>-->
				</td> 
				<%end if%>
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
					<!-- <img alt="Genera un listado, según el criterio especificado" border=0 src="../../imagenes/buscar.gif"></a></b><br><br><br>-->
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
					<!-- <img alt="Se devuelve al menú principal de mantenciones" border=0 src="../../imagenes/cerrar.gif"></a></b><br><br><br> -->
				</td> 
			</tr>
		</table>
	</Form>

</body>

<%else
	Response.Redirect "../../index.htm"
end if%>

</html>

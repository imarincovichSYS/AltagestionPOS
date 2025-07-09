<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	</head>


<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
		if len(trim(request("Empresa"))) > 0 then
		     session("Empresa_usuario")=request("Empresa")
		end if
'	end if	
	if Session("Browser") = 1 then %>
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

<!-- Aqui están las funciones que permiten escribir en el Frame de mensajes.
	¿ Por que hay 2 funciones ?.- 
	Rpt. Segun el Browser que este corriendo la aplicación va ha ser la que se llame,
	Una está desarrollada en VBS y la otra en JS la que está hecha en VBS también puede
	ser llamada de JavaScript, pero la que está hechha en JS no.
	Mensajes ( valor ) es el formato de llamada donde valor va a ser el string que se
	coloca en la sección de los Mensajes.
-->

<script language="JavaScript">

     
	function MensajesStatus( valor )
	{
		window.status = valor;
	}


	function Procesar()
	{
        if ( ! validEmpty(parent.top.frames[1].document.Formulario.Folio_nulo.value) )
		{
			if (validaMontos(parent.top.frames[1].document.Formulario.Folio_nulo.value, parent.top.frames[1].document.Formulario.Folio_nulo))
			{
				if (parent.top.frames[1].document.Formulario.Folio_nulo.value > 0)
				{
					parent.top.frames[1].document.Formulario.submit();
				}
				else
				{
					Mensajes('El número de folio es un dato requerido');
				}
			}
		}
		else
		{
			Mensajes('El número de folio es un dato requerido');
		}
	}	
	
	function Cerrar()
	{
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
</script>

<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	<Form name="Formulario_Botones" method="post" action="Mant_Bancos.asp" target="Trabajo">
	<!-- Formulario que envia a editar o ingresar un nuevo registro de esta mantención -->
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteBotonesLink" width=100%>
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Ingresa folio nulo.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Ingresa folio nulo.")' Onfocus='<%=JavaScript%>MensajesStatus("Ingresa folio nulo.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Procesar()" >Procesar</a></b>
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>

</body>
<%else
	Response.Redirect "../../index.htm"
end if%>

</html>

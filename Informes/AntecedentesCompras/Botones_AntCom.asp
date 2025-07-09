<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Fechas.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
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
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
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
	var newwin;
	function launchwin(winurl,winname,winfeatures,parentname)
	{		if (!document.images)		{
			newwin = null;
		}
		if (newwin == null || newwin.closed)
		{
			newwin = window.open(winurl,winname,winfeatures);			if (newwin.opener == null)
			{
				newwin.opener = window;
			}
			newwin.opener.name = parentname;
		}
		else
		{			if(newwin.opener.name != winname)			{				newwin = window.open(winurl,winname,winfeatures);				if (newwin.opener == null)
				{
					newwin.opener = window;
				}
				newwin.opener.name = parentname;
			}			else			{
				newwin.focus(); 			}
		}
	}

	
	function AyudaProveedores()
	{
		var winURL		 = "../../Mantenciones/AyudaProveedores/Window_FrameSet.asp";
		var winName		 = "Wnd_Proveedores";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=no," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=650," ;
			winFeatures += "height=300," ;
			winFeatures += "top=30," ;
			winFeatures += "left=50" ;
			launchwin(winURL , winName , winFeatures , 'mainwindow')
	}

	function MensajesStatus( valor )
	{
		window.status = valor ;
	}

	function Buscar()
	{
		Mensajes ( "" );
		var Proveedor	= parent.top.frames[1][0].document.Formulario.Proveedor.value;
		var FechaDesde	= parent.top.frames[1][0].document.Formulario.Fecha_Desde.value;
		var FechaHasta	= parent.top.frames[1][0].document.Formulario.Fecha_Hasta.value;
		var Error = "N";
		
		if ( ! validEmpty(Proveedor) )
		{
			if ( validaCharNoPermitidos(Proveedor) )
			{
				Error = "S";
				Mensajes ( "El proveedor tiene carácteres no permitidos (" + cChar + ")." );
				parent.top.frames[1][0].document.Formulario.Proveedor.focus();
			}
		}
		else
		{
			Error = "S";
			Mensajes ( "El proveedor debe ser ingresado" );
			parent.top.frames[1][0].document.Formulario.Proveedor.focus();
		}
		
		if ( Error == "N" )
		{
			if (! validEmpty(FechaDesde) )
			{
				if ( ! validaFecha(FechaDesde) )
				{
					Error = "S";
					Mensajes ( "La fecha desde no es válida." );
					parent.top.frames[1][0].document.Formulario.Fecha_Desde.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if (! validEmpty(FechaHasta) )
			{
				if ( ! validaFecha(FechaHasta) )
				{
					Error = "S";
					Mensajes ( "La fecha hasta no es válida." );
					parent.top.frames[1][0].document.Formulario.Fecha_Hasta.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			var Salida = parent.top.frames[1][0].document.Formulario.Salida.value;
			if ( Salida == "P" )
			{
				parent.top.frames[1][0].document.Formulario.action = "List_AntCom.asp";
				parent.top.frames[1][0].document.Formulario.target = "Listado";
				parent.top.frames[1][0].document.Formulario.submit();
			}
			else if ( Salida == "I" )
			{
				var Url = "Proveedor=" + Proveedor + "&Fecha_Desde=" + FechaDesde + "&Fecha_Hasta=" + FechaHasta
				var winURL		 = "Imprimir.asp?" + Url;
				var winName		 = "Wnd_InfAntCom";
				var winFeatures  = "status=no," ; 
					winFeatures += "resizable=no," ;
					winFeatures += "toolbar=no," ;
					winFeatures += "location=no," ;
					winFeatures += "scrollbars=yes," ;
					winFeatures += "menubar=0," ;
					winFeatures += "width=800," ;
					winFeatures += "height=540," ;
					winFeatures += "top=0," ;
					winFeatures += "left=0" ;
				launchwin(winURL , winName , winFeatures , 'mainwindow')
			}
			else if ( Salida == "A" )
			{
				parent.top.frames[1][0].document.Formulario.action = "GeneraArchivoCSV.asp";
				parent.top.frames[1][0].document.Formulario.target = "Paso";
				parent.top.frames[1][0].document.Formulario.submit();
			}
		}
	}
	
	function Cerrar()
	{
		Mensajes ("");
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
</script>

	<Form name="Formulario_Botones" method="post" action="Mant_AntCom.asp" target="Trabajo">
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteBotonesLink" width=100%>
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Generar</a></b>
				</td> 
		<%	if len(trim(Session("Proveedor"))) = 0 then %>					
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún proveedor.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún proveedor.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún proveedor.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:AyudaProveedores()" >Ayuda proveedores</a></b>
				</td> 
		<%	end if%>
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

<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
'	end if	
%>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<!-- Aqui est�n las funciones que permiten escribir en el Frame de mensajes.
	� Por que hay 2 funciones ?.- 
	Rpt. Segun el Browser que este corriendo la aplicaci�n va ha ser la que se llame,
	Una est� desarrollada en VBS y la otra en JS la que est� hecha en VBS tambi�n puede
	ser llamada de JavaScript, pero la que est� hechha en JS no.
	Mensajes ( valor ) es el formato de llamada donde valor va a ser el string que se
	coloca en la secci�n de los Mensajes.
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
		Mensajes('');
<%	end if%>




<script language="JavaScript">
	Mensajes('');
	function MensajesStatus( valor )
	{
		window.status = valor;
	}

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
		{
			if(newwin.opener.name != winname)			{				newwin = window.open(winurl,winname,winfeatures);				if (newwin.opener == null)
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

	function Buscar()
	{
		Mensajes('');
		var FechaDesde = parent.top.frames[1][0].document.Listado.Fecha_desde.value;
		var FechaHasta = parent.top.frames[1][0].document.Listado.Fecha_hasta.value;
		var RecDesde   = parent.top.frames[1][0].document.Listado.Rec_desde.value;
		var RecHasta   = parent.top.frames[1][0].document.Listado.Rec_hasta.value;
		var Proveedor  = parent.top.frames[1][0].document.Listado.Proveedor.value;
		var Carpeta	   = parent.top.frames[1][0].document.Listado.Carpeta.value;
		var Modo	   = parent.top.frames[1][0].document.Listado.Modo.value;
		var Error = "S";
		
		if(parent.top.frames[1][0].document.Listado.Salida.value=='A')
		{
			parent.top.frames[1][0].document.Listado.action="GeneraArchivoCSV.asp";
			parent.top.frames[1][0].document.Listado.target="Paso";
		}
		else if(parent.top.frames[1][0].document.Listado.Salida.value=='I')
		{
			Mensajes ( "" );
			var Url = "Fecha_desde=" + FechaDesde + "&Fecha_hasta=" + FechaHasta;
				Url = Url + "&Rec_desde=" + RecDesde + "&Rec_hasta=" + RecHasta;
				Url = Url + "&Proveedor=" + Proveedor + "&Carpeta=" + Carpeta;
				Url = Url + "&Modo=" + Modo;
			var winURL		 = "Imprimir.asp?" + Url;
			var winName		 = "Wnd_InfRep";
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
		else  if(parent.top.frames[1][0].document.Listado.Salida.value=='P')
		{
			parent.top.frames[1][0].document.Listado.action="List_Impo.asp";
			parent.top.frames[1][0].document.Listado.target="Listado";
		}
		parent.top.frames[1][0].document.Listado.submit();
	}

	function Cerrar()
	{
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
	
</script>

<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	<Form name="Listado_Botones" method="post" action="Save_Impo.asp" target="Trabajo">
	<!-- Listado que envia a editar o ingresar un nuevo registro de esta mantenci�n -->
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Numero_documento_no_valorizado"		value="">
		<input type="hidden" name="Accion"		value="">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteInput">
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de b�squeda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de b�squeda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de b�squeda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite al usuario la b�squeda de alg�n proveedor.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite al usuario la b�squeda de alg�n proveedor.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite al usuario la b�squeda de alg�n proveedor.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:AyudaProveedores()" >Ayuda proveedores</a></b>
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al men� principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al men� principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al men� principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
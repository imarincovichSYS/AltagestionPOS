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

	function Buscar()
	{
		Mensajes('');
		var BodegaOrigen  = parent.top.frames[1][0].document.Listado.BodegaOrigen.value;
		var BodegaDestino = parent.top.frames[1][0].document.Listado.BodegaDestino.value;
		var Error = "S";
		
		if ( validEmpty(BodegaOrigen) ) { BodegaOrigen = '-' }
		if ( validEmpty(BodegaDestino) ) { BodegaDestino = '*' }
		
		if ( BodegaOrigen != BodegaDestino )
		{
			if(parent.top.frames[1][0].document.Listado.Salida.value=='A')
			{
				parent.top.frames[1][0].document.Listado.action="GeneraArchivoCSV.asp";
				parent.top.frames[1][0].document.Listado.target="Paso";
			}
			else if(parent.top.frames[1][0].document.Listado.Salida.value=='I')
			{
				var Empresa		  = parent.top.frames[1][0].document.Listado.Empresa.value;
				var Medida		  = parent.top.frames[1][0].document.Listado.Medida.value;

				Mensajes ( "" );
				var Url = "Empresa=" + Empresa + "&Medida=" + Medida;
					Url = Url + "&BodegaOrigen=" + BodegaOrigen + "&BodegaDestino=" + BodegaDestino;
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
			else  if(parent.top.frames[1][0].document.Listado.Salida.value=='I')
			{
				parent.top.frames[1][0].document.Listado.action="List_InfRep.asp";
				parent.top.frames[1][0].document.Listado.target="Listado";
			}
			parent.top.frames[1][0].document.Listado.submit();
		}
		else
		{
			Mensajes( 'Las bodegas no pueden ser iguales, revise por favor.' );
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
	<Form name="Listado_Botones" method="post" action="Save_InfRep.asp" target="Trabajo">
	<!-- Listado que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Numero_documento_no_valorizado"		value="">
		<input type="hidden" name="Accion"		value="">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteInput">
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
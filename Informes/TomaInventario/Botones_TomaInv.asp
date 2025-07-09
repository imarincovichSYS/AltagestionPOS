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
	var newwin;
	function launchwin(winurl,winname,winfeatures,parentname)
	{
		if (!document.images)
		{
			newwin = null;
		}
		if (newwin == null || newwin.closed)
		{
			newwin = window.open(winurl,winname,winfeatures);
			if (newwin.opener == null)
			{
				newwin.opener = window;
			}
			newwin.opener.name = parentname;
		}
		else
		{
			if(newwin.opener.name != winname)
			{
				newwin = window.open(winurl,winname,winfeatures);
				if (newwin.opener == null)
				{
					newwin.opener = window;
				}
				newwin.opener.name = parentname;
			}
			else
			{
				newwin.focus(); 
			}
		}
	}

	function AyudaProductos()
	{
		var winURL		 = "../../Mantenciones/AyudaProductos/Window_FrameSet.asp";
		var winName		 = "Wnd_Productos";
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
		window.status = valor;
	}

	
	function Buscar()
	{
		Mensajes('');
		var cChar = "'/\|,ç+-" + '"' ;
		var Bodega = parent.top.frames[1][0].document.Listado.Bodega.value ;
		var Producto = parent.top.frames[1][0].document.Listado.Producto.value ;
		var Slct_SuperFam = parent.top.frames[1][0].document.Listado.Slct_SuperFam.value ;
		var Slct_Familia = parent.top.frames[1][0].document.Listado.Slct_Familia.value ;
		var Slct_SubFamilia = parent.top.frames[1][0].document.Listado.Slct_SubFamilia.value ;
		var PreCarga = parent.top.frames[1][0].document.Listado.Precarga;
		
        if ( validEmpty(Bodega) )
		{
			Mensajes ( "Debe seleccionar la bodega, revise por favor.." );
			parent.top.frames[1][0].document.Listado.Bodega.focus();
			return;
		}
		
		if ( validaCharNoPermitidos(Producto) )
		{
			Mensajes ( "El producto tiene carácteres no permitidos (" + cChar + ")." );
			parent.top.frames[1][0].document.Listado.Producto.focus();
			return;
		}

        parent.top.frames[1][0].document.Listado.hPrecarga.value = "N"
		if ( PreCarga.checked == true )
		{
            var Rsp = confirm ( '¿ Realiza la precarga de la toma ?' )
            if ( Rsp )
            {
                parent.top.frames[1][0].document.Listado.hPrecarga.value = "S"
            }
            
            if ( parent.top.frames[1][0].document.Listado.hPrecarga.value == "S" )
            {
                if(parent.top.frames[1][0].document.Listado.Salida.value=='A')
        		{
        			parent.top.frames[1][0].document.Listado.action="GeneraToma.asp?Url=GeneraArchivoCSV.asp";
        			parent.top.frames[1][0].document.Listado.target="Paso";
        			parent.top.frames[1][0].document.Listado.submit();
        		}
        		else
        		{
        			var Datos = "Bodega=" + Bodega + "&Producto=" + Producto;
        			    Datos = Datos + "&Slct_SuperFam=" + Slct_SuperFam + "&Slct_Familia=" + Slct_Familia
        			    Datos = Datos + "&Slct_SubFamilia=" + Slct_SubFamilia
        			    Datos = Datos + "&Precarga=" + parent.top.frames[1][0].document.Listado.hPrecarga.value
        			    
        			parent.top.frames[1][0].document.Listado.action="GeneraToma.asp?Ventana=S&Url=Imprimir.asp?" + Datos;
        			parent.top.frames[1][0].document.Listado.target="Paso";
        			parent.top.frames[1][0].document.Listado.submit();
        		}
            }
    	}

        if ( parent.top.frames[1][0].document.Listado.hPrecarga.value == "N" )
        {
            if(parent.top.frames[1][0].document.Listado.Salida.value=='A')
    		{
    			parent.top.frames[1][0].document.Listado.action="GeneraArchivoCSV.asp";
    			parent.top.frames[1][0].document.Listado.target="Paso";
    			parent.top.frames[1][0].document.Listado.submit();
    		}
    		else
    		{
    			var Datos = "Bodega=" + Bodega + "&Producto=" + Producto;
    			    Datos = Datos + "&Slct_SuperFam=" + Slct_SuperFam + "&Slct_Familia=" + Slct_Familia
    			    Datos = Datos + "&Slct_SubFamilia=" + Slct_SubFamilia
    			    Datos = Datos + "&Precarga=" + parent.top.frames[1][0].document.Listado.hPrecarga.value
    			    
    			var winURL		 = "Imprimir.asp?" + Datos;
    			var winName		 = "WndToma";
    			var winFeatures  = "status=no," ; 
    				winFeatures += "resizable=no," ;
    				winFeatures += "toolbar=no," ;
    				winFeatures += "location=no," ;
    				winFeatures += "scrollbars=yes," ;
    				winFeatures += "menubar=0," ;
    				winFeatures += "width=650," ;
    				winFeatures += "height=300," ;
    				winFeatures += "top=30," ;
    				winFeatures += "left=50" ;
    				launchwin(winURL , winName , winFeatures , 'mainwindow')
    		}
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
	<Form name="Listado_Botones" method="post" action="Save_TomaInv.asp" target="Trabajo">
	<!-- Listado que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Numero_documento_no_valorizado"		value="">
		<input type="hidden" name="Accion"		value="">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteInput">
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
					<!-- <img alt="Genera un listado, según el criterio especificado" border=0 src="../../imagenes/buscar.gif"></a></b><br><br><br>-->
				</td> 
				<td align=center width=25% nowrap>
				<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún producto.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún producto.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún producto.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:AyudaProductos()" >Ayuda productos</a></b>
					<!-- <img alt="Se devuelve al menú principal de mantenciones" border=0 src="../../imagenes/cerrar.gif"></a></b><br><br><br> -->
				</td> 
				<td align=center width=25% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
					<!-- <img alt="Se devuelve al menú principal de mantenciones" border=0 src="../../imagenes/cerrar.gif"></a></b><br><br><br> -->
				</td> 
			</tr>
		</table>
	</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

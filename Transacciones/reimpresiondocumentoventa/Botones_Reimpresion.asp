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

<%
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"
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

	function AyudaClientes()
	{
		var winURL		 = "../../Mantenciones/AyudaClientes/Window_FrameSet.asp";
		var winName		 = "Wnd_Clientes";
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
		var cChar = "'/\|,ç+-" + '"' ;
		var Numero		   = parent.top.frames[1][0].document.Formulario.Numero_NotaCredito.value;
		var TipoDocumento  = parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.options[parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.selectedIndex].value;
		var Cliente	= parent.top.frames[1][0].document.Formulario.Cliente.value;
//		var ClienteEmpresa = parent.top.frames[1][0].document.Formulario.Slct_Cliente.options[parent.top.frames[1][0].document.Formulario.Slct_Cliente.selectedIndex].value;
		var Bodega	   = parent.top.frames[1][0].document.Formulario.Slct_Bodega.options[parent.top.frames[1][0].document.Formulario.Slct_Bodega.selectedIndex].value;
		if ( ! validEmpty(Cliente) )
		{
			//var aClienteEmpresa = ClienteEmpresa.split("¬");
			parent.top.frames[1][0].document.Formulario.CodigoCliente.value = Cliente;//aClienteEmpresa[0];
			//parent.top.frames[1][0].document.Formulario.CodigoEmpresa.value = aClienteEmpresa[1];
		}
		else
		{
			parent.top.frames[1][0].document.Formulario.CodigoCliente.value = "";
			//parent.top.frames[1][0].document.Formulario.CodigoEmpresa.value = "";
		}
		
			if (! validaCharNoPermitidos(Cliente) )
			{
				if ( ! validEmpty(TipoDocumento) )
				{
					if (! validaCharNoPermitidos(Numero) )
					{
						parent.top.frames[1][0].document.Formulario.CodigoDocumento.value = TipoDocumento;
						parent.top.frames[1][0].document.Formulario.Bodega.value = Bodega;
						parent.top.frames[1][0].document.Formulario.target = "Listado";
						parent.top.frames[1][0].document.Formulario.submit();
					}
					else
					{
						Mensajes ( "El número de folio a buscar tiene carácteres no permitidos (" + cChar + ")." );
						parent.top.frames[1][0].document.Formulario.Numero_NotaCredito.focus();
					}
				}
				else
				{
					Mensajes ( "El tipo de documento a buscar no ha sido especificado ya que es un dato requerido." );
					parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.focus();
				}
			}
			else
			{
				Mensajes ( "El cliente a buscar tiene carácteres no permitidos (" + cChar + ")." );
				parent.top.frames[1][0].document.Formulario.Cliente.focus();
			}
	}

	function SlctTodo()
	{
		Mensajes ( "" );
		var TotalElementos = parent.top.frames[1][1].document.Listado.elements.length;
		var a = 0;
		for (a=0;a<TotalElementos;a++)
		{
			if (parent.top.frames[1][1].document.Listado.elements[a].type == 'checkbox' )
			{
				parent.top.frames[1][1].document.Listado.elements[a].checked = true;
			}
		}
	}

	function SlctAnula()
	{
		Mensajes ( "" );
		var TotalElementos = parent.top.frames[1][1].document.Listado.elements.length;
		var a = 0;
		for (a=0;a<TotalElementos;a++)
		{
			if (parent.top.frames[1][1].document.Listado.elements[a].type == 'checkbox' )
			{
				parent.top.frames[1][1].document.Listado.elements[a].checked = false;
			}
		}
	}

	function SlctInv()
	{
		Mensajes ( "" );
		var TotalElementos = parent.top.frames[1][1].document.Listado.elements.length;
		var a = 0;
		for (a=0;a<TotalElementos;a++)
		{
			if (parent.top.frames[1][1].document.Listado.elements[a].type == 'checkbox' )
			{
				if ( parent.top.frames[1][1].document.Listado.elements[a].checked == true)
				{
					parent.top.frames[1][1].document.Listado.elements[a].checked = false;
				}
				else
				{
					parent.top.frames[1][1].document.Listado.elements[a].checked = true;
				}				
			}
		}
	}

	function Imprimir()
	{
		Mensajes ( "" );
		var Error = "N";
		var TotalElementos = parent.top.frames[1][1].document.Listado.elements.length;
		var NroFacturaIni = parent.top.frames[1][1].document.Listado.NroFacturaIni.value;
		var a = 0;
		
		if ( ! validEmpty(NroFacturaIni) )
		{
			if ( ! validNum(NroFacturaIni) )
			{
				Mensajes ( "El número inicial de factura debe ser numérico, revise por favor." );
				Error = "S"
			}
		}
		
		if ( Error == "N" )
		{
			var cCadena  = "";
			for (a=0;a<TotalElementos;a++)
			{
				if (parent.top.frames[1][1].document.Listado.elements[a].type == 'checkbox' )
				{
					if ( parent.top.frames[1][1].document.Listado.elements[a].checked == true)
					{
						var Id = parent.top.frames[1][1].document.Listado.elements[a].name.replace('chkImprimir','')
						var NroFactura = eval("parent.top.frames[1][1].document.Listado.NroFAV_" + Id + ".value");
						var NroInt = eval("parent.top.frames[1][1].document.Listado.NroInt" + Id + ".value");
						if ( ! validNum(NroFactura) )
						{
							Error = "S";
							Mensajes ( "Debe ingresar un dato numérico como nº de factura en la línea " + (parseFloat(Id) + 1) );
							eval("parent.top.frames[1][1].document.Listado.NroFAV_" + Id + ".focus()");
							break;						
						}
						
						if ( validEmpty(NroFacturaIni) )
						{
							if ( parseFloat(NroFactura) == 0  )
							{
								Error = "S";
								Mensajes ( "El nº de factura en la línea " + (parseFloat(Id) + 1) + ", debe ser distinto a 0.");
								eval("parent.top.frames[1][1].document.Listado.NroFAV_" + Id + ".focus()");
								break;						
							}
						}
						
						cCadena = cCadena + NroInt + '|' + parent.top.frames[1][1].document.Listado.elements[a].value + "|" + NroFactura + "¬";
					}
				}
			}
		}
				
		if ( Error == "N" )
		{
			if ( cCadena == "" )
			{
				Mensajes ( "No hay documentos seleccionados para realizar la reimpresión." );
			}
			else
			{
				var documentos = cCadena.split('|'); 
				document.imprimir.Nroint.value = cCadena;
				if(parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.value == 'FAV')
				{
				  //alert(parent.top.frames[1][1].document.Listado.TDOC.value)
				  if (trim(parent.top.frames[1][1].document.Listado.TDOC.value) == 'FA') {
                      document.imprimir.action="Factura1.asp?Tipo_documento=FAV&tipo_documento_zf=FA";
                    }
				  else
				  {
				      document.imprimir.action = "Factura.asp?Tipo_documento=FAV";
                    }
				  
				}
				if(parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.value == 'FAE')
				{
				    document.imprimir.action = "Factura.asp?Tipo_documento=FAE";
				}
								
				if(parent.top.frames[1][0].document.Formulario.Slct_TipoDocumento.value == 'LEI')
				{
				    document.imprimir.action = "ImprimirLetras.asp";
				}
				document.imprimir.NroFacturaIni.value = NroFacturaIni;
				document.imprimir.target="Paso"
				document.imprimir.submit();
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
	function trim(string){
    return string.replace(/^\s*|\s*$/g, '');
  }
</script>

	<Form name="Formulario_Botones" method="post" action="Mant_Reimpresion.asp" target="Trabajo">
	<!-- Formulario que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="Numero_NotaCredito"  value="">
		<input type="hidden" name="Fecha_NotaCredito"   value="">
		<input type="hidden" name="Factura_NotaCredito" value="">
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Nuevo"		value="S">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteBotonesLink" width=100%>
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
				</td> 
		<%	if Request("HayRegistros") = "S" then%>
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Selecciona todos los registros del listado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Selecciona todos los registros del listado.")' Onfocus='<%=JavaScript%>MensajesStatus("Selecciona todos los registros del listado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:SlctTodo()">Selecciona todo</a></b>
				</td> 
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Anula la selección realizada en el listado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Anula la selección realizada en el listado.")' Onfocus='<%=JavaScript%>MensajesStatus("Anula la selección realizada en el listado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:SlctAnula()">Anula selección</a></b>
				</td> 
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Invierte la selección realizada en el listado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Invierte la selección realizada en el listado.")' Onfocus='<%=JavaScript%>MensajesStatus("Invierte la selección realizada en el listado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:SlctInv()">Invierte selección</a></b>
				</td> 
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Imprime los documentos que están seleccionados en el listado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Imprime los documentos que están seleccionados en el listado.")' Onfocus='<%=JavaScript%>MensajesStatus("Imprime los documentos que están seleccionados en el listado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Imprimir()">Imprimir</a></b>
				</td> 
		<%	end if%>
				<td align=center width=25% nowrap>
				<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún cliente.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún cliente.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite al usuario la búsqueda de algún cliente.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:AyudaClientes()" >Ayuda clientes</a></b>
					<!-- <img alt="Se devuelve al menú principal de mantenciones" border=0 src="../../imagenes/cerrar.gif"></a></b><br><br><br> -->
				</td> 
				<td align=center width=16% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>
	<form name="imprimir" method="post" action="../FacturaBus/Imprimir.asp" target="Mensajes">
		<input type=hidden name="Nroint" value="">
		<input type=hidden name="Reimpresion" value="S">
		<input type=hidden name="NroFacturaIni" value=0>		
	</form>
</body>
<%else
	Response.Redirect "../../index.htm"
end if%>
</html>

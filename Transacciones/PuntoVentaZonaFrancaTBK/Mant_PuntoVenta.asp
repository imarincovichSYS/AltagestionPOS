<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
	FilaInsertada =0
%>
<html>
	<head>
		<title><%=Session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
		<script src="../../Scripts/Js/Fechas.js"></script>
		<script src="../../Scripts/Js/Ventanas.js"></script>
	</head>
<script type="text/javascript"> 

	var blnDOM = false, blnIE4 = false, blnNN4 = false; 

	if (document.layers) blnNN4 = true;
	else if (document.all) blnIE4 = true;
	else if (document.getElementById) blnDOM = true;

	function getKeycode(e)
	{
		var TeclaPresionada = ""
		
		if (blnNN4)
		{
			var NN4key = e.which
			TeclaPresionada = NN4key;
		}
		if (blnDOM)
		{
			var blnkey = e.which
			TeclaPresionada = blnkey;
		}
		if (blnIE4)
		{
			var IE4key = event.keyCode
			TeclaPresionada = IE4key
		}

		if ( TeclaPresionada == 13 ) //Enter = Procesar y/o Confirmar
		{
			var Sw_Procesar = parent.top.frames[1].document.Frm_Mantencion.Sw_Procesar.value;
			if ( parseFloat(Sw_Procesar) == 0 )
			{
				parent.top.frames[2].Procesar(1)
			}
			else if ( parseFloat(Sw_Procesar) == 1 )
			{
				parent.top.frames[2].Procesar(2);
			}
		}
		else if ( TeclaPresionada == 121 ) //F10 o Fin
		{
			parent.top.frames[2].Continuar()
		}
		else if ( TeclaPresionada == 113 ) //Agregar Linea = F2
		{
			parent.top.frames[2].AgregarLineas()
		}
	}

	document.onkeydown = getKeycode
	if (blnNN4) document.captureEvents(Event.KEYDOWN)
</script> 

<%
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout = 3600

	cSql = "Exec DOC_ListaDocumentos 'FAV', Null"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		FolioFAV = Rs("Folio")
	else
		FolioFAV = 1
	end if
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec DOC_ListaDocumentos 'BOV', Null"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		FolioBOV = Rs("Folio")
	else
		FolioBOV = 1
	end if
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec HAB_Lista_Bodegas '" & Session("xBodega") & "', Null, Null, '" & Session("Empresa_usuario") & "'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		NombreBodega = Rs("Descripcion_breve")
	else
		NombreBodega = ""
	end if
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec CDV_ListaCentrosVentas '" & Session("xCentro_de_venta") & "', Null, '" & Session("Empresa_usuario") & "', Null"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		NombreCentroVenta = Rs("Nombre")
	else
		NombreCentroVenta = ""
	end if
	Rs.Close
	Set Rs = Nothing

	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	RegistroExistente	= "S"
	Nuevo				= Request("Nuevo")
	Control				= 0
	Imprimir			= "N"

	MontoTotal			= 0
	sfMontoTotal		= 0

	DoctoDespacho		= "FAV"

	Cliente				= "CLI_BOLETA"
	Error				= "N"
	Estado_OrdenVtaSUP	= "AUT"
	Moneda_OrdenVtaSUP	= "$"
%>
	
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<%	If Session("Browser") = 1 Then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	Else%>
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
<%	End If%>

<script language="JavaScript">
	function fValidaDoc( Documento, Valor )
	{
		if ( ! validEmpty( Valor ) )
		{
			parent.top.frames[1][0].location.href = "ValidaExiste_FAV_NCV.asp?DOC=" + Documento + "&NumeroDoc=" + Valor + "&Nuevo=<%=Nuevo%>&NumeroInt=<=Numero_Interno>";
		}
	}

	function fCambiaNroLinea( NroLinea )
	{
		document.Frm_Mantencion.NroLineaDetalle.value = NroLinea ;
		//document.Frm_Mantencion.Sw_Procesar.value = 0;
	}

	function fAsignaProducto( valor, id )
	{
		eval("document.Frm_Mantencion.txtProducto" + id + ".value = ''" ) ;
		if ( ! validEmpty( valor ) )
		{
			eval("document.Frm_Mantencion.txtProducto" + id + ".value = valor " ) ;
		}
	}

	function fValidNum( obj )
	{
		Mensajes ( '' );
		var valor = obj.value
		if ( ! validEmpty(valor) )
		{
			if ( ! validNum(valor) ) // Si Es número
			{
				Mensajes ( 'Debe ingresar solamente datos numéricos.' );
			}
		}
	}
	
</script>

	<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
		<tr class="FuenteEncabezados" height=20> 
			<td width=100% class="FuenteTitulosFunciones" align=center>&nbsp;&nbsp;&nbsp;&nbsp;<%=Session("title")%></td>
		</tr>
	</table>

	<Form name="Frm_Mantencion" method="post" action="Save_PuntoVenta.asp" target="Paso">
	<script language="JavaScript">
		function asignadescuento(obj)
		{
			document.Frm_Mantencion.maximo_porcentaje_descuento_autorizado.value=obj.descuento;
		}
	</script>
		<input type=hidden name="FolioFAV"		value = "<%=FolioFAV%>" >
		<input type=hidden name="FolioGDV"		value = "<%=FolioGDV%>" >
		<input type=hidden name="FolioBOV"		value = "<%=FolioBOV%>" >
		<input type=hidden name="FechaCalculo"	value = "" >

		<input type=hidden name="pagenum" 		value = "<%=Request("pagenum")%>">
		<input type=hidden name="Orden"			value = "<%=Orden%>">
		<input type=hidden name="Sw_Procesar"	value = "0">
		<input type=hidden name="Venta_documentada"	value = "<%=Venta_documentada%>">
		<input type=hidden name="Error"			value = "N">

		<input type=hidden name="CodigoEmpresa"				value = "<%=Empresa%>">
		<input type=hidden name="Numero_Interno"			value = "0<%=Numero_Interno%>">		
		<input type=hidden name="Total_Factura"				value = "0">
		<input type=hidden name="Fecha_ultima_impresion"	value = "<%=Fecha_ultima_impresion%>">
		
		<input type=hidden name="Control"				value = "<%=Control%>">		
		
		<input type=hidden name="Num_Int_Mov_Prod"	value = "">
		<input type=hidden name="Usuario_creacion"		value = "<%=Usuario_creacion%>">		
		<input type=hidden name="NroLineaDetalle"		value = "0">		
		<input type=hidden name="TotalLineasDetalle"	value = "0">
		<input type=hidden name="LineasAfectadas"		value = "">
		<input type=hidden name="TotalLineasPagos"		value = 0>

		<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteEncabezados">
				<td class="FuenteEncabezados" nowrap width=15% align=left><b>Centro de venta</td>
				<td class="FuenteEncabezados" nowrap width=10% align=left><b><%=NombreCentroVenta%></td>

				<td class="FuenteEncabezados" width=10% align=left><b>Bodega</td>
				<td class="FuenteEncabezados" width=10% align=left><b><%=NombreBodega%>
					<input type=hidden name="Numero_OrdenVtaSUP"	value="<%=Numero_OrdenVtaSUP%>">
					<input type=hidden name="Fecha_OrdenVtaSUP"		value="<%=Fecha_OrdenVtaSUP%>">
					<input type=hidden name="Estado_OrdenVtaSUP"	value="<%=Estado_OrdenVtaSUP%>">
					<input type=hidden name="CodigoMoneda"			value="<%=Moneda_OrdenVtaSUP%>">
					<input type=hidden name="Slct_Bodega"			value="<%=Session("xBodega")%>">
					<input type=hidden name="Centro_de_venta"		value="<%=Session("xCentro_de_venta")%>">
				</td>
			</tr>    

			<tr>
				<td class="FuenteEncabezados" width=15% align=left>
					<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Frm_Mantencion', '', 'Cliente', 'p');">Cliente</a>
				</td>
				<td nowrap class="FuenteInput" width=20% align=left>
					<input Class="FuenteInput" type=text name="Cliente" size=24 maxlength=12 value="<%=Ucase(Cliente)%>">
				</td>

				<td class="FuenteEncabezados" awidth=11% align=left>Responsable</td>
				<td acolspan=2 class="FuenteInput" awidth=20% align=left>
    				<%	maximo_porcentaje_descuento_autorizado = 0
    					cSql = "Exec ECP_ListaVendedores '" & Session("Empresa_Usuario") & "', '" & Session("Login") & "'"
    					Set Rs = Conn.Execute(cSql)%>
    					<select class="FuenteInput" name="Slct_Vendedor" style="width:150" onchange="javascript:asignadescuento(this)"  OnBlur="JavaScript:fCambiaNroLinea(0)">
    					<%	Do While Not Rs.EOF %>
    							<option <%If ucase(Trim(Session("Login"))) = Ucase(Trim(Rs("Entidad_comercial"))) Then Response.Write " Selected "%> descuento='<%=rs("maximo_porcentaje_descuento_autorizado")%>' value='<%=Rs("Entidad_comercial")%>'><%=Rs("Nombre")%>&nbsp;(<%=Rs("Entidad_comercial")%>)</option>
    						<%	Rs.MoveNext
    						Loop
    						Rs.close
    						set Rs = nothing
    					%>
    					</select>
					<input type=hidden name="maximo_porcentaje_descuento_autorizado" value="<%=maximo_porcentaje_descuento_autorizado%>">
					<input type=hidden name="CodigoVendedor" value="<%=CodigoVendedor%>">
				</td>

			</tr>    

			<tr class="FuenteEncabezados"> 
				<td width=15% class="FuenteEncabezados" align=left>Documento de venta&nbsp;&nbsp;</td>
				<td width=25% class="FuenteInput" align=left>
					<select class="FuenteInput" name="Slct_DocDescpacho" style="width:150" Onchange="Javascript:fCargaFolio(this.value)">
						<option selected value='BOV'>Boleta de venta&nbsp;</option>
						<option value='FAV'>Factura de venta&nbsp;</option>
					</select>
				</td>

				<td width=15% nowrap>Número a imprimir</td>
				<td width=25% nowrap>
					<input name="Numero_documento" value="" type=text size=24 maxlength=9 class="FunteInputNumerico" onKeyPress="javascript:validaMontos(this.value , this)" onKeyUp="javascript:validaMontos(this.value , this)" onblur="javascript:validaMontos(this.value , this)" ID="Text1">
				</td> 
			</tr>    
			
			<tr qclass="FuenteCabeceraTabla">
				<td colspan=2 width=15% nowrap>&nbsp;</td>
				
				<td nowrap class="FuenteEncabezados" align=left ><b>Total</b>&nbsp;</td>
				<td nowrap class="FuenteEncabezados" align=left >
					<input Class="DatoOutputNumerico"	type=text	name="nSpan_Total"  value="<%=MontoTotal%>" size=24 readonly>
					<input Class="FuenteInput"			type=hidden name="Total"		value="<%=sfMontoTotal%>">
				</td>
			</tr>

			<tr class="FuenteEncabezados">
				<td colspan=2 width=15% nowrap>&nbsp;</td>
				<td class="FuenteEncabezados" width=6% align=left><b>Vuelto</b>&nbsp;</td>
				<td width=18% Class="FuenteInput" align=left>
					<input Class="DatoOutputNumerico"	type=text	name="nSpan_Vuelto"  value="0" size=24 readonly>
				</td>
			</tr>

		</table>

		<Table Name="ListaDetalles" Id="ListaDetalles" width=95% align=center border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteCabeceraTabla"> 
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=2%  valign=bottom align=center><b>Lin</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=05% valign=bottom align=left  ><b>Producto</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=4%  valign=bottom align=center><b>Cantidad</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=80% valign=bottom align=left  ><b>Nombre producto</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=4%  valign=bottom align=center><b>Un</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=4%  valign=bottom align=center><b>Stock</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=5%  valign=bottom align=center><b>Precio</b></td>
				<td class="FuenteEncabezados" style="border: solid 1px silver" width=12% valign=bottom align=right ><b>Total</b></td>
			</tr>    
		</Table>
		
		<Table width=95% align=center border=0 cellspacing=0 cellpadding=0>
			
		</Table>
		
		<Table Name="ListaPagos" Id="ListaPagos" width=95% align=center border=1 cellspacing=0 cellpadding=0>
			<tr class="FuenteCabeceraTabla"> 
				<td class="FuenteEncabezados" colspan=4 valign=bottom align=center>Documentación del Pago</td>
			</tr>
		</Table>

	</Form>

	<IFRAME Id="Paso" name="Paso" FRAMEBORDER=0 SCROLLING=NO SRC="../../Empty.asp" HEIGHT=0 width=100%></IFRAME>
		<script language=vbscript>
			Sub fTotalDocumento()
				nLineas = cDbl("0" & parent.top.frames(1).document.all("ListaDetalles").rows.length-1 )
				dim nTotalLinea
				dim a
				nTotalLinea = 0
				a = 0
				for a=1 to cDbl(nLineas)
					Producto = parent.top.frames(1).document.all("txtProductoOutput" & a ).value
					if len(trim(Producto)) > 0 then
						nTotalLinea = parent.top.frames(1).document.all("txtTotalLinea" & a ).value 
						if len(trim(nTotalLinea)) = 0 then nTotalLinea = 0
						TotalNeto = TotalNeto + cDbl(nTotalLinea)
					end if
				next

				TotalDoc	= Round( TotalNeto + 0.01 ,0)			
				Iva			= TotalDoc - TotalNeto
				
				parent.top.frames(1).document.all("Total").value = TotalDoc
				parent.top.frames(1).document.all("nSpan_Total").value = FormatNumber(TotalDoc,0)

				FormasPagos = cDbl("0" & parent.top.frames(1).document.all("ListaPagos").rows.length-1 )
				FormasPagos = cDbl(FormasPagos) / 2
				if cDbl(FormasPagos) = 1 then					
					parent.top.frames(1).document.Frm_Mantencion.nMonto_a_pagar2.value = TotalDoc
					parent.top.frames(1).document.Frm_Mantencion.Monto_a_pagar2.value = TotalDoc
				end if
			End Sub
		</script>
		
		<script language="javascript">
			document.Frm_Mantencion.TotalLineasDetalle.value = <%=FilaInsertada%>

			function fTramos2(formulario, i)
			{	
				var CajaProducto = eval("parent.top.frames[1].document." + formulario + ".txtProductoOutput" + i + ".value");
				if ( ! validEmpty(CajaProducto) )
				{
					obj = eval("parent.top.frames[1].document." + formulario + ".txtDatos" +i + ".value");
					if ( ! validEmpty(obj) )
					{
						var ProductoDUN14 = eval("parent.top.frames[1].document." + formulario + ".txtProductoDUN14_" + i + ".value");
						var CantidadActual = eval("parent.top.frames[1].document." + formulario + ".txtCantBak_" + i + ".value");
						if ( ! validEmpty(ProductoDUN14) )
						{
							cantidad = parseFloat(eval("parent.top.frames[1].document." + formulario + ".txtCantidadDUN14_" + i + ".value"))
							obj = obj.replace(ProductoDUN14+"¬"+cantidad+"¬","¬¬")
						}
						else
						{
							cantidad = eval("parent.top.frames[1].document." + formulario + ".txtCantidad_" +i + ".value");
						}

						var CantidadDigitada = eval("parent.top.frames[1].document." + formulario + ".txtCantidad" +i + ".value");
					    
						if ( ! validEmpty(CantidadDigitada) )
						{
							if ( parseFloat(CantidadDigitada) != parseFloat(CantidadActual) )
							{
								var Factor = parseFloat(CantidadDigitada) * parseFloat(cantidad)
								eval("parent.top.frames[1].document." + formulario + ".txtCantBak_" + i + ".value = '" + CantidadDigitada + "'")
								arreglo	= obj.split("¬");
								for(j=4; j<=arreglo.length;j=j+2)
								{
									var Desde = arreglo[j]
									if ( parseFloat(j+2) >= arreglo.length ) 				
									{
										var Hasta = arreglo[j]
									}
									else
									{
										var Hasta = arreglo[j+2]
									}				
									
									if ( validEmpty(Desde) )
									{
										Desde = 0
									}
									if ( validEmpty(Hasta) )
									{
										Hasta = Factor+1
									}

									if( parseFloat(Factor) >= parseFloat(Desde) && parseFloat(Factor) < parseFloat(Hasta) )
									{
										var Precio = parseFloat(arreglo[j-1]) * parseFloat(cantidad) 
										var TotalLinea = ( parseFloat(arreglo[j-1]) * parseFloat(cantidad) ) * parseFloat(CantidadDigitada)
										if ( isNaN(Precio) ) 
										{
											Precio = "''";
											TotalLinea = "''";
										}

										eval("parent.top.frames[1].document." + formulario + ".txtPrecio" + i + ".value = " + Precio );
										eval("parent.top.frames[1].document." + formulario + ".Span_Total" + i + ".value =" + TotalLinea );
										eval("parent.top.frames[1].document." + formulario + ".txtTotalLinea" + i + ".value =" + TotalLinea );
										break;
									}
								} //for(j=4; j<=arreglo.length;j=j+2)
							} //if ( parseFloat(CantidadDigitada) != parseFloat(CantidadActual) )
						}
					}
				}
				else
				{
					eval("parent.top.frames[1].document." + formulario + ".txtPrecio" + i + ".value = ''" );
					eval("parent.top.frames[1].document." + formulario + ".Span_Total" + i + ".value = ''" );
					eval("parent.top.frames[1].document." + formulario + ".txtTotalLinea" + i + ".value = ''" );
				}
			}

			function fVuelto()
			{
				var TotalAPagar		= document.Frm_Mantencion.Total.value;
				var MontoConQuePaga = 0;
				var Vuelto = 0;
				var FormasPagos = parent.top.frames[1].document.all("ListaPagos").rows.length-1;
				for (c=1;c<=FormasPagos;c=c+2)
				{
					var cboDocumento	= eval("parent.top.frames[1].document.Frm_Mantencion.Documento"		+ c + ".value;");
					var ntxtMontoPagar	= eval("parent.top.frames[1].document.Frm_Mantencion.nMonto_a_pagar" + parseFloat(c+1) + ".value" );
							
					/*
					if ( cboDocumento != 'EFI' )
					{
						var Vuelto = 0;
						break;
					}
					else
					{
					*/	if ( validEmpty(ntxtMontoPagar) ) { ntxtMontoPagar = 0;}
						if ( ! validaNumDec(ntxtMontoPagar) ) { ntxtMontoPagar = 0;}
						
						MontoConQuePaga = MontoConQuePaga + ntxtMontoPagar;
						Vuelto = parseFloat(MontoConQuePaga) - parseFloat(TotalAPagar)
					//}
					
					//Cuando el pago es en efectivo y por ende tiene una sola linea de pago
					//se asigna el valor de la venta a la variable oculta.
					if ( FormasPagos == 2 && cboDocumento == "EFI" && parseFloat(ntxtMontoPagar) > 0 )
					{
						eval("parent.top.frames[1].document.Frm_Mantencion.Monto_a_pagar" + parseFloat(c+1) + ".value = TotalAPagar;" )
					}	
					else
					{
						eval("parent.top.frames[1].document.Frm_Mantencion.Monto_a_pagar" + parseFloat(c+1) + ".value = ntxtMontoPagar;" )
						Vuelto = 0;
					}
				}
				if ( parseFloat(Vuelto) < 0 )
				{
					Vuelto = 0 ;
				}
				document.Frm_Mantencion.nSpan_Vuelto.value = FormatNumberJS(Vuelto,0,true,false,true);
			}

			function ClipBoard_precio3( formulario, i)
			{
				ClipBoard_precio2( formulario, i)
				fTramos2(formulario, i)
				eval("parent.top.frames[1].document." + formulario + ".txtCantidad" + i + ".focus()");
			}

			function fCargaFolio( valor )
			{
				document.Frm_Mantencion.Numero_documento.value = "";
				if ( valor == 'FAV' )
				{
					document.Frm_Mantencion.Numero_documento.value = document.Frm_Mantencion.FolioFAV.value;
				}
				else if ( valor == 'BOV' )
				{
					document.Frm_Mantencion.Numero_documento.value = document.Frm_Mantencion.FolioBOV.value;
				}
			}

			//document.Frm_Mantencion.Slct_Vendedor.value = '<%=Session("login")%>';
			document.Frm_Mantencion.maximo_porcentaje_descuento_autorizado.value = 0;
			
			asignadescuento(document.Frm_Mantencion.Slct_Vendedor);
			fCargaFolio( document.Frm_Mantencion.Slct_DocDescpacho.value )
			parent.top.frames[2].location.href = 'BotonesMantencion_PuntoVenta.asp?Nuevo=<%=Nuevo%>&Orden=<%=Orden%>&pagenum=<%=Request("pagenum")%>&Estado=<%=Estado_OrdenVtaSUP%>&Numero_Interno=<%=Numero_Interno_Detalle%>&Imprimir=<%=Imprimir%>&Moneda=<%=Moneda_OrdenVtaSUP%>';
			
		</script>
   </body>
<%Conn.Close

else
	Response.Redirect "../../index.htm"
end if%>

<form name="Validacion" method="post">
	<input type=hidden name="FechaCalculo"		value="">
	<input type=hidden name="nOpc"				value="">
	<input type=hidden name="Bodega"			value="">
	<input type=hidden name="Productos"			value="">
	<input type=hidden name="SoloProductos"		value="">
	<input type=hidden name="IdLinProducto"		value="">
	<input type=hidden name="CodClie"			value="">
	<input type=hidden name="TotalOrdenDeVta"	value="">
	<input type=hidden name="Estado"			value="">
	<input type=hidden name="Error_desc"		value="">
	<input type=hidden name="CodigoMoneda"		value="">
	<input type=hidden name="DocumentoVta"		value="">
</form>
</html>

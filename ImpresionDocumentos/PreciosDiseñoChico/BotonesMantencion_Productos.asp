<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
	</head>

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

<script language="Vbscript">
	Function validaEan13(cCodigo)
		Dim cBase , nCont, nSum
		cBase = "13131313131313"
		cDigito = Mid(LTrim(RTrim(cCodigo)),len(Trim(cCodigo)),1)
		cCodigo = Right("00000000000000" + cCodigo, 14)
		cCodigo = Left(cCodigo,14)
		nSum = 0
		For nCont = 1 To Len(cCodigo)
		    nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
		Next
		nCont = cDbl("0" & Right(cStr(nSum), 1))
		If nCont > 0 Then nCont = 10 - nCont
		if cDbl(nCont) = cDbl(cDigito) then
			validaEan13 = True
		else
			validaEan13 = False
		end if
	End function

	Function DV_EAN13(cCodigo)
		Dim cBase , nCont, nSum
		cCodigo = cCodigo & Space(13)
		cDigito = Mid(LTrim(RTrim(cCodigo)),13,1)
		if len(trim(cDigito)) = 0 then cDigito = 0
		cCodigo = Left(LTrim(RTrim(cCodigo)),12)

		cBase = "131313131313"
		nSum = 0
		For nCont = 1 To Len(cCodigo)
			nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
		Next
		nCont = cDbl("0" & Right(cStr(nSum), 1))
		If nCont > 0 Then nCont = 10 - nCont
		if cDbl(cDigito) = cDbl(nCont) then
			DV_EAN13 = True
		else
			DV_EAN13 = False
		end if
	End Function

	Function validaDun14(cCodigo)
	    Dim cBase , nCont, nSum
	    cCodigo = cCodigo & Space(14)
	    cDigito = Mid(LTrim(RTrim(cCodigo)),14,1)
	    cCodigo = Left(LTrim(RTrim(cCodigo)),13)

	    If Len(cCodigo) <> 7 And Len(cCodigo) <> 13 Then 
			validaDun14 = false
			Exit Function
		end if
	    cBase = "3131313131313"
	    nSum = 0
	    For nCont = 1 To Len(cCodigo)
	        nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
	    Next
	    nCont = cDbl("0" & Right(cStr(nSum), 1))
	    If nCont > 0 Then nCont = 10 - nCont
	    if cDbl(nCont) = cDbl(cDigito) then
			validaDun14 = true
		else
			validaDun14 = false
		end if
	End function
</script>

<script language="JavaScript">
	function MensajesStatus( valor )
	{
		window.status = valor ;
	}

	function Nuevo()
	{
		parent.top.frames[1].document.Frm_Mantencion.SW_EAN13.value = 0;
		parent.top.frames[1].document.Frm_Mantencion.SW_DUN14.value = 0;

		var cChar = "'/\|,ç+-" + '"' ;
		Mensajes ("");
		var Error = "N";
		var Codigo_Pais = parent.top.frames[1].document.Frm_Mantencion.Codigo_pais.value ;
		var Nombre_Pais = parent.top.frames[1].document.Frm_Mantencion.Nombre_pais.value ;
		var Descripcion_detallada = parent.top.frames[1].document.Frm_Mantencion.Descripcion_detallada.value ;
		var TipoProducto = parent.top.frames[1].document.Frm_Mantencion.Tipo_Producto.value ;
		var Prod_FinaloInsumo = parent.top.frames[1].document.Frm_Mantencion.Producto_final_o_insumo.value ;
		var Monedas = parent.top.frames[1].document.Frm_Mantencion.Moneda_de_compra.value ;

		if ( ! validEmpty(Codigo_Pais) )
		{
			if ( ! validaCharNoPermitidos(Codigo_Pais) )
			{
				if ( ! validaCharNoPermitidos_Txt(Nombre_Pais) )
				{						
					if ( ! validEmpty(TipoProducto) )
					{
						if ( validEmpty(Prod_FinaloInsumo) ) 
						{
							Error = "S";
							MensajeError = "El producto final o insumo es un dato obligatorio." ;
							parent.top.frames[1].document.Frm_Mantencion.Slct_Prod_FinIns.focus();
						}
						else
						{
							if (  validaCharNoPermitidos_Txt(Descripcion_detallada) )
							{						
								Error = "S";
								MensajeError = "La descripcion detallada tiene carácteres no permitidos. Comillas simples o dobles" ;
								parent.top.frames[1].document.Frm_Mantencion.Descripcion_detallada.focus();
							}
							else
							{	
								if (Descripcion_detallada.length > 4096)
								{
									Error = "S";
									var dif = parseInt(4096) - parseInt(Descripcion_detallada.length);
									MensajeError = "La descripcion detallada no debe superara los 4.096 caracteres. Sobran " + dif ;
									parent.top.frames[1].document.Frm_Mantencion.Descripcion_detallada.focus();
								}
							}
								
							
						}
					}
					else
					{
						Error = "S";
						MensajeError = "El tipo de producto es un dato obligatorio." ;
						parent.top.frames[1].document.Frm_Mantencion.Slct_TipoProd.focus();
					}
				}
				else
				{
					Error = "S";
					MensajeError = "El nombre del producto tiene caractéres no permitidos. Comillas simples o dobles." ;
					parent.top.frames[1].document.Frm_Mantencion.Nombre_pais.focus();
				}
			}
			else
			{
				Error = "S";
				MensajeError = "El código del producto tiene carácteres no permitidos (" + cChar + ")." ;
				parent.top.frames[1].document.Frm_Mantencion.Codigo_pais.focus();
			}
		}
		else
		{
			Error = "S" ;
			MensajeError = "El código es un dato obligatorio." ;
			parent.top.frames[1].document.Frm_Mantencion.Codigo_pais.focus();
		}

		if ( Error == "N")
		{
			var SuperFamilia	= parent.top.frames[1].document.Frm_Mantencion.Slct_SuperFam.value ;
			var Familia			= parent.top.frames[1].document.Frm_Mantencion.Slct_Familia.value ;
			var SubFamilia		= parent.top.frames[1].document.Frm_Mantencion.Slct_SubFamilia.value ;
			
			if ( ! validEmpty(SuperFamilia) )
			{
				if ( ! validEmpty(Familia) )
				{
					if ( validEmpty(SubFamilia) )
					{
						Error = "S";
						MensajeError = "La Sub Familia es un dato obligatorio." ;
						parent.top.frames[1].document.Frm_Mantencion.Slct_SubFamilia.focus() ;
					}
				}
				else
				{
					Error = "S";
					MensajeError = "La familia  es un dato obligatorio." ;
					parent.top.frames[1].document.Frm_Mantencion.Slct_Familia.focus() ;
				}
			}
			else
			{
				Error = "S";
				MensajeError = "El Rubro  es un dato obligatorio." ;
				parent.top.frames[1].document.Frm_Mantencion.Slct_SuperFam.focus() ;
			}
		}

		if ( Error == "N")
		{
			var Marca = parent.top.frames[1].document.Frm_Mantencion.Marca.value ;
			if ( validEmpty(Marca) )
			{
				Error = "S";
				MensajeError = "La marca es un dato obligatorio." ;
				parent.top.frames[1].document.Frm_Mantencion.Slct_Marca.focus() ;
			}
		}

		if ( Error == "N")
		{
			var Moneda			= parent.top.frames[1].document.Frm_Mantencion.Moneda_de_compra.value ;
			var Estado			= parent.top.frames[1].document.Frm_Mantencion.Slct_Estado.options[parent.top.frames[1].document.Frm_Mantencion.Slct_Estado.selectedIndex].value;
			var TipoServicio	= parent.top.frames[1].document.Frm_Mantencion.Tipo_servicio.value ;
			if ( ! validEmpty(Moneda) )
			{
				if ( validEmpty(Estado) )
				{
					Error = "S";
					MensajeError = "El estado es un dato obligatorio." ;
					parent.top.frames[1].document.Frm_Mantencion.Slct_Estado.focus() ;
				}
			}
			else
			{
				Error = "S";
				MensajeError = "La moneda de compra es un dato obligatorio." ;
				parent.top.frames[1].document.Frm_Mantencion.Slct_Moneda.focus() ;
			}
		}
		

		if ( Error == "N")
		{
			if ( validEmpty(parent.top.frames[1].document.Frm_Mantencion.Vendible.value) )
			{
				Error = "S";
				MensajeError = "Debe especificar si el producto es vendible o no lo es, ya que es requerido." ;
				parent.top.frames[1].document.Frm_Mantencion.Vendible.focus();
			}
		}

		var Cantidad_um_consumo_que_hay_en_una_um_compra= parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_consumo_que_hay_en_una_um_compra.value;
		var Cantidad_um_compra_en_envase_compra			= parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_compra_en_envase_compra.value;
		var Cantidad_um_compra_en_caja_envase_compra	= parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_compra_en_caja_envase_compra.value;
		var Codigo_EAN13								= parent.top.frames[1].document.Frm_Mantencion.Codigo_EAN13.value;
		var Unidad_de_medida_venta_peso_en_kgs			= parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_venta_peso_en_kgs.value;
		var Unidad_de_medida_venta_volumen_en_m3		= parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_venta_volumen_en_m3.value;
		var Costo_de_reposicion_unitario				= parent.top.frames[1].document.Frm_Mantencion.Costo_de_reposicion_unitario.value;
		var Codigo_DUN14								= parent.top.frames[1].document.Frm_Mantencion.Codigo_DUN14.value;
		var Unidades_DUN14								= parent.top.frames[1].document.Frm_Mantencion.Unidades_DUN14.value;
		var Unidad_de_medida_envase_compra				= parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_envase_compra.value;
		var Porcentaje_impuesto_1				        = parent.top.frames[1].document.Frm_Mantencion.Porcentaje_impuesto_1.value;

		if ( Error == "N" )
		{
			if ( validEmpty(Unidad_de_medida_envase_compra) )
			{
				Error = "S";
				MensajeError = "La U/M Case debe ser seleccionada, revise por favor." ;
				parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_envase_compra.focus();
			}
		}
		
		if ( parseFloat(Cantidad_um_consumo_que_hay_en_una_um_compra) <= 0 ) { Cantidad_um_consumo_que_hay_en_una_um_compra = '';}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Cantidad_um_consumo_que_hay_en_una_um_compra) )
			{
				if ( ! validaNumDec(Cantidad_um_consumo_que_hay_en_una_um_compra) )
				{
					Error = "S";
					MensajeError = "La cantidad compra en envase esta mal ingresada, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_consumo_que_hay_en_una_um_compra.focus();
				}
			}
			else
			{
				Error = "S";
				MensajeError = "La unidad de venta en una unidad de compra debe ser ingresada y mayor que 0, revise por favor." ;
				parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_consumo_que_hay_en_una_um_compra.focus();
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Cantidad_um_compra_en_envase_compra) )
			{
				if ( ! validNum(Cantidad_um_compra_en_envase_compra) )
				{
					Error = "S";
					MensajeError = "La cantidad compra en envase esta mal ingresada, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_compra_en_envase_compra.focus();
				}
			}
			else
			{
				Error = "S";
				MensajeError = "La cantidad compra en envase debe ser ingresada, revise por favor." ;
				parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_compra_en_envase_compra.focus();
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Cantidad_um_compra_en_caja_envase_compra) )
			{
				if ( ! validNum(Cantidad_um_compra_en_caja_envase_compra) )
				{
					Error = "S";
					MensajeError = "La cantidad compra en caja envase esta mal ingresada, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Cantidad_um_compra_en_caja_envase_compra.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Codigo_EAN13) )
			{
				if ( ! validaCaractesPassWord(Codigo_EAN13, parent.top.frames[1].document.Frm_Mantencion.Codigo_EAN13) )
				{
					Error = "S";
					MensajeError = "El código EAN13 esta mal ingresado, revise por favor." ;
				}
				else
				{
					//if ( parent.top.frames[1].document.Frm_Mantencion.SW_EAN13.value == 0 )					
						if ( DV_EAN13(Codigo_EAN13) == false )
						{
							parent.top.frames[1].document.Frm_Mantencion.SW_EAN13.value = 1;
						}
					//}
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Unidad_de_medida_venta_peso_en_kgs) )
			{
				if ( ! validaNumDec(Unidad_de_medida_venta_peso_en_kgs) )
				{
					Error = "S";
					MensajeError = "La unidad medida venta peso en grs. esta mal ingresada, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_venta_peso_en_kgs.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Unidad_de_medida_venta_volumen_en_m3) )
			{
				if ( ! validaNumDec(Unidad_de_medida_venta_volumen_en_m3) )
				{
					Error = "S";
					MensajeError = "La unidad medida venta volumen en cc. esta mal ingresada, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Unidad_de_medida_venta_volumen_en_m3.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Costo_de_reposicion_unitario) )
			{
				if ( ! validaNumDec(Costo_de_reposicion_unitario) )
				{
					Error = "S";
					MensajeError = "El costo promedio ponderado está mal ingresado, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Costo_de_reposicion_unitario.focus();
				}
			}
		}


		if ( Error == "N" )
		{
			if ( ! validEmpty(Codigo_DUN14) )
			{
				if ( ! validaCaractesPassWord(Codigo_DUN14, parent.top.frames[1].document.Frm_Mantencion.Codigo_DUN14) )
				{
					Error = "S";
					MensajeError = "El código DUN14 esta mal ingresado, revise por favor." ;
				}
				else
				{
					if ( validaDun14(Codigo_DUN14) == false)
					{
						parent.top.frames[1].document.Frm_Mantencion.SW_DUN14.value = 1;
					}
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Porcentaje_impuesto_1) )
			{
				if ( ! validaNumDec(Porcentaje_impuesto_1) )
				{
					Error = "S";
					MensajeError = "El % Ila debe ser numérico, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Porcentaje_impuesto_1.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Unidades_DUN14) )
			{
				if ( ! validaNumDec(Unidades_DUN14) )
				{
					Error = "S";
					MensajeError = "Las unidades del DUN14 estan mal ingresadas, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Unidades_DUN14.focus();
				}
			}
		}

		if ( Error == "N" )
		{
			if ( ! validEmpty(Codigo_DUN14) )
			{
				if ( validEmpty(Unidades_DUN14) ) { Unidades_DUN14 = 0;} 
				if ( parseFloat(Unidades_DUN14) <= 0)
				{
					Error = "S";
					MensajeError = "Las unidades del DUN14 deben ser mayor que cero, revise por favor." ;
					parent.top.frames[1].document.Frm_Mantencion.Unidades_DUN14.focus();
				}
			}
		}
		

		if ( Error == "N")
		{
			var msgCorto = ''

			if ( parent.top.frames[1].document.Frm_Mantencion.SW_EAN13.value == 1 ){
				msgCorto = 'EAN13'
			}
			if ( parent.top.frames[1].document.Frm_Mantencion.SW_DUN14.value == 1 ){
				if ( validEmpty(msgCorto) )
				{
					msgCorto = 'DUN14'
				}
				else
				{
					msgCorto = msgCorto + ' y el DUN14'
				}
			}
			if ( ! validEmpty(msgCorto) )
			{
				var Rsp = confirm('El ' + msgCorto + ', está(n) mal ingresado(s) ¿ Continua ?')
			}
			else
			{
				var Rsp = true
			}			
			
			if ( Rsp )
			{
				parent.top.frames[1].document.Frm_Mantencion.action = "Save_Productos.asp" ; 
				parent.top.frames[1].document.Frm_Mantencion.target = "Paso" ;
				parent.top.frames[1].document.Frm_Mantencion.submit();
			}
		}	
		else
		{
			Mensajes ( MensajeError );
		}
	}
	
	function Cerrar()
	{
		Mensajes ("");
		parent.top.frames[1].location.href = "Inicial_Productos.asp";
		parent.top.frames[2].location.href = "Botones_Productos.asp";		
	}	
	
</script>


<Form name="Formulario_Botones" method="post" action="Mant_Productos.asp" target="Listado">
	<input type="hidden" name="Nombre_pais" value="">
	<input type="hidden" name="Codigo_pais" value="">
	<input type="hidden" name="pagenum"		value="">
	<input type="hidden" name="Orden"		value="1">
	<input type="hidden" name="Nuevo"		value="S">
	
	<table width=100% border=0 cellspacing=0 cellpadding=0>
		<tr class="FuenteBotonesLink" width=100%>
<!--
	El Request("SinRegistros") Si es "S" entonces significa que trae registros por lo tanto
	Desplegará los botones correspondientes al proceso invocado. Si es Nuevo o va Actualizar
	Este efecto es para cuando se ha eliminado un registro por un lado y van a eliminar el mismo
	registro por otro lado con una lista antigua de pantalla.
-->
<%if Request("SinRegistros") <> "S" then%>
	<%if Request("Nuevo") = "S" then %>
		<td align=center width=25% nowrap>
			<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Grabar el nuevo producto que se está ingresando.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Grabar el nuevo producto que se está ingresando.")' Onfocus='<%=JavaScript%>MensajesStatus("Grabar el nuevo producto que se está ingresando.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Nuevo()" >Agregar</a></b>
		</td> 
	<%else%>
		<td align=center width=25% nowrap>
			<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Actualiza el producto que se está editando.")' OnMouseMove='<%=JavaScript%>MensajesStatus("Actualiza el producto que se está editando.")' Onfocus='<%=JavaScript%>MensajesStatus("Actualiza el producto que se está editando.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Nuevo()" >Actualizar</a></b>
		</td> 
	<%end if%>
<%end if%>
		<td align=center width=25% nowrap>
			<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal de <%=Session("title")%>, cancelando los cambios realizados en esta edición.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal de <%=Session("title")%>, cancelando los cambios realizados en esta edición.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal de <%=Session("title")%>, cancelando los cambios realizados en esta edición.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cancelar</a></b>
		</td> 
	</tr>
</table>
</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
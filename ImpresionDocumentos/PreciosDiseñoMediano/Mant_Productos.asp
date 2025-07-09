<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") ))> 0 then
	if Session("Browser") = 1 then
		largocampo = 50
	else
		largocampo = 40
	end if
	Codigo_pais	= Request ( "Codigo_pais" )
	Nombre_pais	= Request ( "Nombre_pais" )
	Orden		= Request ( "Orden" )

	RegistroExistente = "S"
	Nuevo		= Request("Nuevo")
	Control		= 0

	Valor = Request("Valor")

    ' Si Nuevo = S significa que es nuevo si es igual a N significa que existe y hay que
    ' buscarlo
    SET Conn = Server.CreateObject("ADODB.Connection")
    Conn.Open Session("Dataconn_ConnectionString")
    Conn.commandtimeout=600
    
    Empresa = Session("Empresa_usuario")
     
    cSuperfamilia = ""
    cSql = "Exec SPF_ListaSuperfamilias Null, Null, 1"
    Set RsSF = Conn.Execute ( cSql )
    Do While Not RsSF.Eof
        cSuperfamilia = cSuperfamilia & "<option value='" & Ucase(TRim(RsSF("Superfamilia"))) & "' value='" & Ucase(TRim(RsSF("Superfamilia"))) & "'>" & RsSF("Nombre") & " (" & Ucase(TRim(RsSF("Superfamilia"))) & ")</option>"
        RsSF.MoveNext
    Loop
    RsSF.Close
'response.write("Mant_Productos" & Request("Empresa_usuario"))
	if Nuevo = "N" then
		Sql = "Exec PRO_ListaProductos '"	& Request("Codigo_pais") & "', " +_
										"'"	& Request("Nombre_pais") & "', " +_
										"0" & Orden & ", '" & Session("Empresa_usuario") & "', Null, Null, Null" 
'Response.Write Sql
		SET RsUpdate	=	Conn.Execute( SQL )
		If Not RsUpdate.eof then
			Codigo_pais										= RsUpdate ( "Producto" )
			Nombre_pais										= RsUpdate ( "Nombre" )
			Empresa											= RsUpdate ( "Empresa" )     
			Tipo_producto									= RsUpdate ( "Tipo_producto" )  
			Producto_final_o_insumo							= RsUpdate ( "Producto_final_o_insumo" )
			Descripcion_detallada							= RsUpdate ( "Descripcion_detallada" )     
			Stock_minimo									= RsUpdate ( "Stock_minimo" )     
			Stock_maximo									= RsUpdate ( "Stock_maximo" )  
			Costo_de_reposicion_unitario					= RsUpdate ( "Costo_de_reposicion_unitario" )
			Procedencia_producto							= RsUpdate ( "Procedencia_producto")

			SuperFamilia									= Ucase(Trim(RsUpdate ( "SuperFamilia" )))
			Familia											= RsUpdate ( "Familia" )
			SubFamilia										= RsUpdate ( "SubFamilia" )

			Marca											= RsUpdate ( "Marca" )        

			Unidad_de_medida_consumo						= Trim(Ucase(RsUpdate ( "Unidad_de_medida_consumo" )))      
			Unidad_de_medida_compra							= Trim(Ucase(RsUpdate ( "Unidad_de_medida_compra" )))
			Cantidad_um_consumo_que_hay_en_una_um_compra	= RsUpdate ( "Cantidad_um_consumo_que_hay_en_una_um_compra" )

			Proveedor										= RsUpdate ( "Proveedor" )
			Producto_proveedor_habitual						= RsUpdate ( "Producto_proveedor_habitual" )     
			Nombre_producto_proveedor_habitual				= RsUpdate ( "Nombre_producto_proveedor_habitual" )  
			Precio_lista_proveedor_habitual					= RsUpdate ( "Precio_lista_proveedor_habitual" )
			Porcentaje_descuento_1_de_compra				= RsUpdate ( "Porcentaje_descuento_1_de_compra" )        
			Porcentaje_descuento_2_de_compra				= RsUpdate ( "Porcentaje_descuento_2_de_compra" )      
			Porcentaje_descuento_3_de_compra				= RsUpdate ( "Porcentaje_descuento_3_de_compra" )     
			Porcentaje_impuesto_1							= RsUpdate ( "Porcentaje_impuesto_1" )  
			Porcentaje_impuesto_2							= RsUpdate ( "Porcentaje_impuesto_2" )
			Porcentaje_impuesto_3							= RsUpdate ( "Porcentaje_impuesto_3" )     
			Porcentaje_impuesto_4							= RsUpdate ( "Porcentaje_impuesto_4" )  
			Porcentaje_impuesto_5							= RsUpdate ( "Porcentaje_impuesto_5" )
			Porcentaje_impuesto_6							= RsUpdate ( "Porcentaje_impuesto_6" )

			Moneda_de_compra								= RsUpdate ( "Moneda_de_compra" )  
			Tipo_servicio									= RsUpdate ( "Tipo_servicio" )
			Estado											= RsUpdate ( "Estado" )
			IvaObligatorio									= RsUpdate ( "IVA_obligatorio" )
			Vendible										= RsUpdate ( "Vendible" )
			Control											= RsUpdate ( "Control" )
			
			Cantidad_um_compra_en_envase_compra				= RsUpdate ( "Cantidad_um_compra_en_envase_compra" )
			Cantidad_um_compra_en_caja_envase_compra		= RsUpdate ( "Cantidad_um_compra_en_caja_envase_compra" )
			Codigo_EAN13									= RsUpdate ( "Codigo_EAN13" )
			if IsNull(Codigo_EAN13) Then Codigo_EAN13 = ""
			Unidad_de_medida_cajas_envase_compra			= Trim(Ucase(RsUpdate ( "Unidad_de_medida_cajas_envase_compra" )))
			Unidad_de_medida_envase_compra					= Trim(Ucase(RsUpdate ( "Unidad_de_medida_envase_compra" )))
			Unidad_de_medida_venta_peso_en_kgs				= Trim(Ucase(RsUpdate ( "Unidad_de_medida_venta_peso_en_grs" )))
			Unidad_de_medida_venta_volumen_en_m3			= Trim(Ucase(RsUpdate ( "Unidad_de_medida_venta_volumen_en_m3" )))
			
			Codigo_DUN14 = RsUpdate("Codigo_DUN14")
			if IsNull(Codigo_DUN14) Then Codigo_DUN14 = ""
			Unidades_DUN14 = Trim(Ucase(RsUpdate("Unidades_DUN14")))
			
			Ultimo_nombre_producto_proveedor	= RsUpdate("Ultimo_nombre_producto_proveedor")
			Ultimo_proveedor					= RsUpdate("Ultimo_proveedor")
			Ultima_procedencia					= RsUpdate("Pais_procedencia")
			Ultima_factura_de_compra			= RsUpdate("Ultima_factura_de_compra")
			Tipo_Ultima_factura_de_compra		= RsUpdate("Tipo_Ultima_factura_de_compra")
			Ultimo_CIF_ORI						= RsUpdate("Ultimo_CIF_ORI")
			Ultimo_CIF_ADU						= RsUpdate("Ultimo_CIF_ADU")
			Descripcion_para_boleta				= RsUpdate("Descripcion_para_boleta")
			Ultimo_CPA							= RsUpdate("Ultimo_CPA")
			Temporada							= RsUpdate("Temporada")
			Producto_es_vehiculo				= RsUpdate("Producto_es_vehiculo")
			Tasa_impuesto_aduanero				= RsUpdate("Tasa_impuesto_aduanero")
			if isnull(Tasa_impuesto_aduanero) then Tasa_impuesto_aduanero = 0 

            Imagen = RsUpdate("Vista_max_exterior")
			AfectoExento = RsUpdate("Afecto_o_Exento")
		  
		  '?? no descomentar o error
      'esta_certificado = RsUpdate("esta_certificado")
      
      
                  cFamilia = ""
            cSql = "Exec FAM_ListaFamilias Null, '" & SuperFamilia & "', Null, 1"
            Set RsFAM = Conn.Execute ( cSql )
            Do While Not RsFAM.Eof
                cFamilia = cFamilia & "<option value='" & Trim(Ucase(RsFAM("Familia"))) & "'>" & UCase(Trim(RsFAM("Nombre"))) & " (" & TRim(Ucase(RsFAM("Familia"))) & ")</option>"
                RsFAM.MoveNext
            Loop
            RsFAM.Close

            cSubFamilia = ""
            cSql = "Exec SBF_ListaSubfamilias Null, '" & Familia & "', '" & SuperFamilia & "', Null, 1"
            Set RsSFAM = Conn.Execute ( cSql )
            Do While Not RsSFAM.Eof
                cSubFamilia = cSubFamilia & "<option value='" & Ucase(TRim(RsSFAM("Subfamilia"))) & "' value='" & Ucase(TRim(RsSFAM("Subfamilia"))) & "'>" & Ucase(TRim(RsSFAM("Nombre"))) & " (" & Ucase(TRim(RsSFAM("Subfamilia"))) & ")</option>"
                RsSFAM.MoveNext
            Loop
            RsSFAM.Close

		else
			RegistroExistente		= "N"
		end if
			RsUpdate.Close
	else
		ProxCodProd = 1
		if valor = 2 then 
			ProxCodProd = 10
		end if
		cSql = "Exec PRO_Nuevo_Codigo_Producto 'S', 0" & ProxCodProd
		SET RsUpdate	=	Conn.Execute( cSql )
			Codigo_pais = RsUpdate ( "Codigo" )
		RsUpdate.Close
	end if

	if len(Trim(Codigo_EAN13)) = 0 then
		'Por defecto es UPCA que tiene 12 posiciones
		If IsNumeric(Codigo_Pais) Then
			Codigo_EAN13 = "612962" & Right("000000" & Cdbl(Codigo_Pais),6) 
			Codigo_EAN13 = cDbl(Codigo_EAN13 & DV_EAN13(Codigo_EAN13))
		end if		
	end if
	if len(Trim(Codigo_DUN14)) = 0 then
		if Nuevo = "N" then
			if IsNumeric(Codigo_EAN13) then
				Codigo_DUN14 = "1" & Right("000000000000" & Mid(Codigo_EAN13,1,len(Codigo_EAN13)-1),12)
				Codigo_DUN14 = Codigo_DUN14 & validaDun14(Cdbl(Codigo_DUN14))
			end if
		else
			If IsNumeric(Codigo_Pais) Then
				Codigo_DUN14 = "1612962" & Right("000000" & Cdbl(Codigo_Pais),6) 
				Codigo_DUN14 = Codigo_DUN14 & validaDun14(Cdbl(Codigo_DUN14))
			end if
		end if
	end if

%>

<html>
	<head>
		<title><%=Session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Ajax.js"></script>
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
	</head>
<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 
    function fAsigna()
    {
		document.Frm_Mantencion.Moneda_de_compra.value  			= document.Frm_Mantencion.Slct_Moneda.options[document.Frm_Mantencion.Slct_Moneda.selectedIndex].value ;
		document.Frm_Mantencion.Tipo_Producto.value					= document.Frm_Mantencion.Slct_TipoProd.options[document.Frm_Mantencion.Slct_TipoProd.selectedIndex].value ;
		document.Frm_Mantencion.Producto_final_o_insumo.value		= document.Frm_Mantencion.Slct_Prod_FinIns.options[document.Frm_Mantencion.Slct_Prod_FinIns.selectedIndex].value ;
		document.Frm_Mantencion.Moneda_de_compra.value				= document.Frm_Mantencion.Slct_Moneda.options[document.Frm_Mantencion.Slct_Moneda.selectedIndex].value ;
		document.Frm_Mantencion.Marca.value							= document.Frm_Mantencion.Slct_Marca.options[document.Frm_Mantencion.Slct_Marca.selectedIndex].value ;
		document.Frm_Mantencion.Tipo_servicio.value					= document.Frm_Mantencion.Slct_TipoServicio.options[document.Frm_Mantencion.Slct_TipoServicio.selectedIndex].value ;
    }
</script>

<%If RegistroExistente = "S" Then %>
		
	<table width=100% align=center border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td class="FuenteTitulosFunciones" align=center>&nbsp;&nbsp;&nbsp;&nbsp;<%=Session("title")%></td>
		</tr>
	</table>

<Form name="Frm_Mantencion" method="post" action="Mant_pais.asp?accion=N" target="Seleccion">

<%	If Nuevo = "N" Then %>
		<table width=50% align=center border=0 cellspacing=0 cellpadding=0>
			<tr>
				<td class="FuenteInput" align=center><a class=FuenteBotonesLink href="javascript:_Page('A')"><-Anterior-</a></td>
				<td class="FuenteInput" align=center>Orden
					<select class=FuenteInput name="OrdenadoPor">
						<option <%If Request("OrdenadoPor") = "C" Then Response.Write " selected "%> value="C">Código propio</option>
						<option <%If Request("OrdenadoPor") = "A" Then Response.Write " selected " Else If Request("OrdenadoPor") <> "C" Then Response.Write " selected " %> value="A">Catálogo</option>
						<option <%If Request("OrdenadoPor") = "D" Then Response.Write " selected "%> value="D">Descripción</option>
						<option <%If Request("OrdenadoPor") = "B" Then Response.Write " selected "%> value="B">Código de barra</option>
					</select>
				</td>
				<td class="FuenteInput" align=center><a class=FuenteBotonesLink href="javascript:_Page('S')">-Siguiente-></a></td>
			</tr>
		</table>
<%	End If %>

		<input type=hidden name="pagenum" 		value = "<%=Request("pagenum")%>">
		<input type=hidden name="proveedor"			value = "<%=proveedor%>">
		<input type=hidden name="Orden"			value = "<%=Orden%>">
		
		<input type=hidden name="SW_EAN13" value="0">
		<input type=hidden name="SW_DUN14" value="0">
		
		<table align=center width=98% border=0 cellspacing=1 cellpadding=0>
			<tr class="fuenteinput">
	  			<td class="FuenteEncabezados" align=left><b>Código</b>
					<input type=hidden name="Control" value="<%=Control%>">
					<input type=hidden name="Empresa" value="<%=Empresa%>">
					<input type=hidden name="Tipo_servicio" value='<%=Tipo_servicio%>'>
				</td>
				<%	If Nuevo = "N" Then 
						if IsNull(Codigo_pais) Then %>
							<td class="fuenteinput" width=33% align=left nowrap>
								<input Class="FuenteInput" size=20 maxlength=20 type=Text name="Codigo_pais"  value="" >
							</td>				
					<%	Else%>
							<td Class="FuenteInput" align=left><b><%=Codigo_pais%></b>
								<input type=hidden name="Codigo_pais"  value="<%=Codigo_pais%>">
							</td>
				<%		End If
					else %>
						<td Class="FuenteInput" align=left>
							<input Class="FuenteInput" size=20 maxlength=20 type=Text name="Codigo_pais"  value="" >
						</td>
				<%	End If%>
			</tr>

			<tr class="fuenteinput">
				<td class="FuenteEncabezados" align=left>Nombre</td>
				<td colspan=3 align=left>
					<input Class="FuenteInput" type=Text name="Nombre_pais" size=80 maxlength=50 value="<%=Nombre_pais%>" qonblur="javascript:validaCaractesPassWord(this.value , this)">
				</td>
				<td class="FuenteEncabezados" nowrap align=left>Vendible</td>
				<td class="fuenteinput" nowrap align=left>
					<select class="fuenteinput" name="Vendible" style="width:50" ID="Select2">
						<option value=""></option>
						<option <%If Vendible = "S" Then Response.Write " Selected "%> value="S">Si</option>
						<option <%If Vendible = "N" Then Response.Write " Selected "%> value="N">No</option>
					</select>
				</td>
			</tr>
			<tr class="fuenteinput"> 
				<td class="FuenteEncabezados" align=left>Tipo</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Slct_TipoProd" style="width:150" OnChange="JavaScript:fAsigna()">
						<option value=""></option>
						<option <% If Ucase(Trim(Tipo_Producto)) = "P" Then Response.Write " selected "%> value="P">Inventariable&nbsp;(P)</option>
					</select>
					<input type=hidden name="Tipo_Producto" value="<%=Tipo_Producto%>">
				</td>

				<td class="FuenteEncabezados" align=left>Final/Insumo</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Slct_Prod_FinIns" style="width:150" Onchange="JavaScript:fAsigna()">
						<option value=""></option>
						<option <% If Ucase(Producto_final_o_insumo) = "I" Then Response.Write " selected "%> value="I">Insumo&nbsp;(I)</option>
						<option <% If Ucase(Producto_final_o_insumo) = "F" Then Response.Write " selected "%> value="F">Producto final&nbsp;(F)</option>
					</select>
					<input type=hidden name="Producto_final_o_insumo" value="<%=Producto_final_o_insumo%>">
				</td>

				<td class="FuenteEncabezados" align=left>Estado</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Slct_Estado" style="width:150" OnChange="JavaScript:fAsigna()">
						<option value=""></option>
						<option <%If Estado = "A" Then Response.Write " Selected "%> value="A">Activo&nbsp;(A)</option>
						<option <%If Estado = "S" Then Response.Write " Selected "%> value="S">Stand by&nbsp;(S)</option>
						<option <%If Estado = "F" Then Response.Write " Selected "%> value="F">Fuera de uso&nbsp;(F)</option>
					</select>
				</td>
	   		</tr>

			<tr class="fuenteinput">
				<td class="FuenteEncabezados" align=left nowrap>Rubro</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Slct_SuperFam" style="width:150" onchange="JavaScript:fCargaFamilia(this.value);"> 
						<option value=""></option>
					<%	Response.Write Replace(cSuperFamilia, " value='" & SuperFamilia & "'>", " selected value='" & SuperFamilia & "'>") %>
					</select>
				</td>
				<td class="FuenteEncabezados" align=left>Familia</td>
				<td align=left>
    				<span id="spanFamilia">
    					<select class="fuenteinput" name="Slct_Familia" style="width:150" Onchange="JavaScript:fCargaSubFamilia(document.Frm_Mantencion.Slct_SuperFam.value, this.value);">
    						<option value=""></option>
					<%	Response.Write Replace(cFamilia, " value='" & Familia & "'>", " selected value='" & Familia & "'>") %>
					   </select>
    				</span>
				</td>
				<td class="FuenteEncabezados" align=left>Sub Familia</td>
				<td align=left>
				    <span id="spanSubFamilia">
    					<select class="fuenteinput" name="Slct_SubFamilia" style="width:150" onchange="JavaScript:fAsigna()">
    						<option value=""></option>
					<%	Response.Write Replace(cSubFamilia, " value='" & SubFamilia & "'>", " selected value='" & SubFamilia & "'>") %>
    					</select>
    				</span>
				</td>
	   		</tr>

			<tr class="fuenteinput">
				<td class="FuenteEncabezados" align=left>Marca</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Slct_Marca" style="width:150" onchange="JavaScript:fAsigna()">
						<option value=""></option>
					<%	cSql = "Exec MAR_ListaMarcas Null, Null, 2"
						Set RsMarcas = Conn.Execute ( cSql )
						Do While Not RsMarcas.Eof%>
							<option <%If  Marca = RsMarcas("Marca") Then Response.Write " selected "%> value='<%=RsMarcas("Marca")%>'><%=RsMarcas("Nombre")%>&nbsp;(<%=RsMarcas("Marca")%>)</option>
					<%		RsMarcas.MoveNext
						Loop
						RsMarcas.Close%>
					</select>
					<input type=hidden name="Marca" value='<%=Marca%>'>
				</td>
				<td class="FuenteEncabezados" align=left>Cód.Catálogo</td>
				<td align=left>
					<input Class="FuenteInput" type=Text name="Nombre_producto_proveedor_habitual" size="20" maxlength=50 value="<%=Nombre_producto_proveedor_habitual%>" qonblur="javascript:validaCaractesPassWord(this.value , this)">
				</td>
				<td  nowrap class="FuenteEncabezados" align=left>Procedencia</td>
				<td align=left>
					<select class="fuenteinput" name="Procedencia_producto" style="width:150" OnChange="JavaScript:fAsigna()">
						<option <%If Procedencia_producto = "N" Then Response.Write " Selected "%> value="N">Nacional</option>
						<option <%If Procedencia_producto = "I" Then Response.Write " Selected "%> value="I">Importado</option>
					</select>
				</td>
				</td>
	   		</tr>
			<tr class="fuenteinput">
				<td nowrap class="FuenteEncabezados" align=left>Costo Prom. Pond.</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Costo_de_reposicion_unitario" size="8" maxlength=8 value="<%=Costo_de_reposicion_unitario%>">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Moneda compra</td>
				<td align=left>
					<select class="fuenteinput" name="Slct_Moneda" style="width:150" OnChange="JavaScript:fAsigna()">
						<option value=""></option>
					<%	cSql = "Exec MON_ListaMonedas Null, Null, 2"
						Set RsMonedas = Conn.Execute ( cSql )
						Do While Not RsMonedas.Eof%>
							<option <%If Moneda_de_compra = RsMonedas("Moneda") Then Response.Write " selected " %> value='<%=RsMonedas("Moneda")%>'><%=RsMonedas("Nombre")%>&nbsp;(<%=RsMonedas("Moneda")%>)</option>
					<%		RsMonedas.MoveNext
						Loop
						RsMonedas.Close%>
					</select>
					<input type=hidden name="Moneda_de_compra" value='<%=Moneda_de_compra%>'>
				</td>
				<td class="FuenteEncabezados" align=left nowrap>Tipo servicio</td>
				<td align=left>
					<select class="fuenteinput" name="Slct_TipoServicio" style="width:150" OnChange="JavaScript:fAsigna()">
						<option value=""></option>
					<%	cSql = "Exec TSV_ListaTiposServicios Null, Null, 2"
						Set RsTipoServicio = Conn.Execute ( cSql )
						Do While Not RsTipoServicio.Eof%>
							<option <%If Tipo_servicio = RsTipoServicio("tipo_de_servicio") Then Response.Write " selected " %> value='<%=RsTipoServicio("tipo_de_servicio")%>'><%=RsTipoServicio("Nombre")%>&nbsp;(<%=RsTipoServicio("tipo_de_servicio")%>)</option>
					<%		RsTipoServicio.MoveNext
						Loop
						RsTipoServicio.Close%>
					</select>
	   		</tr>


			<tr class="fuenteinput">
				<td nowrap class="FuenteEncabezados" align=left>U/M venta</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Unidad_de_medida_consumo" style="width:130">
						<option value=""></option>
					<%	cSql = "Exec UNI_ListaUnidadesMedida Null, Null, 2"
						Set Rs = Conn.Execute ( cSql )
						Do While Not Rs.Eof%>
							<option <%If Unidad_de_medida_consumo = Trim(Ucase(Rs("Unidad"))) Then Response.Write " selected " %> value='<%=Rs("Unidad")%>'><%=Rs("Unidad")%>&nbsp;(<%=Rs("Unidad")%>)</option>
					<%		Rs.MoveNext
						Loop
						Rs.Close%>
					</select>
				</td>
				
				<td nowrap class="FuenteEncabezados" align=left>U/M compra</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Unidad_de_medida_compra" style="width:130">
						<option value=""></option>
					<%	cSql = "Exec UNI_ListaUnidadesMedida Null, Null, 2"
						Set Rs = Conn.Execute ( cSql )
						Do While Not Rs.Eof%>
							<option <%If Unidad_de_medida_compra = Trim(Ucase(Rs("Unidad"))) Then Response.Write " selected " %> value='<%=Rs("Unidad")%>'><%=Rs("Unidad")%>&nbsp;(<%=Rs("Unidad")%>)</option>
					<%		Rs.MoveNext
						Loop
						Rs.Close%>
					</select>
				</td>
<%if Nuevo="N" then%>
				<td nowrap class="FuenteEncabezados" align=left>Afecto o Exento</td>
				<td class="DatoOutput" align=left style="width:150">
  				<%if AfectoExento = "A" then response.write "Afecto" else response.write "Exento"%>
				</td>
<%end if%>
			</tr>
			<tr>
				<td nowrap colspan=3 class="FuenteEncabezados" align=left>Unidades de venta en una unidad de compra</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Cantidad_um_consumo_que_hay_en_una_um_compra" size="5" maxlength=5 value="<%=Cantidad_um_consumo_que_hay_en_una_um_compra%>">
				</td>
				
				<td nowrap class="FuenteEncabezados" align=left>Imagen</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Imagen" size="40" maxlength="100" value="<%=Imagen%>">
				
				</td>
								
			</tr>
								
			<tr>
				<td nowrap class="FuenteEncabezados" align=left>U/M case</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Unidad_de_medida_envase_compra" style="width:130" ID="Select5">
						<option value=""></option>
					<%	cSql = "Exec UNI_ListaUnidadesMedida Null, Null, 2"
						Set Rs = Conn.Execute ( cSql )
						Do While Not Rs.Eof%>
							<option <%If Unidad_de_medida_envase_compra = Trim(Ucase(Rs("Unidad"))) Then Response.Write " selected " %> value='<%=Rs("Unidad")%>'><%=Rs("Unidad")%>&nbsp;(<%=Rs("Unidad")%>)</option>
					<%		Rs.MoveNext
						Loop
						Rs.Close%>
					</select>					
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Unids. en case</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Cantidad_um_compra_en_envase_compra" size="5" maxlength=5 value="<%=Cantidad_um_compra_en_envase_compra%>">
				</td>
				
			

			</tr>
			<tr class="fuenteinput">
				<td nowrap class="FuenteEncabezados" align=left>U/M master case</td>
				<td class="fuenteinput" align=left>
					<select class="fuenteinput" name="Unidad_de_medida_cajas_envase_compra" style="width:130" ID="Select4">
						<option value=""></option>
					<%	cSql = "Exec UNI_ListaUnidadesMedida Null, Null, 2"
						Set Rs = Conn.Execute ( cSql )
						Do While Not Rs.Eof%>
							<option <%If Unidad_de_medida_cajas_envase_compra = Trim(Ucase(Rs("Unidad"))) Then Response.Write " selected " %> value='<%=Rs("Unidad")%>'><%=Rs("Unidad")%>&nbsp;(<%=Rs("Unidad")%>)</option>
					<%		Rs.MoveNext
						Loop
						Rs.Close%>
					</select>
					
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Unids. en master case</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Cantidad_um_compra_en_caja_envase_compra" size="5" maxlength=5 value="<%=Cantidad_um_compra_en_caja_envase_compra%>">
				</td>
				
		
			</tr>

			<tr class="fuenteinput">			
				<td nowrap class="FuenteEncabezados" align=left>Peso unitario en grs.</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Unidad_de_medida_venta_peso_en_kgs" size="7" maxlength=7 value="<%=Unidad_de_medida_venta_peso_en_kgs%>">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Volumen unitario en m3</td>
				<td class="fuenteinput" align=left>
					<input Class="FuenteInput" type=Text name="Unidad_de_medida_venta_volumen_en_m3" size="15" maxlength=20 value="<%=Unidad_de_medida_venta_volumen_en_m3%>">
				</td>
				
				<!-- cbutendieck 2009-08-21 -->
				<td nowrap class="FuenteEncabezados" align=left>Está Certificado</td>
				<td class="fuenteinput" align=left>
					<Select class="fuenteinput" name="esta_certificado" >
					   <option <% if esta_certificado = "N" Then Response.Write " selected " %> value='N'>No</option>
					   <option <% if esta_certificado = "S" Then Response.Write " selected " %> value='S'>Si</option>					   
                    </select>
				</td>
				<!-- cbutendieck 2009-08-21 -->
				
			</tr>

			<tr class="fuenteinput">			
				<td nowrap class="FuenteEncabezados" align=left>Código EAN13</td>
				<td class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Codigo_EAN13" value='<%=Codigo_EAN13%>' size="15" maxlength="13" OnChange="Javascript:fLimpiaSw(1);_UpdDun14(this.value)">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Código DUN14</td>
				<td class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Codigo_DUN14" value='<%=Codigo_DUN14%>' size="15" maxlength="20" Onchange="Javscript:fLimpiaSw(2)">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Unidades</td>
				<td class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Unidades_DUN14" value='<%=Unidades_DUN14%>' size="10" maxlength="9">
				</td>
			</tr>

			<tr class="FuenteInput">			
				<td nowrap class="FuenteEncabezados" align=left>Ultimo nom.prod.prov.</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultimo_nombre_producto_proveedor" value='<%=Ultimo_nombre_producto_proveedor%>' size="15" maxlength="13">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Ultimo proveedor</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultimo_proveedor" value='<%=Ultimo_proveedor%>' size="15" maxlength="20">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Ultima procedencia</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultima_procedencia" value='<%=Pais_procedencia%>' size="10" maxlength="9">
				</td>
			</tr>

            <tr class="FuenteInput">			
				<td nowrap class="FuenteEncabezados" align=left>Ultima factura compra</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultima_factura_de_compra" value='<%=Ultima_factura_de_compra%>' size="15" maxlength="13">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Tipo</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Tipo_Ultima_factura_de_compra" value='<%=Tipo_Ultima_factura_de_compra%>' size="15" maxlength="20">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Ultimo CIF ORI</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultimo_CIF_ORI" value='<%=Ultimo_CIF_ORI%>' size="10" maxlength="9">
				</td>
			</tr>
			
			<tr class="FuenteInput">			
				<td nowrap class="FuenteEncabezados" align=left>Ultimo CIF ADU</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultimo_CIF_ADU" value='<%=Ultimo_CIF_ADU%>' size="15" maxlength="13">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Ultimo CPA</td>
				<td class="fuenteinput" align=left>
					<input class="DatoOutput" readonly type=text name="Ultimo_CPA" value='<%=Ultimo_CPA%>' size="15" maxlength="20">
				</td>
				<td nowrap class="FuenteEncabezados" align=left>Es vehículo</td>
				<td class="fuenteinput" align=left>
					<Select class="fuenteinput" name="Producto_es_vehiculo" >
					   <option <% if Producto_es_vehiculo = "N" Then Response.Write " selected " %> value='N'>No</option>
					   <option <% if Producto_es_vehiculo = "S" Then Response.Write " selected " %> value='S'>Si</option>					   
                    </select>
				</td>
			</tr>


            <tr class="FuenteInput">			
				<td nowrap class="FuenteEncabezados" align=left>Temporada</td>
				<td class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Temporada" value='<%=Temporada%>' size="15" maxlength="12">
				</td>

				<td nowrap class="FuenteEncabezados" align=left>% Ila</td>
				<td class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Porcentaje_impuesto_1" value='<%=Porcentaje_impuesto_1%>' size="10" maxlength="6">
				</td>

				<td nowrap class="FuenteEncabezados" align=left>Descripción boleta</td>
				<td colspan=1 class="fuenteinput" align=left>
					<input class="fuenteinput" type=text name="Descripcion_para_boleta" value='<%=Descripcion_para_boleta%>' size="35" maxlength="35">
				</td>
			</tr>

			
			<tr class="fuenteinput">			
				<td class="FuenteEncabezados" align=left nowrap valign=top>Descripción detallada</td>
				<td class="FuenteEncabezados" colspan=3 align=left nowrap valign=top>
					<textarea class="fuenteinput" rows=2 cols=90 name = "Descripcion_detallada" value="<%=Descripcion_detallada%>"><%=Descripcion_detallada%></textarea>
			</tr>		
					
				</td>	
			<td class="FuenteEncabezados" align=left nowrap qvalign=top></td>				
				<td nowrap class="FuenteEncabezados" align=left>
					<input class="fuenteinput" type=hidden name="TasaImpuesto" value='<%=Tasa_impuesto_aduanero%>' size="10" maxlength="6">
				</td>
	   		</tr>

		</table>
	</Form>

	<script language="VbScript">
		Function validaDun14(cCodigo)
		    Dim cBase , nCont, nSum
		    cCodigo = cCodigo & Space(14)
		    cDigito = Mid(LTrim(RTrim(cCodigo)),14,1)
		    cCodigo = Left(LTrim(RTrim(cCodigo)),13)

		    cBase = "3131313131313"
		    nSum = 0
		    For nCont = 1 To Len(cCodigo)
		        nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
		    Next
		    nCont = cDbl("0" & Right(cStr(nSum), 1))
		    If nCont > 0 Then nCont = 10 - nCont

		    validaDun14 = cDbl(nCont)
		End function
	
	</script>

	<script language="Javascript">
        function stateChangedFamilia() 
        { 
            if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
            {
                document.all('spanFamilia').innerHTML = xmlHttp.responseText;
            } 
        }  

	    function fCargaFamilia( valor )
	    {
            if ( ! validEmpty(valor) )
            {
                var Vacio = "<Select class='FuenteInput' name='Slct_Familia' style='width:150' Onchange='JavaScript:fCargaSubFamilia( document.Frm_Mantencion.Slct_SuperFam.value, this.value );'>"
                    Vacio = Vacio + "<option value=''></option>"
                    Vacio = Vacio + "</select>"
                document.all('spanFamilia').innerHTML = Vacio;
                
                var Vacio = "<Select class='FuenteInput' name='Slct_SubFamilia' style='width:150' Onchange='JavaScript:Asigna();'>"
                    Vacio = Vacio + "<option value=''></option>"
                    Vacio = Vacio + "</select>"
                document.all('spanSubFamilia').innerHTML = Vacio;

                xmlHttp=GetXmlHttpObject()
                if (xmlHttp==null)
                {
                    alert ("Browser does not support HTTP Request")
                    return
                } 
                var url = "../../Ayudas/Ajax/Familias.asp?Superfamilia=" + valor;
                url = url + "&sid=" + Math.random()
                xmlHttp.onreadystatechange = stateChangedFamilia
                xmlHttp.open("GET",url,true)
                xmlHttp.send(null)
            }
        }

        function stateChangedSubFamilia() 
        { 
            if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
            {
                document.all('spanSubFamilia').innerHTML = xmlHttp.responseText;
            } 
        }  

	    function fCargaSubFamilia( SuperFamilia, Familia )
	    {
            if ( ! validEmpty(SuperFamilia) )
            {
                xmlHttp=GetXmlHttpObject()
                if (xmlHttp==null)
                {
                    alert ("Browser does not support HTTP Request")
                    return
                } 
                var url = "../../Ayudas/Ajax/SubFamilias.asp?Superfamilia=" + escape(SuperFamilia) + "&Familia=" + escape(Familia);
                url = url + "&sid=" + Math.random()
                xmlHttp.onreadystatechange = stateChangedSubFamilia
                xmlHttp.open("GET",url,true)
                xmlHttp.send(null)
            }
        }

		function fLimpiaSw( valor )
		{
			if ( valor == 1 )
			{
				parent.top.frames[1].document.Frm_Mantencion.SW_EAN13.value = 0;
			}
			else
			{
				parent.top.frames[1].document.Frm_Mantencion.SW_DUN14.value = 0;
			}
		}
		
		function _UpdDun14( valor )
		{
			if ( ! validEmpty(valor) )
			{
				if ( validNum(valor) )
				{
					var CodigoDun14 = '1' + Right("000000000000" + Left(valor,valor.length-1) ,12)
						CodigoDun14 = CodigoDun14 + validaDun14(CodigoDun14)
					document.Frm_Mantencion.Codigo_DUN14.value = CodigoDun14
				}
			}
		}
	
	</script>

	<Form class="fuenteinput" name="grabar" method="post" action="Save_Productos.asp" target="Trabajo">
		<input type=hidden name="pagenum" 		value = "<%=Request("pagenum")%>">
		<input type=hidden name="Orden"			value = "<%=Orden%>">
		<input type=hidden name="Codigo_pais"	value = "<%=Codigo_pais%>">
		<input type=hidden name="Control"		value = "<%=Control%>">
		<input type=Hidden name="Nombre_pais"	value = "<%=Nombre_pais%>">
	</form>
	
	<iframe Id=Paso name=Paso src="../../empty.asp" width=0 height=0></iframe>

	<script language="javascript">
		function _Page( valor )
		{	
			var Producto = document.Frm_Mantencion.Codigo_pais.value;			
			var Orden	 = document.Frm_Mantencion.OrdenadoPor.value;
			parent.top.frames[1][0].location.href = "Consulta_Productos.asp?Producto=" + Producto + "&Modo=" + valor + "&Orden=" + Orden
		}
	</script>
	<%	If Nuevo = "N" Then %>
			<script language="javascript">
				//Carga_Familia(document.Frm_Mantencion.Slct_SuperFam.value);
				//Carga_SubFamilia(document.Frm_Mantencion.Slct_Familia.value);
				fAsigna();
			</script>
	<%	End If%>
<%	Else%>
		<script language="javascript">
		   parent.top.frames[2].location.href = "BotonesMantencion_Productos.asp?SinRegistros=S"		   
		</script>
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr>
				<td class="FuenteTitulosFunciones" align=center>
					<b>No se encontró información sobre este producto.</b>
				</td>
				<td align=center>
					<br><br><br><br><br><br>
				</td>
			</tr>
		</table>	
<%	End If%>
		<script language="javascript">
		   parent.Mensajes.location.href = "../../Mensajes.asp"		   
		</script>
   </body>
</html>
<%Conn.Close
else
	Response.Redirect "../../index.htm"
end if%>

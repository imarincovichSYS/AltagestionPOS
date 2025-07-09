<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache
	On Error Resume Next
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	msgerror=""
	Error = "N"
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600
	Conn.BeginTrans

	Numero_documento	= Request("Numero_documento")
	CodDov			= Session("Tipo_documento_venta") 'Request("Slct_DocDescpacho")
	NroDOV			= Numero_documento

	if len(trim(Numero_documento)) = 0 then
		Sql="exec DOC_NuevoFolio '" & CodDov & "'"
		set rs=Conn.Execute(sql)
			Numero_documento = Rs("Folio")
		rs.close
		set rs=nothing
	else
		if CodDov = "BOV" then
			if Request("FolioBOV") = NroDOV then
				Sql="exec DOC_NuevoFolio '" & CodDov & "'"
				set rs=Conn.Execute(sql)
					Numero_documento = Rs("Folio")
				rs.close
				set rs=nothing
			end if
		elseif CodDov = "FAV" then
			if Request("FolioFAV") = NroDOV then
				Sql="exec DOC_NuevoFolio '" & CodDov & "'"
				set rs=Conn.Execute(sql)
					Numero_documento = Rs("Folio")
				rs.close
				set rs=nothing
			end if
		end if		
	end if

	Numero_Interno	= Request("Numero_Interno")

	Sql = "Exec DOC_NuevoFolio 'DVT'"
	SET RsNuevoFolio = Conn.Execute( SQL )
	If Not RsNuevoFolio.eof then
		Numero_documento_no_valorizado = RsNuevoFolio("Folio")
	End if
	RsNuevoFolio.close
	
	Fecha_OrdenVtaSUP = Now()
	if len(trim(Fecha_OrdenVtaSUP)) = 0 then
		Fecha_OrdenVtaSUP = "Null"
	else
		Fecha_OrdenVtaSUP = "'" & Year(Fecha_OrdenVtaSUP) & "/" & Month(Fecha_OrdenVtaSUP) & "/" & Day(Fecha_OrdenVtaSUP) & " " & time() & "'"
	end if
	Fecha_ultima_impresion = Request("Fecha_ultima_impresion")
	if len(trim(Fecha_ultima_impresion)) = 0 then
		Fecha_ultima_impresion = "Null"
	else
		Fecha_ultima_impresion = "'" & Year(Fecha_ultima_impresion) & "/" & Month(Fecha_ultima_impresion) & "/" & Day(Fecha_ultima_impresion) & " " & Hour(Fecha_ultima_impresion) & ":" & Minute(Fecha_ultima_impresion) & ":" & Second(Fecha_ultima_impresion) & "'"
	end if
	Numero_cotizacion					= Request("Cotizacion_OrdenVtaSUP")
	if len(trim(Numero_cotizacion)) = 0 then
		Numero_cotizacion = "''"
	end if

	Fecha_despacho_solicitada	= Request("Fecha_Despacho")
	if len(trim(Fecha_despacho_solicitada)) = 0 then
		Fecha_despacho_solicitada = "Null"
	else
		Fecha_despacho_solicitada = "'" & Year(Fecha_despacho_solicitada) & "/" & Month(Fecha_despacho_solicitada) & "/" & Day(Fecha_despacho_solicitada) & " " & Hour(Fecha_despacho_solicitada) & ":" & Minute(Fecha_despacho_solicitada) & ":" & Second(Fecha_despacho_solicitada) & "'"
	end if
	
	
	Fecha_movimiento					= "'" & Year(date) & "/" & Month(date) & "/" & Day(date) & " " & time() & "'"
	Documento_ingresado_o_egresado		= "CEG"
	Documento_respaldo					= "OVT"
	Numero_documento_respaldo			= 1
	
	Monto_total_moneda_oficial			= Replace(Request("Total"),",",".")
	Monto_iva_moneda_oficial			= 0
	
	if IsNumeric(Monto_total_moneda_oficial) then
		Monto_iva_moneda_oficial    = Monto_total_moneda_oficial - Round( Monto_total_moneda_oficial / ( 1 + (cDbl(Session("PCTGEIVA")) / 100) ) + 0.01, 0)
		Monto_afecto_moneda_oficial = Monto_total_moneda_oficial  - Monto_iva_moneda_oficial 
	else
		Monto_total_moneda_oficial = 0
	end if
	
	Clasificacion_cliente_o_proveedor	= Request("Clasificacion_cliente_o_proveedor")
	Estado_documento_no_valorizado		= Request("Estado_OrdenVtaSUP")
	Documento_no_valorizado				= "DVT"
	Num_Int_Mov_Prod					= Request("Num_Int_Mov_Prod")
	CodigoVendedor						= Request("CodigoVendedor")
	Tipo_Producto						= "O"
	Moneda_Documento					= Request("CodigoMoneda")
	
	if len(trim(Request("Sucursal"))) = 0 then 
		Sucursal = "Null" 
	Else 
		aSuc = Split(Request("Sucursal"),"¬")
		Sucursal = "'" & aSuc(0) & "'"
	End if

	if len(trim(Request("Tipo_cotizacion"))) = 0 then Tipo_cotizacion = "'O'" Else Tipo_cotizacion = "'" & Request("Tipo_cotizacion") & "'"

	Condicion = Request("Condicion")
	if len(trim(Condicion)) > 0 then 
		aCondicion = Split(Condicion,"¬")
		Condicion = "'" & aCondicion(0) & "'"
	Else 
		Condicion = "Null"
	end if
	
	if len(trim(Request("FormaEnvio"))) = 0 then FormaEnvio = "Null" Else FormaEnvio = "'" & Request("FormaEnvio") & "'"

'Se descuenta 1 porque tambien toma la cabecera de la tabla
	TotalLineasDetalle = Request("TotalLineasDetalle")-1 
'Grabacion de Cabecera del documento Cotización de compra

if Error = "N" then
	cSql_C = "Exec DNV_GrabaDespachoVenta_POS 0"
	cSql_C = cSql_C & Numero_Interno							& ", "
	cSql_C = cSql_C & "'" & Session("Empresa_Usuario")			& "', "
	cSql_C = cSql_C & "0" & Numero_documento_no_valorizado		& ", "
	cSql_C = cSql_C & "'"	& Request("Cliente")				& "', "
	cSql_C = cSql_C & "'"	& CodigoVendedor					& "', "
	cSql_C = cSql_C & "'"	& Session("Login")					& "', "
	cSql_C = cSql_C & Fecha_OrdenVtaSUP							& ", "
	cSql_C = cSql_C & Fecha_ultima_impresion					& ", "
	cSql_C = cSql_C & "'"	& Request("Flete_por_cuenta_de")	& "', "
	cSql_C = cSql_C & "'"	& Request("FormaPago")				& "', 0, "
	cSql_C = cSql_C & Fecha_despacho_solicitada					& ", "
	cSql_C = cSql_C & "'"	& Documento_ingresado_o_egresado	& "', "
	cSql_C = cSql_C & "'"	& Request("DoctoDespacho")			& "', "
	cSql_C = cSql_C & "'" & Tipo_Producto						& "', "
	cSql_C = cSql_C & "'" & Moneda_Documento					& "', "
	cSql_C = cSql_C & Numero_documento_respaldo					& ", 0"
	cSql_C = cSql_C & Monto_afecto_moneda_oficial				& ", 0"
	cSql_C = cSql_C & Monto_iva_moneda_oficial					& ", "
	cSql_C = cSql_C & "'"	& Estado_documento_no_valorizado	& "', "
	cSql_C = cSql_C & "'"	& Trim(Request("Observaciones"))	& "', "
	cSql_C = cSql_C & "'"	& Clasificacion_cliente_o_proveedor	& "', "
	cSql_C = cSql_C & "'"	& Request("Usuario_creacion")		& "', "
	cSql_C = cSql_C & "'"	& Session("Login")					& "', 0"
	cSql_C = cSql_C & Request("Control")						& ", '"
	cSql_C = cSql_C & Session("xBodega")						& "', "
	cSql_C = cSql_C & "'"	& Session("xCentro_de_venta")	& "', null, null, "
	cSql_C = cSql_C & Tipo_cotizacion & ", 1, Null, 'N', " & Sucursal & ", "
	cSql_C = cSql_C & Condicion & ", " & FormaEnvio
'Response.Write cSQL_C & "<br>"	
	Set Rs_C = Conn.Execute( cSql_C )
	if len(trim(Err.Description)) = 0 then
		if Numero_Interno = 0 then
			Numero_int_doc_no_val = Rs_C("Documento")				
		else
			Numero_int_doc_no_val = Numero_Interno
		end if
	else
		Error = "S"
		MsgError = LimpiaError(Err.Description)
	end if
	Rs_C.Close
	
	if Error = "N" Then
		cSql_Borrar = "Exec MOP_BorraMovimientoProductoxdocumentoNoValorizado_SinLinea 'DVT', " & Numero_documento_no_valorizado 
		Conn.Execute( cSql_Borrar )
		if len(trim(Err.Description)) > 0 then
			Error = "S"
			MsgError = LimpiaError(Err.Description)
		end if
	end if
	
	if Error = "N" Then
		For a=1 to TotalLineasDetalle
			if Len(trim(Request("txtProducto"&a))) > 0 then	
				CodigoDUN14 = Request("txtProductoDUN14_" & a)
				CantidadDUN14 = Request("txtCantidadDUN14_" & a)
				if IsNull(CodigoDUN14) Then CodigoDUN14 = ""
				if len(trim(CodigoDUN14)) = 0 Then CodigoDUN14 = "Null" Else CodigoDUN14 = "'" & CodigoDUN14 & "'"
			
				if CodigoDUN14 = "Null" then
					Cantidades	= cDbl(Request("txtCantidad"&a))
					Precio		= cDbl(Request("ntxtPrecio"&a))
					PrecioModificado = cDbl(Request("txtPrecio"&a))
				else
					Cantidades = cDbl(Request("txtCantidad"&a)) * cDbl(CantidadDUN14)
					Precio		= cDbl(Request("ntxtPrecio"&a)) / cDbl(CantidadDUN14)
					PrecioModificado = cDbl(Request("txtPrecio"&a)) / cDbl(CantidadDUN14)
				end if
				if len(trim(Precio)) = 0 Or cDbl("0" & Precio) = 0 then
					Precio  = PrecioModificado
				end if				
				
				if Session("ValoresConIva") = "S" then
					'Precio  = Round( Precio / ( 1 + (cDbl(Session("PCTGEIVA")) / 100) ) + 0.01, 0)
					Precio  = Round( Precio / ( 1 + (cDbl(Session("PCTGEIVA")) / 100) ), 2)
					PrecioModificado = Precio
				end if


				cSql_D = "Exec MOP_Ajusta_Inventario_para_Despacho " & _
						"'" & Session("Empresa_Usuario")			& "', "	& _
						"'" & Session("xBodega")					& "', " & _
						"'"	& Request("txtProducto"&a)				& "', " & _
							Cantidades								& ", "	& _
						"0" & Numero_documento_no_valorizado		& ", "	& _
						"'" & Session("Login")						& "'"
				Conn.Execute( cSQL_D )			
				if len(trim(Err.Description)) > 0 then
					Error = "S"
					MsgError = LimpiaError(Err.Description)
					exit for
				end if


				cSql_D = "Exec MOP_GrabaMovimientoProducto Null, "      & _
						Numero_int_doc_no_val					& ", "	& _
					"'" & Session("Empresa_Usuario")			& "', "	& _
					"'" & Documento_no_valorizado				& "', "	& _
					"0" & Numero_documento_no_valorizado		& ", "	& _
					"0" & a										& ", "  & _
					"'"	& Request("txtProducto"&a)				& "', " & _
						"0"										& ", "  & _
					"'" & Session("xCentro_de_venta") 		    & "', '"  & _
						Session("xBodega")						& "', " & _
					"'"	& Request("Cliente")					& "', "	& _
						"Null"									& ", "  & _
					"'" & Session("xCentro_de_venta") & "'"		& ", "  & _
					"'" & Session("Login")						& "', Null, " & _
					"0"	& Numero_documento_no_valorizado		& ", "	& _
						"0"										& ", "	& _
					"0"	& Request("NroOrdCom")					& ", "	& _
						"0"										& ", "	& _
						Fecha_movimiento						& ", "	& _
						"0"										& ", "	& _
						"0"										& ", "	& _
						"0"										& ", "	& _
						Cantidades								& ", "	& _
						"Null"									& ", "	& _
					"'"	& Request("CodigoMoneda")				& "', "	&  _
						"1"										& ", "	& _
						Fecha_movimiento						& ", 0"	& _
						Precio									& ", 0"	& _					
						PrecioModificado						& ", 0"	& _
						Request("txtDcto1_"&a)					& ", 0"	& _					
						Request("txtDcto2_"&a)					& ", "	& _					
						"0"										& ", 0"	& _
						"0"										& ", "	& _					
						"0"										& ", "	& _
					"'"	& Request("Observaciones")				& "', "	& _
					"'"	&										  "', 0"& _
						Numero_doc_no_valoriz_asiento_cont		& ", 0"	& _
						cdbl(Request("txtControl"&a))				& ", "  & _
					"'" & Estado_documento_no_valorizado & "', 0, 0, Null, Null, Null, Null, " & _
					"0" & CantidadDUN14								& ", "  & _
					""	& CodigoDUN14
					Conn.Execute( cSQL_D )			
					if len(trim(Err.Description)) > 0 then
						Error = "S"
						MsgError = LimpiaError(Err.Description)
						exit for
					end if
			end if
		Next
	end if

	if Error = "X" Then
		cSql = "Exec DNV_Recalcula_montos '" & Documento_no_valorizado & "', 0" & Numero_documento_no_valorizado
		Conn.Execute ( cSql )
		if len(trim(Err.Description)) > 0 then
			Error = "S"
			MsgError = LimpiaError(Err.Description)
		end if
	end if

	if Error = "N" Then
		PrecioTotal = Request("Total")
		if Session("ValoresConIva") = "S" Then
			PrecioNeto  = Round( PrecioTotal / ( 1 + (cDbl(Session("PCTGEIVA")) / 100) ) + 0.01, 0)
		else
			PrecioNeto		= PrecioTotal 
			PrecioTotal		= Round(PrecioNeto * ( 1 + (cDbl(Session("PCTGEIVA")) / 100) ) + 0.01,0)
		end if
			Iva			= Round(PrecioTotal - PrecioNeto,0)			 
		
		Numero_OrdenVenta = 0
		Numero_despacho_de_venta = Numero_documento_no_valorizado
		'se genera documento valorizado
    sql="exec DOV_Graba_pago_documento_venta '" & Session("empresa_usuario")  & "', 0" & +_
    Numero_documento      & ", '"  & +_
    CodDov & "', '" & +_
    request("CodigoMoneda")   & "', '" & +_
    Session("Login")      & "', '" & +_
    Session("xBodega")      & "', 01, 0" & +_
    Replace(PrecioNeto,",",".") & ", 0"  & +_
    Replace(Iva,",",".")      & ", 0"  & +_
    Replace(PrecioTotal,",",".")  & ", 0"  & +_
    Replace(request("Propina"),",",".")         & ", '"  & +_
    request("Cliente")      & "', '" & +_
    request("Nombres_persona")  & "', '" & +_
    request("Apellidos_persona_o_nombre_empresa")   & "', '" & +_
    request("Direccion")        & "', '" & +_
    request("Giro")             & "', 0" & +_
    Numero_GDV                  & ", '"  & +_
    Session("xObservaciones")   & "', "  & +_
    Numero_OrdenVenta           & ", "   & +_
    Numero_despacho_de_venta    & ", '"  & +_
    Session("xCentro_de_venta") & "', '" & +_
    Session("Login") & "', NULL, NULL, NULL, NULL, NULL, 0, NULL, '" & left(CodDov,2) & "'"
		set rs=conn.Execute(sql)
		if Conn.Errors.Count <> 0 then
			Error = "S"
			MsgError = Err.Description
		end if
		Numero_interno_documento_valorizado_DOCVTA =rs("Numero_interno_documento_valorizado")
		Numero_documento_valorizado_DOCVTA         =rs("Numero_documento_valorizado")
		rs.close
		set rs=nothing
	end if

	'Proceso de grabación de la documentación de pagos
	if Error = "N" Then
		hasta = cint(request("TotalLineasPagos")) * 2
		vuelto=0
		for i=1 to hasta step 2
			Monto_a_Pagar = Request("Monto_a_pagar"&cstr(i+1))
			if Monto_a_Pagar = 0 Then Monto_a_Pagar = ""						
			
			if len(trim(Monto_a_Pagar)) > 0 then
				sql = "Exec VMN_RescataParidad '" & Trim(request("CodigoMoneda")) & "', '" & Session("Empresa_usuario") & "'"
				set rs=conn.Execute(sql)
				if Not Rs.Eof then
					ParidadFact = rs("Paridad_para_compra_dolar")
				else
					ParidadFact = 1
				end if
				rs.close
				set rs=nothing

				if len(request("Fecha_vencimiento"&i+1)) > 0 then
					fecha_vencimiento=year(request("Fecha_vencimiento"&i+1)) & "/" & month(request("Fecha_vencimiento"&i+1)) & "/" & day(request("Fecha_vencimiento"&i+1))
				else
					fecha_vencimiento=""
				end if
				if Trim(request("CodigoMoneda")) = "$" then
					paridad=1
				else
					paridad=ParidadFact
				end if

				documento_valorizado_ingresado= Request("documento" & cstr(i))
				
				if documento_valorizado_ingresado = "CHI" Then
					NroCheques = NroCheques + 1
				end if
					
					Numero_efectivo_ingresado = request("Numero"&i)
					if trim(request("CodigoMoneda")) = "$" then
						if trim(request("CodigoMoneda")) = "$" then
							Monto	= cdbl(request("Monto_a_pagar"&i+1)) 
							moneda  = "$"
							ParidadEfectivo = 1
						else								
							Monto	= cdbl(request("Monto_a_pagar"&i+1)) * cdbl(ParidadFact)
										
							moneda="$"
							ParidadEfectivo=1
							sql="exec DOC_NuevoFolio 'CIN'"	'folio comprobante de ingerso
							set rs=Conn.Execute(sql)
								Numero_comprobante_de_ingreso=rs("Folio")
							rs.close
							set rs=nothing

							sql="exec DOC_NuevoFolio 'CEG'" 'folio comprobante de egreso
							set rs=Conn.Execute(sql)
								Numero_comprobante_de_egreso=rs("Folio")
							rs.close
							set rs=nothing

							documento_valorizado_ingresado="EFI" 'folio efectivo ingresado
							sql="exec DOC_NuevoFolio 'EFI'"
							set rs=Conn.Execute(sql)
								Numero_efectivo_ingresado=rs("Folio")
							rs.close
							set rs=nothing

							documento_valorizado_egresado="EFE" 'folio efectivo egresado
							sql="exec DOC_NuevoFolio 'EFE'"
							set rs=Conn.Execute(sql)
								Numero_efectivo_egresado=rs("Folio")
							rs.close
							set rs=nothing

							sql="exec DOV_GrabaComprobanteEgreso '" & Session("Empresa_usuario") & "','" & documento_valorizado_egresado & "'," & Numero_efectivo_egresado & ", 0" & Monto & ",null,'" & Fecha & "','','','','" & moneda & "'," & Numero_comprobante_de_egreso & ",'Cambio de moneda x pago Facturación servicios','" & Session("Login") & "', '" & Diferencia_tipo_cambio & "'"
							Conn.Execute(sql)
							monto_egreso=monto
							if clng(monto) > clng(Total_a_pagar) then
								monto=Total_a_pagar
							end if
							sql="exec DOV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "','" & documento_valorizado_ingresado & "'," & Numero_efectivo_ingresado & "," & Monto & ",null,'" & Fecha & "','','','','" & moneda & "'," & Numero_comprobante_de_ingreso & ",'Cambio de moneda x pago Facturación servicios','" & Session("Login") & "', Null, Null,"
							Conn.Execute(sql)
							vuelto = vuelto + monto_egreso - monto
						end if
					else
						if trim(request("CodigoMoneda")) = "US$" then
							Monto	= cdbl(request("Monto_a_pagar"&i+1)) 
							moneda = "US$"
						else
							sql = "Exec VMN_RescataParidad '" & Trim(request("CodigoMoneda")) & "', '" & Session("Empresa_usuario") & "'"
							set rs=conn.Execute(sql)
							ParidadFact = rs("Paridad_para_compra_dolar")
							ParidadEgreso = rs("Paridad_para_venta_dolar")
							ParidadEfectivo=rs("Paridad_para_facturacion")
							rs.close
							set rs=nothing

							Monto	= cdbl(request("Monto_a_pagar"&i+1)) / cdbl(ParidadFact)
							moneda="US$"
							Monto_egreso	= cdbl(request("Monto_a_pagar"&i+1)) / cdbl(ParidadEgreso)

							sql="exec DOC_NuevoFolio 'CIN'"	'folio comprobante de ingerso
							set rs=Conn.Execute(sql)
							Numero_comprobante_de_ingreso=rs("Folio")
							rs.close
							set rs=nothing

							sql="exec DOC_NuevoFolio 'CEG'" 'folio comprobante de egreso
							set rs=Conn.Execute(sql)
							Numero_comprobante_de_egreso=rs("Folio")
							rs.close
							set rs=nothing

							documento_valorizado_ingresado="UEI" 'folio efectivo ingresado
							sql="exec DOC_NuevoFolio 'UEI'"
							set rs=Conn.Execute(sql)
							Numero_efectivo_ingresado=rs("Folio")
							rs.close
							set rs=nothing

							documento_valorizado_egresado="UEE" 'folio efectivo egresado
							sql="exec DOC_NuevoFolio 'UEE'"
							set rs=Conn.Execute(sql)
							Numero_efectivo_egresado=rs("Folio")
							rs.close
							set rs=nothing

							sql="exec DOV_GrabaComprobanteEgreso '" & Session("Empresa_usuario") & "','" & documento_valorizado_egresado & "'," & Numero_efectivo_egresado & ", 0" & Monto_egreso & ",null,'" & Fecha & "','','','','" & moneda & "'," & Numero_comprobante_de_egreso & ",'Cambio de moneda x pago Facturación servicios','" & Session("Login") & "', '" & Diferencia_tipo_cambio & "'"
							Conn.Execute(sql)
							if clng(monto) > clng(Total_a_pagar) then
								monto=Total_a_pagar
							end if
							vuelto=vuelto + monto_egreso - monto
							sql="exec DOV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "','" & documento_valorizado_ingresado & "'," & Numero_efectivo_ingresado & "," & Monto & ",null,'" & Fecha & "','','','','" & moneda & "'," & Numero_comprobante_de_ingreso & ",'Cambio de moneda x pago Facturación servicios','" & Session("Login") & "', Null, Null"
							Conn.Execute(sql)
						end if
					end if
								
					if clng(monto) > clng(Total_a_pagar) then
						monto = Total_a_pagar
					end if

					sql="exec DOC_NuevoFolio 'CIN'"
					set rs=Conn.Execute(sql)
					Numero_documento_no_valorizado=rs("Folio")
					rs.close
					set rs=nothing
					Fecha_emision = year(date()) & "/" & month(date())& "/" & day(date())
					sql="exec DNV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "', 0" & +_
															Numero_documento_no_valorizado & ",'" &+_
															Fecha_emision & "','C','" & +_
															request("Cliente") & "','" & +_
															trim(request("CodigoMoneda")) & "','" & +_
															request("documento"&cstr(i)) & "'," 
															if  request("Banco"&i+1)="" then
																sql=sql & request("Monto_a_pagar"&i+1) & ",null,'"
															else
																sql=sql & request("Monto_a_pagar"&i+1) & ",'" & request("Banco"&i+1) & "','Creado al facturar servicio"
															end if
															sql=sql & "','" &+_
															Session("Login") & "'"
					set RsManejo=Conn.Execute(sql)
					Registros	= RsManejo("Registros")
					RsManejo.close
					set RsManejo=nothing

		            If request("Fecha_vencimiento_"&i+1) = "" Then
						Fecha_vencimiento = "Null"
					Else
						Fecha_vencimiento = "'" & cambia_fecha(Request("Fecha_vencimiento_"&i+1)) & "'"
					End if
					ccBanco = "Null" 'year(Now()) & "/" & month(Now()) & "/" & day(Now())
					CtaCteBco = "Null"
					IF Ucase(Trim(request("documento"&cstr(i)))) = "DEI" then
						ccBanco = request("Banco"&i+1)
						if len(trim(ccBanco)) = 0 then ccBanco = "Null" else ccBanco = "'" & ccBanco & "'"
						CtaCteBco = "Null"
					end if
					sql = "Exec DOV_GrabaComprobanteIngreso '" & _
							Session("Empresa_usuario") & "', '" & +_
							request("documento"&cstr(i)) & "', 0" & +_
							request("numero"&Cstr(i)) & ", 0" & +_
							request("Monto_a_pagar"&Cstr(i+1)) & ", " & +_
							ccBanco  & ", " & +_
							Fecha_vencimiento  & ", '" & +_
							year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
							CtaCteBco & ", '" & +_
							request("Cliente") & "', '" & +_
							trim(request("CodigoMoneda")) & "', 0" & +_
							Numero_documento_no_valorizado & ", '', '" +_
							Session("Login")	& "', Null, Null"

					set rs=conn.Execute(sql)
					if len(trim(Err.Description)) > 0 then
						Error = "S"
						MsgError = LimpiaError(Err.Description)
						exit for
					end if

					Numero_interno_documento_valorizado=rs("Numero_interno_documento_valorizado")
					Numero_documento_valorizado=rs("Numero_documento_valorizado")
					Numero_interno_DocFav = Rs("Documento")
					rs.close
					set rs=nothing

				sql="exec ACO_Cobro_pago 0" &	Numero_interno_documento_valorizado & ",'" +_
												documento_valorizado_ingresado & "',0" &+_
												Numero_efectivo_ingresado & ",0" & +_
												ParidadEfectivo & ",'" &+_
												"COB', 0" &+_
												Numero_interno_documento_valorizado_DOCVTA & ",'" & +_
												CodDov & "', 0" & +_
												Numero_documento_valorizado_DOCVTA & ",0" & +_
												ParidadEfectivo & ",'" & +_
												"S','" &+_
												"VTA'," &+_
												cdbl(request("Monto_a_pagar"&i+1))  & ",'" &+_  
												moneda & "','" &+_
												Session("Login") & "'"
				Conn.Execute(sql)
				if len(trim(Err.Description)) > 0 then
					Error = "S"
					MsgError = LimpiaError(Err.Description)
					exit for
				end if
			end if
		next
	End if

	If Error = "N" then
		Conn.CommitTrans				
		msgerror	= "Proceso terminado satisfactoriamente. Despacho Nº " & Numero_despacho_de_venta
		Session("xObservaciones") = ""
	Else
		Conn.RollbackTrans
	End if
Else
	Conn.RollbackTrans
	Error = "S"
	MsgError = Err.Description 
End if

	MsgError = LimpiaError(MsgError)

Conn.close

%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

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
	Mensajes( "<%=MsgError%>" );
	if ( '<%=Error%>' == 'N')
	{
		var Rsp = confirm('¿ Imprime boleta ?')
		if ( Rsp )
		{
			location.href = "Imprimir_Boleta.asp?CodDOV=<%=CodDov%>&NroDOV=<%=NroDOV%>"
		}
		else
		{
			parent.top.frames[1].location.href = 'Main_PuntoVenta.asp?Msg=<%=MsgError%>';
		}
	}
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>

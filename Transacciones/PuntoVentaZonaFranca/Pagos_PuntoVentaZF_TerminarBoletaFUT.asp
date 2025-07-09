<%
Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function
FechaBoleta = strzero(year( Session( "Fecha_boleta" ) ),4) & "/" & strzero(month( Session( "Fecha_boleta" ) ),2) & "/" & strzero(day( Session( "Fecha_boleta" ) ),2) & " " & mid( Session( "Fecha_boleta" ), 12, 8 )

' ---------------------------------------- Terminar Boleta -------------------------------------------
'Validaciones
If Accion_a_ejecutar = "Terminar" then
  '*****************************************************************************************************************
  '*****************************************************************************************************************
  'Esta sentencia reemplaza a la de abajo porque en el loop de arriba que cálcula los precios y descuentos
  'ya se recorre la lista_detalle_DVT y se obtiene la cantidad de tuplas (productos) que hay en la venta
  'y se almacena en la variable "total_productos"
  if total_productos = 0 then MensajeError = "Debe al menos ingresar un producto para finalizar una venta"

  'Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
  'if rs.eof then
  '  MensajeError = "Debe al menos ingresar un producto para finalizar una venta"
  'end if
  'rs.close
  'set rs = nothing
  '*****************************************************************************************************************
  '*****************************************************************************************************************
End if

'response.write session("Imprimiendo_boleta") & "<br>" & _
'MensajeError & "<br>" & _
'Accion_a_ejecutar & "<br>" & _
'Session("Tipo_documento_venta")

if Accion_a_ejecutar = "Terminar" and vacio(MensajeError) and session("Imprimiendo_boleta") <> "Si" then
   
   session("Imprimiendo_boleta") = "Si"
   Error = "N"

  Conn.BeginTrans
  
  '##########################################################################################
  '############ Chequear cobro ECO EXPRESS --> descontar del saldo del empleado #############
  '##########################################################################################
  if tipo_cobro_ECO_EXP then
    'Total_Monto_Cobros_Eco_Exp 
    'Session("saldo_empleado_ECO_EXP")
    Conn.Execute("Exec ECO_Express_Descuenta_Saldo '"&Session("Cliente_boleta")&"', "&Total_Monto_Cobros_Eco_Exp)
    if err <> 0 then
      MensajeError = err.Description
    end if
  end if
  '##########################################################################################
  
  if tipo_cobro_ECO then 'Modificación para productos con descuentos ECONOMATO
    strSQL="update movimientos_productos set porcentaje_descuento_1=0, " &_
           "porcentaje_descuento_2=0, producto=producto " &_
           "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
           "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and " &_
           "temporada='ECO'" 
    'Response.Write strSQL
    'Response.End
    Conn.Execute(strSQL)
  else
    if v_existe_prod_mayorista then
      if cdbl(Session("BASETOTMAY")) > cdbl(Total_Precio_Mayoristas) then
        'Volver precio a normales (incluyendo descuentos) y eliminar los productos del estado mayorista
        strSQL="update movimientos_productos set precio_de_lista_modificado=precio_de_lista, " &_
               "temporada=null, producto=producto " &_
    	         "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
    	         "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and " &_
    	         "(temporada is not null and temporada <> 'ECO')"
      else
        'Limpiar los porcentajes de descuento de los posibles productos que se estén vendiendo como mayoristas y 
        'tengan porcentajes de descuento por promoción--> mas abajo se realizan los descuentos de los productos mayoristas 
        'ES DECIR: "preparar los registros para que se realicen los descuentos mayoristas
        
        'ESTE MISMO PROCESO SE DEBE REALIZAR PARA LOS PRODUCTOS CON DESCUENTOS EN ECONOMATO DE TEMPORADA (ej: Navidad)
        strSQL="update movimientos_productos set porcentaje_descuento_1=0, " &_
               "porcentaje_descuento_2=0, producto=producto " &_
      	       "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
      	       "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and " &_
      	       "(temporada is not null and temporada <> 'ECO')"
      end if
      'Response.Write strSQL
      'Response.End
      Conn.Execute(strSQL)
    end if
  end if

   ' ------------------- Graba los precios -----------------------
   ' Se supone que todos estos precios y descuentos ya están validados
   Total_pesos = 0
   Set rs = Conn1.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
   do while not rs.eof

      Numero_documento_no_valorizado =  rs("Numero_documento_no_valorizado")
      Numero_Interno = rs("Numero_interno_documento_no_valorizado")

      'OJO - Colocar toda esta rutina en subrutina ya que se usa en dos partes
      Precio = cdbl( rs("Precio_de_lista_modificado") )
      Descuento = cdbl( rs("Porcentaje_descuento_1") ) + cdbl(rs("Porcentaje_descuento_2"))
      
      Porcentaje_descuento_3 = 0
      if not IsNull(trim(rs("Porcentaje_descuento_3"))) then Porcentaje_descuento_3 = cdbl(rs("Porcentaje_descuento_3"))
      
      Promocion = Rs("Promocion_nombre")
        If IsNull(Promocion) Then Promocion = ""

        if len(trim(Promocion)) = 0 then 'Si no esa dentro de una promoción
            if Es_Kit = "N" then
              if Descuento >= 0 then
              
                  if Descuento_documento > Descuento_linea and Descuento_linea = 0 then
                     Descuento_linea = Descuento_documento
                  end if
                  
                  if Session("Porcentaje_descuento_institucional") > Descuento then
                     Descuento = Session("Porcentaje_descuento_institucional")
                  end if
            
                  if Descuento > Session("Maximo_descuento_cajera") then
                     Descuento = Session("Maximo_descuento_cajera")
                  end if
                  if Descuento > Session("Maximo_descuento_linea") then
                     Descuento = Session("Maximo_descuento_linea")
                  end if 
                  if Descuento > Session("Maximo_descuento_cabecera") then
                     Descuento = Session("Maximo_descuento_cabecera")
                  end if 
            
                    if Session("Porcentaje_descuento_empleado") > 0 then
                        Descuento_linea = Descuento_documento ' Descuento al documento
                        if Session("Permite_hacer_descuento_empleado") then
                             if Session("Porcentaje_descuento_empleado") >= 90 and Session("Porcentaje_descuento_empleado") < 100then
                                Monto_descuento = ( Precio * ( Descuento_linea / 100 ) \ 1 )
                                Porcentaje_descuento_empleado = ( Session("Porcentaje_descuento_empleado") / 100 )
                                ILA = cdbl(rs("Porcentaje_ILA"))/100 'Francisco
                                uno=(((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0046+(100-Session("Porcentaje_descuento_empleado"))/100)))*(ILA))
                                dos=(cdbl(rs("Costo_cif_ori_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*ILA)
                                if uno>=dos then
                                    precio_con_descuento=(((((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0046+(100-Session("Porcentaje_descuento_empleado"))/100)))*(1+ILA))))
                                    'precio_con_descuento = cint(precio_con_descuento/10)*10
                                    precio_con_descuento = cdbl(precio_con_descuento) - cdbl(precio_con_descuento mod 10) ' Mod Cristian
                                    Monto_descuento_empleado = PRECIO - precio_con_descuento
                                else
                                    precio_con_descuento=(((((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0046+(100-Session("Porcentaje_descuento_empleado"))/100)))+(cdbl(rs("Costo_cif_ori_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*ILA))))
                                    'precio_con_descuento = cint(precio_con_descuento/10)*10
                                    precio_con_descuento = cdbl(precio_con_descuento) - cdbl(precio_con_descuento mod 10)' Mod Cristian
                                    Monto_descuento_empleado = PRECIO - precio_con_descuento  
                                end if    
                                if Monto_descuento_empleado > Monto_descuento then
                                   Descuento_linea = ( 1 - ( ( Precio - Monto_descuento_empleado ) / Precio ) ) * 100                                   
                                else 
                                   Descuento_linea = ((( 1 - ( ( Precio + Monto_descuento_empleado ) / Precio ) ) * 100))*-1
                                end if
                            else
                                Monto_descuento = ( Precio * ( Descuento_linea / 100 ) \ 1 )
                                Porcentaje_descuento_empleado = ( Session("Porcentaje_descuento_empleado") / 100 )
                                ILA = cdbl(rs("Porcentaje_ILA"))/100 'Francisco
                                Precio_sin_ILA = Precio/(1+ILA) 'Francisco
                                Costo_CPA = cdbl( rs("Costo_CPA_$") )
                                Costo_CIF_ADU = cdbl( rs("Costo_CIF_ADU_$") )
                                Monto_descuento_empleado =  ( ( ( ( ( Precio_sin_ILA - ( Costo_CPA + ( Costo_CIF_ADU * ( 0.022 + 0.0046 ) ) ) ) * Porcentaje_descuento_empleado)) * (1+ILA) ) \ 10 ) * 10 'Francisco
                                if Monto_descuento_empleado > Monto_descuento then
                                   Descuento_linea = ( 1 - ( ( Precio - Monto_descuento_empleado ) / Precio ) ) * 100
                                end if                            
                            end if
                        end if
                    end if    
              end if
            else
                Descuento = 0
            end if
        end if 
        
        'if Monto_descuento_empleado>=0 then
        '    Precio = ( Precio * ( ( 100 - Descuento_linea ) / 100 ) \ 1 )
        'else
        '    Precio = ( Precio * ( ( 100 + Descuento_linea ) / 100 ) \ 1 )
        'end if
      temporada = trim(Ucase(rs("temporada")))  
      if tipo_cobro_ECO then 'Modificación para productos con descuentos ECONOMATO
        if temporada = "ECO" then Descuento = Porcentaje_descuento_3 'Este se aplica en porcentaje_descuento_2 cuando se llama al procedure "MOP_Graba_precios_linea_DVT" en la linea: 184
        
        '##########################################################################################
        'Limpiar porcentaje_descuento_3 = 0
        strSQL="update movimientos_productos set porcentaje_descuento_3=0, producto=producto " &_
               "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
               "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and " &_
               "Numero_de_linea="&rs("Numero_de_linea")&" and temporada='ECO'" 
        'Response.Write strSQL
        'Response.End
        Conn.Execute(strSQL)
        '##########################################################################################      
      else
        '********************************************************************************
        '***************** MODIFICACION PARA PRODUCTOS MAYORISTAS EN PROMOCION **********
        '********************************************************************************
        if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO"  or temporada="500AÑOS" then Descuento = 0
      end if
      Precio = ( Precio * ( ( 100 - Descuento ) / 100 ) \ 1 )
      ' fin OJO
      'Precio = cdbl(Precio) - cdbl(Precio Mod 10) 'Precio sin pesos (unidades)

      Total_pesos = Total_pesos + ( cint(rs("Cantidad_salida")) * Precio )
      Conn.execute( "Exec MOP_Graba_precios_linea_DVT '" & _
                          Session("Login") & "',0" & _
                          rs("Numero_de_linea") & "," & _
                          Descuento & ",0" & _
                          Precio & ",'" & _
                          Session("empresa_usuario") & "',0" & _
                          Session("Tipo_cambio_boleta") )
      rs.movenext
   loop
   rs.close
   set rs = nothing
      
   'Graba totales del documento no valorizado
   Conn.execute("Exec MOP_Graba_totales_DVT '" & trim(Session("Login")) & "',0" & Total_pesos )
   if len(trim(Err.Description)) > 0 then
   		Error = "S"
			MensajeError = Err.Description
			Log_error "Exec MOP_Graba_totales_DVT '" & trim(Session("Login")) & "',0" & Total_pesos , Err.Description 
	 end if
   
   'Sumando el impuesto aduanero
   Monto_impuesto_aduanero_moneda_oficial = 0
   Monto_impuesto_aduanero_US = 0
   Valor_paridad_moneda_oficial = 1
   Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
   do while not rs.eof
      Valor_paridad_moneda_oficial = rs("Valor_paridad_moneda_oficial")
      Monto_impuesto_aduanero_moneda_oficial =  Monto_impuesto_aduanero_moneda_oficial + cdbl(rs("Monto_impuesto_aduanero_moneda_oficial"))
      Monto_impuesto_aduanero_US = Monto_impuesto_aduanero_US + cdbl(rs("Monto_impuesto_aduanero_US$"))
      rs.movenext
   loop
   rs.close
   set rs = nothing

        'response.write "<br>*4*<br>" & Error

   ' Se obtiene el número de la boleta (Después será reemplazado por el real de la impresora Fiscal)
   if Session("Tipo_documento_venta") = "BOV" then
      set rs=Conn.Execute( "exec DOC_NuevoFolio '" & Session("Tipo_documento_venta") & "'" )
      Numero_documento = Rs("Folio")
      if len(trim(Err.Description)) > 0 then
   		   Error = "S"
	       MensajeError = Err.Description
				 Log_error "exec DOC_NuevoFolio '" & Session("Tipo_documento_venta") & "'" , Err.Description 
	    end if
      rs.close
      set rs=nothing
   else
      Numero_documento = Folio_disponible
   end if

   Documento_no_valorizado = "DVT"
   Propina = 0
   Neto = Total_pesos
   Iva = 0

   Slct_DocDescpacho = Session("Tipo_documento_venta")
   Codigo_moneda = "$"
   Nombres_persona = ""
   Apellidos_persona_o_nombre_empresa = ""
   Direccion = ""
   Giro = ""
   Numero_GDV = 0  'De adonde sale ?
   Observaciones_generales = ""
   
   Numero_OrdenVenta = 0
   Numero_despacho_de_venta = Numero_documento_no_valorizado

  'se genera documento valorizado
	' BOV, UEI, EFE, EFI
	nidovBOV = 0
	nidovUEI = 0
	nidovEFE = 0
	nidovEFI = 0
	nidnvUEI = 0
	nidnvEFE = 0
	nidnvEFI = 0
	niMOP = 0
   if Session("flagFechaBoleta") then
	   sql="exec DOV_Graba_pago_documento_venta '" & Session("empresa_usuario")              & "', 0" & +_
								Numero_documento & ", '"  & +_
								Slct_DocDescpacho & "', '" & +_
								Codigo_moneda & "', '" & +_
								Session("Login") & "', '" & +_
								Session("xBodega") & "', 01, 0" & +_
								Neto & ", 0"  & +_
								Iva & ", 0"  & +_
								Total_pesos & ", 0"  & +_
								Propina & ", '"  & +_
								Session("Cliente_boleta") & "', '" & +_
								Nombres_persona & "', '" & +_
								Apellidos_persona_o_nombre_empresa & "', '" & +_
								Direccion & "', '" & +_
								Giro & "', 0" & +_
								Numero_GDV & ", '"  & +_
								Session("xObservaciones") & "', "  & +_
								Numero_OrdenVenta & ", "   & +_
								Numero_despacho_de_venta & ", '"  & +_
								Session("xCentro_de_venta") & "', '" & +_
								Session("Login") & "',null,'" & FechaBoleta & "',null,'" & FechaBoleta & "',null,0" & +_
								Monto_impuesto_aduanero_moneda_oficial & ",0" & +_
								Monto_impuesto_aduanero_US & ",0" & +_
								Valor_paridad_moneda_oficial & ",'" & left(Slct_DocDescpacho,2) & "'"
   else ' version normal
	   sql="exec DOV_Graba_pago_documento_venta '" & Session("empresa_usuario")              & "', 0" & +_
								Numero_documento & ", '"  & +_
								Slct_DocDescpacho & "', '" & +_
								Codigo_moneda & "', '" & +_
								Session("Login") & "', '" & +_
								Session("xBodega") & "', 01, 0" & +_
								Neto & ", 0"  & +_
								Iva & ", 0"  & +_
								Total_pesos & ", 0"  & +_
								Propina & ", '"  & +_
								Session("Cliente_boleta") & "', '" & +_
								Nombres_persona & "', '" & +_
								Apellidos_persona_o_nombre_empresa & "', '" & +_
								Direccion & "', '" & +_
								Giro & "', 0" & +_
								Numero_GDV & ", '"  & +_
								Session("xObservaciones") & "', "  & +_
								Numero_OrdenVenta & ", "   & +_
								Numero_despacho_de_venta & ", '"  & +_
								Session("xCentro_de_venta") & "', '" & +_
								Session("Login") & "',null,null,null,null,null,0" & +_
								Monto_impuesto_aduanero_moneda_oficial & ",0" & +_
								Monto_impuesto_aduanero_US & ",0" & +_
								Valor_paridad_moneda_oficial & ",'" & left(Slct_DocDescpacho,2) & "'"
   end if
		set rs=conn.Execute(sql)
		if Conn.Errors.Count <> 0 then
			Error = "S"
			MensajeError = Err.Description
			Log_error sql , Err.Description 
		end if
		Numero_interno_documento_valorizado_DOCVTA = rs("Numero_interno_documento_valorizado")
		Numero_documento_valorizado_DOCVTA         = rs("Numero_documento_valorizado")
		rs.close
		set rs=nothing
	' BOV
	nidovBOV = Numero_interno_documento_valorizado_DOCVTA

'CREATE PROCEDURE PUN_Graba_boleta_fiscal_a_imprimir 
'	@Empresa			varchar(12),
'	@Numero_documento_valorizado	int,
'	@Centro_de_venta 		varchar(12) = Null,
'	@Numero_boleta_a_imprimir	int,
'	@Numero_impresora_fiscal_a_imprimir int
  ' BOLETA FANTASMA JOMS Sept 2007
    if session("Boleta_actual") <> "0" and session("Fiscal_actual") <> "0" then
       sql="Grabando boleta fantasma!"
       sql="exec PUN_Graba_boleta_fiscal_a_imprimir '" & _
                 Session("empresa_usuario") & "', 0" & +_
                 Numero_despacho_de_venta & ", '"  & +_
                 Session("xCentro_de_venta") & "',0" & +_
                 session("Boleta_actual") & ",0" & +_
                 session("Fiscal_actual")
       Conn.commandtimeout = 25
       conn.Execute(sql)
       Conn.commandtimeout = 3600
       if Conn.Errors.Count <> 0 then

          Error = "S"
          MensajeError = Err.Description
          Log_error sql , Err.Description 
          sql = "exec DOV_Borrar_Boleta_Fantasma '" & Session("Login") &  "'"
          borrar_boleta_fantasma_sys sql
          'sql="Borrando boleta fantasma!"
       end if
    end if

        'response.write "<br>*5*<br>" & Error

    'response.write sql & chr(13)
    'response.write MensajeError & chr(13)
    'response.write Numero_interno_documento_valorizado_DOCVTA & chr(13)
    'response.write Numero_documento_valorizado_DOCVTA & chr(13)
    
    'Aqui se agregan los documentos de pago --------------------------------------------
    if Error = "N" then
    cCadEconomato = "¬"
    z = 0
    
    for n = 1 to Numero_documentos_cobro

        aDocumento_cobro = Split( Request("Tipo_documento_cobro_" & n ) & ";0;0" , ";" )

        Numero_documento_ingresado = request("Numero_documento_cobro_" & n )
        
        if aDocumento_cobro(0) = "TMU" then
           Fecha_documento = request("Fecha_vencimiento_tmu_" & n )
        else
           Fecha_documento = request("Fecha_documento_cobro_" & n )
        end if
        Banco_documento = request("Banco_documento_cobro_" & n )
        Monto_a_Pagar = cdbl( "0" & request("Monto_documento_cobro_" & n ) )
		IF Session("flagFechaBoleta") then
			Fecha_emision = FechaBoleta
		ELSE
			Fecha_emision = year(date()) & "/" & month(date())& "/" & day(date())
		END IF

		    If len(trim(Fecha_documento)) = 0 Then
					Fecha_vencimiento = "Null"
					IF Session("flagFechaBoleta") then
						Fecha_vencimiento = "'" & FechaBoleta & "'"
					END IF
				Else
					Fecha_vencimiento = "'" & cambia_fecha( Fecha_documento ) & "'"
				End if
        
        Documento_valorizado_ingresado  = aDocumento_cobro(0) 'request("Tipo_documento_cobro_" & n )
        
        'response.write "<br>*6*<br>" & Error
        
        'Pago con dolares
        if Documento_valorizado_ingresado = "UEI" or Documento_valorizado_ingresado = "DDC" then

          'Comprobante de Ingreso ?
  				sql="exec DOC_NuevoFolio 'CIN'"
  				set rs=Conn.Execute(sql)
  				
  				if Conn.Errors.Count <> 0 then
  					 Error = "S"
  					 MensajeError = Err.Description
  					 Log_error sql , Err.Description 
  				end if
  		
  				Numero_documento_no_valorizado=rs("Folio")
  				rs.close
  				set rs=nothing

          sql="Cabecera comprobante ingreso dolares!"
          'response.write sql
          'Se graba la cabecera del comprobante de ingreso por los dolares
          '--------------------------------------------------------------------
          sql = "exec DNV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "', 0" & +_
          				Numero_documento_no_valorizado & ",'" & Fecha_emision & "','O',Null,'" & +_
          				"US$" & "','" & +_
          				Documento_valorizado_ingresado & "',0" & +_
          				Monto_a_Pagar & ",null,'','" & Session("Login") & "'"
          set RsManejo=Conn.Execute(sql)
          if len(trim(Err.Description)) > 0 then
            Error = "S"
            MensajeError = Err.Description
            Log_error sql , Err.Description 
            exit for
          end if
          nidnvUEI = RsManejo( "Documento" )
          RsManejo.close
          set RsManejo=nothing

          'Se graba el detalle del comprobante de ingreso por los dolares
          '--------------------------------------------------------------------
          sql="Detalle comprobante ingreso dolares!"
          'response.write sql

          ' Asigno en Nro BOV al DDC
          IF Documento_valorizado_ingresado = "DDC" THEN
             Numero_documento_ingresado = Numero_documento
          END IF

				  if Session("flagFechaBoleta") then
					   sql = "Exec DOV_GrabaComprobanteIngreso '" & _
									Session("Empresa_usuario") & "', '" & +_
								  Documento_valorizado_ingresado & "', 0" & +_
								  Numero_documento_ingresado & ", 0" & +_
								  Monto_a_Pagar & ", " & +_
								  "Null, " & Fecha_vencimiento & ", '" & +_
								  year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								  "Null,Null, '" & +_
								  "US$" & "', 0" & +_
								  Numero_documento_no_valorizado & ", '', '" & +_
								  Session("Login")	& "', " & Session("cuenta_puente") & ", " & Session("DolarCambio") & "," & _
                  "Null,Null,Null,0,'" & FechaBoleta & "',Null,'" & FechaBoleta & "',Null,Null,Null,Null,Null," & _
                  "'" & Session("xCentro_de_venta") & "','" & Session("xBodega") & "',0" & _
                  Numero_despacho_de_venta & ", 0"
			    else
					   sql = "Exec DOV_GrabaComprobanteIngreso '" & _
									Session("Empresa_usuario") & "', '" & +_
								  Documento_valorizado_ingresado & "', 0" & +_
								  Numero_documento_ingresado & ", 0" & +_
								  Monto_a_Pagar & ", " & +_
								  "Null, " & Fecha_vencimiento & ", '" & +_
								  year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								  "Null,Null, '" & +_
								  "US$" & "', 0" & +_
								  Numero_documento_no_valorizado & ", '', '" & +_
								  Session("Login")	& "', " & Session("cuenta_puente") & ", " & Session("DolarCambio") & "," & _
					        "Null,Null,Null,0,Null,Null,Null,Null,Null,Null,Null,Null," & _
					        "'" & Session("xCentro_de_venta") & "','" & Session("xBodega") & "',0" & _
					        Numero_despacho_de_venta & ", 0"
				  end if
   				'conn.Execute(sql)
				  set RsUEI=Conn.Execute(sql)
					if len(trim(Err.Description)) > 0 then
						  Error = "S"
			        MensajeError = Err.Description
						  Log_error sql , Err.Description 
						  exit for
					end if
				  nidovUEI = RsUEI( "Documento" )
			    RsUEI.close
			    set RsUEI=nothing
          Monto_a_pagar = round( Monto_a_pagar * Session("DolarCambio"), 0 )
          'Monto_a_pagar = round( Monto_a_pagar * Session("Tipo_cambio_boleta"), 0 )

          'Se graba el comprobante de egreso por los pesos de los dolares EFE
          '--------------------------------------------------------------------
'response.write "<br>*6*<br>" & Error
          
          'Comprobante de Ingreso ?
				  sql="exec DOC_NuevoFolio 'CEG'"
				  set rs=Conn.Execute(sql)
				
				  if Conn.Errors.Count <> 0 then
					 Error = "S"
					 MensajeError = Err.Description
					 Log_error sql , Err.Description 
				  end if
          		
				  Numero_documento_no_valorizado=rs("Folio")
				  rs.close
				  set rs=nothing

          sql="Cabecera pesos egresados por dolares!"
          'response.write sql
   				sql = "exec DNV_GrabaComprobanteEgreso '" & Session("Empresa_usuario") & "', 0" & +_
										Numero_documento_no_valorizado & ",'" & Fecha_emision & "','O',Null,'" & +_
										"$" & "','EFE',0" & +_
          					Monto_a_Pagar & ",null,'','" & Session("Login") & "'"
          set RsManejo=Conn.Execute(sql)
          if len(trim(Err.Description)) > 0 then
  					  Error = "S"
              MensajeError = Err.Description
						  Log_error sql , Err.Description 
              exit for
				  end if
			    nidnvEFE = RsManejo( "Documento" )
				  RsManejo.close
				  set RsManejo=nothing

          'Se graba el detalle del comprobante de egreso por los pesos pagados por los dolares EFE
          '--------------------------------------------------------------------
          sql="Detalle pesos egresados pordolares!"
          'response.write sql
          IF isNull(Numero_despacho_de_venta) then Numero_despacho_de_venta = ""
          IF len(Numero_despacho_de_venta) = 0 then Numero_despacho_de_venta = "Null"
					if Session("flagFechaBoleta") then
					   sql = "Exec DOV_GrabaComprobanteEgreso '" & _
								 Session("Empresa_usuario") & "', 'EFE', 0" & +_
								   Numero_documento_ingresado & ", 0" & +_
								   Monto_a_Pagar & ", Null, " & Fecha_vencimiento & ", '" & +_
								   year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								   "Null,Null, '$" & "', 0" & +_
								   Numero_documento_no_valorizado & ", '', '" & +_
								   Session("Login")	& "', " & Session("cuenta_puente") & ",'" & FechaBoleta & "', " & Session("DolarCambio") & ",0" & _
									Monto_a_pagar & ",'$','" & Session("xCentro_de_venta") & "'"
					 sql = sql & ", " & Numero_despacho_de_venta
					else
					   sql = "Exec DOV_GrabaComprobanteEgreso '" & _
								 Session("Empresa_usuario") & "', 'EFE', 0" & +_
								   Numero_documento_ingresado & ", 0" & +_
								   Monto_a_Pagar & ", Null, " & Fecha_vencimiento & ", '" & +_
								   year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								   "Null,Null, '$" & "', 0" & +_
								   Numero_documento_no_valorizado & ", '', '" & +_
								   Session("Login")	& "', " & Session("cuenta_puente") & ",NULl, " & Session("DolarCambio") & ",0" & _
									Monto_a_pagar & ",'$','" & Session("xCentro_de_venta") & "'"
					   sql = sql & ", " & Numero_despacho_de_venta
					end if
   				set rsUEI = conn.Execute(sql)
					if len(trim(Err.Description)) > 0 then
						  Error = "S"
			        MensajeError = Err.Description
						  Log_error sql , Err.Description 
						  exit for
					end if
				  nidovEFE = rsUEI( "Documento" )
          rsUEI.close
           
          Documento_valorizado_ingresado = "EFI"
        end if

        if Monto_a_pagar > Total_pesos then
           Monto_a_pagar = Total_pesos
        end if
        Total_pesos = Total_pesos - Monto_a_pagar
        
        cEconomato = ""
        if len(trim(aDocumento_cobro(4))) > 0 then
            aDatos = Split( aDocumento_cobro(4), "¬")
            cEconomato = aDatos(0)
            DiaCierre  = aDatos(1)
            DiaCobro   = aDatos(2)
        end if
        
  'response.write "<br>*7*<br>" & Error
    
'---------------- INICIO GRABACIÓN DE ECONOMATO ASOCIADO AL CLIENTE --------------
        if len(trim(cEconomato)) > 0 then
            if Instr(1, cCadEconomato, "¬" & cEconomato & "¬" ) = 0 then
                cCadEconomato = cCadEconomato & cEconomato & "¬"
                
                cSql = "Exec ASE_Graba_Asociado '" & Session("Empresa_usuario") & "', "
                cSql = cSql & "'" & cEconomato & "', "
                cSql = cSql & "'" & Session("Cliente_boleta") & "', 'A', Null"
                Conn.Execute ( cSql )
    			if len(trim(Err.Description)) > 0 then
                    Error = "S"
                    MensajeError = Err.Description
                    Log_error cSql, Err.Description 
                    exit for
                end if
            end if
        end if
'---------------- FIN GRABACIÓN DE ECONOMATO ASOCIADO AL CLIENTE --------------

'---------------- INICIO GRABACIÓN DOCUMENTO MCR --------------
'        if Documento_valorizado_ingresado = "MCR" And Z = 0 then
'            cSql = "Exec TMU_Graba_Asociado '" & Session("Empresa_usuario") & "', "
'            cSql = cSql & "'" & Session("Cliente_boleta") & "', 'A', Null"
'            Conn.Execute ( cSql )
'			if len(trim(Err.Description)) > 0 then
'                Error = "S"
'                MensajeError = Err.Description
'                Log_error cSql, Err.Description 
'                exit for
'            end if
'            Z = 1
'        end if
'---------------- FIN GRABACIÓN DOCUMENTO MCR --------------

'-------------------------- DEI o NCV -------------------------        
        if Documento_valorizado_ingresado <> "DEI" and Documento_valorizado_ingresado <> "NCV" then

        'Comprobante de Ingreso ?
				sql="exec DOC_NuevoFolio 'CIN'"
				set rs=Conn.Execute(sql)
				
				if Conn.Errors.Count <> 0 then
					 Error = "S"
					 MensajeError = Err.Description
					 Log_error sql , Err.Description 
				end if
		
				Numero_documento_no_valorizado=rs("Folio")
				rs.close
				set rs=nothing
				
        sql = "exec DNV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "', 0" & +_
										Numero_documento_no_valorizado & ",'" & +_
							  		Fecha_emision & "','C','" & +_
										Session("Cliente_boleta") & "','" & +_
										"$" & "','" & +_
										Documento_valorizado_ingresado & "',0" 
                            
				if Banco_documento = "" then
					sql = sql & Monto_a_Pagar & ",null,'"
				else
					sql=sql & Monto_a_Pagar & ",'" & Banco_documento & "','Creado al facturar servicio"
				end if
        sql = sql & "','" & Session("Login") & "'"
        
        'response.write sql& chr(13)
        
				set RsManejo=Conn.Execute(sql)
				if len(trim(Err.Description)) > 0 then
  					Error = "S"
	      		MensajeError = Err.Description
						Log_error sql , Err.Description 
            'response.write MensajeError & chr(13)
						exit for
				end if
				'Numero_interno_documento_no_valorizado = RsManejo( "Documento" )
				nidnvEFI = RsManejo( "Documento" )
				RsManejo.close
				set RsManejo=nothing

        'Comprobante de Ingreso en Documento Valorizado
		    If len(trim(Fecha_documento)) = 0 Then
					Fecha_vencimiento = "Null"
					if Session("flagFechaBoleta") then
						Fecha_vencimiento = "'" & FechaBoleta & "'"
					end if
				Else
					Fecha_vencimiento = "'" & cambia_fecha( Fecha_documento ) & "'"
				End if
				ccBanco = "Null"
				CtaCteBco = "Null"
				'IF Ucase( Documento_valorizado_ingresado ) = "DEI" then
					ccBanco = Banco_documento
					if len(trim(ccBanco)) = 0 then ccBanco = "Null" else ccBanco = "'" & ccBanco & "'"
						CtaCteBco = "Null"
			'		end if
				if Session("flagFechaBoleta") then
					sql = "Exec DOV_GrabaComprobanteIngreso '" & _
								Session("Empresa_usuario") & "', '" & +_
								Documento_valorizado_ingresado & "', 0" & +_
								Numero_documento_ingresado & ", 0" & +_
								Monto_a_Pagar & ", " & +_
								ccBanco  & ", " & +_
								Fecha_vencimiento  & ", '" & +_
								year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								CtaCteBco & ", '" & +_
								Session("Cliente_boleta") & "', '" & +_
								"$" & "', 0" & +_
								Numero_documento_no_valorizado & ", '', '" +_
								Session("Login")	& "', Null, Null," & _
				  "Null,Null,Null,0,'" & FechaBoleta & "',Null,'" & FechaBoleta & "',Null,Null,Null,Null,Null," & _
				  "'" & Session("xCentro_de_venta") & "','" & Session("xBodega") & "',0" & _
				  Numero_despacho_de_venta & ", 0" & Request("NroDeLaCuota_" & n )
				else
					sql = "Exec DOV_GrabaComprobanteIngreso '" & _
								Session("Empresa_usuario") & "', '" & +_
								Documento_valorizado_ingresado & "', 0" & +_
								Numero_documento_ingresado & ", 0" & +_
								Monto_a_Pagar & ", " & +_
								ccBanco  & ", " & +_
								Fecha_vencimiento  & ", '" & +_
								year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
								CtaCteBco & ", '" & +_
								Session("Cliente_boleta") & "', '" & +_
								"$" & "', 0" & +_
								Numero_documento_no_valorizado & ", '', '" +_
								Session("Login")	& "', Null, Null," & _
				  "Null,Null,Null,0,Null,Null,Null,Null,Null,Null,Null,Null," & _
				  "'" & Session("xCentro_de_venta") & "','" & Session("xBodega") & "',0" & _
				  Numero_despacho_de_venta & ", 0" & Request("NroDeLaCuota_" & n )
				end if
				
          'response.write sql & chr(13)
          
					set rs=conn.Execute(sql)
					if len(trim(Err.Description)) > 0 then
						Error = "S"
			      MensajeError = Err.Description
						Log_error sql , Err.Description 
            'response.write MensajeError & chr(13)
						exit for
					end if

					Numero_interno_documento_valorizado = rs("Numero_interno_documento_valorizado")
					Numero_documento_valorizado = rs("Numero_documento_valorizado")
					Numero_interno_DocFav = Rs("Documento")
					nidovEFI = Rs("Documento")
					rs.close
					set rs=nothing

          'response.write MensajeError & chr(13)
          'response.write Numero_interno_documento_valorizado & chr(13)
          'response.write Numero_documento_valorizado & chr(13)
          'response.write Numero_interno_DocFav & chr(13)
                IF nidovEFE <> 0 THEN
                    cSQL = "UPDATE Documentos_valorizados SET Cliente = Cliente, Numero_comprobante_de_ingreso = " & Numero_documento_no_valorizado& " WHERE Numero_interno_documento_valorizado = " & nidovEFE
					conn.Execute(cSQL)
					if len(trim(Err.Description)) > 0 then
						Error = "S"
			            MensajeError = Err.Description
						Log_error sql , Err.Description 
						exit for
					end if
                END IF
        ' ------------------- FIN DEI - NCV -------------------------
        else

           Numero_interno_documento_valorizado = aDocumento_cobro(2) 'request("Numero_interno_documento_cobro_" & n )

        end if

        'ACO_Cobro_pago
        ParidadEfectivo = 1
        sql="ACO Cobro de pago!"
        'response.write sql
				sql="exec ACO_Cobro_pago 0" &	Numero_interno_documento_valorizado & ",'" +_
												Documento_valorizado_ingresado & "',0" &+_
												Numero_documento_ingresado & ",0" & +_
												ParidadEfectivo & ",'" & +_
												"COB', 0" &+_
												Numero_interno_documento_valorizado_DOCVTA & ",'" &+_
												Documento_valorizado_ingresado & "', 0" & +_
												Numero_documento_valorizado_DOCVTA & ",0" & +_
												ParidadEfectivo & ",'" & +_
												"S','VTA',0" & +_
												Monto_a_Pagar & ",'$','" &+_
												Session("Login") & "'"
				Conn.Execute(sql)
        
				'response.write Sql & chr(13)
        if len(trim(Err.Description)) > 0 then
					Error = "S"
		    	MensajeError = Err.Description
					Log_error sql , Err.Description 
					exit for
				end if
        'response.write MensajeError & chr(13)
		
		' Actualiza Fecha_paridad_moneda_oficial de DOV y ACO si el usuario esta digitando una Boleta anterior
		if Session("flagFechaBoleta") then
			if Session("Nro_caja") > 0 then
				cSQL01 = "UPDATE Documentos_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Fecha_ultimo_cobro_o_pago = '" & Fecha_emision & "', Numero_impresora_fiscal = " & Session("Nro_caja") & ", Tipo_de_boleta = 'F' WHERE Numero_interno_documento_valorizado = " & nidovBOV
			else
				cSQL01 = "UPDATE Documentos_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Fecha_ultimo_cobro_o_pago = '" & Fecha_emision & "' WHERE Numero_interno_documento_valorizado = " & nidovBOV
			end if
			cSQL02 = "UPDATE Documentos_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "' WHERE Numero_interno_documento_valorizado = " & nidovUEI
			cSQL03 = "UPDATE Documentos_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "' WHERE Numero_interno_documento_valorizado = " & nidovEFE
			cSQL04 = "UPDATE Documentos_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Numero_interno_documento_valorizado = " & nidovEFI

			cSQL05 = "UPDATE Asientos_contables SET Empleado_responsable = Empleado_responsable, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovBOV & ") "
			cSQL06 = "UPDATE Asientos_contables SET Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "', Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovUEI & ") "
			cSQL07 = "UPDATE Asientos_contables SET Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "', Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovEFE & ") "
		'	cSQL06 = "UPDATE Asientos_contables SET Empleado_responsable = Empleado_responsable, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "'  WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovUEI & ") "
		'	cSQL07 = "UPDATE Asientos_contables SET Empleado_responsable = Empleado_responsable, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Empleado_responsable = '" + trim(Session("Login_punto_venta")) + "'  WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovEFE & ") "
			cSQL08 = "UPDATE Asientos_contables SET Empleado_responsable = Empleado_responsable, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Empresa = 'SYS' and Documento_no_valorizado = 'ACO' and Numero_documento_no_valorizado in( SELECT Numero_documento_no_valorizado_asiento_insert FROM Documentos_valorizados (nolock) WHERE Numero_interno_documento_valorizado = " & nidovEFI & ") "

			cSQL09 = "UPDATE Documentos_no_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Numero_interno_documento_no_valorizado = " & nidnvUEI
			cSQL10 = "UPDATE Documentos_no_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Numero_interno_documento_no_valorizado = " & nidnvEFE
			cSQL11 = "UPDATE Documentos_no_valorizados SET Cliente = Cliente, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "' WHERE Numero_interno_documento_no_valorizado = " & nidnvEFI

			cSQL12 = "UPDATE Movimientos_productos SET Producto = Producto, Fecha_paridad_moneda_oficial = '" & Fecha_emision & "', Fecha_movimiento = '" & Fecha_emision & "' WHERE Numero_interno_documento_no_valorizado = " & v_num_int_DVT_activa
			
			
			
			Conn.Execute(cSQL01)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL01, Err.Description 
				exit for
			end if

			IF nidovUEI > 0 THEN
			Conn.Execute(cSQL02)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL02, Err.Description 
				exit for
			end if

			Conn.Execute(cSQL03)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL03, Err.Description 
				exit for
			end if
			END If
			
			Conn.Execute(cSQL04)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL04, Err.Description 
				exit for
			end if

			Conn.Execute(cSQL05)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL05, Err.Description 
				exit for
			end if

			IF nidovUEI > 0 THEN
			Conn.Execute(cSQL06)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL06, Err.Description 
				exit for
			end if

			Conn.Execute(cSQL07)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL07, Err.Description 
				exit for
			end if
			END If
			
			Conn.Execute(cSQL08)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL08, Err.Description 
				exit for
			end if

			IF nidnvUEI > 0 THEN
			Conn.Execute(cSQL09)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL09, Err.Description 
				exit for
			end if

			Conn.Execute(cSQL10)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL10, Err.Description 
				exit for
			end if
			END If
			
			Conn.Execute(cSQL11)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL11, Err.Description 
				exit for
			end if

			Conn.Execute(cSQL12)
			if len(trim(Err.Description)) > 0 then
				Error = "S"
		    	MensajeError = Err.Description
				Log_error cSQL12, Err.Description 
				exit for
			end if
		end if
    next

    'response.write "<br>*8*<br>" & Error

    if Session("Tipo_documento_venta") = "FAV" then
       'Se actualiza el folio en la tabla de control de folios
       Sql = "Actualiza folio para facturas"
       Sql = "EXEC PUN_Actualiza_folio 0" & Folio_disponible & ",'" & Session("empresa_usuario") & "','" & Session("Login") & "'"
       Conn.Execute(Sql )
       if len(trim(Err.Description)) > 0 then
          Error = "S"
	    		MensajeError = Err.Description
					Log_error sql , Err.Description 
       end if

       sql="exec ODV_Actualizar_voucher_venta " 
        Conn.Execute(sql)

    end if

    end if
    
    '################################################################
    '##### RESETEA LA OPCION DE DESCUENTOS MANUALES DE CAJERA #######
    if Session("Login") <> "10027765" and Session("Login") <> "13884785" and Session("Login") <> "15308847" and Session("Login") = "15309968" and Session("Login") = "15582502" and Session("Login") = "13971954" and Session("Login") = "17238275" and Session("Login") = "15923212" and Session("Login") = "13859206"  and Session("Login") = "17893185" Or Session("Login") = "19424203" then
      Session("Muestra_descuentos") = ""
    end if
    '################################################################
    
    'response.write "<br>*9*<br>" & Error

		session("Imprimiendo_boleta") = "No"
		
    if Error = "N" then
		   Conn.CommitTrans
		   'Conn.RollbackTrans
           Session("xEconomato") = ""
       if Slct_DocDescpacho = "BOV" then
          Imprimir_boleta = true
					response.redirect "Imprime_boleta_PuntoVentaZF.asp?Accion=Imprimir&Boleta_actual=" & session("Boleta_Actual")
       else
          Imprimir_factura = true
					response.redirect "Imprime_factura_PuntoVentaZF.asp?Accion=Imprimir"
       end if
    else
		   Conn.RollbackTrans
    end if

end if
%>

<%
'#########################################################################
'***** Chequea tipo de cobro para realizar descuentos Economatos (ECO) y ECO Express###
'#########################################################################
dim tipo_cobro_ECO, Total_Monto_Cobros_Eco, Cant_Documentos_Cobro_ECO, Total_Cobro_Permitido_ECO
tipo_cobro_ECO = false : Total_Monto_Cobros_Eco = 0 : Total_Cobro_Permitido_ECO = 0 : Cant_Documentos_Cobro_ECO = 0

dim tipo_cobro_ECO_EXP, Total_Monto_Cobros_Eco_Exp, Cant_Documentos_Cobro_ECO_EXP, Total_Cobro_Permitido_ECO_EXP
tipo_cobro_ECO_EXP = false : Total_Monto_Cobros_Eco_Exp = 0 : Total_Cobro_Permitido_ECO_EXP = 0 : Cant_Documentos_Cobro_ECO_EXP = 0

if Session("xEconomato_tope") <> "" then
  for k = 1 to Numero_documentos_cobro
    'ANumero_documento_cobro(n) = clng( "0" & Request.Form("Numero_documento_cobro_" & n ) )
    'Response.Write "[" & ANumero_documento_cobro(n) & "]"
    'Response.Write Request.Form("Tipo_documento_cobro_" & (n))
    ADocumento  = split( Request.Form("Tipo_documento_cobro_" & k ) & ";0;0" ,";" )
    'Response.Write ADocumento(0) & " -- "
    AMontoCobro = Request.Form("Monto_documento_cobro_" & k )
    if ADocumento(0) = "ECO" then 
      tipo_cobro_ECO = true
      Total_Monto_Cobros_Eco = cdbl(Total_Monto_Cobros_Eco) + cdbl(AMontoCobro)
      Cant_Documentos_Cobro_ECO = cdbl(Cant_Documentos_Cobro_ECO)  + 1
      'exit for
    end if
    'Response.Write AMontoCobro & " ## "
    'Response.Write "Tipo cobro: " & ADocumento(0) & ", otro (1): " & ADocumento(1) & ", otro (2): " & ADocumento(2)
    'Response.Write "Anterior: " & Request.Form("DocumentoSeleccionado_" & k)
    'Response.Write Numero_documentos_cobro
    'Response.Write Request.Form("Tipo_documento_cobro_" & k)    
    v_ultimo_tipo_cobro = ADocumento(0)
  next
  Total_Cobro_Permitido_ECO = cdbl(Cant_Documentos_Cobro_ECO) * ( cdbl(Session("xEconomato_tope")) + cdbl(Session("xEconomato_supera_tope")) )
end if

if session("saldo_empleado_ECO_EXP") <> "" then
  for k = 1 to Numero_documentos_cobro
    ADocumento  = split( Request.Form("Tipo_documento_cobro_" & k ) & ";0;0" ,";" )
    AMontoCobro = Request.Form("Monto_documento_cobro_" & k )
    if ADocumento(0) = "EXP" then 
      tipo_cobro_ECO_EXP = true
      Total_Monto_Cobros_Eco_Exp = cdbl(Total_Monto_Cobros_Eco_Exp) + cdbl(AMontoCobro)
      Cant_Documentos_Cobro_ECO_EXP = cdbl(Cant_Documentos_Cobro_ECO_EXP)  + 1
    end if
    v_ultimo_tipo_cobro = ADocumento(0)
  next
  Total_Cobro_Permitido_ECO_EXP = cdbl(session("saldo_empleado_ECO_EXP"))
end if
'Response.Write tipo_cobro_ECO_EXP
'Response.End

v_num_int_DVT_activa = Get_Numero_Interno_DVT_Activa_X_Login(Session("Login"))

' ------------------------------------- Modificar Precio o Descuento ---------------------------------

'if Error_descuento_documento = "" then

Descuento = 0

if Accion_a_ejecutar = "Modificar" or Accion_a_ejecutar = "ModificarPrecio" then

   if Accion_a_ejecutar = "ModificarPrecio" then
      Descuento = ( 1 - ( cdbl( Request("Precio_" & Request("Linea") ) ) / cdbl( Request("Precio_de_lista_modificado_" & Request("Linea")) ) ) ) * 100
   else
        Descuento = Request( "Descuento_linea_" & Request("Linea") )        
        if len(trim(Descuento)) > 0 then
            if IsNumeric(Descuento) Then
                Descuento = Cdbl(Descuento)
            else
                Descuento = 0
            end if
        else
            Descuento = 0
        end if
   end if

'response.write 1 & "-" & Descuento

   if not Session("Permite_hacer_descuento_empleado") then
      Descuento = 0
'response.write 2 & "-" & Descuento
   else
      if Descuento > Session("Maximo_descuento_cajera") then
         Descuento = Session("Maximo_descuento_cajera")
      end if
      if Descuento > Session("Maximo_descuento_linea") then
         Descuento = Session("Maximo_descuento_linea")
      end if 
      if Descuento > Session("Maximo_descuento_cabecera") then
         Descuento = Session("Maximo_descuento_cabecera")
      end if 
   end if 

   if Descuento >= 0 then
      if Session("Porcentaje_descuento_institucional") > Descuento then
         Descuento = Session("Porcentaje_descuento_institucional")
      end if
      Porcentaje_descuento_promocion = cdbl( Request( "Porcentaje_descuento_promocion_" & Request("Linea") ) )
      if Porcentaje_descuento_promocion > Descuento then
         Descuento = Porcentaje_descuento_promocion
      end if
   end if
   sql = "Exec MOP_Modifica_descuento_linea_DVT '"  & _
                       Session("Login") & "', "     & _
                       Request("Linea") & ", "      & _
                       CdBL( "0" + Descuento)

   Conn.execute( sql )

end if

Total_pesos = 0 : Total_cif_ori = 0 : total_productos = 0 : Existe_Mayorista_en_Lista_DVT = false
Total_pesos_ECO = 0 : Total_Pesos_Eco_Tope = 0 : Total_Pesos_ECO_Supera_Tope = 0
cant_prod_eco_sobre_el_tope = 0
Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
do while not rs.eof
      Es_Kit = Rs("Es_Kit")
    
      'OJO - Colocar toda esta rutina en subrutina ya que se usa en dos partes
      Precio = cdbl( rs("Precio_de_lista_modificado") )
      v_cantidad_salida = rs("cantidad_salida")
      Descuento_linea = cdbl( rs("Porcentaje_descuento_1") ) + cdbl(rs("Porcentaje_descuento_2"))
      Descuento1 = Rs("Porcentaje_descuento_1")
        if IsNull(Descuento1) then Descuento1 = 0
      Promocion = Rs("Promocion_nombre")
      
      
      Porcentaje_descuento_3 = 0
      if not IsNull(trim(rs("Porcentaje_descuento_3"))) then Porcentaje_descuento_3 = cdbl(rs("Porcentaje_descuento_3")) 
      
        If Promocion = "0" Then Promocion = ""
        If IsNull(Promocion) Then Promocion = ""
        if len(trim(Promocion)) = 0 then 'Si no esta dentro de una promoción
            if Es_Kit = "N" then
    'Response.Write Descuento_linea & " ** "
                if Descuento_linea >=0 then
                  if Descuento_documento > Descuento_linea and Descuento_linea = 0 then
                     Descuento_linea = Descuento_documento
                  end if
            
                  if Session("Porcentaje_descuento_institucional") > Descuento_linea then
                     Descuento_linea = Session("Porcentaje_descuento_institucional")
                  end if

    'Response.Write Session("Maximo_descuento_cajera") & " **** " & Descuento_linea & " ** "
    
                  if Descuento_linea > Session("Maximo_descuento_cajera") then
                     Descuento_linea = Session("Maximo_descuento_cajera")
                  end if
                  if Descuento_linea > Session("Maximo_descuento_linea") then
                     Descuento_linea = Session("Maximo_descuento_linea")
                  end if 
                  if Descuento_linea > Session("Maximo_descuento_cabecera") then
                     Descuento_linea = Session("Maximo_descuento_cabecera")
                  end if 
                    
                    if Session("Porcentaje_descuento_empleado") > 0  and Session("xBloqueado") <> "S" then
                        Descuento_linea = Descuento_documento ' Descuento al documento    
                        if Session("Permite_hacer_descuento_empleado") then 'true o false
                             if Session("Porcentaje_descuento_empleado") >= 90 and Session("Porcentaje_descuento_empleado") < 100 then
                                Monto_descuento = ( Precio * ( Descuento_linea / 100 ) \ 1 )
                                Porcentaje_descuento_empleado = ( Session("Porcentaje_descuento_empleado") / 100 )
                                ILA = cdbl(rs("Porcentaje_ILA"))/100 'Francisco
                                uno=(((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0041+(100-Session("Porcentaje_descuento_empleado"))/100)))*(ILA))
                                dos=(cdbl(rs("Costo_cif_ori_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*ILA)
                                if uno>=dos then
                                    precio_con_descuento=(((((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0041+(100-Session("Porcentaje_descuento_empleado"))/100)))*(1+ILA))))
                                    'precio_con_descuento = cint(precio_con_descuento/10)*10
                                    precio_con_descuento = cdbl(precio_con_descuento) - cdbl(precio_con_descuento mod 10) ' Mod Cristian
                                    Monto_descuento_empleado = PRECIO - precio_con_descuento
                                else
                                    precio_con_descuento=(((((cdbl(rs("Costo_cpa_US$"))*cdbl(rs("Valor_paridad_moneda_oficial")))+(cdbl(rs("Costo_cif_adu_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*(0.022+0.0041+(100-Session("Porcentaje_descuento_empleado"))/100)))+(cdbl(rs("Costo_cif_ori_US$"))*cdbl(rs("Valor_paridad_moneda_oficial"))*ILA))))
                                    'precio_con_descuento = cint(precio_con_descuento/10)*10
                                    precio_con_descuento = cdbl(precio_con_descuento) - cdbl(precio_con_descuento mod 10) ' Mod Cristian
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
                                Monto_descuento_empleado =  ( ( ( ( ( Precio_sin_ILA - ( Costo_CPA + ( Costo_CIF_ADU * ( 0.022 + 0.0041 ) ) ) ) * Porcentaje_descuento_empleado)) * (1+ILA) ) \ 10 ) * 10 'Francisco
                                if Monto_descuento_empleado > Monto_descuento then
                                   Descuento_linea = ( 1 - ( ( Precio - Monto_descuento_empleado ) / Precio ) ) * 100
                                   
                                end if                            
                            end if
                        end if
                    end if    
                end if
            else
                Descuento_linea = 0
            end if
        else
            'Aquí se ajusta el precio de la promocion, NO ! se hace en la mantención
           'if Precio - ( ( Precio \ 10 ) * 10 ) >= 5 then
           '   Precio = ( ( Precio \ 10 ) * 10 ) + 10
           'else
           '   Precio = ( ( Precio \ 10 ) * 10 )
           'end if
        end if

    'Response.Write "Promocion: " & Promocion & "Descuento_linea: " & Descuento_linea & "<br>"
    
    if cDbl(Descuento1) = 0 then
        
        if Descuento_linea <> cdbl( rs("Porcentaje_descuento_1") ) + cdbl(rs("Porcentaje_descuento_2")) then
            cSql = "Exec MOP_Modifica_descuento_linea_DVT '"   & _
                     Session("Login") & "', "   & _
                     rs("Numero_de_linea") & ", "  & _
                     cDBL( "0" + Descuento_linea)
            Conn.execute( cSql )
        end if
    end if
    
    temporada = trim(Ucase(rs("temporada")))
        
	  '********************************************************************************
    '***************** MODIFICACION PARA PRODUCTOS MAYORISTAS EN PROMOCION **********
    '********************************************************************************      
    if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" then 
      Descuento_linea = 0
      Existe_Mayorista_en_Lista_DVT = true
    end if
    
    'if tipo_cobro_ECO then 'Mod: X descuentos ECONOMATO
    if tipo_cobro_ECO and Session("xEconomato_temporada") <> "" then
      'Marcar linea de producto con el descuento Economato para que al finalizar la venta se realicen los decuentos que corresponden
      'se utiliza el campo porcentaje_descuento_3 para marcar los productos que pasaron con economato
      
      x_superfamilia  = Left(rs("producto"),1)
      'x_familia       = Right(Left(rs("producto"),3),2)
      'if x_superfamilia = "J" then
      '  if x_familia="HS" or x_familia="MY" or x_familia="FI" then 
      '    x_familia = Right(Left(rs("producto"),3),2)
      '  else
      '    x_familia = ""
      '  end if
      'else
        x_familia = ""
      'end if
      if len(trim(Promocion)) = 0 and Session("Porcentaje_descuento_empleado") = 0 and Es_Kit="N" and Session("xEconomato_temporada") <> "" then
        Descuento_linea = cdbl(Get_Porcentaje_Descuento_Producto_X_Economato(Session("xEconomato"), x_superfamilia, x_familia))
      end if
      'Chequear Precio final del producto al aplicarle el descuento de economato--> puede quedar con pesos unitarios
      'en ese caso se deben sacar los pesos calculando un porcentaje de descuento mayor que el descuento del eco que haga
      'que el precio final quede sin pesos unitarios
      v_precio = Precio * ( ( 100 - Descuento_linea ) / 100 ) \ 1
      v_precio = cdbl(v_precio) - cdbl(v_precio mod 10)
      Descuento_linea = Round(100 - v_precio * 100 / Precio,4)
      'Response.Write Descuento_linea & "-"
      'Response.End
      
      Total_pesos_ECO = cdbl(Total_pesos_ECO) + (cdbl(v_precio) * cdbl(v_cantidad_salida))
      'Response.Write "xEconomato_tope: "&Session("xEconomato_tope")&", Cant_Documentos_Cobro_ECO: "&Cant_Documentos_Cobro_ECO&", Total_pesos_ECO: "&Total_pesos_ECO&",  Total_Cobro_Permitido_ECO: "&Total_Cobro_Permitido_ECO
      if Total_pesos_ECO <= Total_Cobro_Permitido_ECO then
        if (cdbl(Total_Pesos_Eco_Tope) + (cdbl(v_precio) * cdbl(v_cantidad_salida))) <= cdbl(Session("xEconomato_tope")) then Total_Pesos_Eco_Tope  = cdbl(Total_Pesos_Eco_Tope) + (cdbl(v_precio) * cdbl(v_cantidad_salida))
        
        if len(trim(Promocion)) = 0 and Session("Porcentaje_descuento_empleado") = 0 and Es_Kit="N" and Session("xEconomato_temporada") <> "" then     
          'Aplicar descuentos de economato a productos que no están en promoción, que no tengan descuento personal y que no sea un KIT
          strSQL="update movimientos_productos set producto=producto, " &_
                 "porcentaje_descuento_3="&Descuento_linea&", temporada='ECO' " &_
                 "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Rs("producto")&"' " &_
			           "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
			    Conn.Execute(strSQL)
        end if
      else
        if cant_prod_eco_sobre_el_tope = 0 then 'Se está en el producto que produjo que el total del precio se pasará del total del covenio del ECO
          'Se permite hacer descuento al producto, pero al siguiente producto que viene ya no se aplica el descuento
          if len(trim(Promocion)) = 0 then
            '**********************************************************************************************************
            'Sólo se debe hacer el cálculo del descuento proporcional para los productos que NO están en PROMOCION
            '**********************************************************************************************************
            Descuento_linea = cdbl(Get_Porcentaje_Descuento_Producto_X_Economato(Session("xEconomato"), x_superfamilia, x_familia))
          
            '$$$$$$$$$$ EL DESCUENTO QUE SE APLICA EN ESTE CASO ES SOBRE EL TOTAL DEL CONVENIO (o lo que quedé como diferencia del convenio)
          
            'dif_resto_ECO_1 = cdbl(Session("xEconomato_tope"))* Cant_Documentos_Cobro_ECO - (cdbl(Total_pesos_ECO) - cdbl(Precio)) 'Diferencia de lo quede del ECO
            'if dif_resto_ECO_1 > cdbl(Session("xEconomato_tope")) * Cant_Documentos_Cobro_ECO then dif_resto_ECO_1 = cdbl(Session("xEconomato_tope")) * Cant_Documentos_Cobro_ECO
          
            dif_resto_ECO_1 = cdbl(Total_Cobro_Permitido_ECO)* Cant_Documentos_Cobro_ECO - (cdbl(Total_pesos_ECO) - (cdbl(Precio) * cdbl(v_cantidad_salida))) 'Diferencia de lo quede del ECO
            if dif_resto_ECO_1 > cdbl(Total_Cobro_Permitido_ECO) * Cant_Documentos_Cobro_ECO then dif_resto_ECO_1 = cdbl(Session("xEconomato_tope")) * Cant_Documentos_Cobro_ECO
          
          
            'Response.Write Precio
            'Response.End
            dif_resto_ECO_2 = dif_resto_ECO_1 * ( ( 100 - Descuento_linea ) / 100 ) \ 1
            dif_resto_ECO_2 = cdbl(dif_resto_ECO_2) - cdbl(dif_resto_ECO_2 mod 10)
            dif_resto_ECO_1_2 = cdbl(dif_resto_ECO_1) - cdbl(dif_resto_ECO_2)
          
            Descuento_linea = Round(dif_resto_ECO_1_2 * 100 / Precio,4) 'Nuevo descuento línea de acuerdo
          
            'Response.Write descuento_linea & "-"
          
            'Chequear Precio final del producto al aplicarle el descuento de economato--> puede quedar con pesos unitarios
            'en ese caso se deben sacar los pesos calculando un porcentaje de descuento mayor que el descuento del eco que haga
            'que el precio final quede sin pesos unitarios
            v_precio = Precio * ( ( 100 - Descuento_linea ) / 100 ) \ 1
            v_precio = cdbl(v_precio) - cdbl(v_precio mod 10)
            Descuento_linea = Round(100 - v_precio * 100 / Precio,4)
                      
            if len(trim(Promocion)) = 0 and Session("Porcentaje_descuento_empleado") = 0 and Es_Kit="N" and Session("xEconomato_temporada") <> "" then     
              'Aplicar descuentos de economato a productos que no están en promoción, que no tengan descuento personal y que no sea un KIT
              strSQL="update movimientos_productos set producto=producto, " &_
                     "porcentaje_descuento_3="&Descuento_linea&", temporada='ECO' " &_
                     "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Rs("producto")&"' " &_
			               "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
			        Conn.Execute(strSQL)
            end if
            cant_prod_eco_sobre_el_tope = 1
          end if
        else 
          if len(trim(Promocion)) = 0 then
            '**********************************************************************************************************
            'Sólo se debe limpiar el descuento de los productos que NO están en PROMOCION
            '**********************************************************************************************************
            Descuento_linea = 0 'El total de monto pasó el tope del economato--> No se pueden realizar mas descuentos a los siguientes productos de la lista
            if temporada = "ECO" then 'Limpiar descuentos de productos que anteriormente se le aplicó descuento de economato
              strSQL="update movimientos_productos set producto=producto, " &_
                     "porcentaje_descuento_3="&Descuento_linea&", temporada=null " &_
                     "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Rs("producto")&"' " &_
			               "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
              Conn.Execute(strSQL)
            end if
          end if
        end if
      end if
    end if
    if cint(Numero_documentos_cobro) = 0 or ( cint(Numero_documentos_cobro)=1 and v_ultimo_tipo_cobro <> "ECO") then
      'Limpiar los posibles productos que hayan sido cargados anteriormente como economato porcentaje_descuento_3=0, temporada=null
      'Sólo para temporadas = 'ECO'
      if temporada = "ECO" then
        strSQL="update movimientos_productos set producto=producto, " &_
               "porcentaje_descuento_3=0, temporada=null " &_
               "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Rs("producto")&"' " &_
			         "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
        'Response.Write strSQL
        'Response.End
        Conn.Execute(strSQL)
      end if
    end if
    'Response.End
    'Response.Write descuento_linea & "-"
    Precio = ( Precio * ( ( 100 - Descuento_linea ) / 100 ) \ 1 )
    

   Total_pesos = Total_pesos + ( cdbl(rs("Cantidad_salida")) * Precio )
   Total_cif_ori = Total_cif_ori + ( cint(rs("Cantidad_salida")) * cdbl(rs("Costo_cif_ori_US$")) )
   if len(ltrim(trim(rs("Imagen_producto")))) > 0 then
      Imagen_actual = "../../imagenes/productos/" & ltrim(rs("Imagen_producto"))
   end if
   total_productos = total_productos + 1
   
   'Response.Write "Total_pesos: " &Total_pesos& ", Precio: "&Precio&", Descuento_linea: " & Descuento_linea & "<br>"
   
   rs.movenext
loop
'Response.End
rs.close
set rs = nothing
%>

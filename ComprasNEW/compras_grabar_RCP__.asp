<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
documento_respaldo       = Request.Form("documento_respaldo")
documento_respaldo_final = documento_respaldo
'if documento_respaldo = "DS" then documento_respaldo_final = "R" '--> Mod: cmartinez 20161123, comentar esta linea si se quiere grabar como DS

numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
bodega                                  = Request.Form("bodega")

nom_tabla = "movimientos_productos"
OpenConn

numero_documento_no_valorizado_RCP  = Get_Nuevo_Numero_Documento_no_Valorizado_X_Documento_Respaldo("RCP")
v_codigo_LPrecio                    = Get_Codigo_Lista_Precio_LP_BASE

'#############################################################
'----------- Actualizar Atributos ANTERIORES ----------
'#############################################################      
Conn.BeginTrans

strSQL="update productos set " &_
       "anterior_costo_cif_ori_US$=P.ultimo_costo_cif_ori_US$, " &_
       "anterior_costo_cif_adu_US$=P.ultimo_costo_cif_adu_US$, " &_
       "anterior_costo_cpa_US$=P.ultimo_costo_cpa_US$, " &_
       "anterior_delta_cpa_US$=P.delta_cpa_US$ " &_
       "from Productos P inner join " &_
       "(select producto " &_
       "from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&") M on " &_
       "P.producto=M.producto and P.Empresa='SYS'"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:45" 
  Response.End
end if

'#############################################################
'--------------------- Traspasar TCP a RCP -------------------
'-------------------- DOCUMENTO NO VALORIZADO ----------------
'#############################################################
strSQL="update documentos_no_valorizados set documento_no_valorizado='RCP', documento_respaldo='"&documento_respaldo_final&"', " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado_RCP&" where empresa='SYS' and " &_
       "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo&" and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
'Response.Write strSQL&"<br><br>"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:63" 
  Response.End
end if
'#############################################################
'----------- Actualizar Atributos Maestro Productos ----------
'#############################################################      
strSQL="update productos set " &_
       "Fecha_ultimos_costos=M.fecha_movimiento, Ultimo_Proveedor=M.proveedor, " &_
       "nombre=M.nombre_producto, nombre_producto_proveedor_habitual=M.nombre_producto_proveedor, " &_
       "porcentaje_impuesto_1=M.porcentaje_ila, nombre_para_boleta=M.nombre_para_boleta, " &_
       "Ultimo_nombre_producto_proveedor=M.nombre_producto_proveedor, " &_
       "Cantidad_um_compra_en_caja_envase_compra=M.Cantidad_um_compra_en_caja_envase_compra, " &_
       "Cantidad_x_un_consumo=M.cantidad_x_un_consumo, " &_
       "cantidad_mercancias=M.cantidad_entrada, " &_
       "Ultimo_costo_CIF_ADU_US$=M.costo_cif_adu_us$, ultimo_costo_cif_ori_US$=M.costo_cif_ori_US$, " &_
       "Ultimo_costo_CPA_$=M.costo_cpa_$, Ultimo_costo_CPA_US$=M.costo_cpa_US$, " &_
       "Ultimo_costo_EX_FAB_moneda_origen=M.Costo_EX_FAB_moneda_origen, " &_
       "Ultimo_costo_EX_FAB_US$=M.Costo_EX_FAB_US$, " &_
       "Ultimo_costo_FOB_moneda_origen=M.Costo_FOB_moneda_origen, " &_
       "Ultimo_costo_FOB_US$=M.Costo_FOB_US$, " &_
       "Peso_x_caja=M.Peso_x_caja, cantidad_x_caja=M.cantidad_x_caja, delta_cpa_us$=M.delta_cpa_us$, " &_
       "alto=M.alto, ancho=M.ancho, largo=M.largo, peso=M.peso, " &_
       "Codigo_arancelario=M.Codigo_arancelario, temporada=M.temporada," &_
       "Fecha_impresion=M.Fecha_impresion, " &_
       "Unidad_de_medida_compra = M.Unidad_de_medida_compra, " &_
       "Unidad_de_medida_consumo = M.Unidad_de_medida_consumo, " &_
       "Producto_proveedor_habitual = M.Producto_proveedor, " &_
       "Proveedor_origen = M.Proveedor_origen " &_
       "from Productos P inner join " &_
       "(select producto, fecha_movimiento, proveedor, " &_
       "nombre_producto, nombre_producto_proveedor, " &_
       "porcentaje_ila, nombre_para_boleta, " &_
       "cantidad_um_compra_en_caja_envase_compra, " &_
       "Cantidad_x_un_consumo, " &_
       "cantidad_entrada, " &_
       "costo_cif_adu_us$, costo_cif_ori_US$, " &_
       "costo_cpa_$, costo_cpa_US$, " &_
       "Costo_EX_FAB_moneda_origen, " &_
       "Costo_EX_FAB_US$, " &_
       "Costo_FOB_moneda_origen, " &_
       "Costo_FOB_US$, " &_
       "Peso_x_caja, cantidad_x_caja, delta_cpa_us$, " &_
       "alto, ancho, largo, peso, Codigo_arancelario, temporada, " &_
       "Fecha_impresion, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
       "Producto_proveedor, Proveedor_origen " &_
       "from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&") M on " &_
       "P.producto=M.producto and P.Empresa='SYS'"
'Response.Write strSQL
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:121"
  Response.End
end if
'#############################################################
'--------------------- Traspasar TCP a RCP -------------------
'-------------------- MOVIMIENTOS PRODUCTOS ------------------
'#############################################################
strSQL="insert into "&nom_tabla&"(Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
       "Cantidad_de_RCP_disponible_para_vender, Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
       "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
       "Costo_EX_FAB_moneda_origen, Costo_EX_FAB_US$, Costo_FOB_moneda_origen, Costo_FOB_US$, " &_
       "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
       "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , Numero_recepcion_de_compra, Numero_de_linea, " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra, Numero_documento_no_valorizado, Numero_interno_documento_no_valorizado, Observaciones, " &_
       "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
       "Producto_final_o_insumo, Tipo_documento_de_compra , Tipo_producto,Valor_paridad_moneda_oficial, " &_
       "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo,  " &_
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias, Unidad_de_medida_compra, " &_
       "Unidad_de_medida_consumo, Producto_proveedor, Proveedor_origen, Codigo_antiguo, codcaja, unidad_de_medida_origen, cantidad_origen, " &_
       "numero_de_linea_ordenado_agrupado_bodega, numero_de_linea_item_base_agrupado_bodega, Numero_de_orden_sub_item_agrupado_bodega, es_item_base_agrupado_bodega, " &_
       "cantidad_um_compra_en_caja_envase_compra, " &_
       "Numero_guia_de_despacho_o_factura_proveedor, Pais_de_procedencia )" &_
       "(SELECT  " &_
       "Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
       "Cantidad_de_RCP_disponible_para_vender, round(Costo_CIF_ADU_US$ * Valor_paridad_moneda_oficial,0), Costo_CIF_ADU_US$, " &_
       "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
       "Costo_EX_FAB_moneda_origen,  Costo_EX_FAB_US$, Costo_FOB_moneda_origen, Costo_FOB_US$, " &_
       "'RCP', '" & session("Login") & "', Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
       "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , "&numero_documento_no_valorizado_RCP&", Numero_de_linea, " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra,"&numero_documento_no_valorizado_RCP&", Numero_interno_documento_no_valorizado, Observaciones, " &_
       "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
       "Producto_final_o_insumo, '"&documento_respaldo_final&"' , Tipo_producto,Valor_paridad_moneda_oficial, " &_
       "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo, " &_
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
       "Producto_proveedor, Proveedor_origen, Codigo_antiguo, codcaja,  unidad_de_medida_origen, cantidad_origen, " &_
       "numero_de_linea_ordenado_agrupado_bodega, numero_de_linea_item_base_agrupado_bodega, Numero_de_orden_sub_item_agrupado_bodega, es_item_base_agrupado_bodega, " &_
       "cantidad_um_compra_en_caja_envase_compra, " &_
       "Numero_guia_de_despacho_o_factura_proveedor, Pais_de_procedencia " &_
       "from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&")"

 

'Response.Write strSQL&"<br><br>"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:166"
  Response.End
end if

'#############################################################
'------------- Eliminar promociones en productos -------------
'#############################################################
strSQL="delete productos_en_promociones where Empresa='SYS' and producto IN " &_
       "(SELECT producto from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&")"
'Response.Write strSQL&"<br><br>"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:184"
  Response.End
end if
'#############################################################
'--------------- Actualizar Stock en Transito ----------------
'#############################################################      
strSQL="update Productos_en_bodegas set " &_
       "Stock_en_transito=Stock_en_transito - M.cantidad_entrada " &_
       "from Productos_en_bodegas P inner join " &_
       "(select producto, sum(cantidad_entrada) cantidad_entrada from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and Numero_de_linea_en_RCP_o_documento_de_compra_padre is not null and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" " &_
       "group by producto) M on " &_
       "P.producto=M.producto and " &_
       "P.Empresa='SYS' and P.bodega='"&bodega&"'"
'Response.Write strSQL
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:206"
  Response.End
end if
'Conn.CommitTrans
'Conn.RollbackTrans
''Conn.close
'###############################################################################################
'----------- Actualizar precios de los productos que modificaron su precio de venta en TCP------
'###############################################################################################
strSQL="select producto, precio_de_lista_modificado from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
       "precio_de_lista_modificado<>precio_de_lista"
'Response.Write strSQL
'Response.End
v_codigo_LPrecio  = "L01"
v_codigo_LPrecio2 = "L02"
set rs_itemes = Conn.Execute(strSQL)

strSQL1 = ""
strSQL2 = ""

do while not rs_itemes.EOF
  producto  = trim(rs_itemes("producto"))
  valor     = trim(rs_itemes("precio_de_lista_modificado"))
  
  '###### L01 #######
  strSQL1 = strSQL1 & "Exec PLP_Borra_Producto_en_Lista_de_precios '"&v_codigo_LPrecio&"', '"&producto&"'; "
  'Conn.Execute(strSQL)
  'if err <> 0 then
  '  Conn.RollbackTrans
  '  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:237"
  '  Response.End
  'end if
  
  strSQL2 = strSQL2 & "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio&"', '"&producto&"', 0, '$', "&valor&", 0; "
  'Conn.Execute(strSQL)
  'if err <> 0 then
  '  Conn.RollbackTrans
  '  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:244"
  '  Response.End
  'end if

  '###### L02 ######
  
  rs_itemes.MoveNext
loop
rs_itemes.close
set rs_itemes = Nothing

' Se cambia por ciclo FOR
IF FALSE THEN
	IF LEN(strSQL1) > 0 THEN
	  Conn.Execute(strSQL1)
	  if err <> 0 then
		Conn.RollbackTrans
		Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:332"
		Response.End
	  end if
	END IF
	IF LEN(strSQL2) > 0 THEN
	  Conn.Execute(strSQL2)
	  if err <> 0 then
		Conn.RollbackTrans
		Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:340"
		Response.End
	  end if
	END IF
ELSE
	IF LEN(strSQL1) > 0 THEN
		arraySQL = Split( strSQL1, ";" )
		for i =  0 to ubound(arraySQL) - 1
			IF LEN( arraySQL(i) ) > 0 THEN
			  Conn.Execute(arraySQL(i))
			  if err <> 0 then
				Conn.RollbackTrans
				Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:284"
				Response.End
			  end if
			END IF
		next
	END IF
	IF LEN(strSQL2) > 0 THEN
		arraySQL = Split( strSQL2, ";" )
		for i =  0 to ubound(arraySQL) - 1
			IF LEN( arraySQL(i) ) > 0 THEN
			  Conn.Execute(arraySQL(i))
			  if err <> 0 then
				Conn.RollbackTrans
				Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:284"
				Response.End
			  end if
			END IF
		next
	END IF
END IF

'###############################################################################################
'----------- Actualizar stock minimo de los productos segun los productos de la TCP-------------
'###############################################################################################
IF TRUE THEN
	cadenaProductos = ""
	strSQL="select producto " &_
		   "from "&nom_tabla&" with(nolock) " &_
		   "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
		   "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
		   "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
		   "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
		   "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
	set rs = Conn.Execute(strSQL)
	do while not rs.EOF
		cadenaProductos = cadenaProductos & rs("producto") & "~"
	  rs.movenext
	loop  
	rs.Close
	set rs = Nothing

	IF LEN( cadenaProductos ) >  0 THEN
		arrayProductos = Split( cadenaProductos, "~" )
		for i =  0 to ubound(arrayProductos) - 1
			IF LEN( arrayProductos(i) ) > 0 THEN
			  cSql = "Exec PRO_CALCULA_STOCK_MIN_2 '" & arrayProductos(i) & "'"
			  Conn.Execute(cSql)
			  if err <> 0 then
				Conn.RollbackTrans
				Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:368"
				Response.End
			  end if
			END IF
		next
	END IF
END IF

'###############################################################################################
'----------- SE GRABA LA UFC QUE CORRESPONDE A LAS RCP PERO EN LA PARTE CONTABLE---------------
'###############################################################################################
GrabarUFCenCarpetas = "N"
cSQL = "Exec PAR_ListaParametros 'AsienUFCCarp'"
set rs = Conn.Execute( cSQL )
if Not rs.Eof then
	GrabarUFCenCarpetas = ucase( ltrim( rs( "VALOR_TEXTO" ) ) )
end if
rs.Close
set rs = Nothing

IF GrabarUFCenCarpetas = "N" THEN
    ''OpenConn
    ''Conn.BeginTrans
    strSql = "select Documento_respaldo, Numero_documento_respaldo, Proveedor, Monto_neto_US$ = Round(Monto_adu_US$,2), Fecha_recepcion, Paridad_conversion_a_dolar " & _
             "from documentos_no_valorizados where numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado
    set rs_registros = Conn.Execute(strSQL)
    if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:355, " & strSql
        Response.End
    end if
    if trim(rs_registros("Documento_respaldo")) = "Z" then
      strSQL = " select Documento_respaldo = max(Tipo_documento_de_compra)," &_ 
	             " Numero_documento_respaldo = max(numero_documento_de_compra)," &_
	             " Proveedor," &_ 
	             " Monto_neto_US$ = Round(sum(Costo_CIF_ADU_US$ * Cantidad_entrada),2)," &_ 
	             " Fecha_recepcion = max(fecha_movimiento)," &_
	             " Paridad_conversion_a_dolar = max(Valor_paridad_moneda_oficial )" &_
               " from movimientos_productos " &_
               " where empresa='SYS' and documento_no_valorizado='TCP' and numero_documento_de_compra= " & numero_documento_respaldo &_
               " and Tipo_documento_de_compra ='"&documento_respaldo&"'" &_
               " and year(fecha_movimiento) = year(getdate()) group by proveedor"
      set rs_registros = Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:372"
        Response.End
      end if
    end if
    'rs_registros.movefirst
    do while rs_registros.eof = false 
      numero_documento_de_compra = rs_registros("Numero_documento_respaldo") 
      Proveedor                  = rs_registros("proveedor")   
      monto_dolar                = rs_registros("Monto_neto_US$")
      Fecha_recepcion            = month(rs_registros("fecha_recepcion"))&"/"&day(rs_registros("fecha_recepcion"))&"/"&year(rs_registros("fecha_recepcion"))
      valor_paridad              = rs_registros("Paridad_conversion_a_dolar")
      valor_pesos                = cdbl(rs_registros("Monto_neto_US$")) * cdbl(rs_registros("Paridad_conversion_a_dolar"))
  
      strsql = "select Valor_numerico	from Parametros  Where	Parametro = 'FOLCONTAB'"
      set rs_folio = Conn.Execute(strsql)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:389"
        Response.End
      end if
      folio_contabilizacion = cdbl(rs_folio("valor_numerico")) + 1
	  rs_folio.close
	  set rs_folio = Nothing
	  
      strsql = "Update	Parametros  Set	Valor_numerico = IsNull(Valor_numerico, 0) + 1  Where	Parametro = 'FOLCONTAB'"
      Conn.Execute(strsql)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:398"
        Response.End
      end if
  
      strsql = "Exec Dov_graba_facturaCompraUS$ 0,'SYS',"&numero_documento_de_compra&",'"&fecha_recepcion&"',0,'"&Proveedor&"','"&fecha_recepcion&"','','',"&folio_contabilizacion&",'"&fecha_recepcion&"','"&session("Login")&"',"&monto_dolar&","&valor_paridad&",0,''"
      strsql = strsql & ", Null, 'O', 'CPA', '" & documento_respaldo & "'"
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:406"
        Response.End
      end if
  
      strsql = "Select Numero_interno_documento_valorizado = Max(Numero_interno_documento_valorizado)" &_ 
               "From  Documentos_valorizados (NoLock)" &_ 
               "Where Empresa = 'SYS' And Documento_valorizado = 'UFC' And Numero_documento_valorizado = "&numero_documento_de_compra
      set rs = Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:416"
        Response.End
      end if
      Numero_interno_documento_valorizado = rs("Numero_interno_documento_valorizado")
	  rs.close
	  set rs = Nothing
	  
      strsql = "exec DNV_Rescata_NUmero_ACO_FAC " & Numero_interno_documento_valorizado
      set rs = Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:419"
        Response.End
      end if
      numero_documento_no_valorizado_asiento_insert = rs("numero_documento_no_valorizado_asiento_insert")
	  rs.close
	  set rs = Nothing
  
      strsql = "exec ACO_Borra_primer_registro_asiento_contable_UFC " & Numero_interno_documento_valorizado
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:434"
        Response.End
      end if
  
      strsql = "exec ACO_Graba_AsientoContable_Documento_US$ 0,"&numero_documento_no_valorizado_asiento_insert&",'SYS',Null,NUll,Null,'1181150','"&session("Login")&"','S','"&fecha_recepcion&"',"&valor_pesos&",0,'','"&proveedor&"','"&Session("login")&"',0,"&numero_documento_de_compra&","&Numero_interno_documento_valorizado&",'UFC',0,Null,'"&proveedor&"',"&monto_dolar&",0,"&valor_paridad
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:442"
        Response.End
      end if
      rs_registros.movenext
    loop
END IF
'#############################################################
'--------------------- Eliminar TCP  -------------------
'-------------------- MOVIMIENTOS PRODUCTOS ------------------
'#############################################################
strSQL= "Delete from "&nom_tabla&" " &_
        "where empresa='SYS' and " &_
        "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
        "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
        "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
        "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
        "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" "

 

'Response.Write strSQL&"<br><br>"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:179"
  Response.End
end if
'###############################################################################################
'----------- Actualizar la Fecha de Grabacion y el Estado de la Carpeta -------------
'###############################################################################################
Carpeta = ""
NumeroAduana = ""
strSQL="select Carpeta, Numero_documento_respaldo from Documentos_no_valorizados (nolock) where Numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado
set rs = Conn.Execute(strSQL)
if not rs.eof then
    Carpeta = rs( "Carpeta" )
    NumeroAduana = rs( "Numero_documento_respaldo" )
end if
rs.close
set rs = Nothing

'
f_grabacion = mid( now(),  1, 10 )
fgrabacion = mid( f_grabacion, 7, 4 ) & "/" & Lpad(mid( f_grabacion, 4, 2 ),2,0) & "/" & Lpad(mid( f_grabacion, 1, 2 ),2,0)

if Carpeta <> "" then
    IF documento_respaldo = "TU" then
        strSQL = "update carpetas_final set fecha_grabacion = '" & fgrabacion & "', fecha_llegada = Fecha_recepcion where carpeta = '" & Carpeta & "' "
        'strSQL = "update carpetas_final set fecha_grabacion = '" & fgrabacion & "', id_estado = 4, fecha_llegada = Fecha_recepcion where carpeta = '" & Carpeta & "' "
    else
        strSQL = "update carpetas_final set fecha_grabacion = '" & fgrabacion & "' where carpeta = '" & Carpeta & "' "
        'strSQL = "update carpetas_final set fecha_grabacion = '" & fgrabacion & "', id_estado = 4 where carpeta = '" & Carpeta & "' "
    end if
    Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:500"
        Response.End
      end if
end if
if NumeroAduana <> "" then
    strSQL = "update carpetas_final_detalle "
    strSQL = strSQL & "set Fecha_grabacion = '" & fgrabacion & "', id_estado = 4 "
    strSQL = strSQL & "from carpetas_final cf (nolock), carpetas_final_detalle cfd (nolock) "
    strSQL = strSQL & "where cf.carpeta = '" & Carpeta & "' "
    strSQL = strSQL & "and cf.documento_respaldo = cfd.documento_respaldo "
    strSQL = strSQL & "and cf.anio_mes = cfd.anio_mes "
    strSQL = strSQL & "and cf.num_carpeta = cfd.num_carpeta "
    strSQL = strSQL & "and cfd.Numero_aduana = " & NumeroAduana
    Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:516"
        Response.End
      end if

    strSQL = "Exec CPA_EstadoFacturaCompra '" & Carpeta & "'"
    Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:523"
        Response.End
      end if
end if

IF GrabarUFCenCarpetas = "S" THEN
    strSQL = "Exec RCP_Genera_asientos_de_RCP_contra_Facturas_en_Transito "
	strSQL = strSQL & "'SYS', "
	strSQL = strSQL & "'" & session("Login") & "', "
	strSQL = strSQL & "'" & Carpeta & "'"
    Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:537"
        Response.End
      end if
END IF
Conn.CommitTrans
'Conn.RollbackTrans
%>

<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                                  = Request.Form("accion")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
numero_linea                            = Request.Form("numero_linea")
numero_linea_padre                      = Request.Form("numero_linea_padre")
paridad                                 = Request.Form("paridad")
fecha_recepcion                         = Request.Form("fecha_recepcion")
bodega                                  = Request.Form("bodega")
proveedor                               = Request.Form("proveedor")
producto                                = Ucase(Trim(unescape(Request.Form("producto"))))
tipo_dato                               = Request.Form("tipo_dato")


anio                                    = Request.Form("anio")
entidad_comercial                       = Request.Form("entidad_comercial")
entidad_comercial_2                     = Request.Form("entidad_comercial_2")
items                                   = Request.Form("items")

nom_campo   = Unescape(Request.Form("nom_campo"))
valor       = Ucase(trim(Unescape(Request.Form("valor"))))
nom_campo1  = Unescape(Request.Form("nom_campo1"))
valor1      = Ucase(trim(Unescape(Request.Form("valor1"))))
nom_campo2  = Unescape(Request.Form("nom_campo2"))
valor2      = Ucase(trim(Unescape(Request.Form("valor2"))))
nom_campo3  = Unescape(Request.Form("nom_campo3"))
valor3      = Ucase(trim(Unescape(Request.Form("valor3"))))
nom_campo4  = Unescape(Request.Form("nom_campo4"))
valor4      = Ucase(trim(Unescape(Request.Form("valor4"))))
nom_campo5  = Unescape(Request.Form("nom_campo5"))
valor5      = Ucase(trim(Unescape(Request.Form("valor5"))))
nom_campo6  = Unescape(Request.Form("nom_campo6"))
valor6      = Ucase(trim(Unescape(Request.Form("valor6"))))

fecha_recepcion = year(fecha_recepcion) & "/" & month(fecha_recepcion) & "/"&day(fecha_recepcion)
if tipo_dato="2" then 
  if valor <> "" then valor = year(valor) & "/" & month(valor) & "/"&day(valor) 'Date-->fecha vencimiento
end if
nom_tabla = "movimientos_productos"
delimiter = "~"
OpenConn

if accion = "actualizar" then
  if nom_campo = "producto" then
    strSQL="select nombre, nombre_para_boleta, nombre_producto_proveedor_habitual, superfamilia, familia, subfamilia, " &_
           "IsNull(alto,0) alto, IsNull(ancho,0) ancho, IsNull(largo,0) largo, IsNull(peso,0) peso, " &_
           "IsNull(porcentaje_impuesto_1,0) porcentaje_impuesto_1, temporada, IsNull(codigo_arancelario,0) codigo_arancelario, " &_
           "IsNull(cantidad_x_caja,1) cantidad_x_caja, IsNull(peso_x_caja,0) peso_x_caja " &_
           "from productos where empresa='SYS' and producto='"&valor&"'"
    set rs = Conn.Execute(strSQL)
    if not rs.EOF then 
      'Existe el producto-->se deben cargar todos los atributos del producto en la grilla principal de ingreso de datos
      nombre                              = trim(rs("nombre"))
      nombre_para_boleta                  = trim(rs("nombre_para_boleta"))
      nombre_producto_proveedor_habitual  = trim(rs("nombre_producto_proveedor_habitual"))
      superfamilia                        = trim(rs("superfamilia"))
      familia                             = trim(rs("familia"))
      subfamilia                          = trim(rs("subfamilia"))
      alto                                = rs("alto")
      ancho                               = rs("ancho")
      largo                               = rs("largo")
      cantidad_x_caja                     = trim(rs("cantidad_x_caja"))
      volumen                             = Round( (cdbl(alto) * cdbl(ancho) * cdbl(largo)) / 1000000/ cdbl(cantidad_x_caja),6)
      peso_x_caja                         = rs("peso_x_caja")
      peso                                = rs("peso")
      porcentaje_impuesto_1               = rs("porcentaje_impuesto_1")
      temporada                           = trim(rs("temporada"))
      precio                              = Get_Precio_Normal_X_Producto(valor)
      if cdbl(precio) = 0 then precio = 999999
      codigo_arancelario                  = trim(rs("codigo_arancelario"))
      
      strAtributosProd  = nombre            & delimiter
      strAtributosProd  = strAtributosProd  & nombre_producto_proveedor_habitual  & delimiter
      strAtributosProd  = strAtributosProd  & alto                                & delimiter
      strAtributosProd  = strAtributosProd  & ancho                               & delimiter
      strAtributosProd  = strAtributosProd  & largo                               & delimiter
      strAtributosProd  = strAtributosProd  & volumen                             & delimiter
      strAtributosProd  = strAtributosProd  & peso                                & delimiter
      strAtributosProd  = strAtributosProd  & porcentaje_impuesto_1               & delimiter
      strAtributosProd  = strAtributosProd  & temporada                           & delimiter
      strAtributosProd  = strAtributosProd  & precio                              & delimiter
      strAtributosProd  = strAtributosProd  & codigo_arancelario                  & delimiter
      strAtributosProd  = strAtributosProd  & cantidad_x_caja                     & delimiter
      strAtributosProd  = strAtributosProd  & peso_x_caja                         & delimiter
      
      Response.Write strAtributosProd
    
      strSet=" "&nom_campo&"='"&valor&"', Año_recepcion_compra="&year(cdate(fecha_recepcion))&", " &_
             "proveedor='"&proveedor&"', nombre_producto='"&nombre&"', nombre_para_boleta='"&nombre_para_boleta&"', " &_
             "nombre_producto_proveedor='"&nombre_producto_proveedor_habitual&"', " &_
             "superfamilia='"&superfamilia&"', familia='"&familia&"', subfamilia='"&subfamilia&"', " &_
             "porcentaje_ila="&porcentaje_impuesto_1&", temporada='"&temporada&"', " &_
             "precio_de_lista="&precio&", precio_de_lista_modificado="&precio&", " &_
             "Precio_final_con_descuentos_menos_impuestos="&precio&", " &_
             "unidad_de_medida_compra='UN', unidad_de_medida_consumo='UN',cantidad_mercancias=0, " &_
             "alto="&alto&", ancho="&ancho&", largo="&largo&", peso="&peso&", " &_
             "cantidad_x_caja="&cantidad_x_caja&", peso_x_caja="&peso_x_caja&", Delta_CPA_US$=0, " &_
             "codigo_arancelario='"&codigo_arancelario&"'"
    else
      Response.Write "NO_EXISTE"
      Response.End
    end if
  else
    ACTUALIZAR_STOCK_EN_TRANSITO = false
    ' _______________________________________________________________________________________
    '|                                                                                       |
    '| Los campos de la grilla de compras (movimientos_productos) son los mismos que en el   |
    '| maestro de productos (productos) a excepción del "precio" (cambia un poco el nombre   |
    '| del campo en algunos campos, los costos_* son igual ultimo_costo_*), por lo tanto,    |
    '| cada vez que se actualice una celda de la grilla se deberá actualizar el campo actual |
    '| y sus campos asociados en ambas tablas "movimientos_productos" y "productos"          |
    '|_______________________________________________________________________________________|
    
    if nom_campo = "precio_de_lista_modificado" then
      '##########################################################
      '---------------- Actualizar el precio  -------------------
      '##########################################################
      'v_codigo_LPrecio = Get_Codigo_Lista_Precio_LP_BASE
      'strSQL = "Exec PLP_Borra_Producto_en_Lista_de_precios '"&v_codigo_LPrecio&"', '"&producto&"'"
      ''Response.Write strSQL
      'set rs = Conn.Execute(strSQL)
      'strSQL = "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio&"', '"&producto&"', 0, '$', "&valor&", 0"
      ''Response.Write strSQL
      'set rs = Conn.Execute(strSQL)
      
      '-------------------------------
      'strSet = " "&nom_campo&"="&valor&", Precio_de_lista="&valor&", Precio_final_con_descuentos_menos_impuestos="&valor
      strSet = " "&nom_campo&"="&valor
    else
      strSet_t_prod = " Fecha_ultimos_costos='"&fecha_recepcion&"', Ultimo_Proveedor='"&proveedor&"' "  
      nom_campo_t_prod = nom_campo
      if nom_campo = "nombre_producto"            then nom_campo_t_prod = "nombre"
      if nom_campo = "nombre_producto_proveedor"  then nom_campo_t_prod = "nombre_producto_proveedor_habitual"
      if nom_campo = "porcentaje_ila"             then nom_campo_t_prod = "porcentaje_impuesto_1"
      
      if nom_campo_t_prod <> "costo_cif_adu_us$" and nom_campo_t_prod <> "costo_cif_ori_us$" and nom_campo_t_prod <> "costo_cpa_us$" then 
        if tipo_dato="0" then
          strSet_t_prod = strSet_t_prod & ", "&nom_campo_t_prod&"="&valor&" "
        elseif tipo_dato="2" and valor = "" then 
          strSet_t_prod = strSet_t_prod & ", "&nom_campo_t_prod&"=null " 'Fecha vencimiento (fecha_impresion) vacia
        else
          strSet_t_prod = strSet_t_prod & ", "&nom_campo_t_prod&"='"&valor&"' "
        end if
      end if
      
      if nom_campo <> "costo_cif_adu_us$" and nom_campo <> "costo_cif_ori_us$" then
        strSet = " "&nom_campo&"='"&valor&"' "
        if tipo_dato="0" then 
          strSet = " "&nom_campo&"="&valor&" "
        elseif tipo_dato="2" and valor = "" then
          strSet = " "&nom_campo&"=null " 'Fecha vencimiento (fecha_impresion) vacia
        end if
      end if
      
      if nom_campo = "nombre_producto" then 
        strSet_t_prod = strSet_t_prod & ", nombre_para_boleta='"&left(valor,35)&"' "
        strSet_t_prod = strSet_t_prod & ", Ultimo_nombre_producto_proveedor='"&valor&"' "
        if strSet <> "" then strSet = strSet & ", "
        strSet        = strSet & " nombre_para_boleta='"&left(valor,35)&"'"
      end if
      
      if nom_campo4 <> "" then ' "cantidad_um_compra_en_caja_envase_compra" o "cantidad_x_un_consumo"
        strSet_t_prod = strSet_t_prod & ", "&nom_campo4&"="&valor4
        if strSet <> "" then strSet = strSet & ", "
        strSet        = strSet & " "&nom_campo4&"="&valor4
      end if
          
      if nom_campo3 <> "" or nom_campo = "costo_cif_adu_us$" or nom_campo = "costo_cif_ori_us$" then 'Se recalculó la cantidad o se ingresaron costos_totales
        if nom_campo3 <> "" then
          if documento_respaldo = "TU" then 'Se debe actualizar cantidad, cif_ori (valor1) y cif_adu (valor2) por separado (y todos los costos_*)
            valor_cif_adu = valor1
            valor_cif_ori = valor2
          else 'Caso Z o R, se debe actualizar cantidad, cif_ori = cif_adu (valor1), (y todos los costos_*)
            valor_cif_adu = valor1
            valor_cif_ori = valor_cif_adu
          end if
          '############ CANTIDAD ############
          if strSet <> "" then strSet = strSet & ", "
          strSet = strSet & " "&nom_campo3&"="&valor3                                                 'cantidad_entrada
          strSet = strSet & ", Cantidad_de_RCP_disponible_para_vender="&valor3                        'Cantidad_de_RCP_disponible_para_vender
          'Actualizar Stock en tránsito
          ACTUALIZAR_STOCK_EN_TRANSITO = true
        else
          valor_cif_adu = valor
          valor_cif_ori = valor
        end if
        if nom_campo3 <> "" or nom_campo = "costo_cif_adu_us$" then
          '############ ADU ############
          costo_cif_adu_cl  = Round(valor_cif_adu * paridad,7)
          if strSet <> "" then strSet = strSet & ", "
          strSet            = strSet & " Costo_CIF_ADU_US$="&valor_cif_adu                            'Costo_CIF_ADU_US$
          strSet            = strSet & ", Costo_CIF_ADU_$="&costo_cif_adu_cl                          'Costo_CIF_ADU_$
          strSet            = strSet & ", Costo_CIF_ADU_$_al_momento_de_la_compra="&costo_cif_adu_cl  'Costo_CIF_ADU_$_al_momento_de_la_compra
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CIF_ADU_$="&costo_cif_adu_cl            'Ultimo_costo_CIF_ADU_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CIF_ADU_US$="&valor_cif_adu             'Ultimo_costo_CIF_ADU_US$
        end if
        if nom_campo3 <> "" or (nom_campo = "costo_cif_adu_us$" and documento_respaldo <> "TU") or nom_campo = "costo_cif_ori_us$" then
          '############ ORI ############
          costo_cif_ori_cl  = Round(valor_cif_ori * paridad,7)
          if strSet <> "" then strSet = strSet & ", "
          strSet            = strSet & " Costo_CIF_ORI_US$="&valor_cif_ori                            'Costo_CIF_ORI_US$
          strSet            = strSet & ", Costo_CIF_ORI_US$_2_decimales="&Round(valor_cif_ori,2)      'Costo_CIF_ORI_US$_2_decimales
          strSet            = strSet & ", Costo_CIF_ORI_$="&costo_cif_ori_cl                          'Costo_CIF_ORI_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CIF_ORI_$="&costo_cif_ori_cl            'Ultimo_costo_CIF_ORI_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CIF_ORI_US$="&valor_cif_ori             'Ultimo_costo_CIF_ORI_US$
          '########## EX FAB ###########
          strSet            = strSet & ", Costo_EX_FAB_moneda_origen="&valor_cif_ori                  'Costo_EX_FAB_moneda_origen
          strSet            = strSet & ", Costo_EX_FAB_US$="&valor_cif_ori                            'Costo_EX_FAB_US$
          strSet            = strSet & ", Costo_EX_FAB_$="&costo_cif_ori_cl                           'Costo_EX_FAB_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_EX_FAB_moneda_origen="&valor_cif_ori    'Ultimo_costo_EX_FAB_moneda_origen
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_EX_FAB_$="&costo_cif_ori_cl             'Ultimo_costo_EX_FAB_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_EX_FAB_US$="&valor_cif_ori              'Ultimo_costo_EX_FAB_US$
          '############ FOB ############
          strSet = strSet & ", Costo_FOB_moneda_origen="&valor_cif_ori                                'Costo_FOB_moneda_origen
          strSet = strSet & ", Costo_FOB_US$="&valor_cif_ori                                          'Costo_FOB_moneda_origen
          strSet = strSet & ", Costo_FOB_$="&costo_cif_ori_cl                                         'Costo_FOB_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_FOB_moneda_origen="&valor_cif_ori       'Ultimo_costo_FOB_moneda_origen
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_FOB_$="&costo_cif_ori_cl                'Ultimo_costo_FOB_$
          strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_FOB_US$="&valor_cif_ori                 'Ultimo_costo_FOB_US$
        end if
      end if
   
      '################################################################
      '------------------- Actualizar CPA ($ y US$) -------------------
      '################################################################
      if nom_campo5 <> "" then 'Se actualiza el cpa por recálculo de cantidad o cif_adu
        costo_cpa_cl      = Round(valor5 * paridad,7)
        if strSet <> "" then strSet = strSet & ", "
        strSet            = strSet & " "&nom_campo5&"="&valor5                                        'Costo_CPA_US$
        strSet            = strSet & ", Costo_CPA_$="&costo_cpa_cl                                    'Costo_CPA_$
        strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CPA_$="&costo_cpa_cl                      'Ultimo_costo_CPA_$
        strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CPA_US$="&valor5                          'Ultimo_costo_CPA_US$
      end if
      if nom_campo = "costo_cpa_us$" then
        costo_cpa_cl      = Round(valor * paridad,7)
        if strSet <> "" then strSet = strSet & ", "
        strSet            = strSet & " Costo_CPA_$="&costo_cpa_cl                                     'Costo_CPA_$
        strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CPA_$="&costo_cpa_cl                      'Ultimo_costo_CPA_$
        strSet_t_prod     = strSet_t_prod & ", Ultimo_costo_CPA_US$="&valor                           'Ultimo_costo_CPA_US$
      end if
      
      if nom_campo6 <> "" then 'Se actualizó el peso x Caja --> Actualizar el peso unitario
        if strSet <> "" then strSet = strSet & ", "
        strSet            = strSet & " "&nom_campo6&"="&valor6                                        'Peso Unitario "movimientos_productos"
        strSet_t_prod     = strSet_t_prod & ", "&nom_campo6&"="&valor6                                'Peso Unitario "productos"
      end if
    end if
    
    if nom_campo <> "precio_de_lista_modificado" then    
      '#############################################################################
      '------------ Actualizar los datos en el MAESTRO DE PRODUCTOS ---------------
      '#############################################################################      
      'strSQL="update productos set "&strSet_t_prod&" where empresa='SYS' and producto='"&producto&"'"
      'Response.Write strSQL
      'set rs = Conn.Execute(strSQL) --> !!!!!! No se tiene que actualizar la tabla de productos en TCP, sólo cuando se traspase a RCP
    end if
  end if
  '#################################################################################
  '-------- Actualizar campos en mov productos ------------
  '#################################################################################
  strSQL="update "&nom_tabla&" set "&strSet&" where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_linea
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
  
  if ACTUALIZAR_STOCK_EN_TRANSITO then
    v_stock_en_transito = Get_Stock_En_Transito_X_Producto_y_Bodega(producto,bodega)
    strSQL="update productos_en_bodegas set Stock_en_transito="&v_stock_en_transito&" " &_
           "where Bodega='"&bodega&"' and Producto='"&producto&"' and Empresa='SYS'"
    'Response.Write strSQL
    set rs = Conn.Execute(strSQL)
  end if
  
  '############### DEVOLVER EL TOTAL DE CIF ORI Y TOTAL CIF ADU
  Response.Write Get_Total_Cif_ORI_Y_ADU(documento_no_valorizado,numero_documento_no_valorizado,documento_respaldo,numero_documento_respaldo,numero_interno_documento_no_valorizado)
elseif accion = "actualizar_proveedor" then
  proveedor           = Request.Form("proveedor")
  strNum_Lineas       = Unescape(Request.Form("strNum_Lineas"))
  tot_Num_Lineas      = split(strNum_Lineas,delimiter)
  for j=0 to Ubound(tot_Num_Lineas)
    v_num_linea       = tot_Num_Lineas(j)
    strSQL="update "&nom_tabla&" set proveedor='"&proveedor&"' where empresa='SYS' and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra="&v_num_linea
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
elseif accion = "eliminar_ultimo" then
  strSQL="update Productos_en_bodegas set " &_
         "Stock_en_transito=Stock_en_transito - M.cantidad_entrada " &_
         "from Productos_en_bodegas P inner join "&nom_tabla&" M on " &_
         "M.empresa='SYS' and M.documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "M.numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "M.Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "M.numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "M.numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "M.Numero_de_linea_en_RCP_o_documento_de_compra="&numero_linea&" and " &_
         "P.producto=M.producto and " &_
         "P.Empresa='SYS' and P.bodega='"&bodega&"'"
  'Response.Write strSql
  set rs = Conn.Execute(strSql)
  strSQL="delete "&nom_tabla&" where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_linea
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
elseif accion = "limpiar_items" then
  strNum_Lineas       = Unescape(Request.Form("strNum_Lineas"))
  tot_Num_Lineas      = split(strNum_Lineas,delimiter)
  for j=0 to Ubound(tot_Num_Lineas)
    v_num_linea = tot_Num_Lineas(j)
    strSQL="update Productos_en_bodegas set " &_
           "Stock_en_transito=Stock_en_transito - M.cantidad_entrada " &_
           "from Productos_en_bodegas P inner join "&nom_tabla&" M on " &_
           "M.empresa='SYS' and M.documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "M.numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "M.Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "M.numero_documento_de_compra="&numero_documento_respaldo&" and " &_
           "M.numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
           "M.Numero_de_linea_en_RCP_o_documento_de_compra="&v_num_linea&" and " &_
           "P.producto=M.producto and " &_
           "P.Empresa='SYS' and P.bodega='"&bodega&"'"
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
    strSQL="update "&nom_tabla&" set Numero_de_linea_en_RCP_o_documento_de_compra_padre=null, producto='00000000', " &_
           "nombre_producto_proveedor='', nombre_producto='', unidad_de_medida_compra='UN', cantidad_mercancias=0, " &_
           "cantidad_um_compra_en_caja_envase_compra=1, unidad_de_medida_consumo='UN', Cantidad_x_un_consumo=1, cantidad_entrada=0, " &_
           "alto=0, ancho=0, largo=0, peso=0, costo_cif_ori_us$=0, costo_cif_adu_us$=0, costo_cpa_us$=0, precio_de_lista_modificado=0, " &_
           "temporada=null, porcentaje_ila=0, codigo_arancelario=null, fecha_impresion=null, Cantidad_x_caja=1, Peso_x_caja=0, Delta_CPA_US$=0, Obs_delta_CPA_US$=null " &_
           "where empresa='SYS' and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra="&v_num_linea
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
elseif accion = "agrupar" then
  strNum_Lineas       = Unescape(Request.Form("strNum_Lineas"))
  tot_Num_Lineas      = split(strNum_Lineas,delimiter)
  for j=0 to Ubound(tot_Num_Lineas)
    v_num_linea       = tot_Num_Lineas(j)
    strSQL="update "&nom_tabla&" set Numero_de_linea_en_RCP_o_documento_de_compra_padre="&numero_linea_padre&" " &_
           "where empresa='SYS' and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra="&v_num_linea
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
elseif accion = "desagrupar" then
  strNum_Lineas       = Unescape(Request.Form("strNum_Lineas"))
  tot_Num_Lineas      = split(strNum_Lineas,delimiter)
  for j=0 to Ubound(tot_Num_Lineas)
    v_num_linea       = tot_Num_Lineas(j)
    strSQL="update "&nom_tabla&" set Numero_de_linea_en_RCP_o_documento_de_compra_padre=null " &_
           "where empresa='SYS' and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra="&v_num_linea
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
elseif accion = "agregar" then 'Agregar ítemes después de una línea (item)
  '1°: Actualizar los numeros de línea de los ítemes después del ítem en donde se desean agregar líneas
  strSQL="update "&nom_tabla&" set Numero_de_linea_en_RCP_o_documento_de_compra=Numero_de_linea_en_RCP_o_documento_de_compra + "&items&" " &_
         "where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra > "&numero_linea
  'Response.Write strSql&"<br><br>"
  set rs = Conn.Execute(strSql)
  
  '2°: Insertar los ítemes después del número de línea seleccionado
  v_proveedor = entidad_comercial
  if entidad_comercial_2 <> "" then v_proveedor = entidad_comercial_2
  fecha_movimiento = year(cdate(fecha_recepcion)) & "/" & month(cdate(fecha_recepcion)) & "/"&day(cdate(fecha_recepcion))
  v_num_linea = numero_linea
  for i=1 to items
    v_num_linea = v_num_linea + 1
    strSQL="insert into "&nom_tabla&"(Año_recepcion_compra,Bodega, cantidad_mercancias, " &_
           "cantidad_um_compra_en_caja_envase_compra, Cantidad_entrada, Proveedor," &_
           "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento," &_
           "Moneda_documento, Numero_documento_de_compra, Numero_recepcion_de_compra, Numero_de_linea, " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra, " &_
           "Numero_documento_no_valorizado, numero_interno_documento_no_valorizado, Observaciones, Porcentaje_descuento_1, " &_
           "Producto, Producto_final_o_insumo, Tipo_documento_de_compra, Tipo_producto, unidad_de_medida_compra, unidad_de_medida_consumo, " &_
           "Valor_paridad_moneda_oficial, alto, ancho, largo, peso, Cantidad_x_un_consumo, Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$) values(" &_
           ""&anio&"," &_
           "'"&bodega&"'," &_
           "0,1,0," &_
           "'"&v_proveedor&"'," &_
           "'"&documento_no_valorizado&"'," &_
           "'"&session("Login")&"'," &_
           "'SYS'," &_
           "'AUT'," &_
           "convert(datetime,'"&fecha_movimiento&"')," &_
           "'$'," &_
           ""&numero_documento_respaldo&"," &_
           ""&numero_documento_no_valorizado&"," &_
           ""&v_num_linea&"," &_
           ""&v_num_linea&"," &_
           ""&numero_documento_no_valorizado&"," &_
           "'"&numero_interno_documento_no_valorizado&"'," &_
           "'CARGA POR NUEVO MODULO DE INGRESO DE COMPRAS (2011)'," &_
           "0," &_
           "'00000000'," &_
           "'F'," &_
           "'"&documento_respaldo&"'," &_
           "'P'," &_
           "'UN','UN', " &_
           ""&paridad&",0,0,0,0,1,1,0,0)"
    'Response.Write strSQL&"<br><br>"
    'Response.End
    set rs = Conn.Execute(strSQL)
  next
elseif accion = "eliminar_item" then 'Eliminar el ítem seleccionado --> Se deben correr hacia atrás los números de líneas
  '1°: Actualizar stock en tránsito del producto del item seleccionado
  strSQL="update Productos_en_bodegas set " &_
         "Stock_en_transito=Stock_en_transito - M.cantidad_entrada " &_
         "from Productos_en_bodegas P inner join "&nom_tabla&" M on " &_
         "M.empresa='SYS' and M.documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "M.numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "M.Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "M.numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "M.numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "M.Numero_de_linea_en_RCP_o_documento_de_compra="&numero_linea&" and " &_
         "P.producto=M.producto and " &_
         "P.Empresa='SYS' and P.bodega='"&bodega&"'"
  'Response.Write strSql
  set rs = Conn.Execute(strSql)
  
  '2°: Eliminar item seleccionado
  strSQL="delete "&nom_tabla&" where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_linea
  'Response.Write strSql
  set rs = Conn.Execute(strSql)
  
  '3°: Actualizar los numeros de línea de los ítemes que están después del ítem eliminado
  strSQL="update "&nom_tabla&" set Numero_de_linea_en_RCP_o_documento_de_compra=Numero_de_linea_en_RCP_o_documento_de_compra - 1, " &_
         "numero_de_linea=numero_de_linea - 1 where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra > "&numero_linea
  'Response.Write strSql&"<br><br>"
  set rs = Conn.Execute(strSql)
end if
%>

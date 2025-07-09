<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
anio                                    = Request.Form("anio")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")


traspaso_anio                                   = Request.Form("traspaso_anio")
traspaso_documento_no_valorizado                = "TCP"
traspaso_documento_respaldo                     = Request.Form("traspaso_documento_respaldo")
traspaso_numero_documento_respaldo              = Request.Form("traspaso_numero_documento_respaldo")
traspaso_numero_interno_documento_no_valorizado = Request.Form("traspaso_numero_interno_documento_no_valorizado")
traspaso_numero_documento_no_valorizado         = Request.Form("traspaso_numero_documento_no_valorizado")

traspaso_bodega                                 = Request.Form("traspaso_bodega")
traspaso_proveedor                              = Request.Form("traspaso_proveedor")
traspaso_fecha_movimiento                       = Request.Form("traspaso_fecha_movimiento")
traspaso_paridad                                = Request.Form("traspaso_paridad")

nom_tabla = "movimientos_productos"
delimiter = "~"
OpenConn
OpenConn1
set rs = server.CreateObject("ADODB.RECORDSET")		

band_imprime = false
'band_imprime = true
'#############################################################
'----------------- Obtener máx item destino ------------------
'#############################################################
strSQL="select IsNull(max(numero_de_linea_destino),0) max_item_destino from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
if band_imprime then Response.Write strSQL & "<br><br>"
set rs1 = Conn1x.Execute(strSQL) : max_item_destino = 0
if not rs1.EOF then max_item_destino = rs1("max_item_destino")  
if cdbl(max_item_destino) = 0 then
  Response.Write "NO SE HAN INGRESADO ITEMES DE DESTINTO, Linea:47"
  Response.End
end if

Conn.BeginTrans
'##########################################################################################
'Recorrer ciclo de ítemes de destino chequeando si el registro 
'se debe crear (no existe item destino) o actualizar en TCP destino (existe línea en vacía) 
'##########################################################################################
for numero_de_linea_destino=1 to cdbl(max_item_destino)
  if band_imprime then 
    Response.Write "============================================================================================<br>"
    Response.Write "=================================== LINEA DESTINO ["&Lpad(numero_de_linea_destino,3,"0")&"] =======================================<br>"
    Response.Write "============================================================================================<br>"
  end if
  '=====================================================================================================
  '=====================================================================================================
  'Obtener datos de línea de origen 
  strSQL="select producto, Numero_de_linea_en_RCP_o_documento_de_compra, " &_
         "Cantidad_Mercancias, cantidad_um_compra_en_caja_envase_compra, " &_
         "cantidad_x_un_consumo, Cantidad_traspaso, " &_
         "producto_proveedor, proveedor_origen, costo_fob_us$, costo_ex_fab_moneda_origen from "&nom_tabla&" with(nolock) " &_
         "where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
         "numero_de_linea_destino="&numero_de_linea_destino
  if band_imprime then Response.Write strSQL&"<br><br>"
  'Response.End
  '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  '""""" El recordset se habré como sólo de lectura en la misma transacción para poder obtener los cambios """""
  '""""" se debe crear el rs antes (set rs = server.CreateObject("ADODB.RECORDSET")) y así se puede        """""
  '""""" utilizar la misma Conexión (Conn) de la transacción                                              """""
  rs.Open strSQL, Conn, 3, 3
  '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  producto_origen = "" : numero_de_linea_origen = "" : cantidad_mercancias = "" : Cantidad_traspaso = ""
  unidad_de_medida_compra = "" : cantidad_um_compra_en_caja_envase_compra = 0 : unidad_de_medida_consumo = "" : cantidad_x_un_consumo = 0
  producto_proveedor = "" : proveedor_origen = "" : costo_fob_usd = 0 : costo_ex_fab_moneda_origen = 0
  if not rs.EOF then 
    producto_origen             = rs("producto")
    numero_de_linea_origen      = rs("Numero_de_linea_en_RCP_o_documento_de_compra")
    cantidad_mercancias         = rs("cantidad_mercancias")
    cantidad_traspaso           = rs("cantidad_traspaso")
    producto_proveedor          = rs("producto_proveedor")
    proveedor_origen            = rs("proveedor_origen")
    costo_fob_usd               = rs("costo_fob_us$")
    costo_ex_fab_moneda_origen  = rs("costo_ex_fab_moneda_origen")
        
    cantidad_um_compra_en_caja_envase_compra  = rs("cantidad_um_compra_en_caja_envase_compra")
    cantidad_x_un_consumo                     = rs("cantidad_x_un_consumo")
  end if
  rs.close
  '=====================================================================================================
  '=====================================================================================================
  
  '##########################################################################################
  'Verificar si el ítem se debe crear con datos desde el origen, crear línea vacía o actualizar producto en línea
  '##########################################################################################
  
  strSQL="select producto from "&nom_tabla&" with(nolock) " &_
         "where empresa='SYS' and " &_
         "documento_no_valorizado='"&traspaso_documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&traspaso_numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&traspaso_documento_respaldo&"' and " &_
         "numero_documento_de_compra="&traspaso_numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&traspaso_numero_interno_documento_no_valorizado&" and " &_
         "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_de_linea_destino
  if band_imprime then Response.Write strSQL&"<br><br>"
  '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  '""""" El recordset se habré como sólo de lectura en la misma transacción para poder obtener los cambios """""
  '""""" se debe crear el rs antes (set rs = server.CreateObject("ADODB.RECORDSET")) y así se puede        """""
  '""""" utilizar la misma Conexión (Conn) de la transacción                                              """""
  rs.Open strSQL, Conn, 3, 3
  '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  band_accion = ""
  if rs.EOF then 'La línea de destino NO existe
    band_accion = "CREAR_LINEA_DESTINO"
  else
    if band_imprime then Response.Write "Producto: "&trim(rs("producto"))&"<br><br>"
    if trim(rs("producto")) = "00000000" then 'La línea de destino está vacía (producto no ingresado)
      strSQL="delete "&nom_tabla&" " &_
             "where empresa='SYS' and " &_
             "documento_no_valorizado='"&traspaso_documento_no_valorizado&"' and " &_
             "numero_documento_no_valorizado="&traspaso_numero_documento_no_valorizado&" and " &_
             "Tipo_documento_de_compra='"&traspaso_documento_respaldo&"' and " &_
             "numero_documento_de_compra="&traspaso_numero_documento_respaldo&" and " &_
             "numero_interno_documento_no_valorizado="&traspaso_numero_interno_documento_no_valorizado&" and " &_
             "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_de_linea_destino
      if band_imprime then Response.Write strSQL&"<br><br>"
      'Response.End
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:128"
        Response.End
      end if
      band_accion = "CREAR_LINEA_DESTINO"
    end if
  end if
  rs.close
  if band_imprime then Response.Write "band_accion: "&band_accion&"<br><br>"
  if band_accion = "CREAR_LINEA_DESTINO" then
    fecha_movimiento = year(cdate(traspaso_fecha_movimiento)) & "/" & month(cdate(traspaso_fecha_movimiento)) & "/"&day(cdate(traspaso_fecha_movimiento))
    if numero_de_linea_origen = "" then 'La línea de destino no fue ingresada en TCP origen --> Crear línea de destino en blanco
      observaciones_destino = "CREADO CON PROCEDIMIENTO DE TRASPASO DE ITEMES INSERT LINEA VACIA"
      if band_imprime then Response.Write "************ INSERTAR LINEA VACIA ***************<br>"
      strSQL="insert into "&nom_tabla&"(Año_recepcion_compra,Bodega, cantidad_mercancias, " &_
             "cantidad_um_compra_en_caja_envase_compra, Cantidad_entrada, Proveedor," &_
             "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento," &_
             "Moneda_documento, Numero_documento_de_compra, Numero_recepcion_de_compra, Numero_de_linea, " &_
             "Numero_de_linea_en_RCP_o_documento_de_compra, " &_
             "Numero_documento_no_valorizado, numero_interno_documento_no_valorizado, Observaciones, Porcentaje_descuento_1, " &_
             "Producto, Producto_final_o_insumo, Tipo_documento_de_compra, Tipo_producto, unidad_de_medida_compra, " &_
             "unidad_de_medida_consumo, Valor_paridad_moneda_oficial, alto, ancho, largo, peso, Cantidad_x_un_consumo, " &_
             "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, producto_proveedor, proveedor_origen, costo_fob_us$, costo_ex_fab_moneda_origen) values(" &_
             ""&traspaso_anio&"," &_
             "'"&traspaso_bodega&"'," &_
             "0,1,0," &_
             "'"&traspaso_proveedor&"'," &_
             "'"&traspaso_documento_no_valorizado&"'," &_
             "'"&session("Login")&"'," &_
             "'SYS'," &_
             "'AUT'," &_
             "convert(datetime,'"&fecha_movimiento&"')," &_
             "'$'," &_
             ""&traspaso_numero_documento_respaldo&"," &_
             ""&traspaso_numero_documento_no_valorizado&"," &_
             ""&numero_de_linea_destino&"," &_
             ""&numero_de_linea_destino&"," &_
             ""&traspaso_numero_documento_no_valorizado&"," &_
             ""&traspaso_numero_interno_documento_no_valorizado&"," &_
             "'"&observaciones_destino&"'," &_
             "0," &_
             "'00000000'," &_
             "'F'," &_
             "'"&traspaso_documento_respaldo&"'," &_
             "'P'," &_
             "'UN','UN', " &_
             ""&traspaso_paridad&",0,0,0,0,1,1,0,0," &_
             "'"&producto_proveedor&"', '"&proveedor_origen&"', "&Replace(costo_fob_usd,",",".")&", "&Replace(costo_ex_fab_moneda_origen,",",".")&")"
      if band_imprime then Response.Write strSQL&"<br><br>"
      'Response.End
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:179"
        Response.End
      end if
    else 'Línea de destino SI fue ingresada en TCP origen --> Crear la línea de destino en TCP destino a partir de los datos de origen (traspasar línea origen completa a línea destino)
      '#############################################################
      '------ Traspasar línea TCP origen a línea TCP destino -------
      '#############################################################
      
      '---------- Calcular nueva "cantidad de venta" TCP destino -------------
      Cantidad_Venta = Round((cdbl(cantidad_traspaso) * cdbl(cantidad_um_compra_en_caja_envase_compra)) / cdbl(cantidad_x_un_consumo),0)
      
      observaciones_destino = documento_respaldo & "-" & numero_documento_respaldo & "-" & anio & "-" &_
      numero_de_linea_origen & "-" & cantidad_mercancias & "-" & cantidad_traspaso
      if band_imprime then Response.Write "************ TRASPASAR LINEA DE ORIGEN A DESTINO ***************<br>"
      strSQL="insert into "&nom_tabla&"(Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
             "Cantidad_de_RCP_disponible_para_vender, Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
             "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
             "Costo_EX_FAB_moneda_origen,  Costo_EX_FAB_US$, Costo_FOB_moneda_origen,  Costo_FOB_US$, " &_
             "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
             "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , Numero_recepcion_de_compra, Numero_de_linea, " &_
             "Numero_de_linea_en_RCP_o_documento_de_compra, Numero_documento_no_valorizado, Numero_interno_documento_no_valorizado, Observaciones, " &_
             "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
             "Producto_final_o_insumo, Tipo_documento_de_compra , Tipo_producto,Valor_paridad_moneda_oficial, " &_
             "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo,  " &_
             "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias, Unidad_de_medida_compra, Unidad_de_medida_consumo," &_
             "producto_proveedor, proveedor_origen, codcaja,  unidad_de_medida_origen , cantidad_origen) " &_
             "(SELECT  " &_
             "Año_recepcion_compra, '"&traspaso_bodega&"', "&Cantidad_Venta&", Proveedor,Cantidad_de_RCP_vendida, " &_
             ""&Cantidad_Venta&",  Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
             "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
             "Costo_EX_FAB_moneda_origen,  Costo_EX_FAB_US$, Costo_FOB_moneda_origen,  Costo_FOB_US$, " &_
             "'TCP', Empleado_responsable, Empresa, Estado_documento_no_valorizado, convert(datetime,'"&fecha_movimiento&"'), " &_
             "Fecha_impresion, Moneda_documento, " &_
             "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, "&traspaso_numero_documento_respaldo&" , " &_
             ""&traspaso_numero_documento_no_valorizado&", "&numero_de_linea_destino&", " &_
             ""&numero_de_linea_destino&","&traspaso_numero_documento_no_valorizado&", "&traspaso_numero_interno_documento_no_valorizado&", '"&observaciones_destino&"', " &_
             "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
             "Producto_final_o_insumo, '"&traspaso_documento_respaldo&"', Tipo_producto,"&traspaso_paridad&", " &_
             "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo, " &_
             "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, cantidad_traspaso, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
             "producto_proveedor, proveedor_origen, codcaja, case when Tipo_documento_de_compra <> 'Z' Then null else unidad_de_medida_origen End, case when Tipo_documento_de_compra <> 'Z' Then 0 else cantidad_origen End " &_
             "from "&nom_tabla&" with(nolock) " &_
             "where empresa='SYS' and " &_
             "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
             "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
             "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
             "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
             "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
             "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_de_linea_origen&")"
      if band_imprime then Response.Write strSQL&"<br><br>"
      'Response.End
      Conn.Execute(strSQL)
      if err <> 0 then
        Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:227"
        Response.End
       end if
      
      if cdbl(cantidad_mercancias) > cdbl(cantidad_traspaso) then
        if band_imprime then Response.Write "---- ACTUALIZAR CANTIDAD DE MERCANCIAS ORIGEN ------<br>"
        '#############################################################
        '------ Actualizar Cantidad Mercancias, Cantidad Venta y Observaciones TCP origen -------
        '#############################################################
        observaciones_origen = traspaso_documento_respaldo & "-" & traspaso_numero_documento_respaldo & "-" & traspaso_anio & "-" &_
        numero_de_linea_destino & "-" & cantidad_mercancias & "-" & cantidad_traspaso
        
        '---------- Calcular nueva "cantidad de venta" TCP origen -------------
        Cantidad_Venta = Round(( (cdbl(cantidad_mercancias)-cdbl(cantidad_traspaso) ) * cdbl(cantidad_um_compra_en_caja_envase_compra)) / cdbl(cantidad_x_un_consumo),0)
        
        strSQL="update "&nom_tabla&" set Cantidad_Mercancias=Cantidad_Mercancias - Cantidad_traspaso, " &_
               "Cantidad_entrada="&Cantidad_Venta&", Cantidad_de_RCP_disponible_para_vender="&Cantidad_Venta&", " &_
               "observaciones=observaciones + '@"&observaciones_origen&"',producto = producto where empresa='SYS' and " &_
               "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
               "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
               "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
               "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
               "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
               "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_de_linea_origen
        if band_imprime then Response.Write strSQL&"<br><br>"
        'Response.End
        Conn.Execute(strSQL)
        if err <> 0 then
          Conn.RollbackTrans
          Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:251"
          Response.End
        end if
      elseif cdbl(cantidad_mercancias) <= cdbl(cantidad_traspaso) then
        if cdbl(cantidad_mercancias) < cdbl(cantidad_traspaso) then
          'Actualizar transito
          if band_imprime then Response.Write "------ ACTUALIZAR TRANSITO -----<br>"
          cant_transito_adicional = cdbl(cantidad_traspaso) - cdbl(cantidad_mercancias)
          strSQL="update productos_en_bodegas set Stock_en_transito=Stock_en_transito + "&cant_transito_adicional&" " &_
                 "where bodega='"&traspaso_bodega&"' and producto='"&producto_origen&"' and empresa='SYS'"
          if band_imprime then Response.Write strSQL&"<br><br>"
          'Response.End
          Conn.Execute(strSQL)
          if err <> 0 then
            Conn.RollbackTrans
            Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:266"
            Response.End
          end if
        end if
        
        '###################################################################################################################
        '--- Eliminar línea origen en donde se haya traspasdo el total de "Cantidad de Mercancias" o una cantidad mayor ----
        '###################################################################################################################
        if band_imprime then Response.Write "---- ELIMINAR LINEA TCP ORIGEN CANTIDAD_MERCANCIAS<=CANTIDAD_TRASPASO -----<br>"
        strSQL="delete "&nom_tabla&" " &_
               "where empresa='SYS' and " &_
               "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
               "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
               "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
               "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
               "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
               "Numero_de_linea_en_RCP_o_documento_de_compra="&numero_de_linea_origen
        if band_imprime then Response.Write strSQL&"<br><br>"
        'Response.End
        Conn.Execute(strSQL)
        if err <> 0 then
          Conn.RollbackTrans
          Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:288"
          Response.End
        end if
      end if
    end if
  end if
next
'Conn.RollbackTrans
'Response.End
Conn.CommitTrans
%>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
documento_respaldo                      = Request.Form("documento_respaldo")
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
strSQL="update productos set " &_
       "anterior_costo_cif_ori_US$=P.ultimo_costo_cif_ori_US$, " &_
       "anterior_costo_cif_adu_US$=P.ultimo_costo_cif_adu_US$, " &_
       "anterior_costo_cpa_US$=P.ultimo_costo_cpa_US$, " &_
       "anterior_delta_cpa_US$=P.delta_cpa_US$ " &_
       "from Productos P inner join " &_
       "(select producto " &_
       "from "&nom_tabla&" " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&") M on " &_
       "P.producto=M.producto and P.Empresa='SYS'"
Conn.Execute(strSQL)

Conn.BeginTrans

'#############################################################
'--------------------- Traspasar TCP a RCP -------------------
'-------------------- DOCUMENTOS VALORIZADOS -----------------
'#############################################################
strSQL="update documentos_no_valorizados set documento_no_valorizado='RCP', " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado_RCP&" where empresa='SYS' and " &_
       "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo&" and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
'Response.Write strSQL&"<br><br>"
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:53" 
  Response.End
end if
'#############################################################
'--------------------- Traspasar TCP a RCP -------------------
'-------------------- MOVIMIENTOS PRODUCTOS ------------------
'#############################################################
strSQL="insert into "&nom_tabla&"(Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
       "Cantidad_de_RCP_disponible_para_vender, Costo_CIF_ADU_$, Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
       "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_$, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
       "Costo_EX_FAB_moneda_origen, Costo_EX_FAB_$, Costo_EX_FAB_US$, Costo_FOB_moneda_origen, Costo_FOB_$, Costo_FOB_US$, " &_
       "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
       "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , Numero_recepcion_de_compra, Numero_de_linea, " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra, Numero_documento_no_valorizado, Numero_interno_documento_no_valorizado, Observaciones, " &_
       "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
       "Producto_final_o_insumo, Superfamilia, Familia, Subfamilia,Tipo_documento_de_compra , Tipo_producto,Valor_paridad_moneda_oficial, " &_
       "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo,  " &_
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias) " &_
       "(SELECT  " &_
       "Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
       "Cantidad_de_RCP_disponible_para_vender, Costo_CIF_ADU_$, Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
       "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_$, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
       "Costo_EX_FAB_moneda_origen, Costo_EX_FAB_$, Costo_EX_FAB_US$, Costo_FOB_moneda_origen, Costo_FOB_$, Costo_FOB_US$, " &_
       "'RCP', Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
       "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , "&numero_documento_no_valorizado_RCP&", Numero_de_linea, " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra,"&numero_documento_no_valorizado_RCP&", Numero_interno_documento_no_valorizado, Observaciones, " &_
       "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
       "Producto_final_o_insumo, Superfamilia, Familia, Subfamilia,Tipo_documento_de_compra , Tipo_producto,Valor_paridad_moneda_oficial, " &_
       "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo, " &_
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias " &_
       "from "&nom_tabla&" " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:94"
  Response.End
end if
'#############################################################
'------------- Eliminar promociones en productos -------------
'#############################################################
strSQL="delete productos_en_promociones where Empresa='SYS' and producto IN " &_
       "(SELECT producto from "&nom_tabla&" " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:112"
  Response.End
end if
'#############################################################
'--------------- Actualizar Stock en Transito ----------------
'#############################################################      
strSQL="update Productos_en_bodegas set " &_
       "Stock_en_transito=Stock_en_transito - M.cantidad_entrada " &_
       "from Productos_en_bodegas P inner join " &_
       "(select producto, sum(cantidad_entrada) cantidad_entrada from "&nom_tabla&" " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:134"
  Response.End
end if

'#############################################################
'----------- Actualizar Atributos ANTERIORES ----------
'#############################################################      
'strSQL="update productos set " &_
'       "anterior_costo_cif_ori_US$=P.ultimo_costo_cif_ori_US$, " &_
'       "anterior_costo_cif_adu_US$=P.ultimo_costo_cif_adu_US$, " &_
'       "anterior_costo_cpa_US$=P.ultimo_costo_cpa_US$, " &_
'       "anterior_delta_cpa_US$=P.delta_cpa_US$ " &_
'       "from Productos P inner join " &_
'       "(select producto " &_
'       "from "&nom_tabla&" " &_
'       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
'       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
'       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
'       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
'       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&") M on " &_
'       "P.producto=M.producto and P.Empresa='SYS'"
'Response.Write strSQL
'Conn.Execute(strSQL)
'if err <> 0 then
'  Conn.RollbackTrans
'  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:140"
'  Response.End
'end if

'#############################################################
'----------- Actualizar Atributos Maestro Productos ----------
'#############################################################      
strSQL="update productos set " &_
       "Fecha_ultimos_costos=M.fecha_movimiento, Ultimo_Proveedor=M.proveedor, " &_
       "nombre=M.nombre_producto, nombre_producto_proveedor_habitual=M.nombre_producto_proveedor, " &_
       "porcentaje_impuesto_1=M.porcentaje_ila, nombre_para_boleta=M.nombre_para_boleta, " &_
       "Ultimo_nombre_producto_proveedor=M.nombre_producto_proveedor, " &_
       "cantidad_x_un_consumo=M.cantidad_um_compra_en_caja_envase_compra, " &_
       "cantidad_mercancias=M.cantidad_entrada, " &_
       "ultimo_costo_cif_adu_$=M.costo_cif_adu_$, ultimo_costo_cif_ori_$=M.costo_cif_ori_$, " &_
       "Ultimo_costo_CIF_ADU_US$=M.costo_cif_adu_us$, ultimo_costo_cif_ori_US$=M.costo_cif_ori_US$, " &_
       "Ultimo_costo_CPA_$=M.costo_cpa_$, Ultimo_costo_CPA_US$=M.costo_cpa_US$, " &_
       "Ultimo_costo_EX_FAB_moneda_origen=M.Costo_EX_FAB_moneda_origen, " &_
       "Ultimo_costo_EX_FAB_$=M.Costo_EX_FAB_$, Ultimo_costo_EX_FAB_US$=M.Costo_EX_FAB_US$, " &_
       "Ultimo_costo_FOB_moneda_origen=M.Costo_FOB_moneda_origen, " &_
       "Ultimo_costo_FOB_$=M.Costo_FOB_$, Ultimo_costo_FOB_US$=M.Costo_FOB_US$, " &_
       "Peso_x_caja=M.Peso_x_caja, cantidad_x_caja=M.cantidad_x_caja, delta_cpa_us$=M.delta_cpa_us$, " &_
       "alto=M.alto, ancho=M.ancho, largo=M.largo, peso=M.peso, Codigo_arancelario=M.Codigo_arancelario, temporada=M.temporada," &_
       "Fecha_impresion=M.Fecha_impresion " &_
       "from Productos P inner join " &_
       "(select producto, fecha_movimiento, proveedor, " &_
       "nombre_producto, nombre_producto_proveedor, " &_
       "porcentaje_ila, nombre_para_boleta, " &_
       "cantidad_um_compra_en_caja_envase_compra, " &_
       "cantidad_entrada, " &_
       "costo_cif_adu_$, costo_cif_ori_$, " &_
       "costo_cif_adu_us$, costo_cif_ori_US$, " &_
       "costo_cpa_$, costo_cpa_US$, " &_
       "Costo_EX_FAB_moneda_origen, " &_
       "Costo_EX_FAB_$, Costo_EX_FAB_US$, " &_
       "Costo_FOB_moneda_origen, " &_
       "Costo_FOB_$, Costo_FOB_US$, " &_
       "Peso_x_caja, cantidad_x_caja, delta_cpa_us$, " &_
       "alto, ancho, largo, peso, Codigo_arancelario, temporada, Fecha_impresion " &_
       "from "&nom_tabla&" " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:192"
  Response.End
end if
'Conn.RollbackTrans
'Response.End
Conn.CommitTrans

'###############################################################################################
'----------- Actualizar precios de los productos que modificaron su precio de venta en TCP------
'###############################################################################################
strSQL="select producto, precio_de_lista_modificado from "&nom_tabla&" " &_
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
do while not rs_itemes.EOF
  producto  = trim(rs_itemes("producto"))
  valor     = trim(rs_itemes("precio_de_lista_modificado"))
  '###### L01 #######
  strSQL = "Exec PLP_Borra_Producto_en_Lista_de_precios '"&v_codigo_LPrecio&"', '"&producto&"'"
  'Response.Write strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:222"
    Response.End
  end if
  strSQL = "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio&"', '"&producto&"', 0, '$', "&valor&", 0"
  'Response.Write strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:229"
    Response.End
  end if
  '###### L02 ######
  
  strSQL = "select producto from movimientos_productos with (nolock) where empresa='SYS' and documento_no_valorizado='RCP' and " &_
           "producto='"&producto&"' and numero_interno_documento_no_valorizado<>"&numero_interno_documento_no_valorizado&" " &_
           "group by producto"
  set rs_existe = Conn.Execute(strSQL)
  if rs_existe.EOF then 'Es un producto NUEVO
    strSQL = "Exec PLP_Borra_Producto_en_Lista_de_precios '"&v_codigo_LPrecio2&"', '"&producto&"'"
    'Response.Write strSQL
    Conn.Execute(strSQL)
    if err <> 0 then
      Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:243"
      Response.End
    end if
    strSQL = "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio2&"', '"&producto&"', 0, '$', "&valor&", 0"
    'Response.Write strSQL
    Conn.Execute(strSQL)
    if err <> 0 then
      Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:250"
      Response.End
    end if
  end if

  rs_itemes.MoveNext
loop
%>
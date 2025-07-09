<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
documento_respaldo                      = Request.Form("documento_respaldo")
documento_respaldo_final = documento_respaldo
if documento_respaldo = "DS" then documento_respaldo_final = "R"

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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:59" 
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
       "ultimo_costo_cif_adu_$=M.costo_cif_adu_$, ultimo_costo_cif_ori_$=M.costo_cif_ori_$, " &_
       "Ultimo_costo_CIF_ADU_US$=M.costo_cif_adu_us$, ultimo_costo_cif_ori_US$=M.costo_cif_ori_US$, " &_
       "Ultimo_costo_CPA_$=M.costo_cpa_$, Ultimo_costo_CPA_US$=M.costo_cpa_US$, " &_
       "Ultimo_costo_EX_FAB_moneda_origen=M.Costo_EX_FAB_moneda_origen, " &_
       "Ultimo_costo_EX_FAB_$=M.Costo_EX_FAB_$, Ultimo_costo_EX_FAB_US$=M.Costo_EX_FAB_US$, " &_
       "Ultimo_costo_FOB_moneda_origen=M.Costo_FOB_moneda_origen, " &_
       "Ultimo_costo_FOB_$=M.Costo_FOB_$, Ultimo_costo_FOB_US$=M.Costo_FOB_US$, " &_
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
       "costo_cif_adu_$, costo_cif_ori_$, " &_
       "costo_cif_adu_us$, costo_cif_ori_US$, " &_
       "costo_cpa_$, costo_cpa_US$, " &_
       "Costo_EX_FAB_moneda_origen, " &_
       "Costo_EX_FAB_$, Costo_EX_FAB_US$, " &_
       "Costo_FOB_moneda_origen, " &_
       "Costo_FOB_$, Costo_FOB_US$, " &_
       "Peso_x_caja, cantidad_x_caja, delta_cpa_us$, " &_
       "alto, ancho, largo, peso, Codigo_arancelario, temporada, " &_
       "Fecha_impresion, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
       "Producto_proveedor, Proveedor_origen " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:117"
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
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias, Unidad_de_medida_compra, " &_
       "Unidad_de_medida_consumo, Producto_proveedor, Proveedor_origen) " &_
       "(SELECT  " &_
       "Año_recepcion_compra, Bodega, Cantidad_entrada, Proveedor,Cantidad_de_RCP_vendida, " &_
       "Cantidad_de_RCP_disponible_para_vender, Costo_CIF_ADU_$, Costo_CIF_ADU_$_al_momento_de_la_compra, Costo_CIF_ADU_US$, " &_
       "Costo_CIF_ORI_moneda_origen, Costo_CIF_ORI_$, Costo_CIF_ORI_US$, Costo_CIF_ORI_US$_2_decimales, Costo_CPA_$, Costo_CPA_US$, " &_
       "Costo_EX_FAB_moneda_origen, Costo_EX_FAB_$, Costo_EX_FAB_US$, Costo_FOB_moneda_origen, Costo_FOB_$, Costo_FOB_US$, " &_
       "'RCP', Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento, Fecha_impresion, Moneda_documento, " &_
       "Nombre_para_boleta, Nombre_producto, Nombre_producto_proveedor, Numero_documento_de_compra , "&numero_documento_no_valorizado_RCP&", Numero_de_linea, " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra,"&numero_documento_no_valorizado_RCP&", Numero_interno_documento_no_valorizado, Observaciones, " &_
       "Porcentaje_descuento_1, Precio_de_lista, Precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, Producto, " &_
       "Producto_final_o_insumo, Superfamilia, Familia, Subfamilia,'"&documento_respaldo_final&"' , Tipo_producto,Valor_paridad_moneda_oficial, " &_
       "Codigo_arancelario, alto, ancho, largo, peso, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Cantidad_x_un_consumo, " &_
       "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, Obs_delta_CPA_US$, Cantidad_mercancias, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
       "Producto_proveedor, Proveedor_origen " &_
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:160"
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:178"
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
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:200"
  Response.End
end if
'Conn.RollbackTrans
'Response.End
Conn.CommitTrans
''Conn.close
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
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:231"
    Response.End
  end if
  strSQL = "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio&"', '"&producto&"', 0, '$', "&valor&", 0"
  'Response.Write strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:238"
    Response.End
  end if
  '###### L02 ######
  
  'strSQL = "select producto from movimientos_productos where empresa='SYS' and documento_no_valorizado='RCP' and " &_
  ''         "producto='"&producto&"' and numero_interno_documento_no_valorizado<>"&numero_interno_documento_no_valorizado&" " &_
  ''         "group by producto"
  'set rs_existe = Conn.Execute(strSQL)
  'if rs_existe.EOF then 'Es un producto NUEVO
    strSQL = "Exec PLP_Borra_Producto_en_Lista_de_precios '"&v_codigo_LPrecio2&"', '"&producto&"'"
    'Response.Write strSQL
    Conn.Execute(strSQL)
    if err <> 0 then
      Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:252"
      Response.End
    end if
    strSQL = "Exec PLP_Graba_Producto_en_Lista_de_precios 'SYS', '"&v_codigo_LPrecio2&"', '"&producto&"', 0, '$', "&valor&", 0"
    'Response.Write strSQL
    Conn.Execute(strSQL)
    if err <> 0 then
      Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:259"
      Response.End
    end if
  'end if
  '#######################################################################
  '############################# CORREO ################################## 
  '#######################################################################
  'cSQL = "select Producto_final, Precio_unitario from composicion where producto_insumo= '" & Trim(producto) & "'" 
  
  cSQL =  "select producto_final, Precio_unitario from " &_ 
                "(select Producto_final, producto_insumo, Precio_unitario from composicion where producto_insumo='" & Trim(Producto) & "' and substring(Producto_final,1,7) <>'BOUCHER') A, " &_
                "(select  producto from productos where empresa='SYS'  and estado = 'A') B " &_
                "where A.producto_insumo='" & Trim(Producto) & "' " &_
	              "and A.Producto_final = B.producto"
  set rs = server.CreateObject("ADODB.RECORDSET")
  rs.Open cSQL, Conn, 3, 3
  'set rs = Conn.Execute ( cSql )
  if not rs.eof then
    if UCASE(mid(Trim(producto),1,1)) = "A" or UCASE(mid(Trim(producto),1,1)) = "E" or UCASE(mid(Trim(producto),1,1)) = "F" or UCASE(mid(Trim(producto),1,1)) = "O" or UCASE(mid(Trim(producto),1,1)) = "T" then
      destinatarios = "elandolt@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "B" or UCASE(mid(Trim(producto),1,1)) = "D" or UCASE(mid(Trim(producto),1,1)) = "G" or UCASE(mid(Trim(producto),1,1)) = "Q" or UCASE(mid(Trim(producto),1,1)) = "R" then 
      destinatarios = "mpinilla@sanchezysanchez.cl,cmoscoso@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "A" or UCASE(mid(Trim(producto),1,1)) = "C" or UCASE(mid(Trim(producto),1,1)) = "E" or UCASE(mid(Trim(producto),1,1)) = "F" or UCASE(mid(Trim(producto),1,1)) = "I" or UCASE(mid(Trim(producto),1,1)) = "L" or UCASE(mid(Trim(producto),1,1)) = "N" or CASE(mid(Trim(producto),1,1)) = "P" or UCASE(mid(Trim(producto),1,1)) = "T" then
      destinatarios = "omorales@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "U" or UCASE(mid(Trim(producto),1,1)) = "W" or UCASE(mid(Trim(producto),1,1)) = "Y" or UCASE(mid(Trim(producto),1,1)) = "Z" then
      destinatarios = "callende@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "G" or UCASE(mid(Trim(producto),1,1)) = "Q" or UCASE(mid(Trim(producto),1,1)) = "U" or UCASE(mid(Trim(producto),1,1)) = "W" or UCASE(mid(Trim(producto),1,1)) = "Y" or UCASE(mid(Trim(producto),1,1)) = "Z" then
      destinatarios = "callende@sanchezysanchez.cl, acardenas@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "H" or UCASE(mid(Trim(producto),1,1)) = "S" or UCASE(mid(Trim(producto),1,1)) = "V" or UCASE(mid(Trim(producto),1,1)) = "X" then
      destinatarios = "jrojas@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "I" or UCASE(mid(Trim(producto),1,1)) = "J" or UCASE(mid(Trim(producto),1,1)) = "O" then
      destinatarios = "aseron@sanchezysanchez.cl,"
    elseif UCASE(mid(Trim(producto),1,1)) = "K" or UCASE(mid(Trim(producto),1,1)) = "Ñ"  then
      destinatarios = "raravena@sanchezysanchez.cl,"                                                                       
    end if                            
    set msg = Server.CreateObject("CDO.Message")
    msg.From = "altagestion@sanchezysanchez.cl"
    msg.To = left(destinatarios,len(destinatarios)-1)
    'msg.CC = "strivino@sanchezysanchez.cl"
    msg.Subject = "Notificación automática Cambio de Precio producto componente"
    do while not rs.eof 
    v_html = v_html & "<br>Producto: " & Trim(producto) & ", se cambio de precio a: $" & FormatNumber(valor,0) & " y es componente del kit " & rs("Producto_final") & " con un precio de $" & FormatNumber(rs("Precio_unitario"),0)
    rs.movenext
    loop
    'response.write "KIT :" & Trim(v_html)
    'response.end 
    msg.HTMLBody = v_html
    msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.sanchezysanchez.cl"
    msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1
    msg.Configuration.Fields.Update
    msg.Send
    set msg = nothing
    v_html = ""
    '#######################################################################
  end if 
  rs_itemes.MoveNext
loop
'###############################################################################################
'----------- Actualizar stock minimo de los productos segun los productos de la TCP-------------
'###############################################################################################

strSQL="select producto " &_
       "from "&nom_tabla&" " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
set rs = Conn.Execute(strSQL)
do while not rs.EOF
  cSql = "Exec PRO_CALCULA_STOCK_MIN '" & rs("producto") & "'"
  Set Rs_producto = Conn.Execute ( cSql )
  If Not Rs_producto.Eof then
      strSQL1="update productos set stock_minimo= " & Rs_producto("stock") & " where empresa='SYS' and producto = '" & rs("producto") & "'"
      Conn.Execute(strSQL1)
      if err <> 0 then
        ''Conn.RollbackTrans
        Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:336, " & strSql
        Response.End
      end if
  end if
  rs.movenext
loop  
Rs.Close


'###############################################################################################
'----------- SE GRABA LA UFC QUE CORRESPONDE A LAS RCP PERO EN LA PARTE CONTABLE---------------
'###############################################################################################
''OpenConn
''Conn.BeginTrans
strSql = "select Documento_respaldo, Numero_documento_respaldo, Proveedor, Monto_neto_US$ = Round(Monto_adu_US$,2), Fecha_recepcion, Paridad_conversion_a_dolar " & _
         "from documentos_no_valorizados where numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado
set rs_registros = Conn.Execute(strSQL)
if err <> 0 then
    ''Conn.RollbackTrans
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
           " from movimientos_productos with (nolock) " &_
           " where empresa='SYS' and documento_no_valorizado='TCP' and numero_documento_de_compra= " & numero_documento_respaldo &_
           " and Tipo_documento_de_compra ='"&documento_respaldo&"'" &_
           " and year(fecha_movimiento) = year(getdate()) group by proveedor"
  set rs_registros = Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
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
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:389"
    Response.End
  end if
  folio_contabilizacion = cdbl(rs_folio("valor_numerico")) + 1
  
  strsql = "Update	Parametros  Set	Valor_numerico = IsNull(Valor_numerico, 0) + 1  Where	Parametro = 'FOLCONTAB'"
  Conn.Execute(strsql)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:398"
    Response.End
  end if
  
  strsql = "Exec Dov_graba_facturaCompraUS$ 0,'SYS',"&numero_documento_de_compra&",'"&fecha_recepcion&"',0,'"&Proveedor&"','"&fecha_recepcion&"','','',"&folio_contabilizacion&",'"&fecha_recepcion&"','"&session("Login")&"',"&monto_dolar&","&valor_paridad&",0,''"                                             
  Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:406"
    Response.End
  end if
  
  strsql = "Select Numero_interno_documento_valorizado = Max(Numero_interno_documento_valorizado)" &_ 
           "From  Documentos_valorizados (NoLock)" &_ 
           "Where Empresa = 'SYS' And Documento_valorizado = 'UFC' And Numero_documento_valorizado = "&numero_documento_de_compra
  set rs = Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:416"
    Response.End
  end if
  Numero_interno_documento_valorizado = rs("Numero_interno_documento_valorizado")
  
  strsql = "exec DNV_Rescata_NUmero_ACO_FAC " & Numero_interno_documento_valorizado
  set rs = Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:419"
    Response.End
  end if
  numero_documento_no_valorizado_asiento_insert = rs("numero_documento_no_valorizado_asiento_insert")
  
  strsql = "exec ACO_Borra_primer_registro_asiento_contable_UFC " & Numero_interno_documento_valorizado
  Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:434"
    Response.End
  end if
  
  strsql = "exec ACO_Graba_AsientoContable_Documento_US$ 0,"&numero_documento_no_valorizado_asiento_insert&",'SYS',Null,NUll,Null,'1181150','"&session("Login")&"','S','"&fecha_recepcion&"',"&valor_pesos&",0,'','"&proveedor&"','"&Session("login")&"',0,"&numero_documento_de_compra&","&Numero_interno_documento_valorizado&",'UFC',0,Null,'"&proveedor&"',"&monto_dolar&",0,"&valor_paridad
  Conn.Execute(strSQL)
  if err <> 0 then
    ''Conn.RollbackTrans
    Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:442"
    Response.End
  end if
  rs_registros.movenext
loop
''Conn.CommitTrans
%>
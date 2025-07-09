<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio                                    = Request.Form("anio")
numero_interno_pedido                   = Request.Form("numero_interno_pedido")
numero_pedido                           = Request.Form("numero_pedido")
anio_TCP                                = Request.Form("anio_TCP")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_no_valorizado                 = "TCP"
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
fecha_movimiento                        = Request.Form("fecha_recepcion")
fecha_movimiento                        = year(cdate(fecha_movimiento)) & "/" & month(cdate(fecha_movimiento)) & "/"&day(cdate(fecha_movimiento))
bodega                                  = Request.Form("bodega")
proveedor                               = Request.Form("proveedor")
paridad                                 = Request.Form("paridad")
nom_tabla = "movimientos_productos"
delimiter = "~"
OpenConn

strNum_Lineas                               = Request.Form("strNum_Lineas")
strProductos                                = Unescape(Request.Form("strProductos"))
strCantidad_mercancias                      = Request.Form("strCantidad_mercancias")
strUnidad_de_medida_compra                  = Request.Form("strUnidad_de_medida_compra")
strCantidad_um_compra_en_caja_envase_compra = Request.Form("strCantidad_um_compra_en_caja_envase_compra")
strUnidad_de_medida_consumo                 = Request.Form("strUnidad_de_medida_consumo")
strCantidad_x_un_consumo                    = Request.Form("strCantidad_x_un_consumo")
strCantidad_entrada                         = Request.Form("strCantidad_entrada")
strAlto                                     = Request.Form("strAlto")
strAncho                                    = Request.Form("strAncho")
strLargo                                    = Request.Form("strLargo")
strCantidad_x_caja                          = Request.Form("strCantidad_x_caja")
strPeso_x_caja                              = Request.Form("strPeso_x_caja")
strPeso                                     = Request.Form("strPeso")

tot_Num_Lineas                                = split(strNum_Lineas,delimiter)
tot_Productos                                 = split(strProductos,delimiter)
tot_Cantidad_mercancias                       = split(strCantidad_mercancias,delimiter)
tot_Unidad_de_medida_compra                   = split(strUnidad_de_medida_compra,delimiter)
tot_Cantidad_um_compra_en_caja_envase_compra  = split(strCantidad_um_compra_en_caja_envase_compra,delimiter)
tot_Unidad_de_medida_consumo                  = split(strUnidad_de_medida_consumo,delimiter)
tot_Cantidad_x_un_consumo                     = split(strCantidad_x_un_consumo,delimiter)
tot_Cantidad_entrada                          = split(strCantidad_entrada,delimiter)
tot_Alto                                      = split(strAlto,delimiter)
tot_Ancho                                     = split(strAncho,delimiter)
tot_Largo                                     = split(strLargo,delimiter)
tot_Cantidad_x_caja                           = split(strCantidad_x_caja,delimiter)
tot_Peso_x_caja                               = split(strPeso_x_caja,delimiter)
tot_Peso                                      = split(strPeso,delimiter)

'on error resume next

'1°: Obtener el max(num linea) para ingresar los siguientes registros a partir desde ese num linea
'ITEMES
strSQL="select IsNull(max(numero_de_linea_en_rcp_o_documento_de_compra),0) num_linea from "&nom_tabla&" where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
'Response.Write strSQL&"<br>"
'Response.End
set rs = Conn.Execute(strSQL) 'Si no existen registros, la consulta devolverá un "0" (IsNull(max),0)
num_linea = rs("num_linea")
for j=0 to Ubound(tot_Num_Lineas)
  num_linea_pedido  = tot_Num_Lineas(j)
  'Verificar si la TCP ya está agregada en este item del pedido
  strSQL="select numero_interno_movimiento_pedido from pedidos_movimientos where " &_
         "numero_interno_pedido="&numero_interno_pedido&" and numero_pedido="&numero_pedido&" and " &_
         "numero_de_linea = "&num_linea_pedido&" and ( " &_
         "(año_1="&anio_TCP&" and documento_respaldo_1='"&documento_respaldo&"' and numero_documento_respaldo_1="&numero_documento_respaldo&") or " &_
         "(año_2="&anio_TCP&" and documento_respaldo_2='"&documento_respaldo&"' and numero_documento_respaldo_2="&numero_documento_respaldo&") or " &_
         "(año_3="&anio_TCP&" and documento_respaldo_3='"&documento_respaldo&"' and numero_documento_respaldo_3="&numero_documento_respaldo&") or " &_
         "(año_4="&anio_TCP&" and documento_respaldo_4='"&documento_respaldo&"' and numero_documento_respaldo_4="&numero_documento_respaldo&") or " &_
         "(año_5="&anio_TCP&" and documento_respaldo_5='"&documento_respaldo&"' and numero_documento_respaldo_5="&numero_documento_respaldo&") " &_
         ")"
  'Response.Write strSQL
  'Response.End
  set rs_existe = Conn.Execute(strSQL)
  if rs_existe.EOF then
    producto                                  = tot_Productos(j)
    'Cantidad_mercancias                       = tot_Cantidad_mercancias(j)
    Cantidad_mercancias                       = 0
    Unidad_de_medida_compra                   = tot_Unidad_de_medida_compra(j)
    Cantidad_um_compra_en_caja_envase_compra  = tot_Cantidad_um_compra_en_caja_envase_compra(j)
    'Unidad_de_medida_consumo                  = tot_Unidad_de_medida_consumo(j)
    Unidad_de_medida_consumo                  = "UN"
    'Cantidad_x_un_consumo                     = tot_Cantidad_x_un_consumo(j)
    Cantidad_x_un_consumo                     = 1
    'Cantidad_entrada                          = tot_Cantidad_entrada(j)
    Cantidad_entrada                          = 0
    'Alto                                      = tot_Alto(j)
    'Ancho                                     = tot_Ancho(j)
    'Largo                                     = tot_Largo(j)
    'Cantidad_x_caja                           = tot_Cantidad_x_caja(j)
    'Peso_x_caja                               = tot_Peso_x_caja(j)
    'Peso                                      = tot_Peso(j)
    
    strSQL="select nombre, nombre_para_boleta, nombre_producto_proveedor_habitual, superfamilia, familia, subfamilia, " &_
           "IsNull(alto,0) alto, IsNull(ancho,0) ancho, IsNull(largo,0) largo, IsNull(peso,0) peso, " &_
           "IsNull(porcentaje_impuesto_1,0) porcentaje_impuesto_1, temporada, IsNull(codigo_arancelario,0) codigo_arancelario, " &_
           "IsNull(cantidad_x_caja,1) cantidad_x_caja, IsNull(peso_x_caja,0) peso_x_caja " &_
           "from productos where empresa='SYS' and producto='"&producto&"'"
    set rs = Conn.Execute(strSQL)    
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
    
    num_linea = num_linea + 1
    strSQL="insert into "&nom_tabla&"(Año_recepcion_compra,Bodega, cantidad_mercancias, " &_
           "cantidad_um_compra_en_caja_envase_compra, Cantidad_entrada, Proveedor," &_
           "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento," &_
           "Moneda_documento, Numero_documento_de_compra, Numero_recepcion_de_compra, Numero_de_linea, " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra, " &_
           "Numero_documento_no_valorizado, numero_interno_documento_no_valorizado, Observaciones, Porcentaje_descuento_1, " &_
           "Producto, Producto_final_o_insumo, Tipo_documento_de_compra, Tipo_producto, unidad_de_medida_compra, " &_
           "unidad_de_medida_consumo, Valor_paridad_moneda_oficial, alto, ancho, largo, peso, Cantidad_x_un_consumo, " &_
           "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$, " &_
           "nombre_producto, nombre_para_boleta,nombre_producto_proveedor," &_
           "superfamilia, familia, subfamilia," &_
           "porcentaje_ila, temporada, precio_de_lista, precio_de_lista_modificado, Precio_final_con_descuentos_menos_impuestos, " &_
           "codigo_arancelario) values(" &_
           ""&anio_TCP&"," &_
           "'"&bodega&"'," &_
           ""&Cantidad_mercancias&","&Cantidad_um_compra_en_caja_envase_compra&","&Cantidad_entrada&"," &_
           "'"&proveedor&"'," &_
           "'"&documento_no_valorizado&"'," &_
           "'"&session("Login")&"'," &_
           "'SYS'," &_
           "'AUT'," &_
           "convert(datetime,'"&fecha_movimiento&"')," &_
           "'$'," &_
           ""&numero_documento_respaldo&"," &_
           ""&numero_documento_no_valorizado&"," &_
           ""&num_linea&"," &_
           ""&num_linea&"," &_
           ""&numero_documento_no_valorizado&"," &_
           "'"&numero_interno_documento_no_valorizado&"'," &_
           "'CARGA POR NUEVO MODULO DE INGRESO DE PEDIDOS (2011)'," &_
           "0," &_
           "'"&producto&"'," &_
           "'F'," &_
           "'"&documento_respaldo&"'," &_
           "'P'," &_
           "'"&Unidad_de_medida_compra&"','"&Unidad_de_medida_consumo&"', " &_
           ""&paridad&","&Alto&", "&Ancho&", "&Largo&", "&Peso&", "&Cantidad_x_un_consumo&","&Cantidad_x_caja&","&Peso_x_caja&",0," &_
           "'"&nombre&"','"&nombre_para_boleta&"','"&nombre_producto_proveedor_habitual&"'," &_
           "'"&superfamilia&"','"&familia&"','"&subfamilia&"'," &_
           ""&porcentaje_impuesto_1&",'"&temporada&"',"&precio&","&precio&","&precio&",'"&codigo_arancelario&"')"
    'Response.Write strSQL&"<br><br>"
    'Response.End
    set rs = Conn.Execute(strSQL)
    
    strSQL="select IsNull(documento_respaldo_1,'') doc_1, IsNull(documento_respaldo_2,'') doc_2, " &_
           "IsNull(documento_respaldo_3,'') doc_3, IsNull(documento_respaldo_4,'') doc_4, " &_
           "ISNull(documento_respaldo_5,'') doc_5 from pedidos_movimientos where " &_
           "numero_interno_pedido="&numero_interno_pedido&" and " &_
           "numero_pedido="&numero_pedido&" and " &_
           "Numero_de_linea="&num_linea_pedido
    'Response.Write strSQL
    'Response.End
    set rs = Conn.Execute(strSQL)
    if trim(rs("doc_1")) = "" then 
      strSet = "Año_1="&anio_TCP&", documento_respaldo_1='"&documento_respaldo&"', " &_
      "numero_documento_respaldo_1="&numero_documento_respaldo&", numero_de_linea_1="&num_linea&", cantidad_entrada_1=0, cantidad_anulados=0"
    elseif trim(rs("doc_2")) = "" then 
      strSet = "Año_2="&anio_TCP&", documento_respaldo_2='"&documento_respaldo&"', " &_
      "numero_documento_respaldo_2="&numero_documento_respaldo&", numero_de_linea_2="&num_linea&", cantidad_entrada_2=0"
    elseif trim(rs("doc_3")) = "" then 
      strSet = "Año_3="&anio_TCP&", documento_respaldo_3='"&documento_respaldo&"', " &_
      "numero_documento_respaldo_3="&numero_documento_respaldo&", numero_de_linea_3="&num_linea&", cantidad_entrada_3=0"
    elseif trim(rs("doc_4")) = "" then 
      strSet = "Año_4="&anio_TCP&", documento_respaldo_4='"&documento_respaldo&"', " &_
      "numero_documento_respaldo_4="&numero_documento_respaldo&", numero_de_linea_4="&num_linea&", cantidad_entrada_4=0"
    elseif trim(rs("doc_5")) = "" then 
      strSet = "Año_5="&anio_TCP&", documento_respaldo_5='"&documento_respaldo&"', " &_
      "numero_documento_respaldo_5="&numero_documento_respaldo&", numero_de_linea_5="&num_linea&", cantidad_entrada_5=0"
    end if
    strSQL="update pedidos_movimientos set "&strSet&" where " &_
           "numero_interno_pedido="&numero_interno_pedido&" and " &_
           "numero_pedido="&numero_pedido&" and " &_
           "Numero_de_linea="&num_linea_pedido
    'Response.Write strSQL
    set rs = Conn.Execute(strSQL)
  end if
next
if err <> 0 then
  Response.Write err.Source & ", " & err.Description
end if
%>
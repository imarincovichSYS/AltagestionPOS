<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                = Request.Form("accion")
numero_pedido         = Request.Form("numero_pedido")
numero_interno_pedido = Request.Form("numero_interno_pedido")
numero_linea          = Request.Form("numero_linea")
producto              = Ucase(Trim(unescape(Request.Form("producto"))))
tipo_dato             = Request.Form("tipo_dato")

anio                  = Request.Form("anio")
items                 = Request.Form("items")

nom_campo   = Unescape(Request.Form("nom_campo"))
valor       = Ucase(trim(Unescape(Request.Form("valor"))))
nom_campo1  = Unescape(Request.Form("nom_campo1"))
valor1      = Ucase(trim(Unescape(Request.Form("valor1"))))
nom_campo2  = Unescape(Request.Form("nom_campo2"))
valor2      = Ucase(trim(Unescape(Request.Form("valor2"))))
nom_campo3  = Unescape(Request.Form("nom_campo3"))
valor3      = Ucase(trim(Unescape(Request.Form("valor3"))))

if tipo_dato="2" then 
  if valor <> "" then valor = year(valor) & "/" & month(valor) & "/"&day(valor) 'Date-->fecha vencimiento
end if
nom_tabla = "pedidos_movimientos"
delimiter = "~"
OpenConn

if accion = "actualizar" then
  if nom_campo = "producto" then
    strSQL="select nombre, nombre_producto_proveedor_habitual, " &_
           "IsNull(cantidad_mercancias,0) cantidad_mercancias, " &_
           "IsNull(unidad_de_medida_compra,'UN') unidad_de_medida_compra, " &_
           "IsNull(Cantidad_um_compra_en_caja_envase_compra,0) Cantidad_um_compra_en_caja_envase_compra, " &_
           "IsNull(alto,0) alto, IsNull(ancho,0) ancho, IsNull(largo,0) largo, IsNull(peso,0) peso, " &_
           "IsNull(cantidad_x_caja,1) cantidad_x_caja, IsNull(peso_x_caja,0) peso_x_caja " &_
           "from productos where empresa='SYS' and producto='"&valor&"'"
    set rs = Conn.Execute(strSQL)
    if not rs.EOF then 
      'Existe el producto-->se deben cargar todos los atributos del producto en la grilla principal de ingreso de datos
      nombre                                    = trim(rs("nombre"))
      nombre_producto_proveedor_habitual        = trim(rs("nombre_producto_proveedor_habitual"))
      cantidad_mercancias                       = rs("cantidad_mercancias")
      unidad_de_medida_compra                   = trim(rs("unidad_de_medida_compra"))
      cantidad_um_compra_en_caja_envase_compra  = rs("cantidad_um_compra_en_caja_envase_compra")
      alto                                      = rs("alto")
      ancho                                     = rs("ancho")
      largo                                     = rs("largo")
      cantidad_x_caja                           = trim(rs("cantidad_x_caja"))
      volumen                                   = Round( (cdbl(alto) * cdbl(ancho) * cdbl(largo)) / 1000000/ cdbl(cantidad_x_caja),6)
      peso_x_caja                               = rs("peso_x_caja")
      peso                                      = rs("peso")
      
      strAtributosProd  = nombre            & delimiter
      strAtributosProd  = strAtributosProd  & nombre_producto_proveedor_habitual        & delimiter
      strAtributosProd  = strAtributosProd  & cantidad_mercancias                       & delimiter
      strAtributosProd  = strAtributosProd  & unidad_de_medida_compra                   & delimiter
      strAtributosProd  = strAtributosProd  & cantidad_um_compra_en_caja_envase_compra  & delimiter
      strAtributosProd  = strAtributosProd  & alto                                      & delimiter
      strAtributosProd  = strAtributosProd  & ancho                                     & delimiter
      strAtributosProd  = strAtributosProd  & largo                                     & delimiter
      strAtributosProd  = strAtributosProd  & volumen                                   & delimiter
      strAtributosProd  = strAtributosProd  & peso                                      & delimiter
      strAtributosProd  = strAtributosProd  & cantidad_x_caja                           & delimiter
      strAtributosProd  = strAtributosProd  & peso_x_caja                               & delimiter
      
      Response.Write strAtributosProd
    
      strSet=" "&nom_campo&"='"&valor&"', " &_
             "nombre='"&nombre&"',  " &_
             "cantidad_mercancias=0, " &_
             "unidad_de_medida_compra='"&unidad_de_medida_compra&"', " &_
             "cantidad_um_compra_en_caja_envase_compra="&cantidad_um_compra_en_caja_envase_compra&", " &_
             "unidad_de_medida_consumo='UN'," &_
             "alto="&alto&", ancho="&ancho&", largo="&largo&", peso="&peso&", " &_
             "cantidad_x_caja="&cantidad_x_caja&", peso_x_caja="&peso_x_caja
    else
      Response.Write "NO_EXISTE"
      Response.End
    end if
  else            
    strSet = " "&nom_campo&"='"&valor&"' "
    if tipo_dato="0" then strSet = " "&nom_campo&"="&valor&" "
    if nom_campo1 <> "" then ' "cantidad_um_compra_en_caja_envase_compra" o "cantidad_x_un_consumo"
      if strSet <> "" then strSet = strSet & ", "
      strSet        = strSet & " "&nom_campo1&"="&valor1
    end if
    if nom_campo2 <> "" then ' "cantidad_entrad
      if strSet <> "" then strSet = strSet & ", "
      strSet = strSet & " "&nom_campo2&"="&valor2
    end if
    if nom_campo3 <> "" then 'Se actualizó el peso x Caja --> Actualizar el peso unitario
      if strSet <> "" then strSet = strSet & ", "
      strSet            = strSet & " "&nom_campo3&"="&valor3    'Peso Unitario "pedidos_movimientos"
    end if
  end if
  '#################################################################################
  '-------- Actualizar campos en pedidos mov ------------
  '#################################################################################
  strSQL="update "&nom_tabla&" set "&strSet&" where " &_
         "numero_interno_pedido="&numero_interno_pedido&" and " &_
         "numero_pedido="&numero_pedido&" and " &_
         "Numero_de_linea="&numero_linea
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
elseif accion = "eliminar_ultimo" then
  strSQL="delete "&nom_tabla&" where " &_
         "numero_interno_pedido="&numero_interno_pedido&" and " &_
         "numero_pedido="&numero_pedido&" and " &_
         "Numero_de_linea="&numero_linea
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
elseif accion = "limpiar_items" then
  strNum_Lineas       = Unescape(Request.Form("strNum_Lineas"))
  tot_Num_Lineas      = split(strNum_Lineas,delimiter)
  for j=0 to Ubound(tot_Num_Lineas)
    v_num_linea = tot_Num_Lineas(j)
    strSQL="update "&nom_tabla&" set " &_
           "producto=null, nombre=null, unidad_de_medida_compra='UN', cantidad_mercancias=0, " &_
           "cantidad_um_compra_en_caja_envase_compra=1, unidad_de_medida_consumo='UN', " &_
           "Cantidad_x_un_consumo=1, cantidad_entrada=0, " &_
           "alto=0, ancho=0, largo=0, peso=0, Cantidad_x_caja=1, Peso_x_caja=0, " &_
           "año_1=null, documento_respaldo_1=null, numero_documento_respaldo_1=null, numero_de_linea_1=null, cantidad_entrada_1=null, " &_
           "año_2=null, documento_respaldo_2=null, numero_documento_respaldo_2=null, numero_de_linea_2=null, cantidad_entrada_2=null, " &_
           "año_3=null, documento_respaldo_3=null, numero_documento_respaldo_3=null, numero_de_linea_3=null, cantidad_entrada_3=null, " &_
           "año_4=null, documento_respaldo_4=null, numero_documento_respaldo_4=null, numero_de_linea_4=null, cantidad_entrada_4=null, " &_
           "año_5=null, documento_respaldo_5=null, numero_documento_respaldo_5=null, numero_de_linea_5=null, cantidad_entrada_5=null " &_
           "where " &_
           "numero_interno_pedido="&numero_interno_pedido&" and " &_
           "numero_pedido="&numero_pedido&" and " &_
           "Numero_de_linea="&v_num_linea
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
elseif accion = "agregar" then 'Agregar ítemes después de una línea (item)
  '1°: Actualizar los numeros de línea de los ítemes después del ítem en donde se desean agregar líneas
  strSQL="update "&nom_tabla&" set Numero_de_linea=Numero_de_linea + "&items&" " &_
         "where " &_
         "numero_interno_pedido="&numero_interno_pedido&" and " &_
         "numero_pedido="&numero_pedido&" and " &_
         "Numero_de_linea > "&numero_linea
  'Response.Write strSql&"<br><br>"
  set rs = Conn.Execute(strSql)
  
  '2°: Insertar los ítemes después del número de línea seleccionado
  v_num_linea = numero_linea
  for i=1 to items
    v_num_linea = v_num_linea + 1
    strSQL="insert into "&nom_tabla&"(Numero_interno_pedido,Año,Numero_pedido,Numero_de_linea) values(" &_
           ""&numero_interno_pedido&","&anio&","&numero_pedido&","&v_num_linea&")"
    'Response.Write strSQL&"<br><br>"
    'Response.End
    set rs = Conn.Execute(strSQL)
  next
elseif accion = "eliminar_item" then 'Eliminar el ítem seleccionado --> Se deben correr hacia atrás los números de líneas
  '1°: Eliminar item seleccionado
  strSQL="delete "&nom_tabla&" where  " &_
         "numero_interno_pedido="&numero_interno_pedido&" and " &_
         "numero_pedido="&numero_pedido&" and " &_
         "Numero_de_linea="&numero_linea
  'Response.Write strSql
  set rs = Conn.Execute(strSql)
  
  '2°: Actualizar los numeros de línea de los ítemes que están después del ítem eliminado
  strSQL="update "&nom_tabla&" set Numero_de_linea=Numero_de_linea - 1 " &_
         "where " &_
         "numero_interno_pedido="&numero_interno_pedido&" and " &_
         "numero_pedido="&numero_pedido&" and " &_
         "Numero_de_linea > "&numero_linea
  'Response.Write strSql&"<br><br>"
  set rs = Conn.Execute(strSql)
end if
%>
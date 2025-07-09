<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<!--#include file="../ACIDGrid/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                                  = Request.Form("accion")
anio                                    = Request.Form("anio")
bodega                                  = Request.Form("bodega")
entidad_comercial                       = Request.Form("entidad_comercial")
entidad_comercial_2                     = Request.Form("entidad_comercial_2")
fecha_recepcion                         = Request.Form("fecha_recepcion")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
paridad                                 = Request.Form("paridad")
items                                   = Request.Form("items")
numero_linea                            = Request.Form("numero_linea")
numero_linea_padre                      = Request.Form("numero_linea_padre")
checktodos                              = Request.Form("checktodos")

'accion                                  = "NUEVO"
'anio                                    = "2011"
'bodega                                  = "0010"
'entidad_comercial                       = "13512435"
'fecha_recepcion                         = "27/01/2011"
'documento_no_valorizado                 = "TCP"
'numero_documento_no_valorizado          = "17"
'documento_respaldo                      = "TU"
'numero_documento_respaldo               = "1"
'numero_interno_documento_no_valorizado  = "30080446"
'paridad                                 = "0.00"
'items                                   = "1"
'numero_linea                            = ""

width     = "974"
height    = "296"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")		
set rs      = server.CreateObject("ADODB.RECORDSET")		
%><!-- #include file = "compras_productos_config_cols.asp" --><%
OpenConn
nom_tabla = "movimientos_productos"
if accion = "NUEVO" then
  v_proveedor = entidad_comercial
  if entidad_comercial_2 <> "" then v_proveedor = entidad_comercial_2
  fecha_movimiento = year(cdate(fecha_recepcion)) & "/" & month(cdate(fecha_recepcion)) & "/"&day(cdate(fecha_recepcion))
  '################## Crear la cantidad=items registros (SOLO PARA TCP) ######################
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
  '2°: Insertar la cantidad = items de registros desde el max(num_linea) + 1
  for i=1 to items
    num_linea = num_linea + 1
    strSQL="insert into "&nom_tabla&"(Año_recepcion_compra,Bodega, cantidad_mercancias, " &_
           "cantidad_um_compra_en_caja_envase_compra, Cantidad_entrada, Proveedor," &_
           "Documento_no_valorizado, Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_movimiento," &_
           "Moneda_documento, Numero_documento_de_compra, Numero_recepcion_de_compra, Numero_de_linea, " &_
           "Numero_de_linea_en_RCP_o_documento_de_compra, " &_
           "Numero_documento_no_valorizado, numero_interno_documento_no_valorizado, Observaciones, Porcentaje_descuento_1, " &_
           "Producto, Producto_final_o_insumo, Tipo_documento_de_compra, Tipo_producto, unidad_de_medida_compra, " &_
           "unidad_de_medida_consumo, Valor_paridad_moneda_oficial, alto, ancho, largo, peso, Cantidad_x_un_consumo, " &_
           "Cantidad_x_caja, Peso_x_caja, Delta_CPA_US$) values(" &_
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
           ""&num_linea&"," &_
           ""&num_linea&"," &_
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
  'Response.End
end if
strColsDesOri = "" : strColsObsDelta = ""
if checktodos = "true" then
  strColsDesOri   = " A.nombre_producto_proveedor, "
  strColsObsDelta = " A.obs_delta_cpa_us$, "
end if
strCols = ""
if documento_respaldo = "TU" then strCols = "Round(A.costo_cif_ori_us$,4) costo_cif_ori_us$, A.total_cif_ori, "
Lista_LP_BASE = Get_Codigo_Lista_Precio_LP_BASE
paridad_mg    = cdbl(GetParidad_Para_Margen)
TasaImpAdu    = cdbl(Get_Tasa_Impuesto_Aduanero)/100

if documento_no_valorizado = "TCP" then
  '####################################################################################
  '--------- LOS PRECIOS SE OBTIENEN DESDE "movimientos_productos" --------------------
  '####################################################################################
  strSQL="select '', A.numero_de_linea_en_rcp_o_documento_de_compra, A.numero_de_linea_en_rcp_o_documento_de_compra_padre, " &_
         "producto = " &_
         "case when A.producto='00000000' then " &_
         "  '' " &_
         "else " &_
         "  A.producto " &_
         "end , " &_
         " "&strColsDesOri&" " &_
         "nombre_producto = " &_
         "case when A.nombre_producto='-' then " &_
         "  ''" &_
         "else " &_
         "  A.nombre_producto " &_
         "end , " &_
         "A.cantidad_mercancias, A.unidad_de_medida_compra, A.cantidad_um_compra_en_caja_envase_compra, " &_
         "A.unidad_de_medida_consumo, A.cantidad_x_un_consumo, A.cantidad_entrada, " & strCols & " " &_
         "A.costo_cif_adu_us$, A.total_cif_adu, A.Delta_CPA_US$, "&strColsObsDelta&" " &_
         "Round(A.Costo_CPA_US$,4) Costo_CPA_US$, A.Precio_de_lista_modificado, " &_
         "Margen = " &_
         "case when A.Precio_de_lista_modificado > 0 then " &_
         "  case when D.porcentaje_ila > 0 then " &_
         "    Round(" &_
         "   ((A.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") / (1+D.porcentaje_ila/100) - (A.Costo_CPA_US$+A.Delta_CPA_US$))" &_
         "    / " &_
         "    (A.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") / (1+D.porcentaje_ila/100) * 100 " &_
         "    ,2) " &_
         "  else " &_
         "    Round( " &_
         "    ((A.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") - (A.Costo_CPA_US$+A.Delta_CPA_US$)) " &_
         "    / " &_
         "    (A.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") * 100 " &_
         "    ,2) " &_
         "  end " &_
         "else " &_
         "  0 " &_
         "end , " &_
         "A.alto, A.ancho, A.largo, A.Cantidad_x_caja, " &_
         "A.volumen, A.Peso_x_caja, A.peso, A.fecha_impresion, A.temporada, " &_
         "D.porcentaje_ila, A.codigo_arancelario, B.codigo_postal, A.numero_de_linea_en_rcp_o_documento_de_compra item_1 from " &_
         "(select numero_de_linea_en_rcp_o_documento_de_compra, numero_de_linea_en_rcp_o_documento_de_compra_padre, " &_
         "producto, nombre_producto_proveedor, nombre_producto, " &_
         "unidad_de_medida_compra, cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, " &_
         "unidad_de_medida_consumo, cantidad_x_un_consumo, cantidad_entrada, IsNull(alto,0) alto, IsNull(ancho,0) ancho, IsNull(largo,0) largo, " &_
         "IsNull(Cantidad_x_caja,0) Cantidad_x_caja, IsNull(Round( (alto*ancho*largo)/1000000 / Cantidad_x_caja,6),0) volumen, " &_
         "IsNull(Peso_x_caja,0) Peso_x_caja, IsNull(peso,0) peso, fecha_impresion, " &_
         "costo_cif_ori_us$, Round(costo_cif_ori_us$*Cantidad_entrada,2) total_cif_ori, " &_
         "Round(costo_cif_adu_us$,4) costo_cif_adu_us$, Round(costo_cif_adu_us$*Cantidad_entrada,2) total_cif_adu, " &_
         "IsNull(Round(Delta_CPA_US$,2),0) Delta_CPA_US$, obs_delta_cpa_us$, " &_
         "Costo_CPA_US$, Round(Precio_de_lista_modificado,0) Precio_de_lista_modificado, temporada, " &_
         "codigo_arancelario, proveedor from "&nom_tabla&" where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(codigo_postal), entidad_comercial from entidades_comerciales where empresa='SYS') B, " &_
  	     "(select producto, IsNull(porcentaje_impuesto_1,0) porcentaje_ila from productos where empresa='SYS') D " &_
         "where A.proveedor=B.entidad_comercial and A.producto*=D.producto " &_
         "order by numero_de_linea_en_rcp_o_documento_de_compra, numero_de_linea_en_rcp_o_documento_de_compra_padre"
else 'RCP
  '####################################################################################
  '------ LOS PRECIOS SE OBTIENEN DESDE "productos_en_listas_de_precios" (LP_BASE)-----
  '####################################################################################
  strSQL="select '', A.numero_de_linea_en_rcp_o_documento_de_compra, A.numero_de_linea_en_rcp_o_documento_de_compra_padre, " &_
         "A.producto, "&strColsDesOri&" A.nombre_producto, " &_
         "A.cantidad_mercancias, A.unidad_de_medida_compra, A.cantidad_um_compra_en_caja_envase_compra, " &_
         "A.unidad_de_medida_consumo, A.cantidad_x_un_consumo, A.cantidad_entrada, " & strCols & " " &_
         "A.costo_cif_adu_us$, A.total_cif_adu, A.Delta_CPA_US$, "&strColsObsDelta&" " &_
         "Round(A.Costo_CPA_US$,4) Costo_CPA_US$, C.Precio_de_lista_modificado, " &_
         "Margen = " &_
         "case when C.Precio_de_lista_modificado > 0 then " &_
         "  case when D.porcentaje_ila > 0 then " &_
         "    Round(" &_
         "   ((C.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") / (1+D.porcentaje_ila/100) - (A.Costo_CPA_US$+A.Delta_CPA_US$))" &_
         "    / " &_
         "    ((C.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") / (1+D.porcentaje_ila/100)) * 100 " &_
         "    ,2) " &_
         "  else " &_
         "    Round( " &_
         "    ((C.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") - (A.Costo_CPA_US$+A.Delta_CPA_US$)) " &_
         "    / " &_
         "    (C.Precio_de_lista_modificado/"&paridad_mg&" - A.costo_cif_ori_us$ * "&TasaImpAdu&") * 100 " &_
         "    ,2) " &_
         "  end " &_
         "else " &_
         "  0 " &_
         "end , " &_
         "A.alto, A.ancho, A.largo, A.Cantidad_x_caja, " &_
         "A.volumen, A.Peso_x_caja, A.peso, A.fecha_impresion, A.temporada, " &_
         "D.porcentaje_ila, A.codigo_arancelario, B.codigo_postal, A.numero_de_linea_en_rcp_o_documento_de_compra item_1 from " &_
         "(select numero_de_linea_en_rcp_o_documento_de_compra, numero_de_linea_en_rcp_o_documento_de_compra_padre, " &_
         "producto, nombre_producto_proveedor, nombre_producto, " &_
         "unidad_de_medida_compra, cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, " &_
         "unidad_de_medida_consumo, cantidad_x_un_consumo, cantidad_entrada, IsNull(alto,0) alto, IsNull(ancho,0) ancho, IsNull(largo,0) largo, " &_
         "IsNull(Cantidad_x_caja,0) Cantidad_x_caja, IsNull(Round( (alto*ancho*largo)/1000000 / Cantidad_x_caja,6),0) volumen, " &_
         "IsNull(Peso_x_caja,0) Peso_x_caja, IsNull(peso,0) peso, fecha_impresion, " &_
         "costo_cif_ori_us$, Round(costo_cif_ori_us$*Cantidad_entrada,2) total_cif_ori, " &_
         "Round(costo_cif_adu_us$,4) costo_cif_adu_us$, Round(costo_cif_adu_us$*Cantidad_entrada,2) total_cif_adu, " &_
         "IsNull(Round(Delta_CPA_US$,2),0) Delta_CPA_US$, obs_delta_cpa_us$, " &_
         "Costo_CPA_US$, Round(Precio_de_lista_modificado,0) Precio_de_lista_modificado, temporada, " &_
         "codigo_arancelario, proveedor from "&nom_tabla&" where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(codigo_postal), entidad_comercial from entidades_comerciales where empresa='SYS') B, " &_
         "(select producto, valor_unitario Precio_de_lista_modificado from productos_en_listas_de_precios " &_
	       "where empresa='SYS' and lista_de_precios='"&Lista_LP_BASE&"' and limite_precio=0) C, " &_
  	     "(select producto, IsNull(porcentaje_impuesto_1,0) porcentaje_ila from productos where empresa='SYS') D " &_
         "where A.proveedor=B.entidad_comercial and A.producto*=C.producto and A.producto*=D.producto " &_
         "order by numero_de_linea_en_rcp_o_documento_de_compra, numero_de_linea_en_rcp_o_documento_de_compra_padre"
end if
'Response.Write strSQL
'Response.End
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
set grid.recordset = rs	
grid.Height = height : grid.Width = width : grid.TH_Height = TH_Height
grid.scroll_Div_Totales = "0"
strHTML = grid.get_drawGrid()
%>
<script language="javascript">
var nom_tabla = "<%=nom_tabla%>";
var height_tmp= "<%=height%>"</script>
<table bgcolor="#FFFFFF" align="center" width="<%=width_tmp%>" border=0 cellpadding=0 cellspacing=0>
<tr><td id="t" name="t"><%=strHTML%></td></tr>
</table>
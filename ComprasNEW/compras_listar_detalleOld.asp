<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%

server.ScriptTimeout      = 80000
para                      = Request.QueryString("para")
documento_no_valorizado   = Request.QueryString("documento_no_valorizado")
numero_documento_respaldo = Request.QueryString("numero_documento_respaldo")
documento_respaldo        = Request.QueryString("documento_respaldo")
proveedor                 = Request.QueryString("proveedor")
nombre_proveedor          = Unescape(Request.QueryString("nombre_proveedor"))
fecha_emision             = Request.QueryString("fecha_emision")
fecha_factura             = Request.QueryString("fecha_factura")
fecha_recepcion           = Request.QueryString("fecha_recepcion")
fecha_aduana              = Request.QueryString("fecha_aduana")
Manifiesto                = Request.QueryString("Manifiesto")
NDP                       = Request.QueryString("NDP")
if fecha_aduana <> "" then
    fecha_aduana = cdate(fecha_aduana)
end if
if fecha_recepcion = "" then
  if fecha_factura = "" then
    fecha_recepcion = fecha_emision
  else
    fecha_recepcion = fecha_factura
  end if
end if
if fecha_recepcion <> "" then fecha_recepcion = year(fecha_recepcion) & "/" & Lpad(month(fecha_recepcion),2,0) & "/" & Lpad(day(fecha_recepcion),2,0)
paridad                   = cdbl(Request.QueryString("paridad"))
total_cif_ori             = Request.QueryString("total_cif_ori")
total_cif_adu             = Request.QueryString("total_cif_adu")
total_ex_fab              = Request.QueryString("total_ex_fab")
carpeta                   = Request.QueryString("carpeta")

'Se usa la variable con la hhmmss para agregarla al nombre del archivo. Esto porque comenzaron a aparecer problemas cuando se quieren generar archivos con el mismo nombre (puede ser problemas en las carpetas y archivos temporales en cada equipo)
'por este motivo es mejor crear archivo con nombres únicos (concatenar hora al final del archivo). MODIFICACION: 2013-10-10 15:00:00
hora_actual = Lpad(hour(time()),2,0) & Lpad(minute(time()),2,0) & Lpad(day(time()),2,0)
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=Documento_Compra_" & documento_respaldo & "-" &numero_documento_respaldo&"_"&hora_actual&".xls"

OpenConn

'cod_lista_base = Get_Cod_Lista_Base 
cod_lista_base = "L01"
if documento_no_valorizado="RCP" then
  if documento_respaldo  = "R" then
    strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, B.producto, Producto_bodega = B.Producto, B.nombre, B.Marca ,B.Superfamilia, B.Familia, B.Subfamilia, B.Genero, B.Unidad_de_medida_compra, A.Producto_proveedor, B.Unidad_de_medida_consumo, A.nombre_producto_proveedor, A.Proveedor_origen, UMV_Kgs = IsNull(B.Unidad_de_medida_venta_peso_en_kgs,0), B.alto, B.ancho, B.largo, A.Cantidad_x_caja, " &_
	"m3_U = ((IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100))/ Cantidad_x_caja, "&_
	"Tot_m3 = (select sum(M3_U) from (Select  M3_U = sum(IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100) From Movimientos_Productos with(nolock) where empresa='SYS' and documento_no_valorizado = '"&documento_no_valorizado&"' and (Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS') and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" group by alto, largo, ancho) H), " &_
	"Tot_Kg = (select sum(Unidad_de_medida_venta_peso_en_kgs)From Movimientos_Productos A with(nolock), Productos B with(nolock) where  documento_no_valorizado = '"&documento_no_valorizado&"' and (Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS') and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" and A.producto = B.Producto), " &_
	"Producto =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then (Select Producto_Numerico From Productos_Alfanumericos_Numericos with(nolock) Where Producto_Alfanumerico=B.Producto) Else B.producto End), Producto_Alfanumerico =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then B.producto Else '' End), " &_ 
           "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, A.Cantidad_mercancias, A.cantidad_um_compra_en_caja_envase_compra," &_
           "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, C.valor_unitario precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
           "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
           "A.costo_ex_fab_moneda_origen ex_fab, A.total_ex_fab, " &_
           "D.Codigo_postal prov, A.Cubicaje cubicaje, " &_
           "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
           "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
           "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Tot = (select sum ([Stock_real]) As Tot " &_
           "from productos_en_bodegas with(nolock) where Empresa = 'sys' and producto = B.Producto group by producto) " &_
           "from " &_
           "(select distinct(producto) producto, Proveedor, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, nombre_producto_proveedor," &_
           "Costo_CPA_US$, IsNUll(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cubicaje = (Alto*Ancho*largo), Cantidad_x_caja, Proveedor_origen, Cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, Producto_proveedor, " &_ 
           "Round(Precio_de_lista,0) Precio_ant, Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0), " &_
           "Round(costo_ex_fab_moneda_origen,7) costo_ex_fab_moneda_origen, Round(costo_ex_fab_moneda_origen*Cantidad_origen,2) total_ex_fab " &_
           "from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "(Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS' ) and " &_
           "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
           "(select distinct(producto) producto, nombre, Marca, Superfamilia, Familia, Subfamilia, Genero, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
           "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
           "Temporada, anterior_costo_CIF_ADU_US$, anterior_costo_CIF_ORI_US$, anterior_costo_CPA_US$, Unidad_de_medida_venta_peso_en_kgs,alto, ancho, largo, " &_
           "Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm " &_
           "from productos with(nolock) where empresa='SYS') B, " &_
           "(select producto, valor_unitario from productos_en_listas_de_precios with(nolock) " &_
           "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_
           "(select entidad_comercial, Codigo_postal from entidades_comerciales with(nolock) where empresa='SYS' and " &_
           "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
           "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
           "order by Numero_de_linea_en_RCP_o_documento_de_compra"
  
   else
      strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, B.producto, Producto_bodega = B.Producto, B.nombre, B.Marca, B.Superfamilia, B.Familia, B.Subfamilia, B.Genero, B.Unidad_de_medida_compra, B.Unidad_de_medida_consumo, A.nombre_producto_proveedor, A.Proveedor_origen, UMV_Kgs = IsNull(B.Unidad_de_medida_venta_peso_en_kgs,0), B.alto, B.ancho, B.largo, A.Producto_proveedor,A.Cantidad_x_caja, " &_
	  "m3_U = ((IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100))/ Cantidad_x_caja, "&_
	  "Tot_m3 = (select sum(M3_U) from (Select  M3_U = sum(IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100) From Movimientos_Productos with(nolock) where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and Tipo_documento_de_compra='"&documento_respaldo&"' and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" group by alto, largo, ancho) H), " &_
	  "Tot_Kg = (select sum(Unidad_de_medida_venta_peso_en_kgs)From Movimientos_Productos A with(nolock), Productos B with(nolock) where  documento_no_valorizado = '"&documento_no_valorizado&"' and Tipo_documento_de_compra='"&documento_respaldo&"' and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" and A.producto = B.Producto), " &_
	  "Producto =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then (Select Producto_Numerico From Productos_Alfanumericos_Numericos with(nolock) Where Producto_Alfanumerico=B.Producto) Else B.producto End), Producto_Alfanumerico =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then B.producto Else '' End), " &_ 
           "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, A.Cantidad_mercancias, A.cantidad_um_compra_en_caja_envase_compra," &_
           "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, C.valor_unitario precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
           "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
           "A.costo_ex_fab_moneda_origen ex_fab, A.total_ex_fab, " &_
           "D.Codigo_postal prov, A.Cubicaje cubicaje, " &_
           "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
           "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
           "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Tot = (select sum ([Stock_real]) As Tot " &_
           "from productos_en_bodegas with(nolock) where Empresa = 'sys' and producto = B.Producto group by producto) " &_
           "from " &_
           "(select distinct(producto) producto, Proveedor, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, nombre_producto_proveedor, Proveedor_origen," &_
           "Costo_CPA_US$, IsNUll(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cubicaje = (Alto*Ancho*largo), Cantidad_x_caja, Cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, Producto_proveedor," &_ 
           "Round(Precio_de_lista,0) Precio_ant, Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0), " &_
           "Round(costo_ex_fab_moneda_origen,7) costo_ex_fab_moneda_origen, Round(costo_ex_fab_moneda_origen*Cantidad_origen,2) total_ex_fab " &_
           "from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
           "(select distinct(producto) producto, nombre, Marca, Superfamilia, Familia, Subfamilia, Genero, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
           "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
           "Temporada, anterior_costo_CIF_ADU_US$, anterior_costo_CIF_ORI_US$, anterior_costo_CPA_US$, Unidad_de_medida_venta_peso_en_kgs,alto, ancho, largo, " &_
           "Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm " &_
           "from productos with(nolock) where empresa='SYS') B, " &_
           "(select producto, valor_unitario from productos_en_listas_de_precios with(nolock) " &_
           "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_
           "(select entidad_comercial, Codigo_postal from entidades_comerciales with(nolock) where empresa='SYS' and " &_
           "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
           "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
           "order by Numero_de_linea_en_RCP_o_documento_de_compra"
  end if
else 'TCP
  if documento_respaldo = "R" then
    strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, B.producto, Producto_bodega = B.Producto, B.nombre, B.Marca, B.Superfamilia, B.Familia, B.Subfamilia, B.Genero, A.Unidad_de_medida_compra,	  A.Unidad_de_medida_consumo, A.nombre_producto_proveedor, A.Proveedor_origen, UMV_Kgs = IsNull(B.Unidad_de_medida_venta_peso_en_kgs,0), B.alto, B.ancho, B.largo, A.Producto_proveedor, Cantidad_x_caja, " &_
	"m3_U = ((IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100))/ Cantidad_x_caja, " &_
	"Tot_m3 = (select sum(M3_U) from (Select  M3_U = sum(IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100) From Movimientos_Productos with(nolock) where empresa='SYS' and documento_no_valorizado in ('"&documento_no_valorizado&"') and (Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS') and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" group by alto, largo, ancho) H), " &_
	 "Tot_Kg = (select sum(Unidad_de_medida_venta_peso_en_kgs)From Movimientos_Productos A with(nolock), Productos B with(nolock) where  documento_no_valorizado in ('"&documento_no_valorizado&"') and (Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS') and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" and A.producto = B.Producto), " &_
	"Producto =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then (Select Producto_Numerico From Productos_Alfanumericos_Numericos with(nolock) Where Producto_Alfanumerico=B.Producto) Else B.producto End), Producto_Alfanumerico =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then B.producto Else '' End), " &_ 
           "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, A.Cantidad_mercancias, A.cantidad_um_compra_en_caja_envase_compra," &_
           "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, A.precio precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
           "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
           "A.costo_ex_fab_moneda_origen ex_fab, A.total_ex_fab, " &_
           "D.Codigo_postal prov, '0' prom, A.Cubicaje cubicaje, " &_
           "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
           "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
           "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Tot = (select sum ([Stock_real]) As Tot from productos_en_bodegas with(nolock) where Empresa = 'sys' and producto = B.Producto group by producto) " &_         
           " from " &_
           "(select distinct(producto) producto, Proveedor, Unidad_de_medida_compra, Unidad_de_medida_consumo, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, nombre_producto_proveedor, Proveedor_origen, " &_
           "Costo_CPA_US$, IsNull(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, Producto_proveedor, " &_
           "Round(Precio_de_lista_modificado,0) Precio, Round(Precio_de_lista,0) Precio_ant,Cubicaje = (Alto*Ancho*largo), Cantidad_x_caja, Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0), " &_
           "Round(costo_ex_fab_moneda_origen,7) costo_ex_fab_moneda_origen, Round(costo_ex_fab_moneda_origen*Cantidad_origen,2) total_ex_fab " &_
           "from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado in ('"&documento_no_valorizado&"') and " &_
           "(Tipo_documento_de_compra='R' or Tipo_documento_de_compra='DS') and " &_
           "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
           "(select distinct(producto) producto, nombre, Marca, Superfamilia, Familia, Subfamilia, Genero, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
           "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
           "Temporada, Ultimo_costo_CIF_ADU_US$ anterior_costo_CIF_ADU_US$, ultimo_costo_cif_ori_us$ anterior_costo_CIF_ORI_US$, Ultimo_costo_CPA_US$ anterior_costo_CPA_US$, " &_
           "Unidad_de_medida_venta_peso_en_kgs, alto, ancho, largo, delta_cpa_us$ Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm  " &_
           "from productos with(nolock) where empresa='SYS') B, " &_         
           "(select producto, valor_unitario from productos_en_listas_de_precios with(nolock) " &_
           "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_         
           "(select entidad_comercial, Codigo_postal from entidades_comerciales with(nolock) where empresa='SYS' and " &_
           "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
           "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
           "order by Numero_de_linea_en_RCP_o_documento_de_compra"
  else
      strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, B.producto, Producto_bodega = B.Producto, B.nombre, B.Marca, B.Superfamilia, B.Familia, B.Subfamilia, B.Genero, A.Unidad_de_medida_compra, A.Unidad_de_medida_consumo, A.nombre_producto_proveedor, A.Proveedor_origen, UMV_Kgs = IsNull(B.Unidad_de_medida_venta_peso_en_kgs,0), B.alto, B.ancho, B.largo, A.Producto_proveedor, A.Cantidad_x_caja, " &_
	  "m3_U = ((IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100))/ Cantidad_x_caja, "&_
	 "Tot_m3 = (select sum(M3_U) from (Select  M3_U = sum(IsNull(Alto,0)/100) * (IsNull(Ancho,0)/100) * (Isnull(Largo,0)/100) From Movimientos_Productos with(nolock) where empresa='SYS' and documento_no_valorizado in ('"&documento_no_valorizado&"') and Tipo_documento_de_compra='"&documento_respaldo&"' and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" group by alto, largo, ancho) H), " &_
	 "Tot_Kg = (select sum(Unidad_de_medida_venta_peso_en_kgs)From Movimientos_Productos A with(nolock), Productos B with(nolock) where  documento_no_valorizado in ('"&documento_no_valorizado&"') and Tipo_documento_de_compra='"&documento_respaldo&"' and convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&" and A.producto = B.Producto), " &_
	  "Producto =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then (Select Producto_Numerico From Productos_Alfanumericos_Numericos with(nolock) Where Producto_Alfanumerico=B.Producto) Else B.producto End), Producto_Alfanumerico =( Select Case when substring(B.Producto,1,1) Like '[A-Z]' Then B.producto Else '' End), " &_ 
           "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, A.Cantidad_mercancias, A.cantidad_um_compra_en_caja_envase_compra," &_
           "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, A.precio precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
           "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
           "A.costo_ex_fab_moneda_origen ex_fab, A.total_ex_fab, " &_
           "D.Codigo_postal prov, '0' prom, A.Cubicaje cubicaje, " &_
           "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
           "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
           "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre, Tot = (select sum ([Stock_real]) As Tot from productos_en_bodegas with(nolock) where Empresa = 'sys' and producto = B.Producto group by producto) " &_         
           " from " &_
           "(select distinct(producto) producto, Proveedor,  Unidad_de_medida_compra, Unidad_de_medida_consumo, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, nombre_producto_proveedor, Proveedor_origen, " &_
           "Costo_CPA_US$, IsNull(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cantidad_mercancias, cantidad_um_compra_en_caja_envase_compra, Producto_proveedor," &_
           "Round(Precio_de_lista_modificado,0) Precio, Round(Precio_de_lista,0) Precio_ant,Cubicaje = (Alto*Ancho*largo), Cantidad_x_caja, Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0), " &_
           "Round(costo_ex_fab_moneda_origen,7) costo_ex_fab_moneda_origen, Round(costo_ex_fab_moneda_origen*Cantidad_origen,2) total_ex_fab " &_
           "from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado in ('"&documento_no_valorizado&"') and  " &_
           "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
           "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
           "(select distinct(producto) producto, nombre, Superfamilia, Familia, Subfamilia, Marca, Genero, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
           "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
           "Temporada, anterior_costo_CIF_ADU_US$ anterior_costo_CIF_ADU_US$, ultimo_costo_cif_ori_us$ anterior_costo_CIF_ORI_US$, anterior_costo_CPA_US$ anterior_costo_CPA_US$, " &_
           "Unidad_de_medida_venta_peso_en_kgs, alto, ancho, largo, delta_cpa_us$ Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm  " &_
           "from productos with(nolock) where empresa='SYS') B, " &_         
           "(select producto, valor_unitario from productos_en_listas_de_precios with(nolock) " &_
           "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_         
           "(select entidad_comercial, Codigo_postal from entidades_comerciales with(nolock) where empresa='SYS' and " &_
           "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
           "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
           "order by Numero_de_linea_en_RCP_o_documento_de_compra"
  end if        
end If

'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
width = "900"

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40" >
<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 10">
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:LastAuthor>ALTAGESTION</o:LastAuthor>
  <o:LastPrinted>2011-07-02T07:25:56Z</o:LastPrinted>
  <o:Created>2011-07-02T07:26:08Z</o:Created>
  <o:LastSaved>2011-07-02T07:30:14Z</o:LastSaved>
  <o:Version>11.5606</o:Version>
 </o:DocumentProperties>
</xml><![endif]-->
<style>
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
@page
	{
<%if para = "" then%>
	margin:.4in 0in 0in 1.1in;
<%else%>
  margin:0in 0in 0in 0in;
<%end if%>
	mso-header-margin:0in;
	mso-footer-margin:0in;
	<%if para = "" then%>
	mso-page-orientation:landscape;
	<%end if%>}
-->
</style>
</head>
<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">
<table width=1500 border=0 cellpadding=0 cellspacing=0>
<tr style="height:13px" style="font-size: 10px;"><td></td></tr>
<tr style="height:13px""><td 
<%if para="" then%>
  colspan="27" 
<%else%>
  colspan="14" 
<%end if%>align="center" style="font-size: 10px;"><b>INFORME DOCUMENTO DE COMPRA</b></td></tr>
<tr height="13"><td align="center" style="font-size: 10px;"
<%if para="" then%>
  colspan="27"
<%else%>
  colspan="14"
<%end if%>>
<%if documento_no_valorizado="TCP" then%>
  [TCP]
<%end if%>
</td></tr>
<tr style="height:13px" id="texto_9">
  <%if para="" then%>
  <td colspan="2">Documento</td>
  <td><b><%=documento_respaldo%>-<%=numero_documento_respaldo%></b></td>
  <td colspan="4">Fecha Recepción</td>
  <td colspan="3" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_recepcion)%></b></td>
 <%else%>
  <td colspan="2">Documento</td>
  <td colspan="5"><b><%=documento_respaldo%>-<%=numero_documento_respaldo%></b></td>
  <td Align= 'Right' colspan="2">Fecha Recepción</td>
  <td colspan="3" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_recepcion)%></b></td>
  <%end if%>
  <%if para="" then%>
  <!-- <td></td> -->
  <td colspan="3">Fecha Aduana</td>
    <%'if documento_respaldo <> "DS" then%>
      <!-- <td colspan="4" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_emision)%></b></td> -->
    <%'else%>
      <td colspan="4" align="left" style="mso-number-format:'@'"><b>
      <%if documento_respaldo  = "Z" then %>
      <%=fecha_aduana%>
      <%else %>
      <%=cdate(fecha_factura)%>
      <%end if %>
        
      </b></td>
    <%'end if%>
  <%end if%>
  <%if para <> "" then%>
     <tr> 
	  <td colspan="2" align="Left" style="height:13px">Carpeta</td>
      <td colspan="3" id="texto_9"><b><%=carpeta%></b></td>
	  <%end if%>
	  <td Colspan=4></td>
		<td colspan="5"  align="Left" id="texto_9"><b><%=replace(fecha_hoy,"-","/")%></b> - <b><%=hora%></b></td>
</TR>
  
</tr>
<%if para="" then%>
<tr style="height:13px" id="texto_9">
  <td colspan="2">Proveedor</td>
  <td colspan="8"><b><%=proveedor%>&nbsp;&nbsp;<%=nombre_proveedor%></b></td>
  <td colspan="3" align="Left">Carpeta</td>
  <td colspan="3"><b><%=carpeta%></b></td>
  <td colspan="2" align="Center">Total m3.</td>
  <td colspan="2" class="FormatNumber_2" align="Left"><b>4534</b></td> <!-- [Total m3]--OK <%=Trim(rs("Tot_m3"))%> -->
  
</tr>
<tr style="height:13px" id="texto_9">
  <td colspan="2">Paridad</td>
  <td align="left" class="FormatNumber_2"><b><%=paridad%></b></td>
<%if documento_respaldo  = "Z" then%>
  <td colspan="4">Total Ex Fab</td>
  <td colspan="3" align="left"><b><%=FormatNumber(total_ex_fab,2)%></b></td>
<%else%>
  <td colspan="4">Total Cif. Ori.</td>
  <td colspan="3" align="left"><b><%=FormatNumber(total_cif_ori,2)%></b></td>
<%end if%>  
  <td colspan="3">Total Cif. Adu.</td>
  <td colspan="3" align="left"><b><%=FormatNumber(total_cif_adu,2)%></b></td>
  <td colspan="2" align="Center">Total Kg.</td>
  <td colspan="2" class="FormatNumber_2" align="Left"><b><%=Trim(rs("Tot_Kg"))%></b></td> <!-- FALTANTE -->
  <td colspan="1" align="Center">NDP:</td>
  <td colspan="5" align="Left"><b><%=Trim( NDP )%></b></td>
</tr>
<%end if%>
<%if para="" then%>
<tr id="inf_TD_FS_8" style="height:13px" style="font-size: 10px;"><td></td></tr>
<!-- Cabezera-->
<tr style="height:13px" id="inf_TD_FS_8" align="center" >
  <td width="20" style="font-size:10px;" ><B>N°</B></td>
  <td width="60" style="font-size:10px;"><B>Producto</B></B></td>
  <td width="255" style="font-size:10px;"><B>Nombre</B></td>
  <td width="60" align="Left" style="font-size:10px;"><B>Marca</B></td>
  <td width="20" style="font-size:10px;"><B>Ru</B></td>
  <td width="20" style="font-size:10px;"><B>Fa</B></td>
  <td width="28" style="font-size:10px;"><B>Sub</B></td>
  <td width="20" style="font-size:10px;"><B>G</B></td>
  <td width="30" style="font-size:10px;"><B>Tmp</B></td>
  
    <td width="30" align="right" style="font-size:10px;"><B>ILA</B></td>
    <td width="30" align="Center" style="font-size:10px;"><B>UM V</B></td>
    <td width="40" align="Center" style="font-size:10px;"><B>Cant</B></td>
  <%if documento_respaldo = "Z" then%>
    <td width="45" align="right" style="font-size:10px;"><B>Ex Fab V.</B></td>
    <td width="45" align="right" style="font-size:10px;"><B>T.Ex Fab V.</B></td>
  <%else%>
    <td width="45" align="right" style="font-size:10px;"><B>C.Ori V.</B></td>
  <%end if%>
    <td width="48" align="right" style="font-size:10px;"><B>C. Adu V.</B></td>
    <td width="45" align="right" style="font-size:10px;"><B>T.C.Adu</B></td>
    <td width="30" align="right" style="font-size:10px;"><B>&Delta;CPA</B></td>
    <td width="44" align="right" style="font-size:10px;"><B>CPA</B></td>
    <td width="40" align="right" style="font-size:10px;"><B>%C.Adu</B></td>
    <td width="49" align="right" style="font-size:10px;"><B>Precio</B></td>
    <td width="36" align="right" style="font-size:10px;"><B>Mg</B></td>
    <td width="28" align="right" style="font-size:10px;"><B>Tot.</B></td>
    <td width="30" align="right" style="font-size:10px;"><B>SM7</B></td>
    <td width="37" align="right" style="font-size:10px;"><B>Prom</B></td>    
    <td width="33" align="right" style="font-size:10px;"><B>MgP.</B></td>
    <td width="27" align="Center" style="font-size:10px;"><B>Gr.</B></td>
    <td width="34" align="right" style="font-size:10px;"><B>m3/u.</B></td>
    <td width="45" align="right" style="font-size:10px;"><B>m3/T</B></td>
    </tr >

	<!-- Segunda Cabezera -->
	
  <tr id="inf_TD_FS_8" style="height:13px" align="center" > 
  <td width="20" style="font-size:10px;"></td>
  <td width="65" style="font-size:10px;"><B>Código</B></td>
  <td width="255" style="font-size:10px;"><B>Nombre Producto Proveedor</B></td>
  <td width="60" align="Left" style="font-size:10px;"><B>Proveedor</B></td>
  <td colspan="3" align="Center" width="55" style="font-size:10px;"><B>Prov. Ori</B></td>
  <td colspan="3" align="Center" width="80" style="font-size:10px;"><B>Cod.Pr.Ori.</B></td>
  <td width="30" align="Center" style="font-size:10px;"><B>UM C</B></td>
    <td width="40" align="Center" style="font-size:10px;"><B>Cant</B></td>
  <%if documento_respaldo = "Z" then%>
    <td width="48" align="right" style="font-size:10px;"><B>C.Ex Fab</B></td>
    <td width="48" align="right" style="font-size:10px;"><B>T.Ex Fab</B></td>
  <%else%>
    <td width="48" align="right" style="font-size:10px;"><B>C.Ori C.</B></td>
  <%end if%>
    <td width="48" align="right" style="font-size:10px;"><B>C. Adu C.</B></td>
    <td width="42" align="right" style="font-size:10px;"><B>T.C.Adu</B></td>
    <td width="30" align="right"> </td>
    <td width="44" align="right" style="font-size:10px;"><B>CPA A</B></td>
    <td width="40" align="right" style="font-size:10px;"><B>C.AduA</B></td>
    <td width="49" align="right" style="font-size:10px;"><B>PrecioA</B></td>
    <td width="36" align="right" style="font-size:10px;"><B>Mg A</B></td>
    <td width="28" align="right"> </td>
    <td width="30" align="right" style="font-size:10px;"><B>STM</B></td>
    <td width="37" align="right" style="font-size:10px;"><B>Liq.</B></td>    
    <td width="33" align="right" style="font-size:10px;"><B>MgL.</B></td>
    <td width="27" align="Center" style="font-size:10px;"><B>cc.</B></td>
    <td width="34" align="right" style="font-size:10px;"><B>Kg/u.</B></td>
    <td width="45" align="right" style="font-size:10px;"><B>Kg/T</B></td>
  </tr>

 <%else 'Hoja para bodega%>

<tr style="height:13px" align="center" >
  <td width="18" style="font-size:10px;" ><B>N°</B></td>
  <td width="60" style="font-size:10px;"><B>Producto</B></B></td>
  <td width="20" style="font-size:10px;"><B>Ru</B></td>
  <td width="21" style="font-size:10px;"><B>Fa</B></td>
  <td width="28" style="font-size:10px;"><B>Sub</B></td>
  <td width="16" style="font-size:10px;"><B>G</B></td>
  <td width="62" align="Left" style="font-size:10px;"><B>Marca</B></td>
  <td width="250" style="font-size:10px;"><B>Nombre</B></td>
  <td width="26" align="Center" style="font-size:10px;"><B>UM C</B></td>
  <td width="24" align="Center" style="font-size:10px;"><B>UM V</B></td>
  <td width="27" align="Center" style="font-size:10px;"><B>Cant</B></td>
  <td width="28" align="right" style="font-size:10px;"><B>BM7</B></td>
  <td width="23" align="right" style="font-size:10px;"><B>M7</B></td>
  <td width="27" align="right" style="font-size:10px;"><B>JUG</B></td>
  <td width="34" align="right" style="font-size:10px;"><B>M146</B></td>
  <td width="26" align="right" style="font-size:10px;"><B>L27</B></td>
  <td width="32" align="right" style="font-size:10px;"><B>L238</B></td>
  <td width="26" align="right" style="font-size:10px;"><B>L26</B></td>
  <td width="24" align="Left" style="font-size:10px;"><B>SM</B></td> 
	<td width="25" align="Left" style="font-size:10px;"><B></B></td> 
	<td width="25" align="Left" style="font-size:10px;"><B></B></td> 
  <%end if%>
  </tr>
<%
v_total_final_adu = 0
v_total_final_ori = 0
fecha_hoy_prom = year(date()) & "/" & Lpad(month(date()),2,0) & "/" & Lpad(day(date()),2,0)
paridad_mg = cdbl(GetParidad_Para_Margen)
TasaImpAdu = cdbl(Get_Tasa_Impuesto_Aduanero)/100
do while not rs.EOF
  v_total_final_ori = cdbl(v_total_final_ori) + Round(cdbl(rs("Cantidad_entrada")) * cdbl(rs("cif_ori")),2)
  v_total_final_adu = cdbl(v_total_final_adu) + Round(cdbl(rs("total_adu")),2)
  if not IsNull(rs("total_ex_fab")) then v_total_final_ex_fab = cdbl(v_total_final_ex_fab) + cdbl(rs("total_ex_fab"))
  
  cif_ori   = cdbl(rs("cif_ori"))
  cif_adu   = cdbl(rs("cif_adu"))
  ex_fab    = cdbl(rs("ex_fab"))
  if not IsNull(rs("total_ex_fab")) then total_ex_fab = cdbl(rs("total_ex_fab"))
  
  total_adu = cdbl(rs("total_adu"))
  cpa       = cdbl(rs("cpa"))
  cubicaje  = cdbl(rs("cubicaje"))
  delta_cpa = cdbl(rs("delta_cpa"))
  precio    = cdbl(rs("precio"))
  
  if rs("Numero_de_linea_en_RCP_o_documento_de_compra_padre") = 0 then
    item = rs("Numero_de_linea_en_RCP_o_documento_de_compra")
  else
    item = rs("Numero_de_linea_en_RCP_o_documento_de_compra_padre")
  end if
  ila       = cdbl(rs("ila"))
  grs       = cdbl(rs("grs"))
  cc        = cdbl(rs("cc"))
     
  rel_1     = precio/paridad_mg - cif_ori * TasaImpAdu
  rel_ila   = 1 + ila/100
  rel_1_sobre_ila = rel_1 / rel_ila
  if ila = 0 then
    rel_2 = rel_1            - (cpa + delta_cpa)
    if rel_1 > 0 then mg    = Round(rel_2 / rel_1           * 100,2)
  else
    rel_2 = rel_1_sobre_ila  - (cpa + delta_cpa)
    if rel_1_sobre_ila > 0 then mg    = Round(rel_2 / rel_1_sobre_ila * 100,2)
  end if
  p_v = 0
  if grs  <> 0  then p_v = grs
  if cc   <> 0  then p_v = cc
  
  'Anterior
  cif_ori_ant   = cdbl(rs("cif_ori_ant"))
  cif_adu_ant   = cdbl(rs("cif_adu_ant"))
  cpa_ant       = cdbl(rs("cpa_ant"))
  delta_cpa_ant = cdbl(rs("delta_cpa_ant"))
  precio_ant    = cdbl(rs("precio_ant"))
  
  mg_ant = 0
  if precio_ant = 999999 then precio_ant = 0
  if precio_ant <> 0 then
    rel_1     = precio_ant/paridad_mg - cif_ori_ant * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2 = rel_1            - (cpa_ant + delta_cpa_ant)
      mg_ant    = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2 = rel_1_sobre_ila  - (cpa_ant + delta_cpa_ant)
      mg_ant    = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  if documento_no_valorizado="TCP" then  
    strSQL = "select E1.monto_descuento from " &_
             "(select producto, monto_descuento, promocion " &_
             "from productos_en_promociones with(nolock) where empresa='SYS'and producto='"&trim(rs("producto"))&"') E1, " &_
             "(select promocion from promociones with(nolock) where fecha_termino > '"&fecha_hoy_prom&"') E2 " &_
             "where E1.promocion = E2.promocion "
    set rs_prom = Conn.Execute(strSQL) : prom = 0
    if not rs_prom.EOF then prom = cdbl(rs_prom("monto_descuento"))
  end if
  
  mg_prom = 0
  if prom <> 0 then
    rel_1     = prom/paridad_mg - cif_ori * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2   = rel_1            - (cpa + delta_cpa)
      mg_prom = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2   = rel_1_sobre_ila  - (cpa + delta_cpa)
      mg_prom = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  strSQL = "select IsNull(valor_unitario,0) pliq from productos_en_listas_de_precios with(nolock) " &_
           "where empresa='SYS' and producto='"&trim(rs("producto"))&"' and " &_
           "lista_de_precios = 'L02'"
  set rs_liq = Conn.Execute(strSQL) : pliq = 0
  if not rs_liq.EOF then pliq = cdbl(rs_liq("pliq"))
  
  mg_liq = 0
  if pliq <> 0 then
    rel_1     = pliq/paridad_mg - cif_ori * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2   = rel_1            - (cpa + delta_cpa)
      mg_liq = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2   = rel_1_sobre_ila  - (cpa + delta_cpa)
      mg_liq = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  '''''''''''''''''''''''' pancho ''''''''''''''''''''''''
    if mg_ant = 0 then
    rel_1     = precio/paridad_mg - cif_ori_ant * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2 = rel_1            - (cpa_ant + delta_cpa_ant)
      if rel_1 > 0 then mg_ant2    = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2 = rel_1_sobre_ila  - (cpa_ant + delta_cpa_ant)
      if rel_1_sobre_ila > 0 then mg_ant2    = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end If
  
  'Calcular Stock
  
  stock = 0
  strSQL = "select IsNull(sum(stock_real),0) stock from productos_en_bodegas with(nolock) where empresa='SYS' and producto='"&trim(rs("producto"))&"'"
  set rs_stock = Conn.Execute(strSQL)
  if not rs_stock.EOF then stock = cdbl(rs_stock("stock"))
  
  'Calcula si tiene ventas
  fecha_inicial = cdate(cdate(fecha_recepcion) - 10) 'ESTO ES PARA CALCULAR SI TIENE VENTAS EN LOS ULTIMOS 10 DIAS 
  fecha_inicial = year(fecha_inicial) & "/" & Lpad(month(fecha_inicial),2,0) & "/" & Lpad(day(fecha_inicial),2,0)
  
  ventas = "#FFFFFF"
  strSQL_ventas = "select producto from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado='DVT' " &_
                " and convert(varchar(12),fecha_movimiento,111) between '"&fecha_inicial&"' and '"&fecha_recepcion&"' and producto='"&trim(rs("producto"))&"'"
  set rs_ventas = Conn.Execute(strSQL_ventas) 
  if rs_ventas.EOF then
    if documento_no_valorizado="TCP" then  
        if stock > 0 then 
          ventas = "#CCCCCC"
        end if
    else
        if cdbl(stock) - cdbl(rs("Cantidad_entrada")) > 0 then 
          ventas = "#CCCCCC"
        end if          
    end if
  end if
  
  'Stock Minimo
  stock_pintar = "#FFFFFF"
  if cdbl(rs("smm")) = 0 then
    smin = rs("sma")    
  else
    stock_pintar = "#CCCCCC"
    smin = rs("smm")
  end if
 
  %>
<%
   '''''''''''''''Walter''''''''''''''''
 Cant_Compra = cdbl(rs("Cantidad_mercancias"))

if Cant_Compra = 0 Then 
		C_Adu_C = 0

	Else 
		C_Adu_C =(total_adu)/(Cant_Compra)
	
End if
 Cant_V  = cdbl(rs("Cantidad_entrada"))
 Cant_C  = cdbl(rs("Cantidad_mercancias"))
 C_Ori_V = cif_ori

 If Cant_C = 0 Then 
	C_Ori_C = 0
 Else	
 C_Ori_C = (Cant_V * cif_ori ) / Cant_C
End If

C_Ex_Fab_C = 0
cif_adu_antetior	 = cdbl(rs("cif_adu_ant")) 
cif_adu_actual		 = CDbl(rs("cif_adu"))

If cif_adu_actual = 0 Then
	Porcentaje_C_Adu = 0
Else
Porcentaje_C_Adu	 =  ((cif_adu_actual - cif_adu_antetior ) * 100) / cif_adu_actual
End If

M3T = 0
M3T = CDbl(rs("Cantidad_entrada")) *  CDbl(rs("m3_U"))
	
'Response.Write M3T
'Response.End
UMV_Kgs = cdbl(rs("UMV_Kgs"))
KgT = 0
KgT = Cant_C * UMV_Kgs
class_formatnumber_cif_ori_unitario = "FormatNumber_4"
class_formatnumber_cif_ori_total = "FormatNumber_2"
if documento_respaldo = "DS" then
  class_formatnumber_cif_ori_unitario = "FormatNumber_7"
  class_formatnumber_cif_ori_total = "FormatNumber_4"
end if

%>
<%if para="" then%>
<tr style="height:12px" id="inf_TD_FS_9" align="center" align="center">
  <td wrap style="font-size:9px;"><%=item%></td> <!-- [N°]Item --Ok -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("producto"))%></td> <!-- [Producto] --OK -->
  <td align="left"  wrap style="font-size:9px;"><%=left(trim(rs("nombre")),50)%></td> <!--[Nombre]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Marca"))%></td> <!--[Marca]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Superfamilia"))%></td> <!--[Ru]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Familia"))%></td> <!--[Fa]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Subfamilia"))%></td> <!--[Sub]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Genero"))%></td> <!--[G]--OK  -->
  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("temporada"))%></td> <!--[Tmp]--OK  -->
  <td align="right" wrap style="font-size:9px;"><%if cdbl(rs("ila")) = 0 then Response.Write " " else Response.Write rs("ila") end if%></td> <!--[ILA]--OK -->
  <td align="Left"  wrap style="font-size:9px;"><%=rs("Unidad_de_medida_consumo")%></td> <!--[UM V]--OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%=rs("Cantidad_entrada")%></td> <!--[Cant] =  [Cant_V]--OK  -->
<%if documento_respaldo = "Z" then%>
  <td align="right" wrap style="font-size:9px;" class="<%=class_formatnumber_cif_ori_unitario%>"><%=ex_fab%></td> <!--[Ex Fab] --OK-->
  <td align="right" wrap style="font-size:9px;" class="<%=class_formatnumber_cif_ori_unitario%>"><%=total_ex_fab%></td> <!--[Total Ex Fab] --OK-->
<%else%>
  <td align="right" wrap style="font-size:9px;" class="<%=class_formatnumber_cif_ori_unitario%>"><%=cif_ori%></td> <!--[C.Ori V.] --OK-->
<%end if%>
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"><%=cif_adu%></td> <!--[C.Adu V] --OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%=total_adu%></td> <!--[T.C.Adu]--OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%if delta_cpa=0 then Response.Write " " else Response.Write delta_cpa end if%></td> <!--[Delta.CPA]--OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(cpa) end if else response.write(cpa)end if%></td>
  <!--<td align="right" class="FormatNumber_4"><%=cpa%></td>-->  <!--[CPA]--OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2" ><%=Porcentaje_C_Adu%></td>  <!-- [%C.Adu] --   -->
  <td align="right" wrap style="font-size:9px;"><%=FormatNumber(precio,0)%></td> <!-- [Precio]--OK -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(FormatNUmber(mg,2)) end if else response.write(FormatNUmber(mg,2)) end if%></td> <!--[Mg]--OK  -->
  <td align="Center" wrap style="font-size:9px;"><%=Trim(rs("Tot"))%></td> <!-- [Tot.]--OK   -->
  <td align="Center" wrap style="font-size:9px;"><%=Trim(rs("sma"))%></td><!--SM7--OK -->
  <td align="right"  wrap style="font-size:9px;"><%if FormatNumber(prom,0) <> 0 then response.write(FormatNumber(prom,0)) else response.write(" ") end if%></td><!--[Prom.]--OK  -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_2"><% if mg_prom<>0 then response.write(mg_prom) else response.write(" ") end if%></td><!--[MgP.]--OK  -->
  <td align="right"  wrap style="font-size:9px;"><%=Trim(rs("grs"))%></td> <!-- [Gr.]--OK   -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_4" ><%=Trim(rs("m3_U"))%></td> <!-- Hay que Agregar Datos[m3/u.]   -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_2"><%=M3T%></td> <!-- [m3/T]--OK   -->
</tr>
<!-- Datos de la Segunda Cabezera -->
<tr style="height:12px" id="inf_TD_FS_9">
  <td align="Center"></td> <!-- Columna Vacia Proporcional al N° Item-->
  <td align="Left" wrap style="font-size:9px;"><%=Trim(rs("Producto_Alfanumerico"))%></td> <!-- [Codigo]--OK   -->
  <td align="Left" wrap style="font-size:9px;"><%=trim(rs("nombre_producto_proveedor"))%></td>   <!-- Hay que Agregar Datos[Nombre Producto Proveedor]   -->
  <td align="left" wrap style="font-size:9px;"><%=Left(trim(rs("prov")),7)%></td> <!--[Proveedor]--OK  -->
  <td align="Left" wrap style="font-size:9px;" Colspan="3"><%=Trim(rs("Proveedor_origen"))%></td> <!--Agregar Dato[Prov. Ori] -->
  <td align="Left" wrap style="font-size:9px;" Colspan="3"><%=Trim(rs("Producto_proveedor"))%></td> <!--[Cod.Pr.Ori] -->
  <td align="Left" wrap style="font-size:9px;"><%=rs("Unidad_de_medida_compra")%></td> <!--[UM C]--OK  --> 
  <td align="Right" wrap style="font-size:9px;" class="FormatNumber_2"><%=rs("Cantidad_mercancias")%></td> <!--[Cant] = [Cant_C]-- OK -->
<%if documento_respaldo = "Z" then%>
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"></td> <!--Agregar Dato[C.EX Fab C.] -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"></td> <!--Agregar Dato[C.EX Fab C.] -->
<%else%>
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"><%=C_Ori_C%></td> <!--Agregar Dato[C.Ori C.] -->
<%end if%>
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"><%=C_Adu_C%></td> <!--Agregar Dato[C.Adu C.] -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%=total_adu%></td> <!--[T.C.Adu]--OK  -->
  <td align="Center">&nbsp;&nbsp;</td> <!-- Columna Vacia Proporcional al DeltaCPA-->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_4"><%if cpa_ant=0 then response.write(" ") else response.write(FormatNUmber(cpa_ant,4)) end if%></td> <!--[CPA A]  -->
  <td align="right" wrap style="font-size:9px;"class="FormatNumber_4"><%if cif_adu_ant=0 then response.write(" ") else response.write(FormatNUmber(cif_adu_ant,4)) end if%></td> <!--[C.AduA]  -->
  <td align="right" wrap style="font-size:9px;"><%if (FormatNumber(precio_ant,0) = 0 and cpa_ant=0) then response.write(" ") else if FormatNumber(precio_ant,0) = 0 then response.write(FormatNUmber(precio,0)) else response.write(FormatNUmber(precio_ant,0)) end if%></td> <!--[Precio A]--OK  -->
  <td align="right" wrap style="font-size:9px;" class="FormatNumber_2"><%if (FormatNUmber(mg_ant,2) = 0 and cpa_ant=0) then response.write(" ") else if FormatNUmber(mg_ant,2) = 0 then response.write(FormatNUmber(mg_ant2,2)) else  response.write(FormatNUmber(mg_ant,2)) end if%></td> <!--[Mg A]--OK  -->
  <td align="Center">&nbsp;&nbsp;</td> <!-- Columna Vacia Proporcional al Tot. -->
  <td align="Center" wrap style="font-size:9px;"><%=Trim(rs("smm"))%></td> <!--[STM]--OK  -->
  <td align="right"  wrap style="font-size:9px;"><%=FormatNumber(pliq,0)%></td> <!--[Liq]  -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_2"><%=mg_liq%></td> <!--[MgL]  -->
  <td align="right"  wrap style="font-size:9px;"><%=Trim(rs("cc"))%></td> <!--[cc.]--OK   -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_2"><%=Trim(rs("UMV_Kgs"))%></td> <!--[Kg/u.]--OK   -->
  <td align="right"  wrap style="font-size:9px;" class="FormatNumber_2"><%=KgT%></td><!-- Hay que Agregar Datos[Kg/T]   -->
  

  <!--<td bgcolor="<%=stock_pintar%>" align="right"><%=formatNumber(smin,0)%></td> <!--StockMinManual - StockMinAut.  -->
  <!--<td bgcolor="<%=ventas%>" align="right" style="font-size:8px;"><%=FormatNumber(stock,0)%></td> <SM7>
  <!--<td align="right" class="FormatNumber_2" style="font-size:8px;"><%if (delta_cpa_ant = 0 and cpa_ant=0) then response.write(" ") else response.write(FormatNUmber(delta_cpa_ant,4)) end if%></td> --> <!--[Delta.CPA A]No se Utiliza  -->
  <!-- <td align="right" style="font-size:8px;"><%if FormatNumber(prom,0) <> 0 then response.write(FormatNumber(prom,0)) else response.write(" ") end if%></td> --><!--[Liq]  -->
  <!-- <td align="right" style="font-size:8px;" class="FormatNumber_2"><% if mg_prom<>0 then response.write(mg_prom) else response.write(" ") end if%></td> --><!--[Mg L]  --> 
    <!--<td align="right" style="font-size:8px;" class="FormatNumber_2"><%if (FormatNumber(cpa - cpa_ant,0) = 0 or FormatNumber(precio,0)=999999 or FormatNumber(cpa_ant,0)=0) then response.write(" ") else response.write(FormatNumber(cpa - cpa_ant,2)) end if%></td> --><!--  -->
  <!--<td align="right" style="font-size:8px;" class="FormatNumber_2"><%=" "%></td>-->
  
  <!--<td align="right"><%if p_v = 0 then Response.Write " " else Response.Write p_v end if%></td> --><!--[P_V]--Peso/Volumen  -->
  </tr>
    <%else 'Hoja para Bodega%>
    <%
    
	
	BM7   = FormatNumber(Get_Stock_En_Bodega("0010", trim(rs("producto")) ),0)
    M7    = FormatNumber(Get_Stock_En_Bodega("0011", trim(rs("producto")) ),0)
    JUG   = FormatNumber(Get_Stock_En_Bodega("0002", trim(rs("producto")) ),0)
    M146  = FormatNumber(Get_Stock_En_Bodega("0004", trim(rs("producto")) ),0)
    L27   = FormatNumber(Get_Stock_En_Bodega("0005", trim(rs("producto")) ),0)
    L238  = FormatNumber(Get_Stock_En_Bodega("0008", trim(rs("producto")) ),0)
    L26   = FormatNumber(Get_Stock_En_Bodega("0009", trim(rs("producto")) ),0)
    
    if M7   = 0 then M7   = "-"
    if JUG  = 0 then JUG  = "-"
    if M146 = 0 then M146 = "-"
    if L27  = 0 then L27  = "-"
    if L238 = 0 then L238 = "-"
    if BM7  = 0 then BM7  = "-"
    if L26  = 0 then L26  = "-"
    %>
	<td wrap style="font-size:9px;"><%=item%></td> <!-- [N°]Item --Ok -->
	<td align="left"  wrap style="font-size:9px;"><%=trim(rs("Producto_bodega"))%></td> <!-- [Producto] --OK -->
    <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Superfamilia"))%></td> <!--[Ru]--OK  -->
    <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Familia"))%></td> <!--[Fa]--OK  -->
    <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Subfamilia"))%></td> <!--[Sub]--OK  -->
    <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Genero"))%></td> <!--[G]--OK  -->
	  <td align="left"  wrap style="font-size:9px;"><%=trim(rs("Marca"))%></td> <!--[Marca]--OK  -->
	<td align="left"  wrap style="font-size:9px;"><%=left(trim(rs("nombre")),50)%></td> <!--[Nombre]--OK  -->
	<td align="Left" wrap style="font-size:9px;"><%=rs("Unidad_de_medida_compra")%></td> <!--[UM C]--OK  --> 
	<td align="Left"  wrap style="font-size:9px;"><%=rs("Unidad_de_medida_consumo")%></td> <!--[UM V]--OK  -->
    <td align="Left"  wrap style="font-size:9px;"><%=FormatNumber(rs("Cantidad_entrada"),0)%></td> <!--[Cant] =  [Cant_V]--OK  -->
    <td align="right" wrap style="font-size:9px;"><%=BM7%></td>
    <td align="right" wrap style="font-size:9px;"><%=M7%></td>
    <td align="right" wrap style="font-size:9px;"><%=JUG%></td>
    <td align="right" wrap style="font-size:9px;"><%=M146%></td>
    <td align="right" wrap style="font-size:9px;"><%=L27%></td>
    <td align="right" wrap style="font-size:9px;"><%=L238%></td>
    <td align="right" wrap style="font-size:9px;"><%=L26%></td>
    <td bgcolor="<%=stock_pintar%>" align="right" wrap style="font-size:9px;"><%=formatNumber(smin,0)%></td>    
  <%end if%>   
  </tr>
<!-- Salto de Carro  ---------------------------------------------------- -->
 <tr style="height:3px" id="inf_TD_FS_9" align="center" align="center"> </tr> 
<!-- -------------------------------------------------------------------- -->
<%fila = fila + 1
  rs.MoveNext
loop%>
<%if para="" then%>
<tr id="inf_TD_FS_9">
  <td colspan="11">&nbsp;</td>
<%if documento_respaldo = "Z" then%>
  <td>&nbsp;</td>
  <td colspan="2" align="Right"><b><%=FormatNumber(v_total_final_ex_fab,2)%></b></td>
<%else%>
  <td colspan="2" align="Right"><b><%=FormatNumber(v_total_final_ori,2)%></b></td>
<%end if%>
  <td colspan="2" align="Left">&nbsp;&nbsp;<b><%=FormatNumber(v_total_final_adu,2)%></b></td>
  <td colspan="9">&nbsp;</td>
</tr>
<%end if%>
</table>
<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>Documento_Compra</x:Name>
    <x:WorksheetOptions  xmlns="urn:schemas-microsoft-com:office:excel">
     <x:DefaultColWidth>10</x:DefaultColWidth>
     <x:Print>
      <x:ValidPrinterInfo/>
      <%if para = "" then%>
                <x:PaperSizeIndex>5</x:PaperSizeIndex>
        <%end if
      %>

      <x:Scale>95</x:Scale>
      <x:HorizontalResolution>120</x:HorizontalResolution>
      <x:VerticalResolution>72</x:VerticalResolution>
     </x:Print>

     <!--<x:ShowPageBreakZoom/> --> <!-- Muestra los número de página de Excel -->
     <%if para = "" then%>
	 <x:FreezePanes/>
     <x:FrozenNoSplit/>
     <x:SplitHorizontal>9</x:SplitHorizontal>
     <x:ActivePane>2</x:ActivePane>
		<%else 'Hoja para Bodega%>
	 	 <x:FreezePanes/>
     <x:FrozenNoSplit/>
     <x:SplitHorizontal>6</x:SplitHorizontal>
     <x:ActivePane>2</x:ActivePane>
	 <%end if%>

	 <x:PageBreakZoom>100</x:PageBreakZoom>
     <x:Selected/>
     <x:DoNotDisplayGridlines/>
     <x:Panes>
      <x:Pane>
       <x:Number>3</x:Number>
       <!--<x:ActiveRow>19</x:ActiveRow>-->
       <!--<x:ActiveCol>3</x:ActiveCol>-->
      </x:Pane>
     </x:Panes>
     <x:ProtectContents>False</x:ProtectContents>
     <x:ProtectObjects>False</x:ProtectObjects>
     <x:ProtectScenarios>False</x:ProtectScenarios>
    </x:WorksheetOptions>
    <!--<x:PageBreaks>
     <x:RowBreaks>
      <x:RowBreak>
       <x:Row>22</x:Row>
      </x:RowBreak>
     </x:RowBreaks>
    </x:PageBreaks>-->
   </x:ExcelWorksheet>
  </x:ExcelWorksheets>
  <x:WindowHeight>9210</x:WindowHeight>
  <x:WindowWidth>19995</x:WindowWidth>
  <x:WindowTopX>240</x:WindowTopX>
  <x:WindowTopY>60</x:WindowTopY>
  <x:ProtectStructure>False</x:ProtectStructure>
  <x:ProtectWindows>False</x:ProtectWindows>
 </x:ExcelWorkbook>
 <x:ExcelName>
  <x:Name>Print_Area</x:Name>
  <x:SheetIndex>1</x:SheetIndex>
  <%
  col_rango_final = "AB"
  if para <> "" then 
    fila = fila - 1
    col_rango_final = "S"
  end if
  %>
 <x:Formula>Sheet1!$A:$C</x:Formula>
 </x:ExcelName>
</xml><![endif]-->
</body>
</html>

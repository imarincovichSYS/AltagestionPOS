<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
producto      = Ucase(Trim(Unescape(Request.Form("producto"))))
nombre        = Replace(Ucase(Trim(Unescape(Request.Form("nombre")))),"§","+")
superfamilia  = Unescape(Request.Form("superfamilia"))
familia       = Unescape(Request.Form("familia"))
subfamilia    = Unescape(Request.Form("subfamilia"))

marca                                 = Trim(Unescape(Request.Form("marca")))
temporada                             = Trim(Unescape(Request.Form("temporada")))
unidad_de_medida_venta_peso_en_grs    = Trim(Unescape(Request.Form("unidad_de_medida_venta_peso_en_grs")))
unidad_de_medida_venta_volumen_en_cc  = Trim(Unescape(Request.Form("unidad_de_medida_venta_volumen_en_cc")))
porcentaje_impuesto_1                 = Trim(Unescape(Request.Form("porcentaje_impuesto_1")))

if unidad_de_medida_venta_peso_en_grs   = ""  then 
  unidad_de_medida_venta_peso_en_grs  = 0
else
  unidad_de_medida_venta_peso_en_grs  = Replace(unidad_de_medida_venta_peso_en_grs,",",".")
end if
if unidad_de_medida_venta_volumen_en_cc = ""  then 
  unidad_de_medida_venta_volumen_en_cc = 0
else
  unidad_de_medida_venta_volumen_en_cc = Replace(unidad_de_medida_venta_volumen_en_cc,",",".")
end if
if porcentaje_impuesto_1                = ""  then 
  porcentaje_impuesto_1 = 0
else
  porcentaje_impuesto_1 = Replace(porcentaje_impuesto_1,",",".")
end if
OpenConn

id_area = Get_Area_Bodega_Segun_Superfamilia_y_Familia(superfamilia, familia)

if nombre = "" then nombre = "-"
'Los insert se pueden hacer dejando que el trigger actualice las otras tablas o se desactiva el trigger y se hace el ingreso a través de ASP
'Son 4 las tablas que se deben actualizar: productos, productos_en_bodegas, codigos_alternativos_de_productos, Productos_en_listas_de_precios. Las ultimas 2 tablas se actualizan
'si se inserta un registro en productos.
'################### (SE UTILIZARÁN LOS TRIGGER PARA LOS INSERT EN LA OTRAS TABLAS) ######################
Codigo_EAN13  = Get_Nuevo_Codigo_EAN13

Tasa_impuesto_aduanero = 0 : Afecto_o_exento = "E"
if superfamilia <> "G" then 
  Tasa_impuesto_aduanero = Get_Tasa_Impuesto_Aduanero
  Afecto_o_exento = "A"
end if
Conn.BeginTrans
strSQL="Insert into Productos(Producto, Empresa, Familia, Nombre, Nombre_para_boleta, Nombre_producto_proveedor_habitual,Procedencia_producto, " &_       "Subfamilia, Superfamilia, Tipo_producto, Unidad_de_medida_consumo, Unidad_de_medida_compra, Tasa_impuesto_aduanero, " &_
       "Afecto_o_exento, Codigo_EAN13, Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_peso_en_kgs, " &_
       "Unidad_de_medida_venta_volumen_en_cc, Unidad_de_medida_venta_volumen_en_m3, marca, temporada, porcentaje_impuesto_1, id_area) values (" &_       "'"&producto&"'," &_       "'SYS', " &_       "'"&familia&"', " &_       "'"&nombre&"', " &_       "'"&left(nombre,35)&"', " &_
       "'"&nombre&"', " &_       "'I'," &_       "'"&subfamilia&"', " &_       "'"&superfamilia&"', " &_       "'P', " &_       "'UN'," &_       "'UN'," &_       ""&Tasa_impuesto_aduanero&", " &_
	     "'"&Afecto_o_exento&"', " &_	     "'"&Codigo_EAN13&"', " &_	     ""&unidad_de_medida_venta_peso_en_grs&"," &_
	     "0," &_
	     ""&unidad_de_medida_venta_volumen_en_cc&",0," &_
	     "'"&marca&"', " &_
       "'"&temporada&"', " &_
	     ""&porcentaje_impuesto_1&"," &_
       ""&id_area&")"
'Response.Write strSQL
'response.end
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:51" 
  Response.End
end if

strSQL="Insert into Productos_en_listas_de_precios (Empresa,Limite_precio,Lista_de_precios,Producto,Moneda_valor,Valor_unitario) values (" &_       "'SYS',0,'L01','"&producto&"','$',999999)"
'Response.Write strSQL
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:69" 
  Response.End
end if
'########################################################################
'############# Crear registro en L02 ("liquidación") ####################
'strSQL="Insert into Productos_en_listas_de_precios (Empresa,Limite_precio,Lista_de_precios,Producto,Moneda_valor,Valor_unitario) values (" &_ '      "'SYS',0,'L02','"&producto&"','$',999999)"
'Response.Write strSQL
'Conn.Execute(strSQL)
'if err <> 0 then
 ' Conn.RollbackTrans
  'Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:69" 
  'Response.End
'end if
'########################################################################

'Conn.Rollback
Conn.CommitTrans
%>
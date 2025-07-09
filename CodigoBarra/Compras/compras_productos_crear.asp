<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

on error resume next
producto      = Ucase(Trim(Request.Form("producto")))
nombre        = Ucase(Trim(Unescape(Request.Form("nombre"))))
superfamilia  = Unescape(Request.Form("superfamilia"))
familia       = Unescape(Request.Form("familia"))
subfamilia    = Unescape(Request.Form("subfamilia"))
OpenConn

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
       "Unidad_de_medida_venta_volumen_en_cc, Unidad_de_medida_venta_volumen_en_m3) values (" &_       "'"&producto&"'," &_       "'SYS', " &_       "'"&familia&"', " &_       "'"&nombre&"', " &_       "'"&left(nombre,35)&"', " &_
       "'"&nombre&"', " &_       "'I'," &_       "'"&subfamilia&"', " &_       "'"&superfamilia&"', " &_       "'P', " &_       "'UN'," &_       "'UN'," &_       ""&Tasa_impuesto_aduanero&", " &_
	     "'"&Afecto_o_exento&"', " &_	     "'"&Codigo_EAN13&"', " &_	     "0,0,0,0)"
'Response.Write strSQL
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
strSQL="Insert into Productos_en_listas_de_precios (Empresa,Limite_precio,Lista_de_precios,Producto,Moneda_valor,Valor_unitario) values (" &_       "'SYS',0,'L02','"&producto&"','$',999999)"
'Response.Write strSQL
Conn.Execute(strSQL)
if err <> 0 then
  Conn.RollbackTrans
  Response.Write err.Source & ", " & err.number & ", " & err.Description & ", Linea:69" 
  Response.End
end if
'########################################################################

Conn.CommitTrans
%>
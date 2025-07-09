<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

producto = Request.Form("producto")
OpenConn
strSQL="select superfamilia, familia, subfamilia, marca, genero, stock_minimo_manual, " &_
       "unidad_de_medida_venta_peso_en_grs, unidad_de_medida_venta_volumen_en_cc from " &_
       "productos with(nolock) where empresa = 'SYS' and producto = '" & producto & "'"
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  superfamilia  = trim(rs("superfamilia"))
  familia       = trim(rs("familia"))
  subfamilia    = trim(rs("subfamilia"))
  marca         = trim(rs("marca"))
  genero        = trim(rs("genero"))
  stock_minimo_manual = trim(rs("stock_minimo_manual"))
  unidad_de_medida_venta_peso_en_grs    = trim(rs("unidad_de_medida_venta_peso_en_grs"))
  unidad_de_medida_venta_volumen_en_cc  = trim(rs("unidad_de_medida_venta_volumen_en_cc"))
end if
delimiter = "~"
Response.Write superfamilia & delimiter & familia & delimiter & subfamilia & delimiter & marca & delimiter & genero & delimiter & stock_minimo_manual & delimiter & unidad_de_medida_venta_peso_en_grs & delimiter & unidad_de_medida_venta_volumen_en_cc
%>
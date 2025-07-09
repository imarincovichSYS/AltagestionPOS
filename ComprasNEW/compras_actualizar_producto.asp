<!--#include file="../_private/config.asp" -->
<%
producto            = Trim(Unescape(Request.Form("producto")))
superfamilia        = Trim(Unescape(Request.Form("superfamilia")))
familia             = Trim(Unescape(Request.Form("familia")))
subfamilia          = Trim(Unescape(Request.Form("subfamilia")))
marca               = Trim(Unescape(Request.Form("marca")))
genero              = Trim(Unescape(Request.Form("genero")))
stock_minimo_manual = Request.Form("stock_minimo_manual")
unidad_de_medida_venta_peso_en_grs    = Request.Form("unidad_de_medida_venta_peso_en_grs")
unidad_de_medida_venta_volumen_en_cc  = Request.Form("unidad_de_medida_venta_volumen_en_cc")

documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
numero_linea                            = Request.Form("numero_linea")

  if superfamilia = "BL" then
    if familia = "AJ" or familia = "BS" then
    porcentaje_impuesto_1 = 0
    elseif familia = "GC" or familia = "EC" or familia = "BC" then
    porcentaje_impuesto_1 = 10
  elseif familia = "GA" or familia = "EA" or familia = "BA" then 
    porcentaje_impuesto_1 = 18
  elseif familia = "CC" or familia = "VC" then
    porcentaje_impuesto_1 = 20.5
  elseif familia = "LC" then
    porcentaje_impuesto_1 = 31.5
  end if
  else
    porcentaje_impuesto_1 = 0
  end if


OpenConn
strSQL="update productos set " &_
       "superfamilia  = '" & superfamilia & "', " &_
       "familia       = '" & familia & "', " &_
       "subfamilia    = '" & subfamilia & "', " &_
       "marca         = '" & marca & "', " &_
       "genero        = '" & genero & "', " &_
       "stock_minimo_manual = " & stock_minimo_manual & ", " &_
       "unidad_de_medida_venta_peso_en_grs = " & unidad_de_medida_venta_peso_en_grs & ", " &_
       "unidad_de_medida_venta_volumen_en_cc = " & unidad_de_medida_venta_volumen_en_cc & ", " &_
       "Porcentaje_impuesto_1 = "& porcentaje_impuesto_1  &_
       " where empresa='SYS' and producto = '" & producto & "'"
'response.write strSQL
'response.end
 
Conn.Execute(strSQL)



'Actualizar estructura en TCP --> No se actualizar el detalle de TCP porque no se está cargando en ninguna parte estos datos
'strSQL="update movimientos_productos set " &_
'       "superfamilia  = '" & superfamilia & "', " &_
'		   "familia       = '" & familia & "', " &_
'		   "subfamilia    = '" & subfamilia & "' " &_
'		   "where empresa='SYS' and " &_
'       "documento_no_valorizado                       ='" & documento_no_valorizado & "' and " &_
'       "numero_documento_no_valorizado                = " & numero_documento_no_valorizado & " and " &_
'       "Tipo_documento_de_compra                      ='" & documento_respaldo & "' and " &_
'       "numero_documento_de_compra                    = " & numero_documento_respaldo & " and " &_
'       "numero_interno_documento_no_valorizado        = " & numero_interno_documento_no_valorizado & " and " &_
'       "Numero_de_linea_en_RCP_o_documento_de_compra  = " & numero_linea
'response.write strSQL
'response.end
'Conn.Execute(strSQL)
%>
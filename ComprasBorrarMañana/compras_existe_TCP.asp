<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

traspaso_anio                           = Request.Form("traspaso_anio")
traspaso_documento_respaldo             = Request.Form("traspaso_documento_respaldo")
traspaso_numero_documento_respaldo      = Request.Form("traspaso_numero_documento_respaldo")

documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")

delimiter = "~"
OpenConn
strSQL="select Numero_interno_documento_no_valorizado, numero_documento_no_valorizado, " &_
       "bodega, proveedor, fecha_recepcion, paridad_conversion_a_dolar " &_
       "from documentos_no_valorizados where empresa='SYS' and year(fecha_recepcion) = '"&traspaso_anio&"' and " &_
       "documento_respaldo='"&traspaso_documento_respaldo&"' and numero_documento_respaldo="&traspaso_numero_documento_respaldo&" and " &_
       "documento_no_valorizado='TCP'"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then 
  'Limpiar todas la líneas de destino y cantidad de traspaso de la TCP ORIGEN
  'El traspaso de ítemes sólo se puede hacer en el momento que se está en la sesión, 
  'si sale y vuelve a entrar se pierde la información del traspaso)
  strSQL="update movimientos_productos set numero_de_linea_destino=null, cantidad_traspaso=0, producto = producto " &_
         "where empresa='SYS' and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  'Response.Write strSQL
  'Response.End
  Conn.Execute(strSQL)
  Response.Write rs("Numero_interno_documento_no_valorizado") & delimiter &_
                 rs("numero_documento_no_valorizado") & delimiter &_
                 rs("bodega") & delimiter &_
                 rs("proveedor") & delimiter &_
                 rs("fecha_recepcion") & delimiter &_
                 rs("paridad_conversion_a_dolar")
end if
%>
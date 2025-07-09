<!--#include file="../../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio                      = Request.Form("anio")
numero_interno_pedido     = Request.Form("numero_interno_pedido")
numero_pedido             = Request.Form("numero_pedido")
anio_TCP                  = Request.Form("anio_TCP")
documento_respaldo        = Request.Form("documento_respaldo")
numero_documento_respaldo = Request.Form("numero_documento_respaldo")
nom_tabla                 = "documentos_no_valorizados"
delimiter = "~"
OpenConn
strSQL="select numero_documento_respaldo, numero_documento_no_valorizado, " &_
       "numero_interno_documento_no_valorizado, fecha_recepcion, " &_
       "bodega, proveedor, IsNull(proveedor_2,'') proveedor_2, " &_
       "paridad_conversion_a_dolar paridad from "&nom_tabla&" " &_
       "where empresa='SYS' and documento_no_valorizado='TCP' and  " &_
       "documento_respaldo='"&documento_respaldo&"' and " &_
       "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
       "year(Fecha_recepcion)="&anio&" and proveedor is not null"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  'Response.Write "EXISTE"
  proveedor = trim(rs("proveedor"))
  if trim(rs("proveedor_2")) <> "" then proveedor = trim(rs("proveedor_2"))
  Response.Write rs("numero_documento_no_valorizado") & delimiter &_
  rs("numero_interno_documento_no_valorizado")        & delimiter &_
  rs("fecha_recepcion")                               & delimiter &_
  rs("bodega")                                        & delimiter &_
  proveedor                                           & delimiter &_
  rs("paridad")                                       & delimiter
else
  Response.Write "NO_EXISTE"
end if
%>
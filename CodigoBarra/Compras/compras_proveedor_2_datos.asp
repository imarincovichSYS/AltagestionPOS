<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")

nom_tabla = "documentos_no_valorizados_proveedores_secundarios"
delimiter = "~"
OpenConn

strSQL="select A.proveedor, B.apellidos_persona_o_nombre_empresa nombre, B.codigo_postal codprov from " &_
       "(select proveedor from "&nom_tabla&" where " &_
       "documento_respaldo='"&documento_respaldo&"' and " &_
       "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&") A," &_
       "(select entidad_comercial, apellidos_persona_o_nombre_empresa, codigo_postal from entidades_comerciales where empresa='SYS') B " &_
       "where A.proveedor=B.entidad_comercial"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSql)
if not rs.EOF then
  proveedor = Trim(rs("proveedor"))
  codprov   = Trim(rs("codprov"))
  Response.Write proveedor & delimiter & codprov
end if
%>
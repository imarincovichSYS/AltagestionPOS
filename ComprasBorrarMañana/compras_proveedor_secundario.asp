<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                                  = Request.Form("accion")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
proveedor                               = Request.Form("proveedor")
nom_tabla = "documentos_no_valorizados_proveedores_secundarios"
delimiter = "~"
OpenConn

if accion = "asignar" then
  'Chequear si se creó el registro del proveedor secundario, si no existe se crea
  strSQL="select proveedor from "&nom_tabla&" where " &_
         "documento_respaldo='"&documento_respaldo&"' and " &_
         "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  set rs = Conn.Execute(strSql)
  if rs.EOF then 'Crear el registro
    strSQL="insert into "&nom_tabla&"(documento_respaldo,numero_documento_respaldo," &_
           "documento_no_valorizado,numero_documento_no_valorizado," &_
           "numero_interno_documento_no_valorizado,proveedor) values ('"&documento_respaldo&"',"&numero_documento_respaldo&"," &_
           "'"&documento_no_valorizado&"',"&numero_documento_no_valorizado&","&numero_interno_documento_no_valorizado&",'"&proveedor&"')"
  else
    strSQL="update "&nom_tabla&" set proveedor='"&proveedor&"' where " &_
           "documento_respaldo='"&documento_respaldo&"' and " &_
           "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  end if  
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
elseif accion = "eliminar" then
  strSQL="delete "&nom_tabla&" where " &_
         "documento_respaldo='"&documento_respaldo&"' and " &_
         "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
end if
%>
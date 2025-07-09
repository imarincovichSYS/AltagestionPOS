<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio                      = Request.Form("anio")
documento_respaldo        = Request.Form("documento_respaldo")
numero_documento_respaldo = Request.Form("numero_documento_respaldo")
OpenConn
strSQL="select documento_respaldo from documentos_no_valorizados with(nolock) where empresa='SYS' and year(fecha_recepcion) = '"&anio&"' and " &_
       "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo&" and " &_
       "(documento_no_valorizado='RCP' or documento_no_valorizado='TCP')"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then Response.Write "EXISTE"
%>
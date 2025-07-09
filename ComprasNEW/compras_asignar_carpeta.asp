<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio                      = Request.Form("anio")
documento_respaldo        = Request.Form("documento_respaldo")
numero_documento_respaldo = Request.Form("numero_documento_respaldo")
carpeta                   = Request.Form("carpeta")
nom_tabla                 = "documentos_no_valorizados"
OpenConn

strSQL="update "&nom_tabla&" set carpeta='"&carpeta&"' where empresa='SYS' and " &_
       "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo
Response.Write strSQL
'set rs = Conn.Execute(strsql)
%>
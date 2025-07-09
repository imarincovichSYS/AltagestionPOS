<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

entidad_comercial = Request.Form("entidad_comercial")
nom_tabla         = "entidades_comerciales"
OpenConn
strSQL="select entidad_comercial from "&nom_tabla&" where empresa='SYS' and entidad_comercial='"&entidad_comercial&"'"
set rs = Conn.Execute(strsql)
if not rs.EOF then
  Response.Write "EXISTE"
else
  Response.Write "NO_EXISTE"
end if
%>
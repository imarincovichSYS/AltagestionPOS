<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

proveedor = Request.Form("proveedor")
strSQL="select codigo_postal from entidades_comerciales where empresa='SYS' and entidad_comercial='"&proveedor&"'"
'Response.Write strSQL
'Response.End
OpenConn
set rs = Conn.Execute(strSql)
if not rs.EOF then Response.Write Trim(rs("codigo_postal"))
%>
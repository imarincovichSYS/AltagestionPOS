<!--#include file="../../_private/config.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio          = Request.Form("anio")
numero_pedido = Request.Form("numero_pedido")
OpenConn
strSQL="select numero_pedido from pedidos where a�o="&anio&" and numero_pedido="&numero_pedido
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then Response.Write "EXISTE"
%>
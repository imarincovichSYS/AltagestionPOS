<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

superfamilia  = Unescape(Request.Form("superfamilia"))
familia       = Unescape(Request.Form("familia"))
subfamilia    = Unescape(Request.Form("subfamilia"))

OpenConn
Response.Write Get_Nuevo_Producto(superfamilia,familia,subfamilia)
%>
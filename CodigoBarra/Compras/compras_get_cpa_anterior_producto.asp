<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

producto        = Request.Form("producto")
fecha_recepcion = Request.Form("fecha_recepcion")
OpenConn
Response.Write Get_CPA_Producto_Anterior_a_Fecha_en_RCP(producto,fecha_recepcion)
%>
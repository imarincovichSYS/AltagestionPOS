<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
Response.Write Get_Rut_Nuevo_Proveedor_Extranjero
%>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

fecha = Request.Form("fecha")
OpenConn
delimiter = "~"
Response.Write GetParidad_X_Fecha(fecha) & delimiter & GetParidad_Para_Margen
%>
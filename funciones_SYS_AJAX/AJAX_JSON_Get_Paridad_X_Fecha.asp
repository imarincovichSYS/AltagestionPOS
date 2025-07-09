<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
fecha = Request.Form("fecha")
z_paridad_facturacion = GetParidad_X_Fecha(fecha)
z_paridad_facturacion = Replace(FormatNumber(z_paridad_facturacion,2),",",".")
strOutput = "{""paridad_facturacion"":""" & z_paridad_facturacion & """,""paridad_margen"":""" & GetParidad_Para_Margen & """}"
Response.Write strOutput
%>
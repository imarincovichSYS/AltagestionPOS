<!--#include file="_private/config.asp" -->
<!--#include file="_private/funciones_generales.asp" -->
<!--#include file="_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
Codigo_EAN13  = Get_Nuevo_Codigo_EAN13
Response.Write Codigo_EAN13
%>
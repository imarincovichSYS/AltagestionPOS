<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
    ' http://192.168.30.10/Abonados/Sanchez_PtaArenas/ComprasNEW/compras_listar.asp
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

bodega            								   = Request.Form("bodega")
numero_interno_documento_no_valorizado        = Request.Form("numero_interno_documento_no_valorizado")

sql = "exec  DOV_Cambiar_bodega_compra " & numero_interno_documento_no_valorizado & ", '"&bodega&"'"

OpenConn
response.write sql
Conn.Execute(sql)
Conn.Close()

%>
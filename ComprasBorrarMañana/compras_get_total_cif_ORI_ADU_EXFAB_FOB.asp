<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")

OpenConn
Response.Write Get_Total_Cif_ORI_ADU_EXFAB_FOB(documento_no_valorizado,numero_documento_no_valorizado,documento_respaldo,numero_documento_respaldo,numero_interno_documento_no_valorizado)
%>
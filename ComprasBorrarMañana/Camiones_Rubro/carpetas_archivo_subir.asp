<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/xle_upload.asp" -->
<%
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.QueryString("anio")
mes                 = Request.QueryString("mes")
num_carpeta         = Request.QueryString("num_carpeta")
id_gasto            = Request.QueryString("id_gasto")
nom_campo           = Request.QueryString("nom_campo")
extension           = unescape(Request.QueryString("extension"))

nom_archivo = "gasto_"&anio&"-"&mes&"_"&num_carpeta&"_"&id_gasto&extension
band_subir_archivo = true
if band_subir_archivo then
  Set up = New xelUpload
  up.Upload()
  for each fu in up.Ficheros.Items
    file_name = nom_archivo
    'RutaFISICA_Carpeta = Request.ServerVariables("APPL_PHYSICAL_PATH") & "Compras\Carpetas\Documentos\" & anio & "-" & mes & "_" & num_carpeta
    RutaFISICA_Carpeta = Request.ServerVariables("APPL_PHYSICAL_PATH") & "filesUpload"
  	fu.GuardarComo file_name, RutaFISICA_Carpeta
  	if not up.ExisteFichero(file_name, RutaFISICA_Carpeta) then
      Response.Redirect "carpetas_archivo.asp?anio="&anio&"&mes="&mes&"&num_carpeta="&num_carpeta&"&id_gasto="&id_gasto&"&nom_campo="&nom_campo&"&msg_accion=error"
      Response.End
    end if
  next
end if
OpenConn
fec_anio_mes = anio & "/" & mes & "/1"
strSQL="update carpetas_final_gastos set "&nom_campo&"='"&nom_archivo&"' where " &_
       "documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta&" and id_gasto="&id_gasto
'Response.Write strSQL
set rs=Conn.Execute(strSQL)
Response.Redirect "carpetas_archivo.asp?msg_accion=ok"
%>
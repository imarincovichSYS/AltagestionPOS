<!--#include file="../../_private/config.asp" -->
<%
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
id_gasto            = Request.Form("id_gasto")
nom_campo           = Request.Form("nom_campo")
nom_archivo         = unescape(Request.Form("nom_archivo"))
'--------------------------------------------------------
'Eliminar archivo
RutaArchivo = Request.ServerVariables("APPL_PHYSICAL_PATH") & "filesUpload\"&nom_archivo
set fs = createobject("scripting.filesystemobject")
if fs.FileExists(RutaArchivo) then
  fs.deletefile RutaArchivo, true
end if
'--------------------------------------------------------
'Borrar nombre del archivo
OpenConn
fec_anio_mes = anio & "/" & mes & "/1"
strSQL="update carpetas_final_gastos set "&nom_campo&"='' " &_
       "where documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta&" and id_gasto="&id_gasto
'Response.Write strSQL
set rs=Conn.Execute(strSQL)
%>
<!--#include file="../../_private/config.asp" -->
<%
accion              = Request.Form("accion")
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
id_gasto            = Request.Form("id_gasto")
nom_campo           = Request.Form("nom_campo")
valor               = Ucase(trim(Unescape(Request.Form("valor"))))
nom_tabla           = "carpetas_final_gastos"
OpenConn
fec_anio_mes = anio & "/" & mes & "/1"
if accion = "insertar" then
  strSQL="insert into carpetas_final_gastos(documento_respaldo,anio_mes,num_carpeta,id_gasto) " &_
         "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&num_carpeta&","&id_gasto&")"
  'Response.Write strSQL
  set rs = Conn.Execute(strsql)
elseif accion = "actualizar" then
  strSQL="update "&nom_tabla&" set "&nom_campo&"='"&valor&"' " &_
         "where documento_respaldo='"&documento_respaldo&"' and " &_
         "anio_mes='"&fec_anio_mes&"' " &_
         "and num_carpeta="&num_carpeta&" and " &_
         "id_gasto="&id_gasto
  'Response.Write strSQL
  set rs = Conn.Execute(strsql)
elseif accion = "eliminar" then
  strId_Gasto = unescape(Request.Form("strId_Gasto"))
  delimiter   = "~"
  tot_Id_Gasto = split(strId_Gasto,delimiter)
  for j=0 to Ubound(tot_Id_Gasto)
    id_gasto  = tot_Id_Gasto(j)
    strSQL="delete "&nom_tabla&" where " &_
           "documento_respaldo='"&documento_respaldo&"' and " &_
           "anio_mes='"&fec_anio_mes&"' " &_
           "and num_carpeta="&num_carpeta&" and id_gasto="&id_gasto
    'Response.Write strSql
    set rs = Conn.Execute(strSql)
  next
end if
%>
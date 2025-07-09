<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

accion              = Request.Form("accion")
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
nom_campo           = Request.Form("nom_campo")
valor               = Request.Form("valor")
tipo_dato           = Request.Form("tipo_dato")

nom_tabla           = "carpetas_final"

fec_anio_mes = anio & "/" & mes & "/1"
fecha_hoy = Replace(Get_Fecha_Formato_YYYY_MM_DD(date()),"/","-")
OpenConn
if accion = "insert" then
  nuevo_num_carpeta = Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes(documento_respaldo,fec_anio_mes)
  strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes, num_carpeta, carpeta, fecha_salida, fecha_llegada) " &_
         "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&"," &_
         "'"&documento_respaldo&"-"&anio&"-"&mes&"-"&nuevo_num_carpeta&"','"&fecha_hoy&"','"&fecha_hoy&"')"
  'Response.Write strSQL
  'response.end
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&nuevo_num_carpeta&"""}"
  Response.Write strOutput
elseif accion = "update" then
  if tipo_dato="fecha" then
    strSetUpdate = nom_campo & " = '" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"
  elseif tipo_dato = "entero" then
    strSetUpdate = nom_campo & " = " & valor
    if trim(valor) = "" then strSetUpdate = nom_campo & " = null "
  elseif tipo_dato = "texto" then
    strSetUpdate = nom_campo & "='" & valor & "'"
  end if
  strSQL="update "&nom_tabla&" set "&strSetUpdate&" " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&strSQL&"""}"
  Response.Write strOutput
elseif accion = "eliminar" then
  'Chequear que la carpeta no esté asociada a ninguna RCP o TCP
  strSQL="select carpeta from documentos_no_valorizados " &_
         "where empresa='SYS' and (documento_no_valorizado='RCP' or documento_no_valorizado='TCP') and " &_
         "carpeta='"&documento_respaldo&"-"&anio&"-"&cint(mes)&"-"&num_carpeta&"'"
  'Response.Write strSQL
  set rs_existe = Conn.Execute(strSQL)
  if not rs_existe.EOF then 
    strOutput = "{""accion"":""CARPETA_ASOCIADA"",""valor"":"""&strSQL&"""}"
    Response.Write strOutput
    Response.End
  end if
  
  'Eliminar todos los gastos asociados a la carpeta
  'strSQL="delete carpetas_final_gastos " &_
  '       "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
  'Response.Write strSQL
  Conn.Execute(strSQL)
  'Eliminar encabezado de carpeta
  'strSQL="delete "&nom_tabla&" " &_
  '       "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
  'Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&strSQL&"""}"
end if
%>

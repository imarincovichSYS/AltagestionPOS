<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
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
numero_linea        = Request.Form("numero_linea")

entidad_comercial     = trim(Request.Form("entidad_comercial"))
id_tipo_factura       = Request.Form("id_tipo_factura")
numero_factura        = Trim(Unescape(Request.Form("numero_factura")))
fecha_factura         = Trim(Unescape(Request.Form("fecha_factura")))
tipo_moneda           = Unescape(Request.Form("tipo_moneda"))
monto_moneda_origen   = Request.Form("monto_moneda_origen")
paridad               = Request.Form("paridad")
monto_total_usd       = Request.Form("monto_total_usd")
monto_final_usd       = Request.Form("monto_final_usd")
porcentaje_prorrateo  = Request.Form("porcentaje_prorrateo")

nom_tabla             = "carpetas_final_detalle"
fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
OpenConn

function Get_Nuevo_Numero_Linea_Detalle(documento_respaldo,fec_anio_mes, num_carpeta)
  x_numero_linea = 1
  strSQL="select IsNull(max(numero_linea),0) as max_numero_linea from carpetas_final_detalle " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' and num_carpeta=" & num_carpeta
  set v_rs = Conn.Execute(strSQL)
  if not v_rs.EOF then x_numero_linea = cint(v_rs("max_numero_linea")) + 1
  Get_Nuevo_Numero_Linea_Detalle = x_numero_linea
end function

if accion = "insert" then
  nuevo_numero_linea = Get_Nuevo_Numero_Linea_Detalle(documento_respaldo,fec_anio_mes, num_carpeta)
  strSQL="insert into " & nom_tabla & "(documento_respaldo, anio_mes, num_carpeta, numero_linea) " &_
         "values('" & documento_respaldo & "','" & fec_anio_mes & "'," & num_carpeta & "," & nuevo_numero_linea & ")"
  'Response.Write strSQL
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&nuevo_numero_linea&"""}"
  Response.Write strOutput
elseif accion = "update" then
  fecha_factura_YYYY_DD_MM = Get_Fecha_Formato_YYYY_MM_DD(fecha_factura)
  strSQL="update " & nom_tabla & " set " &_
         "entidad_comercial     = '"  & entidad_comercial & "', " &_
         "id_tipo_factura       = "   & id_tipo_factura & ", " &_
         "numero_factura        = '"  & numero_factura & "', " &_
         "fecha_factura         = '"  & fecha_factura_YYYY_DD_MM & "', " &_
         "tipo_moneda           = '"  & tipo_moneda & "', " &_
         "monto_moneda_origen   = "   & Replace(monto_moneda_origen,",",".") & ", " &_
         "paridad               = "   & Replace(paridad,",",".") & ", " &_
         "monto_total_us$       = "   & Replace(monto_total_usd,",",".") & ", " &_
         "monto_final_us$       = "   & Replace(monto_final_usd,",",".") & ", " &_
         "porcentaje_prorrateo  = "   & Replace(porcentaje_prorrateo,",",".") & " " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' " &_
         "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea
  response.write strSQL
  'response.end
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&strSQL&"""}"
  Response.Write strOutput
elseif accion = "delete" then
  strSQL="delete " & nom_tabla & " " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='" & fec_anio_mes & "' " &_
         "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea
  valor_out = strSQL
  Conn.Execute(strSQL)
  
  'Actualizar los numeros de l�nea de los �temes que est�n despu�s del �tem eliminado
  strSQL="update " & nom_tabla & " set " &_
         "numero_linea = numero_linea - 1 " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='" & fec_anio_mes & "' " &_
         "and num_carpeta=" & num_carpeta & " and numero_linea > " & numero_linea
  valor_out = valor_out & " ---------- " & strSQL
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&valor_out&"""}"
  Response.Write strOutput
end if
%>

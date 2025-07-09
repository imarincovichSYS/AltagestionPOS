


<!--#include file="../../../_private/config.asp" -->
<!--#include file="../../../_private/funciones_generales.asp" -->
<%
function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
OpenConn
'fecha_ini_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Replace(dateadd("m",-4, date()),"/","-"))
documento_respaldo            = Request.Form("documento_respaldo")
anio                          = Request.Form("anio")
mes                           = Request.Form("mes")
Numero_documento_respaldo     = Request.Form("Numero_documento_respaldo")
str_documento_respaldo = " documento_respaldo='" & documento_respaldo & "'"
if documento_respaldo = "R" then str_documento_respaldo = " (documento_respaldo='R' or documento_respaldo='DS') "

'strSQL = "select carpeta, substring(carpeta, charindex('-',carpeta,6) + 1, " & _
'         "(charindex('-',carpeta,charindex('-',carpeta,6) + 1) - 1) - charindex('-',carpeta,6)) as num_mes " & _
'         "from documentos_no_valorizados where empresa='SYS' and fecha_recepcion >= '"&fecha_ini_YYYY_MM_DD&"' " &_
'         "" & str_documento_respaldo & " and (documento_no_valorizado='TCP' or documento_no_valorizado='RCP') " & _
'         "and tipo_oc <> 'P' group by carpeta, substring(carpeta, charindex('-',carpeta,6) + 1, " & _
'         "(charindex('-',carpeta,charindex('-',carpeta,6) + 1) - 1) - charindex('-',carpeta,6)) order by num_mes"select carpeta , charindex('-',carpeta,2)


strCarpeta = documento_respaldo & "-" & anio & "-" & mes
cant_caracteres = len(strCarpeta)
strSQL="select carpeta , convert(int,(substring(carpeta,11,2))) from documentos_no_valorizados (nolock) where "&str_documento_respaldo&" and documento_no_valorizado='RCP' and tipo_oc <> 'P' And empresa='SYS' " &_
       "and substring(carpeta,1,"&cant_caracteres&") = '"&strCarpeta&"' group by carpeta " &_
       "UNION " &_
       "select carpeta, convert(int,(substring(carpeta,11,2))) from documentos_no_valorizados (nolock) where "&str_documento_respaldo&" and documento_no_valorizado='TCP' and tipo_oc <> 'P' And empresa='SYS' " &_
       "and substring(carpeta,1,"&cant_caracteres&") = '"&strCarpeta&"' group by carpeta " &_
       " order by convert(int,(substring(carpeta,11,2)))"

'response.write Numero_documento_respaldo
'response.end

set rs = Conn.Execute(strSQL)
%>
<select id="camion" name="camion" style="width:50px;">
<%do while not rs.EOF
  carpeta = Trim(rs("carpeta"))
  Array_Datos_Carpeta = Split(carpeta, "-")
  num_camion = Array_Datos_Carpeta(3)
  %>
  <option value="<%=num_camion%>"><%=num_camion%></option>
<%rs.MoveNext
loop%>
</select>
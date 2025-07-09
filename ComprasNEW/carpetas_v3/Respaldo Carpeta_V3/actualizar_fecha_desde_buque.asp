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

OpenConn

carpeta              = Request.Form("carpeta")

strSQL = "exec CAR_Grabar_Fecha_Desde_Buque '" & carpeta & "'"

set rs = Conn.Execute(strSQL)

if Conn.Errors.Count <> 0 then
    strOutput = "{""accion"":""OK"",""valor"":"""&strSQL&"""}"        
else
    strOutput = "{""accion"":""ERROR"",""valor"":"""&Err.Description&"""}"
end if

Response.Write strOutput




%>

<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
    On Error Resume Next
function Get_Fecha_YYYYMMDD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
    if c_mes <= 9 then
        c_mes = "0" & c_mes
    end if
    if c_dia <= 9 then
        c_dia = "0" & c_dia
    end if
  Get_Fecha_YYYYMMDD = c_anio & "" & c_mes & "" & c_dia
end function

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
carpeta             = "'"& documento_respaldo &"-"& anio &"-"& mes &"-"& num_carpeta &"'"

Lugar               = Request.Form("Lugar")
Fecha_llegada       = Request.Form("Fecha_llegada")
Fecha_salida        = Request.Form("Fecha_salida")
Buque_Base          = Request.Form("Buque_Base")
Viaje               = Request.Form("Viaje")
IdLinea             = Request.Form("IdLinea")


fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
if Not isNull(Fecha_llegada) then
    Fecha_llegada = "'" & Get_Fecha_YYYYMMDD(Fecha_llegada) & "'"
end if
if Not isNull(Fecha_salida) then
     Fecha_salida = "'" & Get_Fecha_YYYYMMDD(Fecha_salida) & "'"
end if 
flgError = "N"
OpenConn

  strSQL="exec  [dbo].[sp_i_Carpetas_Embarcador] null, "& carpeta &","& Lugar &","& Fecha_llegada &","& Fecha_salida &","& Buque_Base &","& Viaje
  'Response.Write strSQL
  Conn.Execute(strSQL)
  Response.Write strOutput
  Conn.BeginTrans
      Conn.Execute(strSQL)
      if Conn.Errors.Count <> 0 then
          flgError = "S"
          msgError = Err.Description
      end if
      if flgError = "N" then
          strOutput = "{""accion"":""OK"",""valor"":"""&strSQL&"""}"
          Conn.CommitTrans
          'Conn.RollbackTrans
      else
          msgError = replace( msgError, "[Microsoft]", "" )
          msgError = replace( msgError, "[ODBC SQL Server Driver]", "" )
          msgError = replace( msgError, "[SQL Server]", "" )
          msgError = replace( msgError, "�", "u" )
          msgError = replace( msgError, "�", "e" )
          msgError = replace( msgError, "�", "i" )
          msgError = replace( msgError, "�", "o" )
          msgError = replace( msgError, "�", "u" )
          msgError = replace( msgError, "�", "n" )
          msgError = replace( msgError, "�", "N" )

          strOutput = "{""accion"":""ERR"",""valor"":"""&msgError&"""}"
          Conn.RollbackTrans
      end if
  Response.Write strOutput
%>

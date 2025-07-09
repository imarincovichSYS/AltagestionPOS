<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
    ' http://192.168.30.10/Abonados/Sanchez_PtaArenas/ComprasNEW/carpetas_v3/carpetas_grabar_detalle.asp

    On Error Resume Next

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
tipo_docto_aduana     = Trim(Unescape(Request.Form("tipo_docto_aduana")))
Numero_aduana         = Trim(Request.Form("Numero_aduana"))
'Numero_aduana         = Trim(Unescape(Request.Form("Numero_aduana")))
if isNull( Numero_aduana ) then Numero_aduana = ""
if Numero_aduana = "" then Numero_aduana = "Null"
fecha_factura         = Trim(Unescape(Request.Form("fecha_factura")))
fecha_aduana          = Trim(Unescape(Request.Form("fecha_aduana")))
tipo_moneda           = Unescape(Request.Form("tipo_moneda"))
monto_moneda_origen   = Request.Form("monto_moneda_origen")
paridad               = Request.Form("paridad")
monto_total_usd       = Request.Form("monto_total_usd")
monto_final_usd       = Request.Form("monto_final_usd")
porcentaje_prorrateo  = Request.Form("porcentaje_prorrateo")
Bultos                = Trim(Unescape(Request.Form("Bultos")))
CBM                   = Trim(Unescape(Request.Form("CBM")))
KG                    = Trim(Unescape(Request.Form("KG")))
Fisico                = Trim(Unescape(Request.Form("Fisico")))
if id_tipo_factura <> 1 then
    Bultos = ""
end if

ProrrateoCBM = Request.Form("ProrrateoCBM")
ProrrateoKG = Request.Form("ProrrateoKG")
ProrrateoUSD = Request.Form("ProrrateoUSD")
ProrrateoItems = Request.Form("ProrrateoItems")
Numero_lineas_factura = Request.Form("Numero_lineas_factura")

nom_tabla             = "carpetas_final_detalle"
fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
OpenConn

GrabarUFCenCarpetas = "N"
cSQL = "Exec PAR_ListaParametros 'AsienUFCCarp'"
set rs = Conn.Execute( cSQL )
if Not rs.Eof then
	GrabarUFCenCarpetas = ucase( ltrim( rs( "VALOR_TEXTO" ) ) )
end if
rs.Close

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
  fecha_aduana_YYYY_DD_MM = "Null"
  if fecha_aduana <> "" then
    fecha_aduana_YYYY_DD_MM = "'" & Get_Fecha_Formato_YYYY_MM_DD(fecha_aduana) & "'"
  end if
  if Bultos = "" then Bultos = "Null"
  if Fisico = "" then Fisico = "N"

  flgError = "N"
  msgError = ""

  IF GrabarUFCenCarpetas = "N" THEN
      strSQL="update " & nom_tabla & " set " &_
             "entidad_comercial     = '" & entidad_comercial & "', " &_
             "id_tipo_factura       = "  & id_tipo_factura & ", " &_
             "numero_factura        = '" & numero_factura & "', " &_
             "Tipo_documento_aduana = '" & tipo_docto_aduana & "', " &_
             "Numero_aduana         = '" & Numero_aduana & "', " &_
             "fecha_factura         = '" & fecha_factura_YYYY_DD_MM & "', " &_
             "fecha_aduana          = "  & fecha_aduana_YYYY_DD_MM & ", " &_
             "tipo_moneda           = '" & tipo_moneda & "', " &_
             "monto_moneda_origen   = "  & Replace(monto_moneda_origen,",",".") & ", " &_
             "paridad               = "  & Replace(paridad,",",".") & ", " &_
             "monto_total_us$       = "  & Replace(monto_total_usd,",",".") & ", " &_
             "monto_final_us$       = "  & Replace(monto_final_usd,",",".") & ", " &_
             "porcentaje_prorrateo  = "  & Replace(porcentaje_prorrateo,",",".") & ", " &_
             "Bultos                = "  & Bultos & ", " &_
             "Fisico                = '" & Fisico & "', " &_
             "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' " &_
             "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea
  ELSE
        strSQL = "Exec CPA_GrabaFacturaCompra "
        strSQL = strSQL & "'" & documento_respaldo & "', "
        strSQL = strSQL & "'" & fec_anio_mes & "', "
        strSQL = strSQL & "" & num_carpeta & ", "
        strSQL = strSQL & "" & numero_linea & ", "
        strSQL = strSQL & "'" & session("login") & "', "

        strSQL = strSQL & "'" & entidad_comercial & "', "
        strSQL = strSQL & "" & id_tipo_factura & ", "
        strSQL = strSQL & "'" & numero_factura & "', "
        strSQL = strSQL & "'" & tipo_docto_aduana & "', "
        strSQL = strSQL & "" & Numero_aduana & ", "
        strSQL = strSQL & "'" & fecha_factura_YYYY_DD_MM & "', "
        strSQL = strSQL & "" & fecha_aduana_YYYY_DD_MM & ", "
        strSQL = strSQL & "'" & tipo_moneda & "', "
        strSQL = strSQL & "" & Replace(monto_moneda_origen,",",".") & ", "
        strSQL = strSQL & "" & Replace(paridad,",",".") & ", "
        strSQL = strSQL & "" & Replace(monto_total_usd,",",".") & ", "
        strSQL = strSQL & "" & Replace(monto_final_usd,",",".") & ", "
        strSQL = strSQL & "" & Replace(porcentaje_prorrateo,",",".") & ", "
        strSQL = strSQL & "" & Bultos & ", "
        strSQL = strSQL & "" & Replace(CBM,",",".") & ", "
        strSQL = strSQL & "" & Replace(KG,",",".") & ", "
        strSQL = strSQL & "'" & Fisico & "', "

        strSQL = strSQL & "" & Replace(ProrrateoCBM,",",".") & ", "
        strSQL = strSQL & "" & Replace(ProrrateoKG,",",".") & ", "
        strSQL = strSQL & "" & Replace(ProrrateoUSD,",",".") & ", "

        strSQL = strSQL & "'" & ProrrateoItems & "', "
        strSQL = strSQL & "" & Numero_lineas_factura & " "
        'Response.write( strSQL & "<br>" )
  END IF

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
          msgError = replace( msgError, "á", "u" )
          msgError = replace( msgError, "é", "e" )
          msgError = replace( msgError, "í", "i" )
          msgError = replace( msgError, "ó", "o" )
          msgError = replace( msgError, "ú", "u" )
          msgError = replace( msgError, "ñ", "n" )
          msgError = replace( msgError, "Ñ", "N" )

          strOutput = "{""accion"":""ERR"",""valor"":"""&msgError&"""}"
          Conn.RollbackTrans
      end if
  Response.Write strOutput
elseif accion = "delete" then
  flgError = "N"
  msgError = ""
  Conn.BeginTrans
    IF GrabarUFCenCarpetas = "S" THEN
        strSQL = "Exec CPA_BorrarFacturaCompra "
        strSQL = strSQL & "'" & documento_respaldo & "', "
        strSQL = strSQL & "" & anio & ", "
        strSQL = strSQL & "" & mes & ", "
        strSQL = strSQL & "" & num_carpeta & ", "
        strSQL = strSQL & "" & numero_linea & " "
        Conn.Execute(strSQL)
        if Conn.Errors.Count <> 0 then
            flgError = "S"
            msgError = Err.Description
        end if
    END IF
    if flgError = "N" then
        strSQL="delete " & nom_tabla & " " &_
                "where documento_respaldo='" & documento_respaldo & "' and anio_mes='" & fec_anio_mes & "' " &_
                "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea
        valor_out = strSQL
        Conn.Execute(strSQL)
        if Conn.Errors.Count <> 0 then
            flgError = "S"
            msgError = Err.Description
        end if
    end if
      'Actualizar los numeros de línea de los ítemes que están después del ítem eliminado
    if flgError = "N" then
        strSQL="update " & nom_tabla & " set " &_
                "numero_linea = numero_linea - 1 " &_
                "where documento_respaldo='" & documento_respaldo & "' and anio_mes='" & fec_anio_mes & "' " &_
                "and num_carpeta=" & num_carpeta & " and numero_linea > " & numero_linea
        valor_out = valor_out & " ---------- " & strSQL
        Conn.Execute(strSQL)
        if Conn.Errors.Count <> 0 then
            flgError = "S"
            msgError = Err.Description
        end if
    end if
    if flgError = "N" then
        strOutput = "{""accion"":""OK"",""valor"":"""&valor_out&"""}"
        Conn.CommitTrans
    else
        strOutput = "{""accion"":""ERR"",""valor"":"""&valor_out&"""}"
        Conn.RollbackTrans
    end if
  Response.Write strOutput
end if
%>

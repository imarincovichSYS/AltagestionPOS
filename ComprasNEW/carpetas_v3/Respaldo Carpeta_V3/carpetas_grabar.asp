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

carpeta_actualizar = documento_respaldo & "-" & anio & "-" & mes & "-" & num_carpeta
'
'accion              = "update"
'documento_respaldo  = "R"
'anio                = 2017
'mes                 = 3
'num_carpeta         = 3
'nom_campo           = "fecha_recepcion"
'valor               = "18-01-2017"
'tipo_dato           = "fecha"
'

nom_tabla           = "carpetas_final"

fec_anio_mes = anio & "/" & mes & "/1"
fecha_hoy = Replace(Get_Fecha_Formato_YYYY_MM_DD(date()),"/","-")
OpenConn
if accion = "insert" then
  nuevo_num_carpeta = Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes(documento_respaldo,fec_anio_mes)
  
  'strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes, num_carpeta, carpeta, fecha_salida, fecha_llegada) " &_
  '       "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&"," &_
  '       "'"&documento_respaldo&"-"&anio&"-"&mes&"-"&nuevo_num_carpeta&"','"&fecha_hoy&"','"&fecha_hoy&"')"

  IF documento_respaldo = "Z" THEN
  strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes, num_carpeta, carpeta) " &_
         "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&"," &_
         "'"&documento_respaldo&"-"&anio&"-"&mes&"-"&nuevo_num_carpeta&"')"
  ELSE
  'strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes, num_carpeta, carpeta, Fecha_aduana ) " &_
  '       "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&"," &_
  '       "'"&documento_respaldo&"-"&anio&"-"&mes&"-"&nuevo_num_carpeta&"', '" & fecha_hoy & "')"
  strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes, num_carpeta, carpeta ) " &_
         "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&"," &_
         "'"&documento_respaldo&"-"&anio&"-"&mes&"-"&nuevo_num_carpeta&"')"
  END IF

  'Response.Write strSQL
  'response.end
  Conn.Execute(strSQL)
  strOutput = "{""accion"":""OK"",""valor"":"""&nuevo_num_carpeta&"""}"
  Response.Write strOutput
elseif accion = "update" then
  if tipo_dato="fecha" then
    strSetUpdate = nom_campo & " = '" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"
    'if nom_campo = "fecha_ptaarenas" then
    ''  strSetUpdate = strSetUpdate & " , fecha_llegada = '" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"
    'end if
  elseif tipo_dato = "entero" then
    strSetUpdate = nom_campo & " = " & valor
    if trim(valor) = "" then strSetUpdate = nom_campo & " = null "
  elseif tipo_dato = "texto" then
    strSetUpdate = nom_campo & "='" & valor & "'"
  end if

  flgError = "N"
  msgError = "N"

  Conn.BeginTrans

    if nom_campo = "fecha_recepcion" then
        cSQL = "Exec DNV_Actualiza_Fecha_Recepcion_de_la_Compra "
        cSQL = cSQL & "'" & Session( "Empresa_usuario" ) & "', "
        cSQL = cSQL & "'" & carpeta_actualizar & "', "
        cSQL = cSQL & "'" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"

        Conn.Execute(cSQL)
        if Conn.Errors.Count <> 0 then
            flgError = "S"
            msgError = Err.Description
        end if
    end if
    if nom_campo = "fecha_ptaarenas" then
        cSQL = "Exec CAR_Actualiza_Fecha_Estimada_Fecha_Punta_Arenas "
        cSQL = cSQL & "'" & Session( "Empresa_usuario" ) & "', "
        cSQL = cSQL & "'" & carpeta_actualizar & "', "
        cSQL = cSQL & "'" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"

        Conn.Execute(cSQL)
        if Conn.Errors.Count <> 0 then
            flgError = "S"
            msgError = Err.Description
        end if
    end if
    if documento_respaldo = "Z" then

        if nom_campo = "fecha_aduana" then
            cSQL = "Exec DNV_Actualiza_Fecha_Aduana_de_la_Compra "
            cSQL = cSQL & "'" & Session( "Empresa_usuario" ) & "', "
            cSQL = cSQL & "'" & carpeta_actualizar & "', "
            cSQL = cSQL & "'" & year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor)) & "'"

            Conn.Execute(cSQL)
            if Conn.Errors.Count <> 0 then
                flgError = "S"
                msgError = Err.Description
            end if
        end if
        
        if nom_campo = "Numero_aduana" then
            cSQL = "Exec DNV_Actualiza_Numero_Aduana_de_la_Compra "
            cSQL = cSQL & "'" & Session( "Empresa_usuario" ) & "', "
            cSQL = cSQL & "'" & carpeta_actualizar & "', "
            cSQL = cSQL & ""  & valor

            Conn.Execute(cSQL)
            if Conn.Errors.Count <> 0 then
                flgError = "S"
                msgError = Err.Description
            end if
        end if
    end if

  if flgError = "N" then
    borrar_buques = false
    if nom_campo = "id_transporte" or nom_campo = "id_embarcador" then
      strSQL =  "select isnull(id_transporte,0) as id_transporte , isnull(id_embarcador,0) as id_embarcador  from carpetas_final " &_
                "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
      set rs_check = Conn.Execute(strSQL)
      if not rs_check.EOF then 
        if ( Cdbl(rs_check("id_transporte")) = 2 and  Cdbl(valor) <> 2) or (Cdbl(rs_check("id_embarcador")) = 3 and   Cdbl(valor) <> 3) then
          borrar_buques = true
          
        end if 
      end if
      rs_check.close
      set rs_check = nothing
    end if

    if borrar_buques = true then
      strSQL="update carpetas_final set Id_Buque_Viaje_Punta_Arenas = null,Id_Buque_Viaje_San_Antonio = null " &_
            "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
      Conn.Execute(strSQL)
    end if

    
    if nom_campo = "Factor_recibir" then
		strSetUpdate = strSetUpdate & ", Fecha_llegada = DATEADD( dd, " & valor & ", Fecha_ptaarenas ) "
	end if

    strSQL="update "&nom_tabla&" set "&strSetUpdate&" " &_
            "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
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
        strOutput = "{""accion"":""ERROR"",""valor"":"""&msgError&"""}"
        Conn.RollbackTrans
    end if
  else
      strOutput = "{""accion"":""ERROR"",""valor"":"""&msgError&"""}"
  end if
  Response.Write strOutput
elseif accion = "eliminar" then
  'Chequear que la carpeta no est� asociada a ninguna RCP o TCP
  strSQL="select carpeta from documentos_no_valorizados " &_
         "where empresa='SYS' and (documento_no_valorizado='RCP' or documento_no_valorizado='TCP') and " &_
         "carpeta='"&documento_respaldo&"-"&anio&"-"&cint(mes)&"-"&num_carpeta&"'"
  'Response.Write strSQL
  set rs_existe = Conn.Execute(strSQL)
  if not rs_existe.EOF then 
    strOutput = "{""accion"":""CARPETA_ASOCIADA"",""valor"":"""&strSQL&"""}"
    Response.Write strOutput
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

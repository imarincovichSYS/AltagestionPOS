<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

'on error resume next

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
OpenConn

tipo_cambio                             = Request.Form("tipo_cambio")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
fecha_recepcion                         = Request.Form("fecha_recepcion")
paridad                                 = Request.Form("paridad")
proveedor                               = Request.Form("proveedor")
proveedor_2                             = Request.Form("proveedor_2")
Conn.BeginTrans
if tipo_cambio = "fecha_recepcion_y_paridad" then
  fecha_recepcion_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(fecha_recepcion)
  'Cambio Fecha Recepcion y Paridad DNV (CABECERA)
  strSQL="update documentos_no_valorizados set " &_
         "Fecha_recepcion = '"&fecha_recepcion_YYYY_MM_DD&"', " &_
         "Fecha_paridad_moneda_oficial = '"&fecha_recepcion_YYYY_MM_DD&"', " &_
         "Paridad_conversion_a_dolar = "&paridad&", " &_
         "Monto_total_moneda_oficial = Monto_neto_US$ * "&paridad&" " &_
         "where numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado
  accion  = "strSQL"
  valor   = strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Conn.RollbackTrans
    accion  = "ERROR"
    valor   = err.Source & ", " & err.number & ", " & err.Description & ", Linea:34"
    strOutput = "{""accion"":""" & accion & """,""valor"":""" & valor & """}"
    Response.End
  end if
  'Cambio Fecha Recepcion y Paridad MOP (DETALLE)
  strSQL="update movimientos_productos set " &_
         "Fecha_movimiento = '"&fecha_recepcion_YYYY_MM_DD&"', " &_
         "fecha_paridad_moneda_oficial = '"&fecha_recepcion_YYYY_MM_DD&"', " &_
         "valor_paridad_moneda_oficial = "&paridad&", " &_
         "Costo_CPA_$ = Costo_CPA_US$ * "&paridad&", " &_
         "Costo_Cif_Ori_$ = Costo_Cif_Ori_US$ * "&paridad&", " &_
         "Costo_Cif_Adu_$ = Costo_Cif_Adu_US$ * "&paridad&", " &_
         "Costo_EX_FAB_moneda_origen = Costo_Cif_Adu_US$ * "&paridad&", " &_
         "Costo_EX_FAB_$ = Costo_Cif_Adu_US$ * "&paridad&", " &_
         "Costo_FOB_$ = Costo_Cif_Adu_US$ * "&paridad&", " &_ 
         "Costo_Cif_Adu_$_al_momento_de_la_compra = Costo_Cif_Adu_US$ * "&paridad&", " &_
         "producto = producto " &_
         "where numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado
  accion  = "strSQL"
  valor   = valor & " ---- " & strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Conn.RollbackTrans
    accion  = "ERROR"
    valor   = err.Source & ", " & err.number & ", " & err.Description & ", Linea:34"
    strOutput = "{""accion"":""" & accion & """,""valor"":""" & valor & """}"
    Response.End
  end if
elseif tipo_cambio = "proveedor" then
  'Cambio Proveedor Legal (CABECERA)
  strSQL="update documentos_no_valorizados set " &_
         "proveedor = '"&proveedor&"'," &_
         "where numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado
  accion  = "strSQL"
  valor   = strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Conn.RollbackTrans
    accion  = "ERROR"
    valor   = err.Source & ", " & err.number & ", " & err.Description & ", Linea:34"
    strOutput = "{""accion"":""" & accion & """,""valor"":""" & valor & """}"
    Response.End
  end if
  'Cambio Proveedor (DETALLE)
  strSQL="update movimientos_productos set " &_
         "proveedor = '"&proveedor&"', " &_
         "producto = producto " &_
         "where numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado
  accion  = "strSQL"
  valor   = valor & " ---- " & strSQL
  Conn.Execute(strSQL)
  if err <> 0 then
    Conn.RollbackTrans
    accion  = "ERROR"
    valor   = err.Source & ", " & err.number & ", " & err.Description & ", Linea:34"
    strOutput = "{""accion"":""" & accion & """,""valor"":""" & valor & """}"
    Response.End
  end if
end if
strOutput = "{""accion"":""" & accion & """,""valor"":""" & valor & """}"
Response.Write strOutput
Conn.RollbackTrans
'Conn.CommitTrans
Conn.Close
%>
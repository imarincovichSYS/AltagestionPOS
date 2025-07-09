<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
    ' http://localhost/Altagestion/ComprasNEW/compras_grabar.asp
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                                  = Request.Form("accion")
anio                                    = Request.Form("anio")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
monto_ADU                               = Request.Form("monto_ADU") 'Valor para cálculo de total moneda oficial
paridad                                 = Request.Form("paridad") 'Valor para cálculo de total moneda oficial
proveedor                               = Request.Form("proveedor") 'Se utiliza aparte para cuando se elimina el segundo proveedor o se actualiza proveedor cabecera
proveedor_2                             = Request.Form("proveedor_2") 'Se utiliza aparte para cuando se elimina el segundo proveedor o se actualiza proveedor cabecera
nom_campo                               = Request.Form("nom_campo")
valor                                   = Request.Form("valor")

carpeta = Request.Form("carpeta")
if Request.Form("fecha_emision") <> "" then
    fecha_emision = cDate( Request.Form("fecha_emision") )
else
    fecha_emision = mid( now(), 1, 10 )
end if
fecha_recepcion = cDate( Request.Form("fecha_recepcion") )

nom_tabla = "documentos_no_valorizados"
delimiter = "~"
OpenConn
if accion = "insertar" then
  numero_documento_no_valorizado = Get_Nuevo_Numero_Documento_no_Valorizado_X_Documento_Respaldo("TCP")
  fecha_hoy = year(date()) & "/" & month(date()) & "/" & day(date())
  if fecha_emision <> "" then
    fecha_emi = "'" & year(fecha_emision) & "/" & month(fecha_emision) & "/" & day(fecha_emision) & "'"
  else
    fecha_emi = "Null"
  end if
  fecha_rec = year(fecha_recepcion) & "/" & month(fecha_recepcion) & "/" & day(fecha_recepcion)
    if documento_respaldo = "TU" then
      strSQL="insert into "&nom_tabla&"(Bodega, Documento_no_valorizado, Documento_respaldo, Carpeta, " &_
             "Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_emision, Numero_recepcion_de_compra, " &_
             "Numero_documento_no_valorizado, Numero_documento_respaldo, Observaciones_generales, paridad_conversion_a_dolar, Fecha_recepcion, Fecha_paridad_moneda_oficial) " &_
             "values(" &_
             "'0010'," &_
             "'"&documento_no_valorizado&"'," &_
             "'"&documento_respaldo&"'," &_
             "'"&carpeta&"'," &_
             "'"&session("Login")&"'," &_
             "'SYS'," &_
             "'AUT'," &_
             ""&fecha_emi&"," &_
             ""&numero_documento_no_valorizado&", " &_
             ""&numero_documento_no_valorizado&", " &_
             ""&numero_documento_respaldo&", " &_
             "'"&documento_no_valorizado&"'," &_
             "0.00, " &_
             "Null, " &_
             "'"&fecha_rec&"')"
             '"'"&fecha_rec&"', " &_
             '"'"&fecha_rec&"')"
    else
        if documento_respaldo = "Z" then
            paridad_para_facturacio = GetParidad_X_Fecha(Request.Form("fecha_recepcion"))

          strSQL="insert into "&nom_tabla&"(Bodega, Documento_no_valorizado, Documento_respaldo, Carpeta, " &_
                 "Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_emision, Numero_recepcion_de_compra, " &_
                 "Numero_documento_no_valorizado, Numero_documento_respaldo, Observaciones_generales, paridad_conversion_a_dolar, Fecha_recepcion, Fecha_paridad_moneda_oficial) " &_
                 "values(" &_
                 "'0010'," &_
                 "'"&documento_no_valorizado&"'," &_
                 "'"&documento_respaldo&"'," &_
                 "'"&carpeta&"'," &_
                 "'"&session("Login")&"'," &_
                 "'SYS'," &_
                 "'AUT'," &_
                 ""&fecha_emi&"," &_
                 ""&numero_documento_no_valorizado&", " &_
                 ""&numero_documento_no_valorizado&", " &_
                 ""&numero_documento_respaldo&", " &_
                 "'"&documento_no_valorizado&"'," &_
                 paridad_para_facturacio & ", " &_
                 "Null, " &_
                 "'"&fecha_rec&"')"
                 '"'"&fecha_rec&"', " &_
                 '"'"&fecha_rec&"')"
        else
          strSQL="insert into "&nom_tabla&"(Bodega, Documento_no_valorizado, Documento_respaldo, Carpeta, " &_
                 "Empleado_responsable, Empresa, Estado_documento_no_valorizado, Fecha_emision, Numero_recepcion_de_compra, " &_
                 "Numero_documento_no_valorizado, Numero_documento_respaldo, Observaciones_generales, paridad_conversion_a_dolar, Fecha_recepcion, Fecha_paridad_moneda_oficial) " &_
                 "values(" &_
                 "'0010'," &_
                 "'"&documento_no_valorizado&"'," &_
                 "'"&documento_respaldo&"'," &_
                 "'"&carpeta&"'," &_
                 "'"&session("Login")&"'," &_
                 "'SYS'," &_
                 "'AUT'," &_
                 ""&fecha_emi&"," &_
                 ""&numero_documento_no_valorizado&", " &_
                 ""&numero_documento_no_valorizado&", " &_
                 ""&numero_documento_respaldo&", " &_
                 "'"&documento_no_valorizado&"'," &_
                 "0.00, " &_
                 "Null, " &_
                 "'"&fecha_rec&"')"
                 '"'"&fecha_rec&"', " &_
                 '"'"&fecha_rec&"')"
        end if
    end if
  'Response.Write strSQL
  'Response.end
  set rs = Conn.Execute(strSQL)
  Numero_Interno_Documento_No_Valorizado = Get_Numero_Interno_Documento_No_Valorizado(documento_respaldo,numero_documento_respaldo,documento_no_valorizado,numero_documento_no_valorizado)
  Response.Write Numero_documento_no_valorizado & delimiter & Numero_Interno_Documento_No_Valorizado
elseif accion = "actualizar" then
  if nom_campo = "fecha_emision" or nom_campo="fecha_recepcion" or nom_campo="fecha_factura" then valor = year(valor) & "/" & month(valor) & "/"&day(valor)
  strSet    = " "&nom_campo&"='"&valor&"' "
  strSetMP  = ""
  if nom_campo="fecha_recepcion" or nom_campo="fecha_factura" or nom_campo="bodega" or nom_campo="paridad_conversion_a_dolar" or nom_campo="proveedor" or nom_campo="proveedor_2" or nom_campo = "numero_documento_respaldo" then 
    if nom_campo="bodega" then
      strSetMP = " bodega='"&valor&"' "
    elseif nom_campo="fecha_recepcion" then 
      strSet=strSet & ", fecha_paridad_moneda_oficial='"&valor&"' "
      strSetMP = " Fecha_paridad_moneda_oficial='"&valor&"', fecha_movimiento='"&valor&"', Año_recepcion_compra="&year(cdate(valor))&" "
    elseif nom_campo="fecha_factura" then 
        'if documento_respaldo <> "TU" then
        '    strSet=strSet & ", Fecha_recepcion=Null "
        'else
        '    'strSet=strSet & ", Fecha_recepcion=Null "
        'end if
      strSetMP = " Fecha_movimiento='"&valor&"', Año_recepcion_compra="&year(cdate(valor))&" "
      'strSetMP = " Fecha_paridad_moneda_oficial=Null, Fecha_movimiento='"&valor&"', Año_recepcion_compra="&year(cdate(valor))&" "
    elseif nom_campo="paridad_conversion_a_dolar" then
      strSetMP = " Valor_paridad_moneda_oficial= " & valor
      'strSetMP = strSetMP & ", Costo_CIF_ADU_$=Round(Costo_CIF_ADU_US$ * " & valor & ",7) " 'Costo_CIF_ADU_$
      strSetMP = strSetMP & ", Costo_CIF_ADU_$_al_momento_de_la_compra=Round(Costo_CIF_ADU_US$ * " & valor & ",0) " 'Costo_CIF_ADU_$_al_momento_de_la_compra
      'strSetMP = strSetMP & ", Costo_CIF_ORI_$=Round(Costo_CIF_ORI_US$ * " & valor & ",7) " 'Costo_CIF_ORI_$ 
      strSetMP = strSetMP & ", costo_CPA_$=Round(Costo_CPA_US$ * " & valor & ",7) " 'Costo_CPA_$
    elseif nom_campo="proveedor" and proveedor_2 = "" then 
      strSetMP = " proveedor='"&valor&"' " 'Se actualizó proveedor cabecera y no se ha agregado proveedor secundario-->actualizar todos los ítemes con el proveedor de la cabecera
    elseif nom_campo="proveedor_2" then 
      if valor = "" then 
        strSetMP = " proveedor='"&proveedor&"' " 'Se eliminó segundo proveedor, se deben actualizar todos los ítemes al proveedor de la cabecera
      else
        strSetMP = " proveedor='"&valor&"' " 'Se agregó segundo proveedor, se deben actalizar todos los ítemes a este proveedor
      end if
    elseif nom_campo = "numero_documento_respaldo" then 'Se cambió el numero_documento_respaldo (numero de la compra = n° aduana)
      'Verificar si el n° está ocupado por otra compra del mismo año y "documento_respaldo"
      strSQL="select documento_respaldo from documentos_no_valorizados with(nolock) where empresa='SYS' and year(fecha_recepcion) = '"&anio&"' and " &_
             "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo&" and " &_
             "(documento_no_valorizado='RCP' or documento_no_valorizado='TCP')"
      'Response.Write strSQL
      'Response.End
      set rs = Conn.Execute(strSQL)
      if not rs.EOF then 
        Response.Write "EXISTE"
        Response.End
      end if
      strSetMP = " Numero_documento_de_compra="&numero_documento_respaldo&" "
    end if
    
    if strSetMP <> "" then
      strSetMP = strSetMP & ", producto = producto " 'Para que no se gatille el trigger que actualiza los atributos desde "productos" a "movimientos_productos"
      if nom_campo = "numero_documento_respaldo" then
        strSQL="update movimientos_productos set "&strSetMP&" where empresa='SYS' and " &_
               "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
               "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
               "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
               "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
      else
        strSQL="update movimientos_productos set "&strSetMP&" where empresa='SYS' and " &_
               "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
               "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
               "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
               "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
               "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
      end if
      'Response.Write strSQL
      'Response.End
      if numero_interno_documento_no_valorizado <> "" then
         set rs = Conn.Execute(strSQL)
      end if
    end if
  end if
  if nom_campo="monto_neto_US$" or nom_campo="monto_adu_US$" or nom_campo="numero_factura" or nom_campo="paridad_conversion_a_dolar" or nom_campo = "numero_documento_respaldo" then strSet=" "&nom_campo&"="&valor&" "
  if nom_campo="monto_adu_US$" and (documento_respaldo <> "TU" and documento_respaldo <> "DS") then strSet = strSet & ", monto_neto_US$="&valor
  
  if nom_campo="monto_adu_US$" or nom_campo="paridad_conversion_a_dolar" or nom_campo="fecha_recepcion" then
    if monto_ADU = "" then monto_ADU = 0
    if paridad = "" then paridad = 0
    v_monto_total_moneda_oficial = Round(cdbl(monto_ADU) * cdbl(paridad),0)
    strSet = strSet & ", Monto_total_moneda_oficial = "&v_monto_total_moneda_oficial
  end if
  
  if nom_campo = "numero_documento_respaldo" then
    strSQL="update "&nom_tabla&" set "&strSet&" where empresa='SYS' and " &_
           "documento_respaldo='"&documento_respaldo&"' and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  else
    strSQL="update "&nom_tabla&" set "&strSet&" where empresa='SYS' and " &_
           "documento_respaldo='"&documento_respaldo&"' and " &_
           "numero_documento_respaldo="&numero_documento_respaldo&" and " &_
           "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
           "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
           "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  end if
  
  'Response.Write strSQL
  if numero_interno_documento_no_valorizado <> "" then
     set rs = Conn.Execute(strSQL)
  end if
elseif accion = "eliminar" then
  '1° se debe actualizar el Stock en tránsito

 '' strSQL="update Productos_en_bodegas set " &_
 ''        "Stock_en_transito  =  Stock_en_transito - M.cantidad_entrada " &_
 ''        "from Productos_en_bodegas P inner join movimientos_productos M on " &_
 ''        "M.empresa='SYS' and M.documento_no_valorizado='"&documento_no_valorizado&"' and " &_
  ''       "M.numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_'
''         "M.Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
''         "M.numero_documento_de_compra="&numero_documento_respaldo&" and " &_
''         "M.numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
''         "P.producto=M.producto and P.Empresa='SYS' and P.bodega='"&bodega&"'"

strSQL="update Productos_en_bodegas set Stock_en_transito = Stock_en_transito - b.cantidad_entrada " &_
       "from  Productos_en_bodegas a with(nolock), Movimientos_productos b with(nolock) " &_
       "where b.Documento_no_valorizado = '"&documento_no_valorizado&"' and " &_
       "b.numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "a.Producto = b.Producto  and a.Bodega   = b.bodega and " &_
       "b.Numero_de_linea not in (select distinct c.Numero_de_linea_en_RCP_o_documento_de_compra_padre from Movimientos_productos c with(nolock) " &_
                                 "where c.Documento_no_valorizado = '" &documento_no_valorizado&"' and c.numero_documento_de_compra="&numero_documento_respaldo&" and  Numero_de_linea_en_RCP_o_documento_de_compra_padre is not null)"

  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
  '2° se debe eliminar el detalle en "movimientos_productos": existe una validación de llaves foraneas
  strSQL="delete movimientos_productos where empresa='SYS' and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and numero_documento_de_compra="&numero_documento_respaldo&" and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
  strSQL="delete "&nom_tabla&" where empresa='SYS' and " &_
         "documento_respaldo='"&documento_respaldo&"' and numero_documento_respaldo="&numero_documento_respaldo&" and " &_
         "documento_no_valorizado='"&documento_no_valorizado&"' and numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
         "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
end if
%>
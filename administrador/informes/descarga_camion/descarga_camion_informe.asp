<%@ Language=VBScript %>
<!--#include file="../../../_private/config.asp" -->
<!--#include file="../../../_private/funciones_generales.asp" -->
<%

function Get_String_Suma_Cantidades_Item_Agrupado(x_documento_no_valorizado,x_numero_interno_documento_no_valorizado, x_numero_de_linea_Item_Base_agrupado_bodega)
  strSQL="select 	" &_
         "convert(varchar(15),IsNull(sum(A.cantidad_mercancias),0)) " &_
         "+ '|' + " &_
         "convert(varchar(10),IsNull(sum(A.cantidad_um_compra_en_caja_envase_compra),0)) " &_
         "+ '|' + " &_
         "convert(varchar(10),IsNull(sum(A.cantidad_x_un_consumo),0)) " &_
         "+ '|' + " &_
         "convert(varchar(20),IsNull(sum(A.cantidad_entrada),0)) " &_
         "from " &_
         "( " &_
         "select " &_
         "sum(cantidad_mercancias) as cantidad_mercancias, " &_
         "sum(cantidad_um_compra_en_caja_envase_compra) as cantidad_um_compra_en_caja_envase_compra, " &_
         "sum(cantidad_x_un_consumo) as cantidad_x_un_consumo, " &_
         "sum(cantidad_entrada) as cantidad_entrada " &_
         "from movimientos_productos with(nolock)" &_
         "where numero_interno_documento_no_valorizado = "&x_numero_interno_documento_no_valorizado&" " &_
         "and documento_no_valorizado='"&x_documento_no_valorizado&"' and numero_de_linea_Item_Base_agrupado_bodega = "&x_numero_de_linea_Item_Base_agrupado_bodega&" " &_
         "UNION " &_
         "select " &_
         "sum(cantidad_mercancias) as cantidad_mercancias, " &_
         "sum(cantidad_um_compra_en_caja_envase_compra) as cantidad_um_compra_en_caja_envase_compra, " &_
         "sum(cantidad_x_un_consumo) as cantidad_x_un_consumo, " &_
         "sum(cantidad_entrada) as cantidad_entrada " &_
         "from movimientos_productos with(nolock) " &_
         "where numero_interno_documento_no_valorizado = "&x_numero_interno_documento_no_valorizado&" " &_
         "and documento_no_valorizado='"&x_documento_no_valorizado&"' and numero_de_linea_en_RCP_o_documento_de_compra = " & x_numero_de_linea_Item_Base_agrupado_bodega & " " &_
         ") A " 
  set v_rs = Conn.Execute(strSQL) : String_Suma_Cantidades_Item_Agrupado = ""
  if not v_rs.EOF then String_Suma_Cantidades_Item_Agrupado = v_rs(0)
  Get_String_Suma_Cantidades_Item_Agrupado = String_Suma_Cantidades_Item_Agrupado
'response.write strSQL
'response.end
end function

function Tiene_Cantidades_Entrada_Descuadradas(x_documento_no_valorizado, x_numero_interno_documento_no_valorizado)
  if x_documento_no_valorizado = "RCP" then
    strSQL="select RCP.numero_interno_movimiento_producto, RCP.numero_de_linea_en_RCP_o_documento_de_compra, RCP.producto, RCP.Nombre_producto, " &_
           "RCP.cantidad_mercancias, RCP.unidad_de_medida_compra, RCP.cantidad_um_compra_en_caja_envase_compra, " &_
           "RCP.Cantidad_entrada, RCP.unidad_de_medida_consumo, RCP.cantidad_x_un_consumo, " &_
           "MaxCajas_TotXCaja = (select (convert(varchar(3),count(*)) + '|' + convert(varchar(5),IsNull(sum(cantidad_x_caja),0))) " &_
                                  "from Bultos b  WITH (nolock) " & _ 
                                  "left join Bultos_detalle bd  WITH (nolock) on b.BultosID = bd.BultosID " & _ 
                                  "where b.numero_interno_documento_no_valorizado = RCP.numero_interno_documento_no_valorizado and bd.numero_de_linea = RCP.numero_de_linea) " & _
           "from " &_
           "(select numero_interno_movimiento_producto,numero_interno_documento_no_valorizado, numero_de_linea_en_RCP_o_documento_de_compra, producto, Nombre_producto, " &_
           "cantidad_mercancias, unidad_de_medida_compra, cantidad_um_compra_en_caja_envase_compra, " &_
           "cantidad_entrada, unidad_de_medida_consumo, cantidad_x_un_consumo,numero_de_linea " &_
           "from movimientos_productos with(nolock) where documento_no_valorizado='RCP' and numero_interno_documento_no_valorizado = " & x_numero_interno_documento_no_valorizado & ") RCP " &_
           "order by RCP.Numero_de_linea_en_RCP_o_documento_de_compra"
  else
    strSQL="select numero_interno_movimiento_producto, numero_de_linea_en_RCP_o_documento_de_compra, producto, Nombre_producto, " &_
           "cantidad_mercancias, unidad_de_medida_compra, cantidad_um_compra_en_caja_envase_compra, " &_
           "Cantidad_entrada, unidad_de_medida_consumo, cantidad_x_un_consumo,  " &_
           "MaxCajas_TotXCaja = (select (convert(varchar(3),count(*)) + '|' + convert(varchar(5),IsNull(sum(bd.cantidad_x_caja),0)))  " &_
           "from Bultos b with(nolock) " & _
           "left join bultos_detalle bd with(nolock) on b.BultosID = bd.BultosID  " & _
           "where bd.numero_interno_movimiento_producto = Mov.Numero_interno_movimiento_producto) " & _
           "from movimientos_productos Mov with(nolock) where documento_no_valorizado='TCP' and numero_interno_documento_no_valorizado = " & x_numero_interno_documento_no_valorizado & " " &_
           "order by Numero_de_linea_en_RCP_o_documento_de_compra"
  end if
  set v_rs_detalle = Conn.Execute(strSQL) : band_cantidad_descuadrada = false
  do while not v_rs_detalle.EOF
    x_item                      = v_rs_detalle("numero_de_linea_en_RCP_o_documento_de_compra")
    'Venta
    x_cantidad_entrada          = v_rs_detalle("cantidad_entrada")
    x_cantidad_x_un_consumo     = v_rs_detalle("cantidad_x_un_consumo")
    
    x_MaxCajas_TotXCaja         = v_rs_detalle("MaxCajas_TotXCaja")
    x_Array_MaxCajas_TotXCaja   = Split(Trim(v_rs_detalle("MaxCajas_TotXCaja")), "|")
    x_Bultos                    = CDbl(x_Array_MaxCajas_TotXCaja(0))
    x_TotXCaja                  = CDbl(x_Array_MaxCajas_TotXCaja(1))
    
    'if trim(x_numero_interno_documento_no_valorizado) = "64542381" and trim(x_item) = "4" then
    '  response.write "<br>x_cantidad_entrada: " & x_cantidad_entrada
    '  response.write "<br>x_TotXCaja: " & x_TotXCaja
    'end if
    
    x_cantidad_venta_x_bulto = x_TotXCaja
    if cdbl(x_cantidad_entrada) <> cdbl(x_TotXCaja) then
      x_cantidad_venta_x_bulto  = cdbl(x_TotXCaja) / cdbl(x_cantidad_x_un_consumo)
      if cdbl(x_cantidad_entrada) <> cdbl(x_cantidad_venta_x_bulto) then
        band_cantidad_descuadrada = true
        exit do
      end if
    end if
    v_rs_detalle.MoveNext
  loop
  Tiene_Cantidades_Entrada_Descuadradas = band_cantidad_descuadrada
end function

server.ScriptTimeout      = 10000
documento_respaldo         = Request.QueryString("documento_respaldo")
anio                       = Request.QueryString("anio")
mes                        = Request.QueryString("mes")
camion                     = Request.QueryString("camion")
check_solo_dif             = Request.QueryString("check_solo_dif")
Numero_documento_respaldo  = Request.QueryString("Numero_documento_respaldo")

'response.write Numero_documento_respaldo
'response.end

'Se usa la variable con la hhmmss para agregarla al nombre del archivo. Esto porque comenzaron a aparecer problemas cuando se quieren generar archivos con el mismo nombre (puede ser problemas en las carpetas y archivos temporales en cada equipo)
'por este motivo es mejor crear archivo con nombres únicos (concatenar hora al final del archivo). MODIFICACION: 2013-10-10 15:00:00
hora_actual = time()
hora_actual_hhmmss = Lpad(hour(hora_actual),2,0) & Lpad(minute(hora_actual),2,0) & Lpad(second(hora_actual),2,0)
hora_actual_hh_mm_ss = Lpad(hour(hora_actual),2,0) & ":" & Lpad(minute(hora_actual),2,0) & ":" & Lpad(second(hora_actual),2,0)

nom_mes = GetMes(mes)
carpeta = documento_respaldo & "-" & anio & "-" & mes & "-" & camion

Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=Descarga_Camion_"&carpeta&"_"&hora_actual_hhmmss&".xls"

OpenConn
str_documento_respaldo = " documento_respaldo='" & documento_respaldo & "' and"
if documento_respaldo = "R" then str_documento_respaldo = " (documento_respaldo='R' or documento_respaldo='DS') and"

'**********************************************************************************************************************
'******************************************** Select cuadro resumen ***************************************************
if Numero_documento_respaldo > 0 then
  strSQL="select A.documento_respaldo, A.Numero_interno_documento_no_valorizado, A.Numero_documento_respaldo, a.Fecha_emision,  " & _
         "B.codigo_postal, B.Apellidos_persona_o_nombre_empresa nombre_proveedor, IsNull(A.Monto_adu_US$,0) total_cif_adu, IsNull(A.bultos,0) as bultos,  " & _
         "Rtrim(Ltrim(convert(varchar,count(*),10))) + '|' + Rtrim(Ltrim(convert(varchar,Round(sum(c.dim_L * c.dim_W * c.dim_H)/1000,3),15))) + '|' +  Rtrim(Ltrim(convert(varchar,Round(sum(c.peso_KG),3),15))) AS bultos_cubicaje_kgs  " & _
  "from (  select bd.BultosID,b.dim_L,b.dim_H,b.dim_W,b.peso_KG,b.numero_interno_documento_no_valorizado " & _
  "from bultos b with(nolock) " & _      
   "left join bultos_detalle bd with(nolock) on bd.BultosID = b.BultosID " & _      
    ") C left join " & _
  "from documentos_no_valorizados     A with(nolock) ,  " & _
  "     entidades_comerciales         B with(nolock)  " & _
  "where "&str_documento_respaldo&" "& _
  "       A.documento_no_valorizado = 'RCP'                          and " & _
  "       A.Numero_documento_respaldo = "&Numero_documento_respaldo&"               and " & _
  "       A.tipo_oc                <>  'P'                           and " & _
  "       A.empresa                 = 'SYS'                          and" & _
  "       A.proveedor               = B.Entidad_comercial            and" & _
  "       c.Numero_interno_documento_no_valorizado = A.Numero_interno_documento_no_valorizado " & _
  "GROUP BY  A.documento_respaldo," & _
  "       A.Numero_interno_documento_no_valorizado ," & _
  "       A.Numero_documento_respaldo, " & _
  "       a.Fecha_emision ," & _
  "       B.codigo_postal, " & _
  "       B.Apellidos_persona_o_nombre_empresa," & _
  "       IsNull(A.Monto_adu_US$,0) , " & _
  "       IsNull(A.bultos,0) " & _
  "     order by B.codigo_postal, A.Numero_documento_respaldo"
else
  strSQL="select A.documento_respaldo, A.Numero_interno_documento_no_valorizado, A.Numero_documento_respaldo, a.Fecha_emision,  " & _
         "B.codigo_postal, B.Apellidos_persona_o_nombre_empresa nombre_proveedor, IsNull(A.Monto_adu_US$,0) total_cif_adu, IsNull(A.bultos,0) as bultos,  " & _
         "Rtrim(Ltrim(convert(varchar,count(*),10))) + '|' + Rtrim(Ltrim(convert(varchar,Round(sum(c.dim_L * c.dim_W * c.dim_H)/1000,3),15))) + '|' +  Rtrim(Ltrim(convert(varchar,Round(sum(c.peso_KG),3),15))) AS bultos_cubicaje_kgs  " & _
         "from (  select bd.BultosID,b.dim_L,b.dim_H,b.dim_W,b.peso_KG,b.numero_interno_documento_no_valorizado  " & _
              " from bultos b with(nolock) " & _
        "left join bultos_detalle bd with(nolock) on bd.BultosID = b.BultosID  " & _
        ") C left join  " & _
  "documentos_no_valorizados     A (nolock) on A.Numero_interno_documento_no_valorizado = C.numero_interno_documento_no_valorizado, " & _
  "     entidades_comerciales         B (nolock)  " & _
  "where "&str_documento_respaldo&" "& _
  "       A.documento_no_valorizado = 'RCP'                          and " & _
  "       A.carpeta                 = '"&carpeta&"'                  and " & _
  "       A.tipo_oc                <>  'P'                           and " & _
  "       A.empresa                 = 'SYS'                          and" & _
  "       A.proveedor               = B.Entidad_comercial            and" & _
  "       c.Numero_interno_documento_no_valorizado = A.Numero_interno_documento_no_valorizado " & _
  "GROUP BY  A.documento_respaldo," & _
  "       A.Numero_interno_documento_no_valorizado ," & _
  "       A.Numero_documento_respaldo, " & _
  "       a.Fecha_emision ," & _
  "       B.codigo_postal, " & _
  "       B.Apellidos_persona_o_nombre_empresa," & _
  "       IsNull(A.Monto_adu_US$,0) , " & _
  "       IsNull(A.bultos,0) " & _
  "     order by B.codigo_postal, A.Numero_documento_respaldo"
end IF

'Response.Write strSQL
'Response.End
set rs_resumen = Server.CreateObject("ADODB.recordset")
rs_resumen.Open strSQL, Conn
'set rs_resumen = Conn.Execute(strSQL)
'**********************************************************************************************************************
width = 1100

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40" >
<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 10">
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:LastAuthor>ALTAGESTION</o:LastAuthor>
  <o:LastPrinted>2011-07-02T07:25:56Z</o:LastPrinted>
  <o:Created>2011-07-02T07:26:08Z</o:Created>
  <o:LastSaved>2011-07-02T07:30:14Z</o:LastSaved>
  <o:Version>11.5606</o:Version>
 </o:DocumentProperties>
</xml><![endif]-->
<style>
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
@page
	{
  margin:0in 0in 0in 0in;
	mso-header-margin:0in;
	mso-footer-margin:0in;
	}
-->
.border_celda{
  border-style:solid;
  border-width:thin ;
}
</style>
</head>
<%
total_cols = 13
%>
<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">
<table style="width:1000px;" cellpadding=0 cellspacing=0 align="center" border=0>
<tr style="height:24px;">
  <td colspan="<%=total_cols%>" align="center" style="font-size: 18px; color:#555555;"><b>INFORME DESCARGA</b></td>
</tr>
<tr style="height:20px;">
  <td colspan="<%=total_cols%>" align="center" style="font-size: 14px; color:#666666;"><b>(Etiquetado de bultos)</b></td>
</tr>
<tr style="height:20px;">
  <td colspan="<%=total_cols%>" align="center" style="font-size: 16px; color:#444444;"><b>RECEPCION No <%=camion%> - <%=nom_mes%>&nbsp;<%=anio%></b></b></td>
</tr>
<tr style="height:12px;">
  <td colspan="<%=total_cols%>" align="right" style="font-size: 10px;">Generado el <%=Replace(date(),"/","-")%> a las <%=hora_actual_hh_mm_ss%>&nbsp;</td>
</tr>
<tr style="height:20px;">
  <td class="border_celda" colspan="<%=total_cols%>" align="center" style="font-size: 14px; color:#444444;"><b>Cuadro Resumen Documentos</b></td>
</tr>
<tr style="height:16px; font-weight:bold; font-size: 12px; color:#444444;">
  <td class="border_celda" align="center">Tipo Doc</td>
  <td class="border_celda" align="right">N° Doc</td>
  <td class="border_celda">Fecha</td>
  <td class="border_celda" colspan=2>Sigla</td>
  <td class="border_celda" colspan=5>Proveedor</td>
  <td class="border_celda" align="right">Bultos Fact.</td>
  <td class="border_celda" align="right">Bultos Recib.</td>
  <td class="border_celda" align="right">Tot. Kgs.</td>
  <td class="border_celda" align="right">Tot. Vol. M3</td>
</tr>
<%do while not rs_resumen.EOF
  numero_interno_documento_no_valorizado  = rs_resumen("numero_interno_documento_no_valorizado")
 documento_respaldo                       = rs_resumen("documento_respaldo")
  numero_documento_respaldo = rs_resumen("numero_documento_respaldo")
  Fecha_emision            = rs_resumen("Fecha_emision")
  codigo_postal             = rs_resumen("codigo_postal")
  nombre_proveedor          = rs_resumen("nombre_proveedor")
  total_cif_adu             = rs_resumen("total_cif_adu")
  bultos                    = rs_resumen("bultos")  
  'bultos_tmp                = rs_resumen("bultos_tmp")
  
  v_bultos_tmp = 0: v_vol_m3 = 0: v_kgs_tmp = 0
  If Not IsNull(rs_resumen("bultos_cubicaje_kgs")) Then
      array_bultos_cubicaje_kgs = Split(rs_resumen("bultos_cubicaje_kgs"), "|")
      v_bultos_tmp = cdbl(array_bultos_cubicaje_kgs(0))
      v_cubicaje_tmp = cdbl(array_bultos_cubicaje_kgs(1))
      v_kgs_tmp = cdbl(array_bultos_cubicaje_kgs(2))
      v_vol_m3 = Round(v_cubicaje_tmp / 1000, 2)
  End If
        'Response.write cdbl(bultos)
        'Response.write cdbl(v_bultos_tmp)

  color = "#000099" : bgcolor = ""
  if cdbl(bultos) > cdbl(v_bultos_tmp) then
    color = "#EE0000"
    bgcolor = "#FFCC99"
  elseif cdbl(bultos) < cdbl(v_bultos_tmp) then
    color = "#FF6600"
    bgcolor = "#FFCC33"
  end if
  
  total_bultos        = total_bultos        + bultos
  v_total_bultos_tmp  = v_total_bultos_tmp  + v_bultos_tmp
  v_total_kgs_tmp     = v_total_kgs_tmp     + v_kgs_tmp
  v_total_vol_m3      = v_total_vol_m3      + v_vol_m3
  
  band_muestra_fila = true
  if check_solo_dif = "1" and color = "#000099" then band_muestra_fila = false
  
  if check_solo_dif = "1" then
    if Tiene_Cantidades_Entrada_Descuadradas(documento_no_valorizado, numero_interno_documento_no_valorizado) then band_muestra_fila = true
  end if
  
  if band_muestra_fila then
%>
<tr style="height:18px; font-size: 12px; color:#222222;">
  <td class="border_celda" align="center" title="<%=numero_interno_documento_no_valorizado%>" ><%=documento_respaldo%></td>
  <td class="border_celda" align="right"><%=numero_documento_respaldo%></td>
  <td class="border_celda" align="left"><%=Fecha_emision%></td>
  <td class="border_celda" align="left" colspan=2><%=codigo_postal%></td>
  <td class="border_celda" align="left" colspan=5><%=nombre_proveedor%></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(bultos,0)%></b></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(v_bultos_tmp,0)%></b></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(v_kgs_tmp,2)%></b></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(v_vol_m3,2)%></b></td>
</tr>
<%end if
  rs_resumen.MoveNext
loop%>
<tr style="height:18px; font-size: 12px; color:#222222;">
  <td class="border_celda" align="center">&nbsp;</td>
  <td class="border_celda" align="left">&nbsp;</td>
  <td class="border_celda" align="left">&nbsp;</td>
  <td class="border_celda" align="left" colspan=2>&nbsp;</td>
  <td class="border_celda" align="left" colspan=5 align="right" style="color:#222222;"><b>TOTALES:</b>&nbsp;</td>
  <td class="border_celda" align="right" style="color:#333333;"><b><%=FormatNumber(total_bultos,0)%></b></td>
  <td class="border_celda" align="right" style="color:#333333;"><b><%=FormatNumber(v_total_bultos_tmp,0)%></b></td>
  <td class="border_celda" align="right" style="color:#333333;"><b><%=FormatNumber(v_total_kgs_tmp,2)%></b></td>
  <td class="border_celda" align="right" style="color:#333333;"><b><%=FormatNumber(v_total_vol_m3,2)%></b></td>
</tr>
<tr style="height:12px;">
  <td colspan="<%=total_cols%>" align="center">&nbsp;</td>
</tr>
<tr style="height:20px;">
  <td class="border_celda" colspan="<%=total_cols%>" align="center" style="font-size: 14px; color:#444444;"><b>Detalle por Documento</b></td>
</tr>
<%
rs_resumen.MoveFirst
do while not rs_resumen.EOF
  
  numero_interno_documento_no_valorizado = rs_resumen("numero_interno_documento_no_valorizado")
  documento_respaldo   = rs_resumen("documento_respaldo")
  numero_documento_respaldo = rs_resumen("numero_documento_respaldo")
  Fecha_emision            = rs_resumen("Fecha_emision")
  codigo_postal             = rs_resumen("codigo_postal")
  nombre_proveedor          = rs_resumen("nombre_proveedor")
  total_cif_adu             = rs_resumen("total_cif_adu")
  bultos                    = rs_resumen("bultos")

  strSQL =  "select documento_no_valorizado from documentos_no_valorizados with(nolock) where numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado

  set rs_documento_no_valorizado = Conn.Execute(strSQL)
  if not rs_documento_no_valorizado.EOF then
    documento_no_valorizado = rs_documento_no_valorizado("documento_no_valorizado")
  end if
  rs_documento_no_valorizado.close
  set rs_documento_no_valorizado = nothing


  'bultos_tmp                = rs_resumen("bultos_tmp")
  
  v_bultos_tmp = 0: v_vol_m3 = 0: v_kgs_tmp = 0
  If Not IsNull(rs_resumen("bultos_cubicaje_kgs")) Then
      array_bultos_cubicaje_kgs = Split(rs_resumen("bultos_cubicaje_kgs"), "|")
      v_bultos_tmp = CDbl(array_bultos_cubicaje_kgs(0))
      v_cubicaje_tmp = CDbl(array_bultos_cubicaje_kgs(1))
      v_kgs_tmp = CDbl(array_bultos_cubicaje_kgs(2))
      v_vol_m3 = Round(v_cubicaje_tmp / 100, 2)
  End If
  
  color = "#000099" : bgcolor = ""
  if cdbl(bultos) > cdbl(v_bultos_tmp) then
    color = "#EE0000"
    bgcolor = "#FFCC99"
  elseif cdbl(bultos) < cdbl(v_bultos_tmp) then
    color = "#FF6600"
    bgcolor = "#FFCC33"
  end if
  
  band_muestra_fila = true
  if check_solo_dif = "1" and color = "#000099" then band_muestra_fila = false
  
  if check_solo_dif = "1" then
    if Tiene_Cantidades_Entrada_Descuadradas(documento_no_valorizado, numero_interno_documento_no_valorizado) then band_muestra_fila = true
  end if
  
  if band_muestra_fila then
%>
<tr style="height:16px; font-weight:bold; font-size: 12px; color:#222222;">
  <td class="border_celda" align="center">Tipo Doc</td>
  <td class="border_celda">N° Doc</td>
  <td class="border_celda">Fecha</td>
  <td class="border_celda" colspan=2>Sigla</td>
  <td class="border_celda" colspan=7>Proveedor</td>
  <td class="border_celda" align="right">Bultos Fact.</td>
  <td class="border_celda" align="right">Bultos Recib.</td>
</tr>
<tr style="height:18px; font-size: 12px; color:#222222;">
  <td class="border_celda" align="center"><%=documento_respaldo%></td>
  <td class="border_celda" align="left"><%=numero_documento_respaldo%></td>
  <td class="border_celda" align="left"><%=Fecha_emision%></td>
  <td class="border_celda" align="left" colspan=2><%=codigo_postal%></td>
  <td class="border_celda" align="left" colspan=7><%=nombre_proveedor%></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(bultos,0)%></b></td>
  <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=FormatNumber(v_bultos_tmp,0)%></b></td>
</tr>
<tr style="height:14px; font-weight:bold; font-size: 12px; color:#222222;">
  <td colspan=2>&nbsp;</td>
  <td class="border_celda">Item</td>
  <td class="border_celda">Sub Item</td>
  <td class="border_celda">Producto</td>
  <td class="border_celda">Descripci&oacute;n Venta</td>
  <td class="border_celda" align="right">Cant. Comp.</td>
  <td class="border_celda" align="center">U/M C.</td>
  <td class="border_celda" align="right">Cant. U/M C.</td>
  <td class="border_celda" align="center">U/M V.</td>
  <td class="border_celda" align="right">Cant. U/M V.</td>
  <td class="border_celda" align="right">Cant. Vta.</td>
  <td class="border_celda" align="right">Cant Recib.</td>
  <td class="border_celda" align="right">Bultos</td>
</tr>
<%
  'La información de etiquetado (DETALLE) se guarda con los números internos de movimiento producto en TCP, 
  'por lo tanto para las búsquedas se debe hacer el join del número interno movimiento producto en TCP (PERO PUEDE TENER UNA DIFERENCIA CON CANT. VTA, UN X VTA Y CANT X UN VTA.)
  'se deben obtener estos datos desde el detalle del mov. en RCP (LISTO CORREGIDO OK OK)
  
  'strSQL="select A.numero_interno_movimiento_producto, A.numero_de_linea_en_RCP_o_documento_de_compra, A.producto, A.Nombre_producto, " &_
  '       "A.Cantidad_entrada, A.unidad_de_medida_consumo, A.cantidad_x_un_consumo, " &_
  '       "MaxCajas_TotXCaja = (select (convert(varchar(3),count(*)) + '|' + convert(varchar(5),IsNull(sum(cantidad_x_caja),0))) " &_
  '       "from detalle_productos_etiquetados where Numero_interno_movimiento_producto = A.Numero_interno_movimiento_producto) " & _
  '       "from movimientos_productos A where A.documento_no_valorizado='TCP' and A.numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado & " " & _
  '       "order by A.Numero_de_linea_en_RCP_o_documento_de_compra"
  
  if documento_no_valorizado = "RCP" then
    strSQL="select RCP.numero_interno_movimiento_producto, RCP.numero_de_linea_en_RCP_o_documento_de_compra, " &_
           "RCP.numero_de_linea_Ordenado_agrupado_bodega, RCP.Numero_de_orden_sub_item_agrupado_bodega, " & _
           "RCP.es_item_base_agrupado_bodega, RCP.numero_de_linea_item_base_agrupado_bodega, RCP.producto, RCP.Nombre_producto, " &_
           "RCP.cantidad_mercancias, RCP.unidad_de_medida_compra, RCP.cantidad_um_compra_en_caja_envase_compra, " &_
           "RCP.Cantidad_entrada, RCP.unidad_de_medida_consumo, RCP.cantidad_x_un_consumo, " &_
           "MaxCajas_TotXCaja = ( " & _
                  "( " & _
                  "select (convert(varchar(4),count(distinct b.BultosID)) )  " & _
                  "from Bultos b  WITH (nolock)  " & _
                  "left join Bultos_detalle bd with(nolock) on b.BultosID = bd.BultosID " & _
                  "where numero_interno_documento_no_valorizado = RCP.numero_interno_documento_no_valorizado and numero_de_linea = RCP.numero_de_linea " & _                
                  ") " & _
                  "+ '|' + " & _ 
                  "( " & _
                  "select convert(varchar(6),IsNull(sum(cantidad_x_caja),0)) " & _
                  "from Bultos b  WITH (nolock)  " & _
                  "left join Bultos_detalle bd with(nolock) on b.BultosID = bd.BultosID  " & _     
                  "where numero_interno_documento_no_valorizado = RCP.numero_interno_documento_no_valorizado and numero_de_linea = RCP.numero_de_linea " & _
                  ") " & _
                ") " & _  
           "from " &_
           "(select numero_interno_movimiento_producto, numero_de_linea_en_RCP_o_documento_de_compra, producto, Nombre_producto, " &_
           "cantidad_mercancias, unidad_de_medida_compra, cantidad_um_compra_en_caja_envase_compra,numero_interno_documento_no_valorizado,Numero_de_linea, " &_
           "cantidad_entrada, unidad_de_medida_consumo, cantidad_x_un_consumo,numero_de_linea " &_
           "numero_de_linea_Ordenado_agrupado_bodega, Numero_de_orden_sub_item_agrupado_bodega, " & _
           "es_item_base_agrupado_bodega, numero_de_linea_item_base_agrupado_bodega " &_
           "from movimientos_productos with(nolock) where empresa = 'SYS' and documento_no_valorizado='RCP' and numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado & ") RCP " &_
           
           "order by RCP.numero_de_linea_Ordenado_agrupado_bodega, RCP.Numero_de_orden_sub_item_agrupado_bodega"
  else
    strSQL="select numero_interno_movimiento_producto, numero_de_linea_en_RCP_o_documento_de_compra, " &_
           "numero_de_linea_Ordenado_agrupado_bodega, Numero_de_orden_sub_item_agrupado_bodega, " & _
           "es_item_base_agrupado_bodega, numero_de_linea_item_base_agrupado_bodega, producto, Nombre_producto, " &_
           "cantidad_mercancias, unidad_de_medida_compra, cantidad_um_compra_en_caja_envase_compra, " &_
           "Cantidad_entrada, unidad_de_medida_consumo, cantidad_x_un_consumo,  " &_
            "MaxCajas_TotXCaja = ( " & _
                  "( " & _
                  "select (convert(varchar(4),count(distinct b.BultosID)) )  " & _
                  "from Bultos b  WITH (nolock)  " & _
                  "left join Bultos_detalle bd with(nolock) on b.BultosID = bd.BultosID " & _
                  "where numero_interno_movimiento_producto = Mov.Numero_interno_movimiento_producto  " & _                
                  ") " & _
                  "+ '|' + " & _ 
                  "( " & _
                  "select convert(varchar(6),IsNull(sum(cantidad_x_caja),0)) " & _
                  "from Bultos b  WITH (nolock)  " & _
                  "left join Bultos_detalle bd with(nolock) on b.BultosID = bd.BultosID  " & _     
                  "where numero_interno_movimiento_producto = Mov.Numero_interno_movimiento_producto  " & _
                  ") " & _
                ") " & _  
           "from movimientos_productos Mov with(nolock) where Empresa = 'SYS' and  documento_no_valorizado='TCP' and numero_interno_documento_no_valorizado = " & numero_interno_documento_no_valorizado & " " &_
           "order by numero_de_linea_Ordenado_agrupado_bodega, Numero_de_orden_sub_item_agrupado_bodega"
  end if
  'if numero_documento_respaldo = "54467" then
  '  response.write strSQL
  '  response.end
  'end if
  
  'response.write strSQL
  'response.end
  
  set rs_detalle = Conn.Execute(strSQL)
  do while not rs_detalle.EOF
    numero_de_linea_en_RCP_o_documento_de_compra  = Trim(rs_detalle("numero_de_linea_en_RCP_o_documento_de_compra"))
    numero_de_linea_item_base_agrupado_bodega     = Trim(rs_detalle("numero_de_linea_item_base_agrupado_bodega"))
    Numero_de_orden_sub_item_agrupado_bodega      = Trim(rs_detalle("numero_de_orden_sub_item_agrupado_bodega"))
    Es_Item_Base_Agrupado_Bodega                  = Trim(rs_detalle("es_item_base_agrupado_bodega"))
    
    producto        = trim(rs_detalle("producto"))
    Nombre_producto = Left(trim(rs_detalle("Nombre_producto")),40)
    
    'Compra
    cantidad_mercancias                       = cdbl(rs_detalle("cantidad_mercancias"))
    unidad_de_medida_compra                   = trim(rs_detalle("unidad_de_medida_compra"))
    cantidad_um_compra_en_caja_envase_compra  = cdbl(rs_detalle("cantidad_um_compra_en_caja_envase_compra"))
    'Venta
    cantidad_entrada                          = rs_detalle("cantidad_entrada")
    unidad_de_medida_consumo                  = rs_detalle("unidad_de_medida_consumo")
    cantidad_x_un_consumo                     = rs_detalle("cantidad_x_un_consumo")
    
    MaxCajas_TotXCaja           = rs_detalle("MaxCajas_TotXCaja")
    Array_MaxCajas_TotXCaja     = Split(Trim(rs_detalle("MaxCajas_TotXCaja")), "|")
    Bultos                      = CDbl(Array_MaxCajas_TotXCaja(0))
    TotXCaja                    = CDbl(Array_MaxCajas_TotXCaja(1))
    
    
    
    
    if Es_Item_Base_Agrupado_Bodega = "1" then
      'Guardar datos del item simple o base para configurar las filas siguientes
      str_numero_item                 = numero_de_linea_en_RCP_o_documento_de_compra
      str_producto                    = producto
      str_nombre_producto             = Nombre_Producto
      fila_inicial_item_base          = fila
      producto_fila_inicial_item_base = producto
      cantidad_um_compra_en_caja_envase_compra_fila_inicial_item_base = cantidad_um_compra_en_caja_envase_compra
      TotXCaja_fila_inicial_item_base = TotXCaja
      str_numero_item                 = numero_de_linea_en_RCP_o_documento_de_compra
      str_numero_sub_item             = 1
      
      str_cantidad_mercancias                       = FormatNumber(cantidad_mercancias,0)
      str_unidad_de_medida_compra                   = unidad_de_medida_compra
      str_cantidad_um_compra_en_caja_envase_compra  = FormatNumber(cantidad_um_compra_en_caja_envase_compra,0)
      str_unidad_de_medida_consumo                  = unidad_de_medida_consumo
      str_cantidad_x_un_consumo                     = FormatNumber(cantidad_x_un_consumo,0)
      str_cantidad_entrada                          = FormatNumber(cantidad_entrada,0)
      str_TotXCaja                                  = FormatNumber(TotXCaja,0)
      str_Bultos                                    = FormatNumber(Bultos,0)
      
      array_suma_cantidades_item_agrupado = Split(Get_String_Suma_Cantidades_Item_Agrupado(documento_no_valorizado,numero_interno_documento_no_valorizado, numero_de_linea_en_RCP_o_documento_de_compra),"|")
      
      if Ubound(array_suma_cantidades_item_agrupado) > 1 then
        cantidad_mercancias                       = cdbl(array_suma_cantidades_item_agrupado(0))
        cantidad_um_compra_en_caja_envase_compra  = cdbl(array_suma_cantidades_item_agrupado(1))
        cantidad_x_un_consumo                     = cdbl(array_suma_cantidades_item_agrupado(2))
        cantidad_entrada                          = cdbl(array_suma_cantidades_item_agrupado(3))
        
        str_cantidad_mercancias                       = FormatNumber(cantidad_mercancias,0)
        str_cantidad_um_compra_en_caja_envase_compra  = FormatNumber(cantidad_um_compra_en_caja_envase_compra,0)
        str_cantidad_x_un_consumo                     = FormatNumber(cantidad_x_un_consumo,0)
        str_cantidad_entrada                          = FormatNumber(cantidad_entrada,0)
      end if      
      
      
      color = "#000099" : bgcolor = ""
      cantidad_venta_x_bulto = TotXCaja
      if cdbl(cantidad_entrada) <> cdbl(TotXCaja) then
        cantidad_venta_x_bulto      = cdbl(TotXCaja) / cdbl(cantidad_x_un_consumo)
        if cdbl(cantidad_entrada) > cdbl(cantidad_venta_x_bulto) then
          color = "#EE0000"
          bgcolor = "#FFCC99"
        elseif cdbl(cantidad_entrada) < cdbl(cantidad_venta_x_bulto) then
          color = "#FF6600"
          bgcolor = "#FFCC33"
        end if
      end if
    else '[0]: No es item base
      'Chequear si es un [item simple no agrupado] o es [item agrupado]
      if numero_de_linea_item_base_agrupado_bodega = "0" then 'Es item simple no agrupado 
        str_numero_item                               = numero_de_linea_en_RCP_o_documento_de_compra
        str_numero_sub_item                           = ""
        str_numero_item                               = numero_de_linea_en_RCP_o_documento_de_compra
        str_cantidad_mercancias                       = FormatNumber(cantidad_mercancias,0)
        str_unidad_de_medida_compra                   = unidad_de_medida_compra
        str_cantidad_um_compra_en_caja_envase_compra  = FormatNumber(cantidad_um_compra_en_caja_envase_compra,0)
        str_unidad_de_medida_consumo                  = unidad_de_medida_consumo
        str_cantidad_x_un_consumo                     = FormatNumber(cantidad_x_un_consumo,0)
        str_cantidad_entrada                          = FormatNumber(cantidad_entrada,0)
        str_TotXCaja                                  = FormatNumber(TotXCaja,0)
        str_Bultos                                    = FormatNumber(Bultos,0)

        color = "#000099" : bgcolor = ""
        cantidad_venta_x_bulto = TotXCaja
        if cdbl(cantidad_entrada) <> cdbl(TotXCaja) then
          'cantidad_venta_x_bulto      = cdbl(TotXCaja) / cdbl(cantidad_x_un_consumo)
          cantidad_venta_x_bulto      = cdbl(cantidad_mercancias) * cdbl(cantidad_um_compra_en_caja_envase_compra) / cdbl(cantidad_x_un_consumo) 
          if cdbl(cantidad_entrada) > cdbl(cantidad_venta_x_bulto) then
            color = "#EE0000"
            bgcolor = "#FFCC99"
          elseif cdbl(cantidad_entrada) < cdbl(cantidad_venta_x_bulto) then
            color = "#FF6600"
            bgcolor = "#FFCC33"
          end if
        end if
      else 'Es item agrupado
        color = "#000099" : bgcolor = ""
        str_numero_item     = ""
        str_numero_sub_item = Numero_de_orden_sub_item_agrupado_bodega
        'Chequear si es una agrupación por [ítemes del mismo producto] o por [ítem abierto (caso maletas)]
        if Trim(producto) = Trim(producto_fila_inicial_item_base) then '[ítemes del mismo producto]
          str_cantidad_mercancias                       = ""
          str_unidad_de_medida_compra                   = ""
          str_cantidad_um_compra_en_caja_envase_compra  = ""
          str_unidad_de_medida_consumo                  = ""
          str_cantidad_x_un_consumo                     = ""
          str_cantidad_entrada                          = ""
          str_TotXCaja                                  = ""
          str_Bultos                                    = ""
        else '[ítem abierto por digitación (caso maletas o varios productos en el mismo bultos)]
          str_cantidad_mercancias                       = ""
          str_unidad_de_medida_compra                   = ""
          str_cantidad_um_compra_en_caja_envase_compra  = ""
          str_unidad_de_medida_consumo                  = ""
          str_cantidad_x_un_consumo                     = ""
          str_cantidad_entrada                          = ""
          str_TotXCaja                                  = ""
          str_Bultos                                    = ""
        end if
      end if
    end if
    
    band_muestra_fila = true
    if check_solo_dif = "1" and color = "#000099" then band_muestra_fila = false
    
    if band_muestra_fila then
%>
  <tr>
    <td colspan=2>&nbsp;</td>
    <td class="border_celda"><%=str_numero_item%></td>
    <td class="border_celda"><%=str_numero_sub_item%></td>
    <td class="border_celda"><%=producto%></td>
    <td class="border_celda"><%=Nombre_producto%></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_cantidad_mercancias%></b></td>
    <td class="border_celda" align="center" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_unidad_de_medida_compra%></b></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_cantidad_um_compra_en_caja_envase_compra%></b></td>
    <td class="border_celda" align="center" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_unidad_de_medida_consumo%></b></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_cantidad_x_un_consumo%></b></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_cantidad_entrada%></b></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_TotXCaja%></b></td>
    <td class="border_celda" align="right" style="color:<%=color%>; background-color:<%=bgcolor%>;"><b><%=str_Bultos%></b></td>
  </tr>
  <%end if
    rs_detalle.MoveNext
  loop%>
<%end if
  rs_resumen.MoveNext
loop%>
</table>
</body>
</html>
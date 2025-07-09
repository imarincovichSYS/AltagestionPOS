<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

sub Get_Nombre_y_CodigoPostal_Proveedor(v_entidad_comercial)
  strSQL="select Apellidos_persona_o_nombre_empresa as nombre_proveedor, codigo_postal from entidades_comerciales where empresa='SYS' and entidad_comercial='"&v_entidad_comercial&"'"
  set v_rs = Conn.Execute(strsql) : v_nombre_proveedor = "" : v_codigo_postal = ""
  if not v_rs.EOF then 
    v_nombre_proveedor  = v_rs("nombre_proveedor") 
    v_codigo_postal     = v_rs("codigo_postal")
  end if
end sub

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
OpenConn

Server.ScriptTimeout = 2000

estado                                  = Request.Form("estado")
tipo_cambio                             = Request.Form("tipo_cambio")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")

strSQL="select numero_interno_documento_no_valorizado, documento_no_valorizado, documento_respaldo, numero_documento_respaldo, " &_
       "Proveedor, Proveedor_2, fecha_emision, fecha_recepcion, numero_factura, fecha_factura, " &_
       "IsNull(monto_neto_US$,0) as total_cif_ori, IsNull(Monto_adu_US$,0) as total_cif_adu, " &_
       "monto_total_moneda_oficial as total_peso, paridad_conversion_a_dolar, " &_
       "Bodega, numero_documento_no_valorizado, carpeta from documentos_no_valorizados where numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  w_table = 998
  w_numero_interno_dnv        = 50
  w_documento_no_valorizado   = 30
  w_documento_respaldo        = 20
  w_numero_documento_respaldo = 50
  w_numero_factura            = 40
  w_proveedor                 = 54
  w_codigo_postal             = 54
  w_nombre_proveedor_2        = 140
  w_fecha_recepcion           = 60
  w_paridad                   = 40
  w_total_cif_adu             = 60
  w_total_peso                = 60
  w_carpeta                   = 80
  
  v_nombre_proveedor = "" : v_codigo_postal = ""
  Get_Nombre_y_CodigoPostal_Proveedor trim(rs("Proveedor_2"))
  nombre_proveedor_2  = v_nombre_proveedor
  codigo_postal_2     = v_codigo_postal
  
  v_nombre_proveedor = "" : v_codigo_postal = ""
  Get_Nombre_y_CodigoPostal_Proveedor trim(rs("proveedor"))
  
  color_fecha_recepcion = "" : color_paridad = "" : color_proveedor = ""
  font_weight_fecha_recepcion = "normal" : font_weight_paridad = "normal" : font_weight_proveedor = "normal"
  if tipo_cambio = "fecha_recepcion_y_paridad" then
    font_weight_fecha_recepcion = "bold"
    font_weight_paridad         = "bold"
    color_fecha_recepcion       = "#AA0000"
    color_paridad               = "#AA0000"
    if estado = "actualizado" then
      color_fecha_recepcion = "#009900"
      color_paridad         = "#009900"
    end if
  elseif tipo_cambio = "proveedor" then
    font_weight_proveedor = "bold"
    color_proveedor       = "#AA0000"
    if estado = "actualizado" then color_proveedor = "#009900"
  end if
  
	%>  
  <table class="table_cabecera" style="width:<%=w_table%>px; font-size: 10px;" border=0 cellpadding=0 cellspacing=0>
  <tr style="height:20px;" bgcolor="#666666">
    <td class="th_left"   rowspan=2 style="width: <%=w_numero_interno_dnv%>px;"         align="center">Nro. Int. DNV</td>
    <td class="th_middle" rowspan=2 style="width: <%=w_documento_no_valorizado%>px;"    align="center">T. DOC.</td>  		  
    <td class="th_middle" rowspan=2 style="width: <%=w_documento_respaldo%>px;"         align="center">TIP.</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_numero_documento_respaldo%>px;"  align="center">N° DOC.</td>
  	<!--<td class="th_middle" rowspan=2 style="width: <%=w_numero_factura%>px;"             align="center">N° FACT.</td>-->
  	<td class="th_middle" colspan=3 align="center" >PROVEEDOR LEGAL</td>
  	<td class="th_middle" colspan=3 align="center">2° PROVEEDOR</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_fecha_recepcion%>px;"            align="center">FEC. RECEP.</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_paridad%>px;"                    align="right">US$&nbsp;</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_total_cif_adu%>px;"              align="center">TOTAL ADU US$</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_total_peso%>px;"                 align="center">TOTAL $</td>
  	<td class="th_middle" rowspan=2 style="width: <%=w_carpeta%>px;"                    align="center">CARPETA</td>
  </tr>
  <tr style="height:20px;" bgcolor="#666666">
    <td class="th_middle" style="width: <%=w_proveedor%>px;"          align="center">RUT</td>
  	<td class="th_middle" style="width: <%=w_codigo_postal%>px;"      align="center">SIGLA</td>
  	<td class="th_middle">&nbsp;NOMBRE</td>
  	<td class="th_middle" style="width: <%=w_proveedor%>px;"          align="center">RUT</td>
  	<td class="th_middle" style="width: <%=w_codigo_postal%>px;"      align="center">SIGLA</td>
  	<td class="th_middle" style="width: <%=w_nombre_proveedor_2%>px;" align="left">&nbsp;NOMBRE</td>
  </tr>
  <tr bgcolor="#FFFFFF" style="font-size:11px;">
    <td class="td_left"   align="center"><%=rs("numero_interno_documento_no_valorizado")%></td>
  	<td class="td_middle" align="center"><%=rs("documento_no_valorizado")%></td>
  	<td class="td_middle" align="center"><%=rs("documento_respaldo")%></td>
  	<td class="td_middle" align="center"><%=rs("numero_documento_respaldo")%></td>
  	<!--<td class="td_middle" align="center">&nbsp;<%=trim(rs("numero_factura"))%></td>-->
  	<td class="td_middle" align="center" style="color:<%=color_proveedor%>; font-weight: <%=font_weight_proveedor%>;"><%=trim(rs("proveedor"))%></td>
  	<td class="td_middle" align="center" style="color:<%=color_proveedor%>; font-weight: <%=font_weight_proveedor%>;"><%=v_codigo_postal%></td>
  	<td class="td_middle" style="color:<%=color_proveedor%>; font-weight: <%=font_weight_proveedor%>;">&nbsp;<%=Left(v_nombre_proveedor,30)%></td>
  	<td class="td_middle" align="center" style="color:<%=color_proveedor2%>;">&nbsp;<%=trim(rs("proveedor_2"))%></td>
  	<td class="td_middle" align="center" style="color:<%=color_proveedor2%>;">&nbsp;<%=codigo_postal_2%></td>
  	<td class="td_middle" style="color:<%=color_proveedor2%>;">&nbsp;<%=Left(nombre_proveedor_2,26)%></td>
  	<td class="td_middle" align="center" style="color:<%=color_fecha_recepcion%>; font-weight: <%=font_weight_fecha_recepcion%>;"><%=Replace(rs("fecha_recepcion"),"/","-")%></td>
  	<td class="td_middle" align="right" style="color:<%=color_paridad%>; font-weight: <%=font_weight_paridad%>"><%=Replace(FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2)),",",".")%>&nbsp;</td>
  	<td class="td_middle" align="right"><%=FormatNumber(Round(rs("total_cif_adu"),2))%>&nbsp;</td>
  	<td class="td_middle" align="right"><%=FormatNumber(Round(rs("total_peso"),0),0)%>&nbsp;</td>
  	<td class="td_middle" align="center"><%=trim(rs("carpeta"))%></td>
  </tr>  
  </table>
  <input type="hidden" id="hidden_fecha_recepcion"    name="hidden_fecha_recepcion"     value="<%=Replace(rs("fecha_recepcion"),"/","-")%>">
  <input type="hidden" id="hidden_paridad"            name="hidden_paridad"             value="<%=Replace(FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2)),",",".")%>">
  <input type="hidden" id="hidden_proveedor"          name="hidden_proveedor"           value="<%=trim(rs("proveedor"))%>">
  <input type="hidden" id="hidden_nombre_proveedor"   name="hidden_nombre_proveedor"    value="<%=v_nombre_proveedor%>">
  <input type="hidden" id="hidden_codigo_postal"      name="hidden_codigo_postal"       value="<%=v_codigo_postal%>">
  <input type="hidden" id="hidden_proveedor_2"        name="hidden_proveedor_2"         value="<%=trim(rs("proveedor_2"))%>">
  <input type="hidden" id="hidden_nombre_proveedor_2" name="hidden_nombre_proveedor_2"  value="<%=nombre_proveedor_2%>">
  <input type="hidden" id="hidden_codigo_postal_2"    name="hidden_codigo_postal_2"     value="<%=codigo_postal_2%>">
  <input type="hidden" id="hidden_carpeta"            name="hidden_carpeta"             value="<%=trim(rs("carpeta"))%>">
<%else%>
  <table style="width:100%; font-size: 11px;" border=0 cellpadding=0 cellspacing=0>
  <tr align="center" style="height: 100px; color: #222222;">
    <td><b>No se encontraron registros...</b></td>
  </tr>
  </table>
<%end if%>
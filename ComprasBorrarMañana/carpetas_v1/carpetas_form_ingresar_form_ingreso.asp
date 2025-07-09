<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
numero_linea        = Request.Form("numero_linea")

OpenConn
strSQL="select id_tipo_factura, (convert(varchar(1),id_tipo_factura) + '. ' + n_tipo_factura) as n_tipo_factura from carpetas_tipos_facturas order by n_tipo_factura"
set rs_tipo_factura = Conn.Execute(strSQL)

strSQL="select moneda, nombre from monedas order by nombre"
set rs_tipo_moneda = Conn.Execute(strSQL)

if numero_linea <> "" then
  fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
  strSQL="select entidad_comercial, id_tipo_factura, numero_factura, tipo_moneda, " &_
         "monto_moneda_origen, paridad, monto_total_us$, monto_final_us$, porcentaje_prorrateo " &_
         "from carpetas_final_detalle " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' " &_
         "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea
  'response.write strSQL
  set rs = Conn.Execute(strSQL)
  if not rs.EOF then
    entidad_comercial     = trim(rs("entidad_comercial"))
    id_tipo_factura       = trim(rs("id_tipo_factura"))
    numero_factura        = trim(rs("numero_factura"))
    tipo_moneda           = trim(rs("tipo_moneda"))
    'monto_moneda_origen   = Replace(Replace(FormatNumber(rs("monto_moneda_origen"),2),".",""),",",".")
    'paridad               = Replace(Replace(FormatNumber(rs("paridad"),2),".",""),",",".")
    'monto_total_usd       = Replace(Replace(FormatNumber(rs("monto_total_us$"),2),".",""),",",".")
    'monto_final_usd       = Replace(Replace(FormatNumber(rs("monto_final_us$"),2),".",""),",",".")
    'porcentaje_prorrateo  = Replace(Replace(FormatNumber(rs("porcentaje_prorrateo"),2),".",""),",",".")
    
    monto_moneda_origen   = Replace(FormatNumber(rs("monto_moneda_origen"),2),",","")
    paridad               = Replace(FormatNumber(rs("paridad"),2),",","")
    monto_total_usd       = Replace(FormatNumber(rs("monto_total_us$"),2),",","")
    monto_final_usd       = Replace(FormatNumber(rs("monto_final_us$"),2),",","")
    porcentaje_prorrateo  = Replace(FormatNumber(rs("porcentaje_prorrateo"),2),",","")
    
    strSQL="select ('(' + codigo_postal + ') ' + Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona) as nombre " &_
           "from entidades_comerciales where empresa = 'SYS' and entidad_comercial='" & entidad_comercial & "'"
    set rs = Conn.Execute(strSQL) : nombre = ""
    if not rs.EOF then nombre = Left(trim(rs("nombre")),32)
  end if
end if
h_tr = 30
color= "#555555"
bgcolor_tabla = "#CCCCCC"
%>
<input type="hidden" id="buscar_entidad_comercial" name="buscar_entidad_comercial" value="">
<input type="hidden" id="buscar_nombre" name="buscar_nombre" value="">
<table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>">
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Item:</b>&nbsp;</td>
  <td><input value="<%=numero_linea%>" id="numero_linea" name="numero_linea" style="font-size:10px; width:40px; text-align:left; background-color:#EEEEEE;" readonly></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td style="width:114px;" align="right"><b>Proveedor:</b>&nbsp;</td>
  <td><input value="<%=nombre%>" id="buscar_proveedor" name="buscar_proveedor" style="font-size:9px; width:120px;"></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Rut:</b>&nbsp;</td>
  <td><input value="<%=entidad_comercial%>" id="entidad_comercial" name="entidad_comercial" style="font-size:10px; width:90px; background-color:#EEEEEE;" readonly></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Tipo factura:</b>&nbsp;</td>
  <td>
  <select id="id_tipo_factura" name="id_tipo_factura" style="width: 120px;">
    <%do while not rs_tipo_factura.EOF%>
      <option 
      <%if trim(id_tipo_factura) = trim(rs_tipo_factura("id_tipo_factura")) then %> selected <%end if%>
      value="<%=rs_tipo_factura("id_tipo_factura")%>"><%=rs_tipo_factura("n_tipo_factura")%></option>
    <%rs_tipo_factura.MoveNext
    loop%>
  </select>
  </td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>N° factura:</b>&nbsp;</td>
  <td><input value="<%=numero_factura%>" id="numero_factura" name="numero_factura" style="font-size:10px; width:120px;"></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Tipo moneda:</b>&nbsp;</td>
  <td>
  <select id="tipo_moneda" name="tipo_moneda" style="width: 90px;">
    <%do while not rs_tipo_moneda.EOF%>
      <option 
      <%if trim(tipo_moneda) = trim(rs_tipo_moneda("moneda")) then %> selected <%end if%>
      value="<%=rs_tipo_moneda("moneda")%>"><%=rs_tipo_moneda("nombre")%></option>
    <%rs_tipo_moneda.MoveNext
    loop%>
  </select>
  </td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Monto Mon. Ori.:</b>&nbsp;</td>
  <td><input onkeypress="return Valida_Numerico(event);" maxlength=10 return value="<%=monto_moneda_origen%>" id="monto_moneda_origen" name="monto_moneda_origen" style="font-size:10px; width:90px; text-align:right; "></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Paridad Mon. Ori.:</b>&nbsp;</td>
  <td><input onkeypress="return Valida_Numerico(event);" maxlength=6 value="<%=paridad%>" id="paridad" name="paridad" style="font-size:10px; width:90px; text-align:right; "></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Monto Tot. US$:</b>&nbsp;</td>
  <td><input value="<%=monto_total_usd%>" id="monto_total_usd" name="monto_total_usd" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" readonly></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Monto Final US$:</b>&nbsp;</td>
  <td><input onkeypress="return Valida_Numerico(event);" maxlength=10 value="<%=monto_final_usd%>" id="monto_final_usd" name="monto_final_usd" style="font-size:10px; width:90px; text-align:right; "></td>
</tr>
<tr style="height: <%=h_tr%>; color:<%=color%>;">
  <td align="right"><b>Prorrateo (%):</b>&nbsp;</td>
  <td><input value="<%=porcentaje_prorrateo%>" id="porcentaje_prorrateo" name="porcentaje_prorrateo" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" readonly></td>
</tr>
<tr style="height: <%=h_tr + 2%>; color:<%=color%>;">
  <td colspan=2>
  <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
  <tr>
    <td>&nbsp;</td>
    <td style="width:100px;" align="right">
      <label id="label_actualizar" name="label_actualizar" class="bot_success">
      &nbsp;<img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Check_16X15.png" width=16 height=15 border=0 align="top">&nbsp;&nbsp;Actualizar&nbsp;</label>
    </td>
    <td style="width:10px;">&nbsp;</td>
    <td style="width:100px;">
      <label id="label_cancelar" name="label_cancelar" class="bot_inverse">
      <img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Cancel_15X16.png" width=15 height=16 border=0 align="top">&nbsp;&nbsp;Cancelar&nbsp;</label>
    </td>
    <td>&nbsp;</td>
  </tr>
  </table>
  </td>
</tr>
</table>
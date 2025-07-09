<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
titulo = "Administracion de Carpetas (v1)"

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")

openConn
strSQL="select id_embarcador, n_embarcador from tb_embarcadores order by n_embarcador"
set rs_embarcadores = Conn.Execute(strSQL)
strSQL="select id_origen, n_origen from tb_origenes order by n_origen"
set rs_origenes = Conn.Execute(strSQL)
strSQL="select id_transporte, n_transporte from tb_transportes order by n_transporte"
set rs_transportes = Conn.Execute(strSQL)

fec_anio_mes  = anio & "/" & Lpad(mes,2,0) & "/01"
strMes        = GetMes(mes)
strSQL="select id_embarcador, id_transporte, id_origen, IsNull(fecha_salida,'') as fecha_salida, IsNull(fecha_llegada,'') as fecha_llegada, manifiesto " &_
       "from carpetas_final where documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes = '"&fec_anio_mes&"' and num_carpeta = " & num_carpeta
'response.write strSQL
'response.end
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  id_embarcador = rs("id_embarcador")
  id_transporte = rs("id_transporte")
  id_origen     = rs("id_origen")
  fecha_salida  = Replace(rs("fecha_salida"),"/","-")
  fecha_llegada = Replace(rs("fecha_llegada"),"/","-")
  manifiesto    = rs("manifiesto")
end if

bgcolor_tabla = "#CCCCCC"
%>
<table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0 bgcolor="#FFFFFF">
<tr>
  <td>
  <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
  <tr align="center" bgcolor="#444444">
    <td style="width: 100px;">&nbsp;</td>
    <td style="font-size: 11px; color:#CCCCCC;"><b><%=Ucase(titulo)%>:&nbsp;EDITAR CARPETA</b></td>
    <td style="width: 100px;">&nbsp;</td>
  </tr>
  </table>
  <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
  <tr style="height:24px;">
    <td style="width:10px;">&nbsp;</td>
    <td style="width:100px;">
        <label id="label_volver" name="label_volver" class="bot_inverse">
    <img src="<%=RutaProyecto%>imagenes/Ico_Arrow_Left_White_Trans_18X16.png" width=18 height=16 border=0 align="top">&nbsp;&nbsp;Volver</label>
    </td>
    <td>&nbsp;</td>
  </tr>
  </table>
  <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="center" style="width:980px; height:50px;">
    <legend id="texto_10">Datos generales</legend>
    <table id="texto_11" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>">
    <tr style="height:44px; color:#555;">
      <td style="width:4px;">&nbsp;</td>
      <td style="width:80px;"><b>DOC.</b><br><input value="<%=documento_respaldo%>" readonly type="text" id="documento_respaldo" name="documento_respaldo" style="width: 40px; background-color:#EEE;"></td>
      <td style="width:84px;"><b>AÑO</b><br><input value="<%=anio%>" type="text" id="anio" name="anio" style="width: 50px; background-color:#EEE;"></td>
      <td style="width:116px;"><b>MES</b><br><input value="<%=Ucase(strMes)%>" type="text" id="str_mes" name="str_mes" style="width: 70px; background-color:#EEE;">
      <input type="hidden" id="mes" name="mes" value="<%=mes%>"></td>
      <td style="width:40px;"><b>N°</b><br><input value="<%=num_carpeta%>" type="text" id="num_carpeta" name="num_carpeta" style="width: 20px; background-color:#EEE;"></td>
      <td style="width:158px;"><b>ORIGEN</b>
      <select id="id_origen" name="id_origen" style="width: 110px;" tipo_dato="entero" o_value="<%=id_origen%>">
        <option value=""></option>
        <%do while not rs_origenes.EOF%>
          <option 
          <%if trim(id_origen) = trim(rs_origenes("id_origen")) then %> selected <%end if%>
          value="<%=rs_origenes("id_origen")%>"><%=rs_origenes("n_origen")%></option>
        <%rs_origenes.MoveNext
        loop%>
      </select>
      </td>
      <td style="width:146px;"><b>TRANSP.</b>
      <select id="id_transporte" name="id_transporte" style="width: 90px;" tipo_dato="entero" o_value="<%=id_transporte%>">
        <option value=""></option>
        <%do while not rs_transportes.EOF%>
        <option 
        <%if trim(id_transporte) = trim(rs_transportes("id_transporte")) then %> selected <%end if%>
        value="<%=rs_transportes("id_transporte")%>"><%=rs_transportes("n_transporte")%></option>
        <%rs_transportes.MoveNext
        loop%>
      </select>
      </td>
      <td style="width:140px;"><b>FEC. SALIDA</b>
      <input value="<%=fecha_salida%>" o_value="<%=fecha_salida%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" 
      type="text" id="fecha_salida" name="fecha_salida" maxlength="10" style="width: 64px;"></td>
      <td style="width:140px;"><b>FEC. LLEGADA</b>
      <input value="<%=fecha_llegada%>" o_value="<%=fecha_llegada%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" 
      type="text" id="fecha_llegada" name="fecha_llegada" maxlength="10" style="width: 64px;"></td>
      <td style="width:140px;"><b>MANIFIESTO</b>
      <input value="<%=manifiesto%>" o_value="manifiesto" tipo_dato="entero" type="text" id="manifiesto" name="manifiesto" maxlength="10" style="width: 64px;"></td>
      <td><b>EMBARCADOR</b>
      <select style="width: 130px;" id="id_embarcador" name="id_embarcador" tipo_dato="entero" o_value="<%=id_embarcador%>" >
      <option value=""></option>
      <%do while not rs_embarcadores.EOF%>
        <option 
        <%if trim(id_embarcador) = trim(rs_embarcadores("id_embarcador")) then %> selected <%end if%>
        value="<%=rs_embarcadores("id_embarcador")%>"><%=rs_embarcadores("n_embarcador")%></option>
      <%rs_embarcadores.MoveNext
      loop%>
      </select>
      </td>
      <td style="width:4px;">&nbsp;</td>
    </tr>
    </table>
  </fieldset>
  <fieldset id="fieldset_gastos" name="fieldset_gastos" align="center" style="width:980px; height:400px;">
    <legend id="texto_10">Listado de facturas</legend>
    <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
    <tr style="height: <%=h_tr%>; color:<%=color%>;">
      <td style="width:160px;">
        <label id="label_agregar_factura" name="label_agregar_factura" class="bot_success">
        &nbsp;<img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Plus_14X14.png" width=14 height=14 border=0 align="top">&nbsp;&nbsp;Agregar factura&nbsp;</label>
      </td>
      <td>&nbsp;</td>
    </tr>
    </table>
    <table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
    <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 >
    <tr valign="top" style="height:362px;">
      <td id="td_lista" name="td_lista" style="border: 1px solid #CCCCCC;">&nbsp;</td>
      <td style="width:4px;">&nbsp;</td>
      <td id="td_form_ingreso" name="td_form_ingreso" style="width:240px;"></td>
    </tr>
    </table>
  </fieldset>
  <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
  <tr align="center" height="24">
    <td id="td_msg" name="td_msg">&nbsp;</td>
  </tr>
  </table>
  </td>
</tr>
</table>
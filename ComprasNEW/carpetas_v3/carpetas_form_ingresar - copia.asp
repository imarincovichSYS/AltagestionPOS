<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
titulo = "Administracion de Carpetas (v3)"

'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
numero_documento_respaldo = Request.Form("numero_documento_respaldo")

openConn
strSQL="select id_embarcador, n_embarcador from tb_embarcadores order by n_embarcador"
set rs_embarcadores = Conn.Execute(strSQL)
strSQL="select id_origen, n_origen from tb_origenes order by n_origen"
set rs_origenes = Conn.Execute(strSQL)
strSQL="select id_transporte, n_transporte from tb_transportes order by n_transporte"
set rs_transportes = Conn.Execute(strSQL)

ya_existe_RCP = "N"
auxCarpeta = documento_respaldo & "-" & anio & "-" & mes & "-" & num_carpeta
strSQL=" SELECT Carpeta FROM Documentos_no_valorizados with(nolock index=IX_Empresa_DNV_Carpeta_FechaEmision) WHERE Empresa = 'SYS' and Documento_no_valorizado = 'RCP' and Carpeta = '" & auxCarpeta & "' "
set rs_carpetas = Conn.Execute(strSQL)
if not rs_carpetas.eof then
    ya_existe_RCP = "S"
end if
rs_carpetas.close

' Calculo de Bultos, CBM y Kg desde la Pesa
IF FALSE THEN
strSQL = "SELECT Bultos = count(*), CBM = sum( dim_H * dim_L * dim_W ) / 1000000, Kg = sum( peso_KG ) "
strSQL = strSQL & "FROM detalle_productos_etiquetados (nolock) "
strSQL = strSQL & "WHERE numero_interno_documento_no_valorizado in ( "
strSQL = strSQL & " select dnv.Numero_interno_documento_no_valorizado "
strSQL = strSQL & " from Documentos_no_valorizados dnv (nolock) "
strSQL = strSQL & " where dnv.Empresa = 'sys' "
strSQL = strSQL & " and dnv.Documento_no_valorizado in( 'tcp', 'rcp' ) "
strSQL = strSQL & " and dnv.Carpeta in( "
strSQL = strSQL & "  select cf.carpeta "
strSQL = strSQL & "  from carpetas_final cf (nolock) "
strSQL = strSQL & "  where cf.carpeta = '" & auxCarpeta & "' "
strSQL = strSQL & "  )"
strSQL = strSQL & " )"
set rs_pesas = Conn.Execute(strSQL)
if not rs_pesas.eof then
    PesaBultos = rs_pesas( "Bultos" )
    PesaCBM = rs_pesas( "CBM" )
    PesaKg = rs_pesas( "Kg" )
end if
rs_pesas.close
END IF

fec_anio_mes  = anio & "/" & Lpad(mes,2,0) & "/01"
strMes        = GetMes(mes)
strSQL="select id_origen, id_transporte, manifiesto, id_embarcador, id_estado, Numero_aduana, NDP, " &_
       "fecha_salida = isNull( fecha_salida, '' ), " &_
       "fecha_sanantonio = isNull( fecha_sanantonio, '' ), " &_
       "fecha_transbordo = isNull( fecha_transbordo, '' ), " &_
       "fecha_ptaarenas = isNull( fecha_ptaarenas, '' ), " &_
       "fecha_aduana = isNull( fecha_aduana, '' ), " &_
       "fecha_llegada = isNull( fecha_llegada, '' ), " &_
       "fecha_recepcion = isNull( fecha_recepcion, '' ), " &_
       "fecha_grabacion = isNull( fecha_grabacion, '' ), " &_
       "fecha_guia = isNull( fecha_guia, '' ), " &_

       "TotalBultos = isNull( Total_Bultos, 0 ), " &_
       "TotalCBM = isNull( Total_CBM, 0 ), " &_
       "TotalKG = isNull( Total_KG, 0 ) " &_

       "from carpetas_final where documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes = '"&fec_anio_mes&"' and num_carpeta = " & num_carpeta
'response.write strSQL
'response.end
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  id_origen = rs("id_origen")
  id_transporte = rs("id_transporte")
  manifiesto = rs("manifiesto")
  id_embarcador = rs("id_embarcador")
  id_estado = rs("id_estado")
  Numero_aduana = rs("Numero_aduana")
  NDP = rs("NDP")

  fecha_salida = Replace(rs("fecha_salida"),"/","-")
  fecha_sanantonio = Replace(rs("fecha_sanantonio"),"/","-")
  fecha_transbordo = Replace(rs("fecha_transbordo"),"/","-")
  fecha_ptaarenas = Replace(rs("fecha_ptaarenas"),"/","-")
  fecha_aduana = Replace(rs("fecha_aduana"),"/","-")
  fecha_llegada = Replace(rs("fecha_llegada"),"/","-")
  fecha_recepcion = Replace(rs("fecha_recepcion"),"/","-")
  fecha_grabacion  = Replace(rs("fecha_grabacion"),"/","-")
  fecha_guia = Replace(rs("fecha_guia"),"/","-")

  TotalBultos = rs("TotalBultos")
  TotalCBM = rs("TotalCBM")
  TotalKG = rs("TotalKG")
  if isNull( TotalBultos ) then TotalBultos = 0
  if isNull( TotalCBM ) then TotalCBM = 0
  if isNull( TotalKG ) then TotalKG = 0
end if

bgcolor_tabla = "#CCCCCC"
%>
<table width="50%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="#FFFFFF">
    <tr>
        <td>
            <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
                <tr align="center" bgcolor="#444444">
                    <td style="width: 100px;">&nbsp;</td>
                    <td style="font-size: 11px; color:#CCCCCC;"><b><%=Ucase(titulo)%>:&nbsp;EDITAR CARPETA</b></td>
                    <td style="width: 100px;">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>

    <!--
    <tr>
        <td>
            <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
                <tr style="height:24px;">
                    <td style="width:10px;">&nbsp;</td>
                    <td style="width:100px;">
                        <label id="label_volver" name="label_volver" class="bot_inverse">
                            <img src="<%=RutaProyecto%>imagenes/Ico_Arrow_Left_White_Trans_18X16.png" width=18 height=16 border=0 align="top">&nbsp;&nbsp;Volver
                        </label>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    -->

    <tr>
        <td align='left'>
            <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="left" style="width:1430px; height:10px;">
                <legend id="texto_10">Datos generales</legend>
                <table width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="#FFFFFF">
                    <tr>
                        <td width='100%'>
                            <table id="texto_11" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>">
                                <tr style="height:40px; color:#555;">
                                    <td style="width:4px;">&nbsp;</td>
                                    <td style="width:30px;">
                                        <b>DOC.</b><br>
                                        <input value="<%=documento_respaldo%>" readonly type="text" id="documento_respaldo" name="documento_respaldo" style="width: 20px; background-color:#EEE;">
                                    </td>

                                    <td style="width:40px;">
                                        <b>A�O</b><br>
                                        <input value="<%=anio%>" type="text" id="anio" name="anio" style="width: 30px; background-color:#EEE;">
                                    </td>

                                    <td style="width:80px;">
                                        <b>MES</b><br>
                                        <input value="<%=Ucase(strMes)%>" type="text" id="str_mes" name="str_mes" style="width: 70px; background-color:#EEE;">
                                        <input type="hidden" id="mes" name="mes" value="<%=mes%>">
                                    </td>

                                    <td style="width:40px;">
                                        <b>N�</b><br>
                                        <input value="<%=num_carpeta%>" type="text" id="num_carpeta" name="num_carpeta" style="width: 30px; background-color:#EEE;">
                                    </td>

                                    <td style="width:120px;">
                                        <b>ORIGEN</b><br />
                                        <select id="id_origen" name="id_origen" style="width: 110px;" tipo_dato="entero" o_value="<%=id_origen%>">
                                            <option value=""></option>
                                            <%do while not rs_origenes.EOF%>
                                            <option <%if trim(id_origen) = trim(rs_origenes("id_origen")) then %> selected <%end if%> value="<%=rs_origenes("id_origen")%>"><%=rs_origenes("n_origen")%></option>
                                            <%rs_origenes.MoveNext
                                            loop%>
                                        </select>
                                    </td>

                                    <td style="width:100px;">
                                        <b>TRANSPORTE</b><br />
                                        <select id="id_transporte" name="id_transporte" style="width: 90px;" tipo_dato="entero" o_value="<%=id_transporte%>">
                                            <option value=""></option>
                                            <%do while not rs_transportes.EOF%>
                                            <option <%if trim(id_transporte) = trim(rs_transportes("id_transporte")) then %> selected <%end if%> value="<%=rs_transportes("id_transporte")%>"><%=rs_transportes("n_transporte")%></option>
                                            <%rs_transportes.MoveNext
                                            loop%>
                                        </select>
                                    </td>

                                    <td style="width:100;">
                                        <b>EMP.TRANS.</b><br />
                                        <select style="width: 90px;" id="id_embarcador" name="id_embarcador" tipo_dato="entero" o_value="<%=id_embarcador%>" >
                                            <option value=""></option>
                                            <%do while not rs_embarcadores.EOF%>
                                            <option <%if trim(id_embarcador) = trim(rs_embarcadores("id_embarcador")) then %> selected <%end if%> value="<%=rs_embarcadores("id_embarcador")%>"><%=rs_embarcadores("n_embarcador")%></option>
                                            <%rs_embarcadores.MoveNext
                                            loop%>
                                        </select>
                                    </td>
    
                                    <td style="width:160px;">
                                        <b>Manifiesto</b><br />
                                        <input value="<%=manifiesto%>" o_value="" tipo_dato="texto" type="text" id="manifiesto" name="manifiesto" maxlength="20" style="width: 150px;">
                                    </td>

                                    <td style="width:160px;">
                                        <b>NDP</b><br />
                                        <input value="<%=NDP%>" o_value="" tipo_dato="texto" type="text" id="NDP" name="NDP" maxlength="20" style="width: 150px;">
                                    </td>

                                    <td style="width:90;">
                                        <% if documento_respaldo = "Z" then %>
                                        <b>Nro. ADUANA:</b><br />
                                        <input value="<% = Numero_aduana %>" tipo_dato="texto" type="text" id="Numero_aduana" name="Numero_aduana" maxlength="10" style="width: 74px;" xreadOnly xdisabled>
                                        <% else %>
                                        &nbsp;<input value="" type="hidden" id="Numero_aduana" name="Numero_aduana">
                                        <% end if %>
                                        <input type='hidden' value='<% = ya_existe_RCP %>' id='ya_existe_RCP' name='ya_existe_RCP' />
                                    </td>

                                    <td style="width:90;">
                                        <b>ESTADO</b><br />
                                        <select style="width: 80px;" id="id_estado" name="id_estado" tipo_dato="entero" o_value="<%=id_estado%>" disabled>
                                            <option value=""></option>
                                            <option <%if trim(id_estado) = "1" then %> selected <%end if%> value="1">FACTURA</option>
                                            <option <%if trim(id_estado) = "2" then %> selected <%end if%> value="2">DAI</option>
                                            <option <%if trim(id_estado) = "3" then %> selected <%end if%> value="3">DAT</option>
                                            <option <%if trim(id_estado) = "4" then %> selected <%end if%> value="4">RCP</option>
                                        </select>
                                    </td>

                                    <td xstyle="width:100px;" align='left'>
                                        <label id="label_volver" name="label_volver" class="bot_inverse">
                                            <img src="<%=RutaProyecto%>imagenes/Ico_Arrow_Left_White_Trans_18X16.png" width=18 height=16 border=0 align="top">&nbsp;&nbsp;Volver
                                        </label>
                                    </td>
                                    <td style="display:none;" align='left'>
                                        <label id="label_ico" name="label_volver" class="bot_inverse">
                                            <img src="<%=RutaProyecto%>imagenes/85.ico" width=10 height=10 border=0 align="top">
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
    
                    <tr>
                        <td>
                            <table id="texto_12" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style="table-layout: fixed;">
                                <tr style="height:40px; color:#555;">
                                    <td style="width:100;">
                                        <b>FEC. SALIDA</b><br />
                                        <input value="<%=fecha_salida%>" o_value="<%=fecha_salida%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_salida" name="fecha_salida" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;" id='TD_fecha_sanantonio'>
                                        <b>SN.ANTONIO</b><br />
                                        <input value="<%=fecha_sanantonio%>" o_value="<%=fecha_sanantonio%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_sanantonio" name="fecha_sanantonio" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;" id='TD_fecha_transbordo'>
                                        <b>TRANSBORDO</b><br />
                                        <input value="<%=fecha_transbordo%>" o_value="<%=fecha_transbordo%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_transbordo" name="fecha_transbordo" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;">
                                        <b>PTA. ARENAS</b><br />
                                        <input value="<%=fecha_ptaarenas%>" o_value="<%=fecha_ptaarenas%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_ptaarenas" name="fecha_ptaarenas" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;" id='TD_fecha_aduana'>
                                        <b>ADUANA</b><br />
                                        <input value="<%=fecha_aduana%>" o_value="<%=fecha_aduana%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_aduana" name="fecha_aduana" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;">
                                        <b>EST.LLEGADA</b><br />
                                        <input value="<%=fecha_llegada%>" o_value="<%=fecha_llegada%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_llegada" name="fecha_llegada" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;">
                                        <b>RECEPCION</b><br />
                                        <input value="<%=fecha_recepcion%>" o_value="<%=fecha_recepcion%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_recepcion" name="fecha_recepcion" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:100;">
                                        <b>GRABACION</b><br />
                                        <input value="<%=fecha_grabacion%>" o_value="<%=fecha_grabacion%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_grabacion" name="fecha_grabacion" maxlength="10" style="width: 64px;" disabled>
                                    </td>

                                    <td style="width:100;">
                                        <b>FEC.DE GUIA</b><br />
                                        <input value="<%=fecha_guia%>" o_value="<%=fecha_guia%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_guia" name="fecha_guia" maxlength="10" style="width: 64px;" disabled>
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #00c000; border-left: 1px solid #00c000; border-bottom: 1px solid #00c000;" align='center'>
                                        <b>T. Bultos</b><br />
                                        <input value="<%=TotalBultos%>" o_value="" tipo_dato="texto" type="text" id="TotalBultos" name="TotalBultos" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #FFFFFF; border-bottom: 1px solid #FFFFFF;" align='center'>
                                        <b>T. CBM</b><br />
                                        <input value="<%=TotalCBM%>" o_value="" tipo_dato="texto" type="text" id="TotalCBM" name="TotalCBM" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #00c000; border-right: 1px solid #00c000; border-bottom: 1px solid #00c000;" align='center'>
                                        <b>T. KG</b><br />
                                        <input value="<%=TotalKG%>" o_value="" tipo_dato="texto" type="text" id="TotalKG" name="TotalKG" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #c00000; border-left: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. Bultos</b><br />
                                        <input value="<%=PesaBultos%>" o_value="" tipo_dato="texto" type="text" id="PesaBultos" name="PesaBultos" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. CBM</b><br />
                                        <input value="<%=PesaCBM%>" o_value="" tipo_dato="texto" type="text" id="PesaCBM" name="PesaCBM" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #c00000; border-right: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. KG</b><br />
                                        <input value="<%=PesaKG%>" o_value="" tipo_dato="texto" type="text" id="PesaKG" name="PesaKG" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #ffff40; border-left: 1px solid #ffff40; border-bottom: 1px solid #ffff40;" align='center'>
                                        <b>% Ocup.</b><br />
                                        <input value="<%=PorcOcup%>" o_value="" tipo_dato="texto" type="text" id="PorcOcup" name="PorcOcup" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #ffff40; border-right: 1px solid #ffff40; border-bottom: 1px solid #ffff40;" align='center'>
                                        <b>% Vacio</b><br />
                                        <input value="<%=PorcVacio%>" o_value="" tipo_dato="texto" type="text" id="PorcVacio" name="PorcVacio" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:100%">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </td>
    </tr>

    <tr>
        <td>
            <fieldset id="fieldset_gastos" name="fieldset_gastos" align="left" style="width:99.5%; height:50px;">
                <legend id="texto_10">Listado de facturas</legend>
                <table border='0' cellpadding='0' cellspacing='0' width='100%' align='left' style='table-layout: fixed;'>
                    <tr>
                        <td colspan='1' align='left'>
                            <table align="left" width="100%" cellpadding=0 cellspacing=0 border=0>
                                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                                    <td style="width:160px;">
                                        <label id="label_agregar_factura" name="label_agregar_factura" class="bot_success">
                                            &nbsp;<img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Plus_14X14.png" width=14 height=14 border=0 align="top">&nbsp;&nbsp;Agregar factura&nbsp;
                                        </label>
                                    </td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td colspan='1' align='left'>
                            <table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
                        </td>
                    </tr>

                    <tr>
                        <td colspan='1' align='left'>
                            <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 >
                                <tr valign="top" style="height:0px;">
                                    <td id="td_lista" name="td_lista" xstyle="border: 1px solid #CCCCCC;">&nbsp;</td>
                                    <td style="width:4px;">&nbsp;</td>
                                    <td id="td_form_ingreso" name="td_form_ingreso" style="width:680px;"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </td>
    </tr>

    <tr>
        <td>

            <table align="left" width="100%" cellpadding=0 cellspacing=0 border=0>
                <tr align="center" height="24">
                    <td id="td_msg" name="td_msg">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>

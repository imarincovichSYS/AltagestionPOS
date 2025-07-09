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
NumeroAduana       = Request.Form("Numero_aduana")

OpenConn
if documento_respaldo = "Z" then
strSQL="select id_tipo_factura, (convert(varchar(1),id_tipo_factura) + '. ' + n_tipo_factura) as n_tipo_factura from carpetas_tipos_facturas order by n_tipo_factura"
else
strSQL="select id_tipo_factura, (convert(varchar(1),id_tipo_factura) + '. ' + n_tipo_factura) as n_tipo_factura from carpetas_tipos_facturas where id_tipo_factura = '1' order by n_tipo_factura"
end if
set rs_tipo_factura = Conn.Execute(strSQL)

strSQL="select moneda, nombre from monedas order by nombre"
set rs_tipo_moneda = Conn.Execute(strSQL)

if numero_linea <> "" then
  fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
  strSQL="select entidad_comercial, id_tipo_factura, numero_factura, fecha_factura, tipo_moneda, " &_
         "monto_moneda_origen, paridad, monto_total_us$, monto_final_us$, porcentaje_prorrateo, Numero_aduana, Fecha_aduana, Tipo_documento_aduana, " &_
         "ProrrateoCBM = isNull( ProrrateoCBM, 0 ), ProrrateoKG = isNull( ProrrateoKG, 0 ), ProrrateoUSD = isNull( ProrrateoUSD, 0 ), ProrrateoItems = isNull( ProrrateoItems, '' ), " &_
         "Numero_lineas_factura = isNull( Numero_lineas_factura, 0 ), " &_
         "Bultos = isNull( Bultos, 0 ), CBM = isNull( CBM, 0 ), KG = isNull( KG, 0 ), Fisico = isNull( Fisico, 'N' ), " &_
         "TDP = isNull( Tipo_documento_pago, '' ),GrupoID,numero_interno_carpeta_detalle " &_
         "from carpetas_final_detalle " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' " &_
         "and num_carpeta=" & num_carpeta & " and numero_linea = " & numero_linea

  'response.write strSQL
  set rs = Conn.Execute(strSQL)
  if not rs.EOF then
    entidad_comercial     = trim(rs("entidad_comercial"))
    id_tipo_factura       = trim(rs("id_tipo_factura"))
    numero_factura        = trim(rs("numero_factura"))
    GrupoID        = rs("GrupoID")
    numero_interno_carpeta_detalle = rs("numero_interno_carpeta_detalle")
    fecha_factura = ""
    if not isNull(rs("fecha_factura")) then fecha_factura = Replace(rs("fecha_factura"),"/","-")
    tipo_moneda           = trim(rs("tipo_moneda"))
    'monto_moneda_origen   = Replace(Replace(FormatNumber(rs("monto_moneda_origen"),2),".",""),",",".")
    'paridad               = Replace(Replace(FormatNumber(rs("paridad"),2),".",""),",",".")
    'monto_total_usd       = Replace(Replace(FormatNumber(rs("monto_total_us$"),2),".",""),",",".")
    'monto_final_usd       = Replace(Replace(FormatNumber(rs("monto_final_us$"),2),".",""),",",".")
    'porcentaje_prorrateo  = Replace(Replace(FormatNumber(rs("porcentaje_prorrateo"),2),".",""),",",".")
    Numero_aduana          = trim(rs("Numero_aduana"))
    if isNull( Numero_aduana ) then Numero_aduana = ""
    if Numero_aduana = "" then Numero_aduana = NumeroAduana
    Fecha_aduana          = trim(rs("Fecha_aduana"))
    if isNull( Fecha_aduana ) then Fecha_aduana = ""

    Bultos = trim(rs("Bultos"))
    if isNull( Bultos ) then Bultos = ""
    CBM = trim(rs("CBM"))
    if isNull( CBM ) then CBM = 0.00
    KG = trim(rs("KG"))
    if isNull( KG ) then KG = 0.00
    Fisico = trim(rs("Fisico"))
    if isNull( Fisico ) then Fisico = "N"

    Tipo_documento_aduana = trim( rs( "Tipo_documento_aduana" ) )

    Numero_lineas_factura = trim(rs("Numero_lineas_factura"))
    if isNull( Numero_lineas_factura ) then Numero_lineas_factura = ""
    
    monto_moneda_origen   = Replace(FormatNumber(rs("monto_moneda_origen"),2),",","")
    paridad               = Replace(FormatNumber(rs("paridad"),7),",","")
    monto_total_usd       = Replace(FormatNumber(rs("monto_total_us$"),2),",","")
    monto_final_usd       = Replace(FormatNumber(rs("monto_final_us$"),2),",","")
    porcentaje_prorrateo  = Replace(FormatNumber(rs("porcentaje_prorrateo"),2),",","")

    ProrrateoCBM  = Replace(FormatNumber(rs("ProrrateoCBM"),2),",","")
    ProrrateoKG  = Replace(FormatNumber(rs("ProrrateoKG"),2),",","")
    ProrrateoUSD  = Replace(FormatNumber(rs("ProrrateoUSD"),2),",","")
    ProrrateoItems  = trim(rs("ProrrateoItems"))
    if ProrrateoItems = "0" then
        ProrrateoItems = ""
    end if

    TDP = trim( rs( "TDP" ) )

    strSQL="select ('(' + codigo_postal + ') ' + Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona) as nombre " &_
           "from entidades_comerciales where empresa = 'SYS' and entidad_comercial='" & entidad_comercial & "'"
    set rs = Conn.Execute(strSQL) : nombre = ""
    if not rs.EOF then nombre = Left(trim(rs("nombre")),32)
  end if
end if

h_tr = 25
color= "#555555"
bgcolor_tabla = "#CCCCCC"
%>
<input type="hidden" id="buscar_entidad_comercial" name="buscar_entidad_comercial" value="">
<input type="hidden" id="buscar_nombre" name="buscar_nombre" value="">
<input type="hidden" id="numero_interno_carpeta_detalle" name="numero_interno_carpeta_detalle" value="<%=numero_interno_carpeta_detalle%>">
<table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style='border: 1px solid #AAAAAA; table-layout: fixed;'>
    <tr valign='top'>
        <td colspan='2' align='center' bgcolor='#FFFFFF'><b>Ingreso / Modificacion de Documento</b>&nbsp;</td>
    </tr>
    <tr>
        <td width='340px' valign='top'>
            <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style='table-layout: fixed;'>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right" ><b>Item:</b>&nbsp;</td>
                  <td><input value="<%=numero_linea%>" id="numero_linea" name="numero_linea" style="font-size:10px; width:40px; text-align:left; background-color:#EEEEEE;" readonly></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td xstyle="width:114px;" align="right"><b>Proveedor:</b>&nbsp;</td>
                  <td><input value="<%=nombre%>" id="buscar_proveedor" name="buscar_proveedor" style="font-size:9px; width:120px;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right"><b>Rut:</b>&nbsp;</td>
                  <td><input value="<%=entidad_comercial%>" id="entidad_comercial" name="entidad_comercial" style="font-size:10px; width:90px; background-color:#EEEEEE;" readonly></td>
                </tr>

                <% IF TDP = "" THEN %>
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
                  <td align="right"><b>Fecha factura:</b>&nbsp;</td>
                  <td><input value="<%=fecha_factura%>" id="fecha_factura" name="fecha_factura" style="font-size:10px; width:80px;" xreadonly></td>
                </tr>
                <% ELSE %>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right" style="color:red;"><b>Tipo factura:</b>&nbsp;</td>
                  <td>
                      <select id="id_tipo_factura" name="id_tipo_factura" style="width: 120px; color:red;" ReadOnly>
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
                  <td align="right" style="color:red;"><b>N° factura:</b>&nbsp;</td>
                  <td><input value="<%=numero_factura%>" id="numero_factura" name="numero_factura" style="font-size:10px; width:120px; color:red;" ReadOnly></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right" style="color:red;"><b>Fecha factura:</b>&nbsp;</td>
                  <td><input value="<%=fecha_factura%>" id="fecha_factura" name="fecha_factura" style="font-size:10px; width:80px; color:red;"  ReadOnly></td>
                </tr>
                <% END IF %>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRNumero_lineas_factura" name="TRNumero_lineas_factura">
                  <td align="right"><b>Nro. lineas factura:</b>&nbsp;</td>
                  <td><input value="<%=Numero_lineas_factura%>" id="Numero_lineas_factura" name="Numero_lineas_factura" style="font-size:10px; width:40px; text-align:right;"></td>
                </tr>

                <% if documento_respaldo = "R" then %>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right"><b>Tipo dcto. aduana:</b>&nbsp;</td>
                  <td>
                      <select id="tipo_docto_aduana" name="tipo_docto_aduana" style="width: 40px;">
                            <option <% if Tipo_documento_aduana = "DS" then Response.write( "selected" ) %> value="DS">DS</option>
                            <option <% if Tipo_documento_aduana = "R" then Response.write( "selected" ) %> value="R">R</option>
                      </select>
                  </td>
                </tr>
                <% else %>
                <tr style="height: 25; color: #555555; display: none;'>
                  <td align="right">&nbsp;</td>
                  <td>
                      <select id="tipo_docto_aduana" name="tipo_docto_aduana" style="width: 40px;">
                            <option value="">&nbsp;</option>
                      </select>
                  </td>
                </tr>
                <% end if %>

                <% if documento_respaldo <> "Z" then %>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right"><b>N° Aduana:</b>&nbsp;</td>
                  <td><input value="<%=Numero_aduana%>" id="NumeroAduana" name="NumeroAduana" style="font-size:10px; width:80px;"></td>
                </tr>

                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                    <td align="right"><b>Fecha aduana:</b>&nbsp;</td>
                    <td><input value="<%=fecha_aduana%>" id="Fecha_aduana" name="Fecha_aduana" style="font-size:10px; width:80px;" xreadonly></td>
                </tr>
                <% else %>
                <tr style="height: <%=h_tr%>; color:<%=color%>; display: none;">
                  <td align="right">&nbsp;</td>
                  <td><input value="<%=Numero_aduana%>" id="NumeroAduana" name="NumeroAduana" type="hidden"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>; display: none;">
                  <td align="right">&nbsp;</td>
                  <td><input value="<%=fecha_aduana%>" id="Fecha_aduana" name="Fecha_aduana" type="hidden"></td>
                </tr>
                <% end if %>

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
                <% IF TDP = "" THEN %>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRMonto_total_usd" name="TRMonto_total_usd">
                    <td align="right"><b>Monto US$:</b>&nbsp;</td>
                    <td><input value="<%=monto_total_usd%>" id="monto_total_usd" name="monto_total_usd" style="font-size:10px; width:90px; text-align:right;"></td>
                  </tr>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRMonto_moneda_origen" name="TRMonto_moneda_origen">
                    <td align="right"><b>Monto Mon. Ori.:</b>&nbsp;</td>
                    <td><input onkeypress="return Valida_Numerico(event);" maxlength=10 value="<%=monto_moneda_origen%>" id="monto_moneda_origen" name="monto_moneda_origen" style="font-size:10px; width:90px; text-align:right;"></td>
                  </tr>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRParidad" name="TRParidad">
                    <td align="right"><b>Paridad M.Ori./US$:</b>&nbsp;</td>
                    <td><input onkeypress="return Valida_Numerico(event);" maxlength=6 value="<%=paridad%>" id="paridad" name="paridad" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" xreadOnly></td>
                  </tr>
                <%ELSE%>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRMonto_total_usd" name="TRMonto_total_usd">
                    <td align="right" style="color:red;"><b>Monto US$:</b>&nbsp;</td>
                    <td><input value="<%=monto_total_usd%>" id="monto_total_usd" name="monto_total_usd" disabled="true" style="font-size:10px; width:90px; text-align:right;color:red;" ></td>
                  </tr>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRMonto_moneda_origen" name="TRMonto_moneda_origen">
                    <td align="right" style="color:red;"><b>Monto Mon. Ori.:</b>&nbsp;</td>
                    <td><input onkeypress="return Valida_Numerico(event);" disabled="true" maxlength=10 value="<%=monto_moneda_origen%>" id="monto_moneda_origen" name="monto_moneda_origen" style="font-size:10px; width:90px; text-align:right;color:red;"></td>
                  </tr>
                  <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRParidad" name="TRParidad">
                    <td align="right"><b>Paridad M.Ori./US$:</b>&nbsp;</td>
                    <td><input onkeypress="return Valida_Numerico(event);" maxlength=6 value="<%=paridad%>" id="paridad" name="paridad" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" readOnly></td>
                  </tr>
                <%END IF%>
            </table>
        </td>

        <td  valign='top'>
            <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style='table-layout: fixed;'>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRBultos" name="TRBultos">
                  <td align="right"><b>Bultos:</b>&nbsp;</td>
                  <td><input value="<%=Bultos%>" id="Bultos" name="Bultos" style="font-size:10px; width:40px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRCBM" name="TRCBM">
                  <td align="right"><b>CBM:</b>&nbsp;</td>
                  <td><input value="<%=CBM%>" id="CBM" name="CBM" style="font-size:10px; width:40px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRKG" name="TRKG">
                  <td align="right"><b>KG:</b>&nbsp;</td>
                  <td><input value="<%=KG%>" id="KG" name="KG" style="font-size:10px; width:40px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;">
                  <td align="right"><b>Fisico:</b>&nbsp;</td>
                  <td>
                      <select id="Fisico" name="Fisico" style="width: 50px;">
                          <option <% if Fisico = "N" then Response.write( "selected" ) %> value="N">No</option>
                          <option <% if Fisico = "S" then Response.write( "selected" ) %> value="S">Si</option>
                          <option <% if Fisico = "F" then Response.write( "selected" ) %> value="F">Finalizado</option>
                      </select>
                  </td>
                </tr>

                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRProrrateoCBM" name="TRProrrateoCBM">
                  <td align="right"><b>% Prorrateo CBM:</b>&nbsp;</td>
                  <td><input value="<%=ProrrateoCBM%>" id="ProrrateoCBM" name="ProrrateoCBM" style="font-size:10px; width:90px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRProrrateoKG" name="TRProrrateoKG">
                  <td align="right"><b>% Prorrateo KG:</b>&nbsp;</td>
                  <td><input value="<%=ProrrateoKG%>" id="ProrrateoKG" name="ProrrateoKG" style="font-size:10px; width:90px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRProrrateoUSD" name="TRProrrateoUSD">
                  <td align="right"><b>% Prorrateo USD:</b>&nbsp;</td>
                  <td><input value="<%=ProrrateoUSD%>" id="ProrrateoUSD" name="ProrrateoUSD" style="font-size:10px; width:90px; text-align:right;"></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" id="TRProrrateoItems" name="TRProrrateoItems">
                  <td align="right"><b>% Prorrateo Items:</b>&nbsp;</td>
                  <td><input value="<%=ProrrateoItems%>" id="ProrrateoItems" name="ProrrateoItems" style="font-size:10px; width:120px;"></td>
                </tr>

                <tr style="height: <%=h_tr%>; color:<%=color%>; visibility: hidden;" style='display: none;'>
                  <td align="right"><b>Monto Final US$:</b>&nbsp;</td>
                  <td><input value="<%=monto_final_usd%>" id="monto_final_usd" name="monto_final_usd" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" readonly></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>; visibility:hidden;" style='display: none;'>
                  <td align="right"><b>Prorrateo (%):</b>&nbsp;</td>
                  <td><input value="<%=porcentaje_prorrateo%>" id="porcentaje_prorrateo" name="porcentaje_prorrateo" style="font-size:10px; width:90px; text-align:right; background-color:#EEEEEE;" readonly></td>
                </tr>
                <tr style="height: <%=h_tr%>; color:<%=color%>;" >
                  <td align="right"><b>Grupo:</b>&nbsp;</td>
                  <td>
                    
                      <select id="GrupoID" name="GrupoID" style="width: 50px;">
                          <option <% if GrupoID = 1 then Response.write( "selected" ) %> value="1">SYS</option>
                          <option <% if GrupoID = 2  then Response.write( "selected" ) %> value="2">ASH</option>
                      </select>
                  </td>
                </tr>
            </table>
        </td>
    </tr>
    <% IF TDP <> "" THEN %>
    <tr valign='top'>
        <td colspan='2' align='center' bgcolor='#FFFFFF' style="color:red; font-size: 10px;"><b>Por haber pago del documeto, no pueden modificar los datos de la Factura. Elimime los Pagos.</b>&nbsp;</td>
    </tr>
    <% END IF %>
    <tr valign='top'>
        <td colspan='2' align='center' bgcolor='#FFFFFF'>
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

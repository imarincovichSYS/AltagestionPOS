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

strSQL="select *,nombre_puerto = '('+ (select Nombre_Pais from compras.Paises where Id_Pais =p.Id_Pais) + ') ' + Nombre_Pue " &_
        "from compras.Puertos p order by '('+ (select Nombre_Pais from compras.Paises where Id_Pais =p.Id_Pais) + ') ' + Nombre_Pue "
set rs_puertos = Conn.Execute(strSQL)

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
PorcOcup = 0.00
PorcVacio = 0.00

dim_H = 0
dim_L = 0
dim_W = 0
IF TRUE THEN
strSQL = "SELECT dim_H, dim_L, dim_W  "
strSQL = strSQL & "FROM carpetas_final_camion_medidas (nolock) "
strSQL = strSQL & "WHERE carpeta = '" & auxCarpeta & "' "
set rs_medidas = Conn.Execute(strSQL)
if not rs_medidas.eof then
    dim_H = rs_medidas( "dim_H" )
    dim_L = rs_medidas( "dim_L" )
    dim_W = rs_medidas( "dim_W" )
end if
rs_medidas.close

strSQL = "UPDATE carpetas_final "
strSQL = strSQL & "SET CamionAlto = " & dim_H & ", "
strSQL = strSQL & "CamionAncho = " & dim_W & ", "
strSQL = strSQL & "CamionLargo = " & dim_L & " "
'strSQL = strSQL & "CamionCubicaje = ( CamionAlto * CamionAncho * CamionLargo ) / 1000000 "
strSQL = strSQL & "WHERE carpeta = '" & auxCarpeta & "' "
Conn.Execute(strSQL)

strSQL = "SELECT Bultos = count(distinct b.BultosID), CBM = isNull( sum( dim_H * dim_L * dim_W ) / 1000000, 0 ), Kg = isNull( sum( peso_KG ), 0 )  "
strSQL = strSQL & "FROM bultos b with(nolock) "
strSQL = strSQL & "WHERE numero_interno_documento_no_valorizado in ( "
strSQL = strSQL & " select dnv.Numero_interno_documento_no_valorizado "
strSQL = strSQL & " from Documentos_no_valorizados dnv (nolock) "
strSQL = strSQL & " where dnv.Empresa = 'sys' "
strSQL = strSQL & " and dnv.Documento_no_valorizado in( 'tcp', 'rcp' ) "
strSQL = strSQL & " and dnv.Carpeta in( "
strSQL = strSQL & "  select cf.carpeta "
strSQL = strSQL & "  from carpetas_final cf (nolock) "
strSQL = strSQL & "  where cf.carpeta = '" & auxCarpeta & "' "
strSQL = strSQL & "  ) "
strSQL = strSQL & " ) "
set rs_pesas = Conn.Execute(strSQL)
if not rs_pesas.eof then
    PesaBultos = Replace(rs_pesas( "Bultos" ), ",",".")
    PesaCBM = Replace(rs_pesas( "CBM" ), ",",".")
    PesaKg = Replace(rs_pesas( "Kg" ), ",",".")
end if
rs_pesas.close


strSQL = "UPDATE carpetas_final "
strSQL = strSQL & "SET PesaBultos = " & PesaBultos & ", "
strSQL = strSQL & "PesaCBM = " & PesaCBM & ", "
strSQL = strSQL & "PesaKg = " & PesaKg & ", "
strSQL = strSQL & "CamionCubicaje = ( CamionAlto * CamionAncho * CamionLargo ) / 1 "
'strSQL = strSQL & "CamionCubicaje = ( CamionAlto * CamionAncho * CamionLargo ) / 1000000 "
strSQL = strSQL & "WHERE carpeta = '" & auxCarpeta & "' "
Conn.Execute(strSQL)

strSQL = "UPDATE carpetas_final "
strSQL = strSQL & "SET PorcOcup =         case when CamionCubicaje is Null or CamionCubicaje = 0 then 0 else ( PesaCBM / CamionCubicaje ) * 100 end, "
strSQL = strSQL & "   PorcVacio = 100 - ( case when CamionCubicaje is Null or CamionCubicaje = 0 then 0 else ( PesaCBM / CamionCubicaje ) * 100 end ) "
'strSQL = strSQL & "  PorcVacio = CamionCubicaje - ( case when CamionCubicaje is Null or CamionCubicaje = 0 then 0 else ( PesaCBM / CamionCubicaje ) * 100 end ) "
strSQL = strSQL & "WHERE carpeta = '" & auxCarpeta & "' "
Conn.Execute(strSQL)
END IF

fec_anio_mes  = anio & "/" & Lpad(mes,2,0) & "/01"
strMes        = GetMes(mes)
strSQL="select id_origen, id_transporte, manifiesto, id_embarcador, id_estado,id_puerto, Numero_aduana, NDP, " &_
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
       "TotalKG = isNull( Total_KG, 0 ), " &_

       "PesaBultos = isNull( PesaBultos, 0 ), " &_
       "PesaCBM = isNull( PesaCBM, 0 ), " &_
       "PesaKG = isNull( PesaKG, 0 ), " &_

       "PorcOcup = isNull( PorcOcup, 0 ), " &_
       "PorcVacio = isNull( PorcVacio, 0 ), " &_

       "CamionPatente = isNull( CamionPatente, '' ), " &_
       "CamionAlto = isNull( CamionAlto, 0 ), " &_
       "CamionAncho = isNull( CamionAncho, 0 ), " &_
       "CamionLargo = isNull( CamionLargo, 0 ), " &_
       "CamionCubicaje = isNull( CamionCubicaje, 0 ), " &_
       "CamionChofer = isNull( CamionChofer, '' ), " &_
       "Factor_recibir = isNull( Factor_recibir, 0 ), " &_
       "Id_Buque_Viaje_Punta_Arenas,Id_Buque_Viaje_San_Antonio, " &_
       "Booking, " &_
       "idTipoCarga, " &_
       "Arrival_in = isNull( Arrival_in, '' ) " &_

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
  BOOKING = rs("Booking")
  idTipoCarga = rs("idTipoCarga")
  
  fecha_salida = Replace(rs("fecha_salida"),"/","-")
  fecha_sanantonio = Replace(rs("fecha_sanantonio"),"/","-")
  fecha_transbordo = Replace(rs("fecha_transbordo"),"/","-")
  fecha_ptaarenas = Replace(rs("fecha_ptaarenas"),"/","-")
  fecha_aduana = Replace(rs("fecha_aduana"),"/","-")
  fecha_llegada = Replace(rs("fecha_llegada"),"/","-")
  fecha_recepcion = Replace(rs("fecha_recepcion"),"/","-")
  fecha_grabacion  = Replace(rs("fecha_grabacion"),"/","-")
  fecha_guia = Replace(rs("fecha_guia"),"/","-")
  Arrival_in = Replace(rs("Arrival_in"),"/","-")

  TotalBultos = rs("TotalBultos")
  TotalCBM = rs("TotalCBM")
  TotalKG = rs("TotalKG")
  id_puerto = rs("id_puerto")
  if isNull( TotalBultos ) then TotalBultos = 0
  if isNull( TotalCBM ) then TotalCBM = 0
  if isNull( TotalKG ) then TotalKG = 0

  PesaBultos = rs("PesaBultos")
  PesaCBM = rs("PesaCBM")
  PesaKG = rs("PesaKG")
  if isNull( PesaBultos ) then PesaBultos = 0
  if isNull( PesaCBM ) then PesaCBM = 0
  if isNull( PesaKG ) then PesaKG = 0

  PorcOcup = rs("PorcOcup")
  PorcVacio = rs("PorcVacio")
  if isNull( PorcOcup ) then PorcOcup = 0
  if isNull( PorcVacio ) then PorcVacio = 0

  CamionPatente = rs("CamionPatente")
  CamionAlto = rs("CamionAlto")
  CamionAncho = rs("CamionAncho")
  CamionLargo = rs("CamionLargo")
  CamionCubicaje = rs("CamionCubicaje")
  CamionChofer = rs("CamionChofer")
  Id_Buque_Viaje_Punta_Arenas = rs("Id_Buque_Viaje_Punta_Arenas")
  Id_Buque_Viaje_San_Antonio = rs("Id_Buque_Viaje_San_Antonio")
  if isNull( CamionAlto ) then CamionAlto = 0
  if isNull( CamionAncho ) then CamionAncho = 0
  if isNull( CamionLargo ) then CamionLargo = 0
  if isNull( CamionCubicaje ) then CamionCubicaje = 0
  
  Factor_recibir = rs("Factor_recibir")
  if isNull( Factor_recibir ) then Factor_recibir = 0
end if

if isNull(Id_Buque_Viaje_Punta_Arenas) = false then
   strSQL = "select " &_
            "Nombre_Buque = (select top 1 Nombre_Buque from compras.Buques where Id_Buque = bv.Id_Buque) + ' ' + Numero " &_
            "from compras.Buques_Viajes bv " &_
            "where Id_Buque_Viaje = " & Id_Buque_Viaje_Punta_Arenas

   set rs_Buque_Viaje_Punta_Arenas = Conn.Execute(strSQL)
   if not rs_Buque_Viaje_Punta_Arenas.eof then
      nombre_nave_punta_arenas = rs_Buque_Viaje_Punta_Arenas( "Nombre_Buque" )
   else
      nombre_nave_punta_arenas = ""
   end if
   rs_Buque_Viaje_Punta_Arenas.close
end if

if isNull(Id_Buque_Viaje_San_Antonio) = false then
   strSQL = "select " &_
            "Nombre_Buque = (select top 1 Nombre_Buque from compras.Buques where Id_Buque = bv.Id_Buque) + ' ' + Numero " &_
            "from compras.Buques_Viajes bv " &_
            "where Id_Buque_Viaje = " & Id_Buque_Viaje_San_Antonio

   set rs_Buque_Viaje_San_Antonio = Conn.Execute(strSQL)
   if not rs_Buque_Viaje_San_Antonio.eof then
      nombre_nave_san_antonio = rs_Buque_Viaje_San_Antonio( "Nombre_Buque" )
   else
      nombre_nave_san_antonio = ""
   end if
   rs_Buque_Viaje_San_Antonio.close
end if

facturas_mismo_numero_con_fecha_distinta = false
strSQL = "select numero_factura from carpetas_final_detalle " &_
      "where documento_respaldo = '"&documento_respaldo&"' and anio_mes = '"&fec_anio_mes&"' and num_carpeta = " & num_carpeta & " " &_
      "group by entidad_comercial,numero_factura having MAX(fecha_factura)<>MIN(fecha_factura) " 
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  facturas_mismo_numero_con_fecha_distinta = true
  numero_factura_diferente_fecha = rs("numero_factura")
end if

rs.close
set rs = nothing

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
            <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="left" style="width:1500px; height:10px;">
                <legend id="texto_10">Datos generales</legend>
                <table width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="#FFFFFF">
                    <tr>
                        <td width='100%'>
                            <table id="texto_11" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>">
                                <tr style="height:40px; color:#555;">
                                    <!--<td style="width:4px;">&nbsp;</td>-->
                                    <td style="width:30px;">
                                        <b>DOC.</b><br>
                                        <input value="<%=documento_respaldo%>" readonly type="text" id="documento_respaldo" name="documento_respaldo" style="width: 20px; background-color:#EEE;">
                                        <input type="hidden" value="<%=auxCarpeta%>" name="auxCarpeta" id="auxCarpeta" >
                                    </td>

                                    <td style="width:35px;">
                                        <b>A&ntilde;O</b><br>
                                        <input value="<%=anio%>" type="text" id="anio" name="anio" style="width: 30px; background-color:#EEE;">
                                    </td>

                                    <td style="width:75px;">
                                        <b>MES</b><br>
                                        <input value="<%=Ucase(strMes)%>" type="text" id="str_mes" name="str_mes" style="width: 70px; background-color:#EEE;">
                                        <input type="hidden" id="mes" name="mes" value="<%=mes%>">
                                    </td>

                                    <td style="width:45px;">
                                        <b>N&ordm;</b><br>
                                        <input value="<%=num_carpeta%>" type="text" id="num_carpeta" name="num_carpeta" style="width: 30px; background-color:#EEE;">
                                    </td>
                  
                                    <td style="width:1px;">&nbsp;</td>

                                    <td style="width:130px;">
                                        <b>ORIGEN</b><br />
                                        <select id="id_origen" name="id_origen" style="width: 120px;" tipo_dato="entero" o_value="<%=id_origen%>">
                                            <option value=""></option>
                                            <%do while not rs_origenes.EOF%>
                                            <option <%if trim(id_origen) = trim(rs_origenes("id_origen")) then %> selected <%end if%> value="<%=rs_origenes("id_origen")%>"><%=rs_origenes("n_origen")%></option>
                                            <%rs_origenes.MoveNext
                                            loop%>
                                        </select>
                                    </td>
                  
                                    <td style="width:1px;">&nbsp;</td>

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
                  
                                    <td style="width:1px;">&nbsp;</td>

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
                                    <% if id_transporte = "2"  then %>
                    <td style="width:1px;">&nbsp;</td>
                                       <td style="width:150;">
                                          <b>PUERTO</b><br />
                                          <select style="width: 140px;" id="id_puerto" name="id_puerto" tipo_dato="entero" o_value="<%=id_puerto%>" >
                                             <option value=""></option>
                                             <%do while not rs_puertos.EOF%>
                                                <option <%if trim(id_puerto) = trim(rs_puertos("Id_Pue")) then %> selected <%end if%> value="<%=rs_puertos("Id_Pue")%>"><%=rs_puertos("nombre_puerto")%></option>
                                            <%rs_puertos.MoveNext
                                            loop%>
                                          </select>
                                       </td>
                                      
                    <td style="width:1px;">&nbsp;</td>
                                       <td style="width:150;">
                                          <b>BUQUE SN.ANTONIO</b><br />
                                          <input value="<%=nombre_nave_san_antonio%>" id="buscar_buque_san_antonio" name="buscar_buque_san_antonio" style="font-size:9px; width:140px;">
                                          <input value="" id="Id_Buque_Viaje_San_Antonio" name="Id_Buque_Viaje_San_Antonio" type="hidden" tipo_dato="entero">
                                       </td>
                    <td style="width:1px;">&nbsp;</td>
                                       <td style="width:150;">
                                          <b>BUQUE PTA.ARENAS</b><br />
                                          <input value="<%=nombre_nave_punta_arenas%>" id="buscar_buque_punta_arenas" name="buscar_buque_punta_arenas" style="font-size:9px; width:140px;">
                                          <input value="" id="Id_Buque_Viaje_Punta_Arenas" name="Id_Buque_Viaje_Punta_Arenas" type="hidden" tipo_dato="entero">
                                       </td>
                                       

                                    <%else%>
                    <td style="width:1px;">
                       &nbsp;<input value="" type="hidden" id="id_puerto" name="id_puerto" value="<%=id_puerto%>">
                    </td>
                                    <%end if%>
                  <td style="width:1px;">&nbsp;</td>
                                    <td style="width:100px;">
                                        <b>Manifiesto</b><br />
                                        <input value="<%=manifiesto%>" o_value="" tipo_dato="texto" type="text" id="manifiesto" name="manifiesto" maxlength="20" style="width: 100px;">
                                    </td>
                  
                                    <td style="width:1px;">&nbsp;</td>

                                    <td style="width:100px;">
                                        <b>NDP</b><br />
                                        <input value="<%=NDP%>" o_value="" tipo_dato="texto" type="text" id="NDP" name="NDP" maxlength="20" style="width: 100px;">
                                    </td>
                  
                                    <td style="width:1px;">&nbsp;</td>
                                    <% if documento_respaldo = "Z" then %>
                                    <td style="width:100px;">
                                        <b>BOOKING</b><br />
                                        <input value="<%=BOOKING%>" o_value="" tipo_dato="texto" type="text" id="Booking" name="Booking" maxlength="20" style="width: 100px;">
                                    </td>
                                   <%else%>
                                    &nbsp;<input value="" type="hidden" id="Booking" name="Booking">

                                   <% end if %>
                                    <td style="width:1px;">&nbsp;</td>

                                    <td style="width:90;">
                                        <% if documento_respaldo = "Z" then %>
                                        <b>Nro. ADUANA:</b><br />
                                        <input value="<% = Numero_aduana %>" tipo_dato="texto" type="text" id="Numero_aduana" name="Numero_aduana" maxlength="10" style="width: 74px;" xreadOnly xdisabled>
                                        <% else %>
                                        &nbsp;<input value="" type="hidden" id="Numero_aduana" name="Numero_aduana">
                                        <% end if %>
                                        <input type='hidden' value='<% = ya_existe_RCP %>' id='ya_existe_RCP' name='ya_existe_RCP' />
                                    </td>
                  
                                    <td style="width:1px;">&nbsp;</td>

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

                                    <td style="width:1px;">&nbsp;</td>
                                        <% if documento_respaldo = "Z" then %>
                                        <td style="width:100px;">
                                            <b>Tipo Carga</b><br />
                                            <select style="width: 80px;" id="idTipoCarga" name="idTipoCarga" tipo_dato="entero" o_value="<%=idTipoCarga%>">
                                                <option value=""></option>
                                                <option <%if trim(idTipoCarga) = "1" then %> selected <%end if%> value="1">FAK</option>
                                                <option <%if trim(idTipoCarga) = "2" then %> selected <%end if%> value="2">DG</option>
                                            </select>

                                        </td>
                                        <% end if %>
                                    <td style="width:1px;">&nbsp;</td>
                  <!--
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
                  -->
                  
                                    <td style="width:100%">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
    
                    <tr>
                        <td>
                            <table id="texto_12" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style="table-layout: fixed;">
                                <tr style="height:40px; color:#555;">
                                    <td style="width:80;">
                                        <b>FEC. SALIDA</b><br />
                                        <input value="<%=fecha_salida%>" o_value="<%=fecha_salida%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_salida" name="fecha_salida" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;" id='TD_fecha_sanantonio'>
                                        <b>SN.ANTONIO</b><br />
                                        <input value="<%=fecha_sanantonio%>" o_value="<%=fecha_sanantonio%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_sanantonio" name="fecha_sanantonio" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;" id='TD_fecha_transbordo'>
                                        <b>TRANSBORDO</b><br />
                                        <input value="<%=fecha_transbordo%>" o_value="<%=fecha_transbordo%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_transbordo" name="fecha_transbordo" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;">
                                        <b>PTA. ARENAS</b><br />
                                        <% if id_transporte = "2" and isNull(Id_Buque_Viaje_Punta_Arenas) = false then %>
                                        <input value="<%=fecha_ptaarenas%>" o_value="<%=fecha_ptaarenas%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_ptaarenas" name="fecha_ptaarenas" maxlength="10" style="width: 64px;" disabled>
                                        <% else %>
                                        <input value="<%=fecha_ptaarenas%>" o_value="<%=fecha_ptaarenas%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_ptaarenas" name="fecha_ptaarenas" maxlength="10" style="width: 64px;">
                                        <% end if %>
                                    </td>

                  <% if documento_respaldo = "Z" then %>
                                    <td style="width:40px;">
                                        <b>Factor</b><br>
                                        <input value="<%=Factor_recibir%>" type="text" id="Factor_recibir" tipo_dato="entero" name="Factor_recibir" style="width: 30px;">
                                    </td>
                  <% else %>
                                    <td style="width:40px;">
                                        <input value="<%=Factor_recibir%>" type="hidden" id="Factor_recibir" tipo_dato="entero" name="Factor_recibir" style="width: 30px;">
                                    </td>
                  <% end if %>

                                    <td style="width:80;" id='TD_fecha_aduana'>
                                        <b>ADUANA</b><br />
                                        <input value="<%=fecha_aduana%>" o_value="<%=fecha_aduana%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_aduana" name="fecha_aduana" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;">
                                        <b>EST.LLEGADA</b><br />
                                        <input value="<%=fecha_llegada%>" o_value="<%=fecha_llegada%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_llegada" name="fecha_llegada" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;">
                                        <b>RECEPCION</b><br />
                                        <input value="<%=fecha_recepcion%>" o_value="<%=fecha_recepcion%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_recepcion" name="fecha_recepcion" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:80;">
                                        <b>GRABACION</b><br />
                                        <input value="<%=fecha_grabacion%>" o_value="<%=fecha_grabacion%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_grabacion" name="fecha_grabacion" maxlength="10" style="width: 64px;" disabled>
                                    </td>

                                    <td style="width:80;">
                                        <b>FEC.DE GUIA</b><br />
                                        <input value="<%=fecha_guia%>" o_value="<%=fecha_guia%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="fecha_guia" name="fecha_guia" maxlength="10" style="width: 64px;" disabled>
                                    </td>

                                    <td style="width:80;" id='TD_fecha_arrival'>
                                        <b>Arrival in</b><br />
                                        <input value="<%=Arrival_in%>" o_value="<%=Arrival_in%>" tipo_dato="fecha" onkeypress="return Valida_Caracteres_Fecha(event);" type="text" id="Arrival_in" name="Arrival_in" maxlength="10" style="width: 64px;">
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #00c000; border-left: 1px solid #00c000; border-bottom: 1px solid #00c000;" align='center'>
                                        <b>T. Bultos</b><br />
                                        <input value="<%=FormatNumber( TotalBultos, 0 )%>" o_value="" tipo_dato="texto" type="text" id="TotalBultos" name="TotalBultos" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #00c000; border-bottom: 1px solid #00c000;" align='center'>
                                        <b>T. CBM</b><br />
                                        <input value="<%=FormatNumber( TotalCBM, 4 )%>" o_value="" tipo_dato="texto" type="text" id="TotalCBM" name="TotalCBM" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #00c000; border-right: 1px solid #00c000; border-bottom: 1px solid #00c000;" align='center'>
                                        <b>T. KG</b><br />
                                        <input value="<%=FormatNumber( TotalKG, 2 )%>" o_value="" tipo_dato="texto" type="text" id="TotalKG" name="TotalKG" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #c00000; border-left: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. Bultos</b><br />
                                        <input value="<%=FormatNumber( PesaBultos, 0 )%>" o_value="" tipo_dato="texto" type="text" id="PesaBultos" name="PesaBultos" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. CBM</b><br />
                                        <input value="<%=FormatNumber( PesaCBM, 4 )%>" o_value="" tipo_dato="texto" type="text" id="PesaCBM" name="PesaCBM" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #c00000; border-right: 1px solid #c00000; border-bottom: 1px solid #c00000;" align='center'>
                                        <b>T. KG</b><br />
                                        <input value="<%=FormatNumber( PesaKG, 2 )%>" o_value="" tipo_dato="texto" type="text" id="PesaKG" name="PesaKG" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:60px; border-top: 1px solid #ffff40; border-left: 1px solid #ffff40; border-bottom: 1px solid #ffff40;" align='center'>
                                        <b>% Ocup.</b><br />
                                        <input value="<%=FormatNumber( PorcOcup, 2 )%>" o_value="" tipo_dato="texto" type="text" id="PorcOcup" name="PorcOcup" style="width: 50px; text-align: center" disabled>
                                    </td>
                                    <td style="width:60px; border-top: 1px solid #ffff40; border-right: 1px solid #ffff40; border-bottom: 1px solid #ffff40;" align='center'>
                                        <b>% Vacio</b><br />
                                        <input value="<%=FormatNumber( PorcVacio, 2 )%>" o_value="" tipo_dato="texto" type="text" id="PorcVacio" name="PorcVacio" style="width: 50px; text-align: center" disabled>
                                    </td>

                                    <td style="width:100%">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <table id="texto_12" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style="table-layout: fixed;">
                                <tr style="height:40px; color:#555;">
                                    <td style="width:60px;">
                                        <b>Nro Chasis</b><br />
                                        <input value="<%=CamionPatente%>" o_value="" tipo_dato="texto" type="text" id="CamionPatente" name="CamionPatente" maxlength="7" style="width: 60px;">
                                    </td>

                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:60px;">
                                        <b>Alto</b><br />
                                        <input value="<%=FormatNumber( CamionAlto, 2 )%>" o_value="" tipo_dato="texto" type="text" id="CamionAlto" name="CamionAlto" maxlength="10" style="width: 50px;" disabled>
                                    </td>
                                    <td style="width:60px;">
                                        <b>Ancho</b><br />
                                        <input value="<%=FormatNumber( CamionAncho, 2 )%>" o_value="" tipo_dato="texto" type="text" id="CamionAncho" name="CamionAncho" maxlength="10" style="width: 50px;" disabled>
                                    </td>
                                    <td style="width:60px;">
                                        <b>Largo</b><br />
                                        <input value="<%=FormatNumber( CamionLargo, 2 )%>" o_value="" tipo_dato="texto" type="text" id="CamionLargo" name="CamionLargo" maxlength="10" style="width: 50px;" disabled>
                                    </td>

                                    <td style="width:60px;">
                                        <b>Cubicaje</b><br />
                                        <input value="<%=FormatNumber( CamionCubicaje, 2 )%>" o_value="" tipo_dato="texto" type="text" id="CamionCubicaje" name="CamionCubicaje" maxlength="10" style="width: 50px;" disabled>
                                    </td>
                                    <td style="width:5px; border-top: 0px none #FFFFFF; border-left: 0px none #FFFFFF; border-bottom: 0px none #FFFFFF;" align='center'>
                                        &nbsp;
                                    </td>

                                    <td style="width:170px;">
                                        <b>Chofer</b><br />
                                        <input value="<%=CamionChofer%>" o_value="" tipo_dato="texto" type="text" id="CamionChofer" name="CamionChofer" maxlength="50" style="width: 170px;">
                                    </td>

                                    <td style="width:100px;" align='center'>
                                        <label id="label_volver" name="label_volver" class="bot_inverse">
                                            <img src="<%=RutaProyecto%>imagenes/Ico_Arrow_Left_White_Trans_18X16.png" width=18 height=16 border=0 align="top">&nbsp;&nbsp;Volver
                                        </label>
                                    </td>
                                    <!--<td style="width:170px;display:inline">
                                        <b>Manifiestos</b><br />
                                        <input value="" o_value="" tipo_dato="texto" type="text" id="ManifiestoNuevo" name="ManifiestoNuevo" maxlength="50" style="width: 170px;">
                                        
                                    </td>
                                    <td style="width:100px;" align='left'>
                                        <br />
                                        <button style="display:inline">+</button>
                                    </td>
                                    -->
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
    <%if facturas_mismo_numero_con_fecha_distinta = true then%>
    <tr><span style="background-color:yellow;font-size: 12px;">Tiene Facturas con el mismo Numero y diferente fecha <%=numero_factura_diferente_fecha%></span></tr>
    <%end if%>
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

                                   <td style="width:200px;">
                                        <label id="lbl_movimiento_buque" name="lbl_movimiento_buque" class="bot_success">
                                            &nbsp;<img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Plus_14X14.png" width=14 height=14 border=0 align="top">&nbsp;&nbsp;Agregar Movimiento Buques&nbsp;
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

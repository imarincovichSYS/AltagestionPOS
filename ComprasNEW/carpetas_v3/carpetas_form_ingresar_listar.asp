<%@ Language=VBScript %>
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
fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
OpenConn

set ObjDict_TIPOS_FACTURA = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_TIPOS_FACTURA,"select id_tipo_factura value, n_tipo_factura text from carpetas_tipos_facturas order by value"

strSQL="select A.numero_linea, A.entidad_comercial, " &_
       "proveedor = (select codigo_postal from entidades_comerciales where empresa = 'SYS' and entidad_comercial = A.entidad_comercial), " &_
       "A.id_tipo_factura, A.numero_factura, A.fecha_factura, A.tipo_moneda, A.monto_moneda_origen, A.paridad, A.monto_total_us$, A.monto_final_us$, A.porcentaje_prorrateo, A.Numero_aduana, A.Numero_factura_contable " &_
       ", A.Fecha_aduana, A.Fecha_grabacion, A.Fecha_guia, A.Bultos, A.Fisico, A.Tipo_documento_aduana, A.CBM, A.KG, A.Tipo_documento_pago, A.Numero_documento_pago, A.Fecha_documento_pago, A.Fecha_conciliacion " &_
       ", A.Prorrateo, A.ProrrateoCBM, A.ProrrateoKG, A.ProrrateoUSD, A.ProrrateoItems, A.Numero_lineas_factura " &_
       ", Pagos = ( SELECT count(*) FROM Asientos_contables ac (nolock) WHERE ac.Empresa = 'SYS' and ac.Registro_de_cancelacion = 'S' and ac.Numero_interno_documento_cobrado_o_pagado in( SELECT d.Numero_interno_documento_valorizado FROM Documentos_valorizados d (nolock) WHERE d.Empresa = 'SYS' and d.Documento_valorizado = 'UFC' and d.Numero_documento_valorizado = A.Numero_factura_contable and d.Carpeta = ( SELECT carpeta FROM carpetas_final cf (nolock) WHERE cf.documento_respaldo = A.documento_respaldo and cf.anio_mes = A.anio_mes and cf.num_carpeta = A.num_carpeta ) ) ) " &_
       ", NroInterno = ( SELECT d.Numero_interno_documento_valorizado FROM Documentos_valorizados d (nolock) WHERE d.Empresa = 'SYS' and d.Documento_valorizado = 'UFC' and d.Numero_documento_valorizado = A.Numero_factura_contable and  d.Proveedor = A.entidad_comercial and d.Carpeta = ( SELECT carpeta FROM carpetas_final cf (nolock) WHERE cf.documento_respaldo = A.documento_respaldo and cf.anio_mes = A.anio_mes and cf.num_carpeta = A.num_carpeta ) ) " &_
       ", id_estado = isNull( A.id_estado, 0 ) " &_
       ", Estado = case when id_estado =  1 then 'FAC' when id_estado =  2 then 'DAI' when id_estado =  3 then 'DAT' when id_estado =  4 then 'RCP' else '' end, " &_
       "Grupo = case when GrupoID = 1 then 'SYS' when GrupoID = 2 then 'ASH' else '' end " &_
       "from carpetas_final_detalle A with(nolock), carpetas_tipos_facturas F with(nolock) " &_
       "where A.documento_respaldo='" & documento_respaldo & "' and A.anio_mes='"  &fec_anio_mes & "' and A.num_carpeta=" & num_carpeta & " " &_
        "and A.id_tipo_factura = F.id_tipo_factura " 

if documento_respaldo = "Z" then
  strSQL = strSQL & "order by  F.Orden, A.numero_linea , Proveedor, a.numero_factura "
else
  strSQL = strSQL & "order by  Proveedor "
end if

       
       '"order by A.numero_linea"


'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  width             = 1000
  w_item            = 25
  w_tipo_factura    = 70
  w_num_factura     = 110
  w_num_contable    = 60
  w_fecha_factura   = 42
  w_tipo_docto_aduana = 50
  w_num_aduana      = 50
  w_fecha_aduana    = 42
  w_estado = 42
  w_fecha_grabacion = 42
  w_fecha_guia      = 42

  w_tipo_mon      = 40
  w_monto_mon_ori = 70
  w_paridad       = 50
  w_monto_tot_usd = 70
  w_monto_fin_usd = 70
  w_prorrateo     = 50

  w_bultos        = 20
  w_fisico        = 20
  w_Grupo = 25

  w_CBM = 40
  w_KG = 40
  w_Tipo_documento_pago = 40
  w_Numero_documento_pago = 60
  w_Fecha_documento_pago = 42
  w_Fecha_conciliacion = 42

  w_Prorrateo = 40
  w_NumLinFac = 25

  w_ico           = 18

  %>
  <table width="100%" align="left" cellpadding=0 cellspacing=0 border=0 bgcolor="#FFFFFF">
  <tr>
    <td>
    <div name="capaEncListaDetalle" id="capaEncListaDetalle" style="width: 100%; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width: 100%;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="16">
      <td style="width:<%=w_item%>px; text-align:left;"                     id='grid_TH_1'>&nbsp;Item</td>
      <td style="text-align:left;"                                          id='grid_TH_1'>&nbsp;Proveedor</td>
      <td style="width:<%=w_tipo_factura%>px; text-align:left;"             id='grid_TH_1'>&nbsp;Tipo factura</td>
      <td style="width:<%=w_num_factura%>px; text-align:center;"            id='grid_TH_1'>&nbsp;N° factura<br />proveedor</td>
      <td style="width:<%=w_num_contable%>px; text-align:center;"           id='grid_TH_1'>&nbsp;N° factura<br />contable</td>
      <td style="width:<%=w_fecha_factura%>px; text-align:center;"          id='grid_TH_1'>&nbsp;Fecha<br />factura</td>
      <td style="width:<%=w_NumLinFac%>px; text-align:center;"              id='grid_TH_1'>&nbsp;Lin<br />Fact</td>
      <% if documento_respaldo <> "Z" then %>
      <td style="width:<%=w_tipo_docto_aduana%>px; text-align:center;"      id='grid_TH_1'>&nbsp;Docto.<br />aduana</td>
      <td style="width:<%=w_num_aduana%>px; text-align:center;"             id='grid_TH_1'>&nbsp;N° aduana</td>
      <td style="width:<%=w_fecha_aduana%>px; text-align:center;"           id='grid_TH_1'>&nbsp;Fecha<br />aduana</td>
      <td style="width:<%=w_estado%>px; text-align:center;"                 id='grid_TH_1'>&nbsp;Estado</td>
      <td style="width:<%=w_fecha_grabacion%>px; text-align:center;"        id='grid_TH_1'>&nbsp;Fecha<br />grabac</td>
      <td style="width:<%=w_fecha_guia%>px; text-align:center;"             id='grid_TH_1'>&nbsp;Fecha<br />de guia</td>
      <% end if %>
      <td style="width:<%=w_tipo_mon%>px;"                                  id='grid_TH_1'>Moneda</td>
      <td style="width:<%=w_monto_mon_ori%>px; text-align:center;"          id='grid_TH_1'>Monto<br>Mon. Ori.</td>
      <td style="width:<%=w_paridad%>px; text-align:center;"                id='grid_TH_1'>Paridad</td>
      <td style="width:<%=w_monto_fin_usd%>px; text-align:right;"           id='grid_TH_1'>Monto US$&nbsp;</td>

      <td style="width:<%=w_fisico%>px; text-align:center;"                 id='grid_TH_1'>Fis</td>
      <td style="width:<%=w_bultos%>px; text-align:center;"                 id='grid_TH_1'>Bul</td>
      <td style="width:<%=w_CBM%>px; text-align:center;"                    id='grid_TH_1'>CBM</td>
      <td style="width:<%=w_KG%>px; text-align:center;"                     id='grid_TH_1'>KG</td>

      <% if documento_respaldo = "Z" then %>
      <td style="width:<%=w_Prorrateo%>px; text-align:center;"              id='grid_TH_1'>% Prorr<br />CBM</td>
      <td style="width:<%=w_Prorrateo%>px; text-align:center;"              id='grid_TH_1'>% Prorr<br />KG</td>
      <td style="width:<%=w_Prorrateo%>px; text-align:center;"              id='grid_TH_1'>% Prorr<br />US$</td>
      <td style="width:<%=w_Prorrateo%>px; text-align:center;"              id='grid_TH_1'>% Prorr<br />Items</td>
      <% end if %>

      <td style="width:<%=w_Tipo_documento_pago%>px; text-align:center;"    id='grid_TH_1'>T.Dcto.<br />pago</td>
      <td style="width:<%=w_Numero_documento_pago%>px; text-align:center;"  id='grid_TH_1'>N°.Docto.<br />pago</td>
      <td style="width:<%=w_Fecha_documento_pago%>px; text-align:center;"   id='grid_TH_1'>Fec.Dcto<br />pago</td>
      <td style="width:<%=w_Fecha_conciliacion%>px; text-align:center;"     id='grid_TH_1'>Fecha<br />concil</td>
      <td style="width:<%=w_Grupo%>px; text-align:center;"     id='grid_TH_1'>Gru</td>

      <td style="width:<%=w_ico%>px; text-align:center;"                    id='grid_TH_1'>&nbsp;</td>
      <td style="width:<%=w_ico%>px; text-align:center;"                    id='grid_TH_1'>&nbsp;</td>
    </tr>
    </table>
    </div>
    <!-- <div align="left" id="capaListaDetalle" name="capaListaDetalle" onscroll="$('#capaEncListaDetalle').scrollLeft=this.scrollLeft;" style="width:<%=width%>; height: 502px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;"> -->
    <div align="left" id="capaListaDetalle" name="capaListaDetalle" onscroll="$('#capaEncListaDetalle').scrollLeft=this.scrollLeft;" style="width: 100%; height: 394px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <!-- <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0> -->
    <table style="width: 100%;" cellpadding=0 cellspacing=0 border=0>
    <%
    total_monto_final_usd = 0
    fila = 1
    do while not rs.EOF
      str_fecha_factura = ""
      if trim(rs("fecha_factura")) <> "" then str_fecha_factura = trim(Replace(rs("fecha_factura"),"/","-"))
      str_fecha_aduana = ""
      if trim(rs("fecha_aduana")) <> "" then str_fecha_aduana = trim(Replace(rs("fecha_aduana"),"/","-"))
      str_fecha_grabacion = ""
      if trim(rs("fecha_grabacion")) <> "" then str_fecha_grabacion = trim(Replace(rs("fecha_grabacion"),"/","-"))
      str_fecha_guia = ""
      if trim(rs("fecha_guia")) <> "" then str_fecha_guia = trim(Replace(rs("fecha_guia"),"/","-"))

      Pagos = rs( "Pagos" )
      if isNull( Pagos ) then Pagos = 0 end if
      NroInterno = rs( "NroInterno" )
      if isNull( NroInterno ) then NroInterno = 0 end if
      %>
    <tr align="center" id="tr_detalle_<%=fila%>" name="tr_detalle_<%=fila%>" style="height:18px;">
      <td style="width:<%=w_item%>px;" id="grid_TD_1" align="left">&nbsp;<%=rs("numero_linea")%></td>
      <td id="grid_TD_1" align="left">&nbsp;<%=rs("proveedor") & " - " & rs( "entidad_comercial" ) %></td>
      <td style="width:<%=w_tipo_factura%>px;"      id="grid_TD_1" align="left">&nbsp;<%=ObjDict_TIPOS_FACTURA.Item(trim(rs("id_tipo_factura")))%></td>
      <td style="width:<%=w_num_factura%>px;"       id="grid_TD_1" align="left">&nbsp;<%=trim(rs("numero_factura"))%></td>
      <td style="width:<%=w_num_contable%>px;"      id="grid_TD_1" align="center">&nbsp;<%=trim(rs("Numero_factura_contable"))%></td>
      <td style="width:<%=w_fecha_factura%>px;"     id="grid_TD_1" align="center"><%= FechaDDMMAA(str_fecha_factura) %></td>
      <td style="width:<%=w_NumLinFac%>px;"         id="grid_TD_1" align="center">&nbsp;<%=trim(rs("Numero_lineas_factura"))%></td>
      <% if documento_respaldo <> "Z" then %>
      <td style="width:<%=w_tipo_docto_aduana%>px;" id="grid_TD_1" align="center">&nbsp;<%=trim(rs("Tipo_documento_aduana"))%></td>
      <td style="width:<%=w_num_aduana%>px;"        id="grid_TD_1" align="center">&nbsp;<%=trim(rs("Numero_aduana"))%></td>
      <td style="width:<%=w_fecha_aduana%>px;"      id="grid_TD_1" align="center"><%= FechaDDMMAA(str_fecha_aduana) %></td>
      <td style="width:<%=w_estado%>px;"            id="grid_TD_1" align="center">&nbsp;<%=trim(rs("Estado"))%></td>
      <td style="width:<%=w_fecha_grabacion%>px;"   id="grid_TD_1" align="center">&nbsp;<%= FechaDDMMAA(str_fecha_grabacion) %></td>
      <td style="width:<%=w_fecha_guia%>px;"        id="grid_TD_1" align="center">&nbsp;<%= FechaDDMMAA(str_fecha_guia) %></td>
      <% end if %>
      <td style="width:<%=w_tipo_mon%>px;"          id="grid_TD_1" align="center"><%=trim(rs("tipo_moneda"))%></td>
      <td style="width:<%=w_monto_mon_ori%>px;"     id="grid_TD_1" align="right"><%=FormatNumber(rs("monto_moneda_origen"),2)%>&nbsp;</td>
      <td style="width:<%=w_paridad%>px;"           id="grid_TD_1" align="right"><%=FormatNumber(rs("paridad"),4)%>&nbsp;</td>
      <td style="width:<%=w_monto_fin_usd%>px;"     id="grid_TD_1" align="right"><%=FormatNumber(rs("monto_final_us$"),2)%>&nbsp;</td>

      <td style="width:<%=w_fisico%>px;"            id="grid_TD_1" align="center">&nbsp;<%=rs("Fisico")%></td>
      <td style="width:<%=w_bultos%>px;"            id="grid_TD_1" align="center">&nbsp;<%=rs("Bultos")%></td>

      <td style="width:<%=w_CBM%>px;"               id="grid_TD_1" align="center">&nbsp;<%=rs("CBM")%></td>
      <td style="width:<%=w_KG%>px;"                id="grid_TD_1" align="center">&nbsp;<%=rs("KG")%></td>

      <% if documento_respaldo = "Z" then %>
      <td style="width:<%=w_Prorrateo%>px;"             id="grid_TD_1" align="center">&nbsp;<%=rs("ProrrateoCBM")%></td>
      <td style="width:<%=w_Prorrateo%>px;"             id="grid_TD_1" align="center">&nbsp;<%=rs("ProrrateoKG")%></td>
      <td style="width:<%=w_Prorrateo%>px;"             id="grid_TD_1" align="center">&nbsp;<%=rs("ProrrateoUSD")%></td>
      <td style="width:<%=w_Prorrateo%>px;"             id="grid_TD_1" align="center">&nbsp;<%=rs("ProrrateoItems")%></td>
      <% end if %>

      <% if cDbl(Pagos) <= 1 then %>
      <td style="width:<%=w_Tipo_documento_pago%>px;"   id="grid_TD_1" align="center">&nbsp;<%=rs("Tipo_documento_pago")%></td>
      <td style="width:<%=w_Numero_documento_pago%>px;" id="grid_TD_1" align="center">&nbsp;<%=rs("Numero_documento_pago")%></td>
      <td style="width:<%=w_Fecha_documento_pago%>px;"  id="grid_TD_1" align="center">&nbsp;<%= FechaDDMMAA(rs("Fecha_documento_pago"))%></td>
      <td style="width:<%=w_Fecha_conciliacion%>px;"    id="grid_TD_1" align="center">&nbsp;<%= FechaDDMMAA(rs("Fecha_conciliacion")) %></td>
      <% else %>
      <td style="width:<%=w_Tipo_documento_pago%>px;"   id="grid_TD_1" align="center">&nbsp;</td>
      <td style="width:<%=w_Numero_documento_pago%>px;" id="grid_TD_1" align="center">&nbsp;<a href="javascript:fncMasDctos( '<% = NroInterno %>' );">mas...</a></td>
      <td style="width:<%=w_Fecha_documento_pago%>px;"  id="grid_TD_1" align="center">&nbsp;</td>
      <td style="width:<%=w_Fecha_conciliacion%>px;"    id="grid_TD_1" align="center">&nbsp;</td>
      <% end if %>
      <td style="width:<%=w_Grupo%>px;"    id="grid_TD_1" align="center"><%=rs("Grupo")%></td>
      <% if str_fecha_grabacion = "" then %>
      <td style="width:<%=w_ico%>px;"               id="grid_TD_1" align="center"><img 
      OnMouseOver="$('#tr_detalle_<%=fila%>').css('background-color','#EEEEEE');$('#tr_detalle_<%=fila%>').css('cursor','pointer');" OnMouseOut="$('#tr_detalle_<%=fila%>').css('background-color',''); $('#tr_detalle_<%=fila%>').css('cursor','default');"  
      OnClick="Cargar_Form_Ingresar_Form_Ingreso(<%=trim(rs("numero_linea"))%>);" title="Editar factura"
      src="<%=RutaProyecto%>imagenes/Ico_Glyph_Edit_16X14.png" width=16 height=14 border=0></td>
      <% else %>
      <td style="width:<%=w_ico%>px;"               id="grid_TD_1" align="center">&nbsp;</td>
      <% end if %>

      <% if cDbl(Pagos) = 0 then %>
      <td style="width:<%=w_ico%>px;"               id="grid_TD_1" align="center"><img 
      OnMouseOver="$('#tr_detalle_<%=fila%>').css('background-color','#EEEEEE');$('#tr_detalle_<%=fila%>').css('cursor','pointer');" OnMouseOut="$('#tr_detalle_<%=fila%>').css('background-color',''); $('#tr_detalle_<%=fila%>').css('cursor','default');"  
      OnClick="Eliminar_Factura(<%=trim(rs("numero_linea"))%>);" title="Eliminar factura"
      src="<%=RutaProyecto%>imagenes/Ico_Glyph_Trash_11X14.png" width=11 height=14 border=0></td>
      <% else %>
      <td style="width:<%=w_ico%>px;"               id="grid_TD_1" align="center">&nbsp;</td>
      <% end if %>
    </tr>
    <%total_monto_final_usd = cdbl(total_monto_final_usd) + cdbl(rs("monto_final_us$"))
      fila = fila + 1
      rs.MoveNext
    loop%>
    </table>
    </div>
    <div align="left" style="width: 100%; height: 26px;" id="capaTotal" name="capaTotal" >
        <table style="width: 100%;" cellpadding=0 cellspacing=0 border=0>
            <tr align="center" style="height:26px; color:#555555;">
              <!--
              <td style="font-size:12px;" xid="grid_TD_1" align="right" colspan=1 width=' 80'><b>Total Bultos:</b>&nbsp;</td>
              <td style="font-size:12px;" xid="grid_TD_1" align="left"  colspan=1 width='100'>&nbsp;100</td>

              <td style="font-size:12px;" xid="grid_TD_1" align="right" colspan=1 width=' 80'><b>Total CBM:</b>&nbsp;</td>
              <td style="font-size:12px;" xid="grid_TD_1" align="left"  colspan=1 width='100'>&nbsp;32</td>

              <td style="font-size:12px;" xid="grid_TD_1" align="right" colspan=1 width=' 80'><b>Total US$:</b>&nbsp;</td>
              <td style="font-size:12px;" xid="grid_TD_1" align="left"  colspan=1 width='100'>&nbsp;32.000</td>
              -->

              <td style="font-size:12px;" xid="grid_TD_1" align="right" colspan=1><b>Total:</b>&nbsp;</td>
              <td style="width:<%=w_monto_fin_usd + 20%>px; font-size:12px;" xid="grid_TD_1" align="right" width='100'><b><%=FormatNumber(total_monto_final_usd,2)%></b>&nbsp;</td>
            </tr>
        </table>
    </div>
    </td>
  </tr>
  </table>
<%end if%>

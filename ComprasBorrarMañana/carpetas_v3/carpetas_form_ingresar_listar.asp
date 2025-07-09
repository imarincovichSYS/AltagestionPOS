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
       "A.id_tipo_factura, A.numero_factura, A.fecha_factura, A.tipo_moneda, A.monto_moneda_origen, A.paridad, A.monto_total_us$, A.monto_final_us$, A.porcentaje_prorrateo " &_
       "from carpetas_final_detalle A " &_
       "where A.documento_respaldo='" & documento_respaldo & "' and A.anio_mes='"  &fec_anio_mes & "' and A.num_carpeta=" & num_carpeta & " " &_
       "order by A.numero_linea"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  width           = 730
  w_item          = 30
  w_tipo_factura  = 130
  w_num_factura   = 90
  w_fecha_factura = 80
  w_tipo_mon      = 50
  w_monto_mon_ori = 70
  w_paridad       = 50
  w_monto_tot_usd = 70
  w_monto_fin_usd = 70
  w_prorrateo     = 50
  w_ico           = 18
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0 bgcolor="#FFFFFF">
  <tr>
    <td>
    <div name="capaEncListaDetalle" id="capaEncListaDetalle" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="16">
      <td style="width:<%=w_item%>px; text-align:left;"             id='grid_TH_1'>&nbsp;Item</td>
      <td style="text-align:left;"                                  id='grid_TH_1'>&nbsp;Proveedor</td>
      <td style="width:<%=w_tipo_factura%>px; text-align:left;"     id='grid_TH_1'>&nbsp;Tipo factura</td>
      <td style="width:<%=w_num_factura%>px; text-align:left;"      id='grid_TH_1'>&nbsp;N° factura</td>
      <td style="width:<%=w_fecha_factura%>px; text-align:center;"  id='grid_TH_1'>&nbsp;Fecha factura</td>
      <td style="width:<%=w_tipo_mon%>px;"                          id='grid_TH_1'>Tipo<br>Mon. Ori.</td>
      <td style="width:<%=w_monto_mon_ori%>px; text-align:center;"  id='grid_TH_1'>Monto<br>Mon. Ori.</td>
      <td style="width:<%=w_paridad%>px; text-align:center;"        id='grid_TH_1'>Paridad</td>
      <!--<td style="width:<%=w_monto_tot_usd%>px; text-align:center;"  id='grid_TH_1'>Monto Total<br>US$</td>-->
      <td style="width:<%=w_monto_fin_usd%>px; text-align:right;"  id='grid_TH_1'>Monto US$&nbsp;</td>
      <!--<td style="width:<%=w_prorrateo%>px; text-align:center;"      id='grid_TH_1'>Prorrateo<br>(%)</td>-->
      <td style="width:<%=w_ico%>px; text-align:center;"            id='grid_TH_1'>&nbsp;</td>
      <td style="width:<%=w_ico%>px; text-align:center;"            id='grid_TH_1'>&nbsp;</td>
    </tr>
    </table>
    </div>
    <div align="left" id="capaListaDetalle" name="capaListaDetalle" onscroll="$('#capaEncListaDetalle').scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: 302px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    total_monto_final_usd = 0
    fila = 1
    do while not rs.EOF
      str_fecha_factura = ""
      if trim(rs("fecha_factura")) <> "" then str_fecha_factura = trim(Replace(rs("fecha_factura"),"/","-"))
      %>
    <tr align="center" id="tr_detalle_<%=fila%>" name="tr_detalle_<%=fila%>" style="height:18px;">
      <td style="width:<%=w_item%>px;" id="grid_TD_1" align="left">&nbsp;<%=rs("numero_linea")%></td>
      <td id="grid_TD_1" align="left">&nbsp;<%=rs("proveedor")%></td>
      <td style="width:<%=w_tipo_factura%>px;"  id="grid_TD_1" align="left">&nbsp;<%=ObjDict_TIPOS_FACTURA.Item(trim(rs("id_tipo_factura")))%></td>
      <td style="width:<%=w_num_factura%>px;"   id="grid_TD_1" align="left">&nbsp;<%=trim(rs("numero_factura"))%></td>
      <td style="width:<%=w_fecha_factura%>px;"   id="grid_TD_1" align="center">&nbsp;<%=str_fecha_factura%></td>
      <td style="width:<%=w_tipo_mon%>px;"      id="grid_TD_1" align="center"><%=trim(rs("tipo_moneda"))%></td>
      <td style="width:<%=w_monto_mon_ori%>px;" id="grid_TD_1" align="right"><%=FormatNumber(rs("monto_moneda_origen"),2)%>&nbsp;</td>
      <td style="width:<%=w_paridad%>px;"       id="grid_TD_1" align="right"><%=FormatNumber(rs("paridad"),2)%>&nbsp;</td>
      <!--<td style="width:<%=w_monto_tot_usd%>px;" id="grid_TD_1" align="right"><%=FormatNumber(rs("monto_total_us$"),2)%>&nbsp;</td>-->
      <td style="width:<%=w_monto_fin_usd%>px;" id="grid_TD_1" align="right"><%=FormatNumber(rs("monto_final_us$"),2)%>&nbsp;</td>
      <!--<td style="width:<%=w_prorrateo%>px;"     id="grid_TD_1" align="right"><%=FormatNumber(rs("porcentaje_prorrateo"),2)%>&nbsp;</td>-->
      <td style="width:<%=w_ico%>px;"           id="grid_TD_1" align="center"><img 
      OnMouseOver="$('#tr_detalle_<%=fila%>').css('background-color','#EEEEEE');$('#tr_detalle_<%=fila%>').css('cursor','pointer');" OnMouseOut="$('#tr_detalle_<%=fila%>').css('background-color',''); $('#tr_detalle_<%=fila%>').css('cursor','default');"  
      OnClick="Cargar_Form_Ingresar_Form_Ingreso(<%=trim(rs("numero_linea"))%>);" title="Editar factura"
      src="<%=RutaProyecto%>imagenes/Ico_Glyph_Edit_16X14.png" width=16 height=14 border=0></td>
      <td style="width:<%=w_ico%>px;"           id="grid_TD_1" align="center"><img 
      OnMouseOver="$('#tr_detalle_<%=fila%>').css('background-color','#EEEEEE');$('#tr_detalle_<%=fila%>').css('cursor','pointer');" OnMouseOut="$('#tr_detalle_<%=fila%>').css('background-color',''); $('#tr_detalle_<%=fila%>').css('cursor','default');"  
      OnClick="Eliminar_Factura(<%=trim(rs("numero_linea"))%>);" title="Eliminar factura"
      src="<%=RutaProyecto%>imagenes/Ico_Glyph_Trash_11X14.png" width=11 height=14 border=0></td>
    </tr>
    <%total_monto_final_usd = cdbl(total_monto_final_usd) + cdbl(rs("monto_final_us$"))
      fila = fila + 1
      rs.MoveNext
    loop%>
    </table>
    </div>
    <div align="left" style="width:<%=width%>; height: 26px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <tr align="center" style="height:26px; color:#555555;">
      <td style="font-size:12px;" id="grid_TD_1" align="right" colspan=7><b>Total:</b>&nbsp;</td>
      <td style="width:<%=w_monto_fin_usd%>px; font-size:12px;" id="grid_TD_1" align="right"><b><%=FormatNumber(total_monto_final_usd,2)%></b>&nbsp;</td>
      <!--<td style="width:<%=w_prorrateo + w_ico + w_ico + 2%>px;" align="right">&nbsp;</td>-->
      <td style="width:<%=w_ico + w_ico + 2%>px;" align="right">&nbsp;</td>
    </tr>
    </table>
    </div>
    </td>
  </tr>
  </table>
<%end if%>

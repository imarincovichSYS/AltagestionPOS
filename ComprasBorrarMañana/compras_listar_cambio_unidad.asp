<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%

server.ScriptTimeout      = 10000

para                      = Request.QueryString("para")
documento_no_valorizado   = Request.QueryString("documento_no_valorizado")
numero_documento_respaldo = Request.QueryString("numero_documento_respaldo")
documento_respaldo        = Request.QueryString("documento_respaldo")
proveedor                 = Request.QueryString("proveedor")
nombre_proveedor          = Unescape(Request.QueryString("nombre_proveedor"))
fecha_recepcion           = Request.QueryString("fecha_recepcion")
fecha_emision             = Request.QueryString("fecha_emision")
if fecha_recepcion <> "" then fecha_recepcion = year(fecha_recepcion) & "/" & Lpad(month(fecha_recepcion),2,0) & "/" & Lpad(day(fecha_recepcion),2,0)
paridad                   = cdbl(Request.QueryString("paridad"))
total_cif_ori             = Request.QueryString("total_cif_ori")
total_cif_adu             = Request.QueryString("total_cif_adu")
carpeta                   = Request.QueryString("carpeta")

Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=Solicitud_Cambio_Unidad_Medida_" & documento_respaldo & "-" &numero_documento_respaldo&".xls"

OpenConn
'cod_lista_base = Get_Cod_Lista_Base
cod_lista_base = "L01"

'strSQL1="select Numero_de_linea_en_RCP_o_documento_de_compra item, cantidad_mercancias cant_c, Unidad_de_medida_compra un_c, " &_
'       "Nombre_producto descripcion, Round(Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) / cantidad_mercancias,4) cif_unitario_c, " &_
'       "Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) cif_total_c, Cantidad_entrada cant_v, Unidad_de_medida_consumo un_v, " &_
'       "Round(costo_cif_adu_us$,4) cif_unitario_v from movimientos_productos " &_
'       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
'       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
'       "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and " &_
'       "Numero_documento_de_compra="&numero_documento_respaldo&" and " &_
'       "(Unidad_de_medida_compra <> Unidad_de_medida_consumo or Numero_de_linea_en_RCP_o_documento_de_compra_padre <> '') " &_
'       "order by Numero_de_linea_en_RCP_o_documento_de_compra, Numero_de_linea_en_RCP_o_documento_de_compra_padre "

strSQL1="select A.item, A.item_padre, B.cant_c, B.un_c, B.descripcion, B.descripcion_original, B.cif_unitario_c, " &_
        "B.cif_total_c, B.cant_v, B.un_v, B.cif_unitario_v from " &_
        "(" &_
        "select Numero_de_linea_en_RCP_o_documento_de_compra item, " &_
        "Numero_de_linea_en_RCP_o_documento_de_compra item_padre " &_
        "from movimientos_productos " &_
        "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
        "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
        "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and " &_
        "Numero_documento_de_compra="&numero_documento_respaldo&" and " &_
        "(Unidad_de_medida_compra <> Unidad_de_medida_consumo or " &_
        "cantidad_um_compra_en_caja_envase_compra <> cantidad_x_un_consumo) " &_
        "and Numero_de_linea_en_RCP_o_documento_de_compra_padre is null " &_
        "UNION " &_
        "select Numero_de_linea_en_RCP_o_documento_de_compra_padre item, " &_
        "Numero_de_linea_en_RCP_o_documento_de_compra item_padre " &_
        "from movimientos_productos " &_
        "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
        "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
        "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and " &_
        "Numero_documento_de_compra="&numero_documento_respaldo&" and " &_
        "Numero_de_linea_en_RCP_o_documento_de_compra_padre is not null " &_
        ")" &_
        "A, " &_
        "(select Numero_de_linea_en_RCP_o_documento_de_compra item, cantidad_mercancias cant_c, " &_
        "Unidad_de_medida_compra un_c, " &_
        "Nombre_producto descripcion, Nombre_Producto_Proveedor descripcion_original, " &_
        "Round(Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) / cantidad_mercancias,4) cif_unitario_c, " &_
        "Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) cif_total_c, Cantidad_entrada cant_v, " &_
        "Unidad_de_medida_consumo un_v, Round(costo_cif_adu_us$,4) cif_unitario_v from movimientos_productos " &_
        "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
        "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
        "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and " &_
        "Numero_documento_de_compra="&numero_documento_respaldo&") B " &_
        "where A.item_padre = B.item order by A.item, A.item_padre"

'strSQL2="select Numero_de_linea_en_RCP_o_documento_de_compra item, cantidad_mercancias cant_c, Unidad_de_medida_compra un_c, " &_
'       "Nombre_producto descripcion, Round(Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) / cantidad_mercancias,4) cif_unitario_c, " &_
'       "Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) cif_total_c, Cantidad_entrada cant_v, Unidad_de_medida_consumo un_v, " &_
'       "Round(costo_cif_adu_us$,4) cif_unitario_v from movimientos_productos " &_
'       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
'       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
'       "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and " &_
'       "Numero_documento_de_compra="&numero_documento_respaldo&" " &_
'       "order by Numero_de_linea_en_RCP_o_documento_de_compra"
'Response.Write strSQL1
'Response.End
cant_filas_x_hoja = 30 'itemes X hoja
total_filas_hoja = 45
cant_hojas = 1
set rs = Conn.Execute(strSQL1)

width = "900"

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)

sub Imprime_Encabezado_Cambio_Unidad()
  %>
  <tr height="26">
    <td rowspan="3" colspan="5" align="center" style="font-size: 16px; vertical-align:middle; border:.5pt solid windowtext;"><b>SOLICITUD DE CAMBIO DE UNIDAD DE MEDIDA</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext;">USUARIO DE ZONA FRANCA</td>
    <td colspan="2" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext; " align="center">N° AUTORIZACION ADUANA</td>
    
    <td rowspan="3" colspan="5" align="center" style="font-size: 16px; vertical-align:middle; border:.5pt solid windowtext;"><b>SOLICITUD DE CAMBIO DE UNIDAD DE MEDIDA</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext;">USUARIO DE ZONA FRANCA</td>
    <td colspan="2" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext; " align="center">N° AUTORIZACION ADUANA</td>
    
    <td rowspan="3" colspan="5" align="center" style="font-size: 16px; vertical-align:middle; border:.5pt solid windowtext;"><b>SOLICITUD DE CAMBIO DE UNIDAD DE MEDIDA</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext;">USUARIO DE ZONA FRANCA</td>
    <td colspan="2" style="border-top:.5pt solid windowtext; border-right:.5pt solid windowtext; " align="center">N° AUTORIZACION ADUANA</td>
  </tr>
  <tr height="26">
    <td></td>
    <td colspan="4" style="font-family: courier; border-right:.5pt solid windowtext;">SANCHEZ Y SANCHEZ LTDA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td></td>
    <td colspan="4" style="font-family: courier; border-right:.5pt solid windowtext;">SANCHEZ Y SANCHEZ LTDA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td></td>
    <td colspan="4" style="font-family: courier; border-right:.5pt solid windowtext;">SANCHEZ Y SANCHEZ LTDA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
  </tr>
  <tr height="26">
    <td style="border-bottom:.5pt solid windowtext;">DIRECCION&nbsp;&nbsp;</td>
    <td colspan="4" style="font-family: courier; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td style="border-bottom:.5pt solid windowtext;">DIRECCION&nbsp;&nbsp;</td>
    <td colspan="4" style="font-family: courier; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td style="border-bottom:.5pt solid windowtext;">DIRECCION&nbsp;&nbsp;</td>
    <td colspan="4" style="font-family: courier; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
  </tr>
  <tr height="25" align="center" style="font-family: courier">
    <td colspan="4" style="font-size: 13px; mso-number-format:'@'; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><%=documento_respaldo%>-<%=numero_documento_respaldo%>&nbsp;<%=fecha_emision%></td>
    <td style="font-size: 15px; border-right:.5pt solid windowtext;">DOLAR U.S.A.</td>
    <td colspan="2" style="font-size: 15px; border-right:.5pt solid windowtext;">96.620.660-8</td>
    <td colspan="3" style="font-size: 15px; border-right:.5pt solid windowtext;">T-217&nbsp;&nbsp;21.07.17</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td colspan="4" style="font-size: 13px; mso-number-format:'@'; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><%=documento_respaldo%>-<%=numero_documento_respaldo%>&nbsp;<%=fecha_emision%></td>
    <td style="font-size: 15px; border-right:.5pt solid windowtext;">DOLAR U.S.A.</td>
    <td colspan="2" style="font-size: 15px; border-right:.5pt solid windowtext;">96.620.660-8</td>
    <td colspan="3" style="font-size: 15px; border-right:.5pt solid windowtext;">T-217&nbsp;&nbsp;21.07.17</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
    
    <td colspan="4" style="font-size: 13px; mso-number-format:'@'; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><%=documento_respaldo%>-<%=numero_documento_respaldo%>&nbsp;<%=fecha_emision%></td>
    <td style="font-size: 15px; border-right:.5pt solid windowtext;">DOLAR U.S.A.</td>
    <td colspan="2" style="font-size: 15px; border-right:.5pt solid windowtext;">96.620.660-8</td>
    <td colspan="3" style="font-size: 15px; border-right:.5pt solid windowtext;">T-217&nbsp;&nbsp;21.07.17</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2"></td>
  </tr>
  <tr height="25" align="center">
    <td colspan="4" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">TIPO, NUMERO Y FECHA DOC. DE INGRESO</td>
    <td style="border-right:.5pt solid windowtext;">MONEDA DE VALORACION</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">R.U.T.</td>
    <td style="border-right:.5pt solid windowtext;" colspan="3">N° Y FECHA DE CONTRATO</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">FECHA, FIRMA Y TIMBRE</td>
    
    <td colspan="4" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">TIPO, NUMERO Y FECHA DOC. DE INGRESO</td>
    <td style="border-right:.5pt solid windowtext;">MONEDA DE VALORACION</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">R.U.T.</td>
    <td style="border-right:.5pt solid windowtext;" colspan="3">N° Y FECHA DE CONTRATO</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">FECHA, FIRMA Y TIMBRE</td>
    
    <td colspan="4" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">TIPO, NUMERO Y FECHA DOC. DE INGRESO</td>
    <td style="border-right:.5pt solid windowtext;">MONEDA DE VALORACION</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">R.U.T.</td>
    <td style="border-right:.5pt solid windowtext;" colspan="3">N° Y FECHA DE CONTRATO</td>
    <td style="border-right:.5pt solid windowtext;" colspan="2">FECHA, FIRMA Y TIMBRE</td>
  </tr>
  <tr height="30" style="font-size: 16px;" align="center">
    <td colspan="7" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Antecedentes Documentos de Ingreso</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Cambio Solicitado</b></td>
    
    <td colspan="7" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Antecedentes Documentos de Ingreso</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Cambio Solicitado</b></td>
    
    <td colspan="7" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Antecedentes Documentos de Ingreso</b></td>
    <td colspan="5" style="border-top:.5pt solid windowtext; border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"><b>Cambio Solicitado</b></td>
  </tr>
  <%ancho_tabla=1500%>
  <tr height="2">
    <td width="30" style="border-left:.5pt solid windowtext; ">&nbsp;</td><!--  1 -->
    <td width="76">&nbsp;</td><!--  2 -->
    <td width="46">&nbsp;</td><!--  3 -->
    <td width="126">&nbsp;</td><!-- 4 -->
    <td width="230">&nbsp;</td><!-- 5 -->
    <td width="80">&nbsp;</td><!--  6 -->
    <td width="90">&nbsp;</td><!--  7 -->
    <td width="76">&nbsp;</td><!--  8 -->
    <td width="46">&nbsp;</td><!--  9 -->
    <td width="130">&nbsp;</td><!--10 -->
    <td width="230">&nbsp;</td><!--11 -->
    <td width="70" style="border-right:.5pt solid windowtext;">&nbsp;</td><!-- 12 -->
    
    <td width="30" style="border-left:.5pt solid windowtext; ">&nbsp;</td><!--  1 -->
    <td width="76">&nbsp;</td><!--  2 -->
    <td width="46">&nbsp;</td><!--  3 -->
    <td width="126">&nbsp;</td><!-- 4 -->
    <td width="230">&nbsp;</td><!-- 5 -->
    <td width="80">&nbsp;</td><!--  6 -->
    <td width="90">&nbsp;</td><!--  7 -->
    <td width="76">&nbsp;</td><!--  8 -->
    <td width="46">&nbsp;</td><!--  9 -->
    <td width="130">&nbsp;</td><!--10 -->
    <td width="230">&nbsp;</td><!--11 -->
    <td width="70" style="border-right:.5pt solid windowtext;">&nbsp;</td><!-- 12 -->
    
    <td width="30" style="border-left:.5pt solid windowtext; ">&nbsp;</td><!--  1 -->
    <td width="76">&nbsp;</td><!--  2 -->
    <td width="46">&nbsp;</td><!--  3 -->
    <td width="126">&nbsp;</td><!-- 4 -->
    <td width="230">&nbsp;</td><!-- 5 -->
    <td width="80">&nbsp;</td><!--  6 -->
    <td width="90">&nbsp;</td><!--  7 -->
    <td width="76">&nbsp;</td><!--  8 -->
    <td width="46">&nbsp;</td><!--  9 -->
    <td width="130">&nbsp;</td><!--10 -->
    <td width="230">&nbsp;</td><!--11 -->
    <td width="70" style="border-right:.5pt solid windowtext;">&nbsp;</td><!-- 12 -->
  </tr>
  <tr height="38" align="center" style="font-size: 10px; vertical-align:middle;">
    <td style="border:.5pt solid windowtext;">ITEM</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
    <td style="border:.5pt solid windowtext;">CIF TOTAL</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
    
    <td style="border:.5pt solid windowtext;">ITEM</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
    <td style="border:.5pt solid windowtext;">CIF TOTAL</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
    
    <td style="border:.5pt solid windowtext;">ITEM</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
    <td style="border:.5pt solid windowtext;">CIF TOTAL</td>
    <td style="border:.5pt solid windowtext;">CANTIDAD DE MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">UNIDAD MEDIDA</td>
    <td colspan="2" style="border:.5pt solid windowtext;">DESCRIPCION MERCANCIAS</td>
    <td style="border:.5pt solid windowtext;">CIF UNITARIO</td>
  </tr>
  <%
end sub

sub Imprime_Pie_De_Pagina_Cambio_Unidad()
%>
  <tr height="15" style="font-size:10px;">
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">Declaro que el cambio solicitado ampara la totalidad de</td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">Declaro que el cambio solicitado ampara la totalidad de</td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">Declaro que el cambio solicitado ampara la totalidad de</td>
  </tr>
  <tr height="15" style="font-size:10px;">
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">las mercancias existentes en en el(los) ítem(s) señalado(s).</td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">las mercancias existentes en en el(los) ítem(s) señalado(s).</td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="7" style="border-right:.5pt solid windowtext;">las mercancias existentes en en el(los) ítem(s) señalado(s).</td>
  </tr>
  <tr height="26" style="font-size:16px; font-family: courier; vertical-align:middle;">
    <td colspan="5" align="center" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td colspan="7" style="border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" align="center" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td colspan="7" style="border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" align="center" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;">MANZANA 7 ZONA FRANCA</td>
    <td colspan="7" style="border-right:.5pt solid windowtext;"></td>
  </tr>
  <tr height="26" style="font-size:16px; font-family: courier; vertical-align:top;">
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="2"></td>
    <td colspan="4" style="border-bottom:.5pt solid windowtext;" align="center"><!--MANUEL HERNANDEZ A.--></td>
    <td style="border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="2"></td>
    <td colspan="4" style="border-bottom:.5pt solid windowtext;" align="center"><!--MANUEL HERNANDEZ A.--></td>
    <td style="border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    <td colspan="2"></td>
    <td colspan="4" style="border-bottom:.5pt solid windowtext;" align="center"><!--MANUEL HERNANDEZ A.--></td>
    <td style="border-right:.5pt solid windowtext;"></td>
  </tr>
  <tr height="18" style="font-size:10px;">
    <td colspan="5" style="border-left:.5pt solid windowtext; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">UBICACION DE LAS MERCANCIAS</td>
    <td colspan="2" style="border-bottom:.5pt solid windowtext;"></td>
    <td colspan="4" align="center" style="border-bottom:.5pt solid windowtext; vertical-align:top;">NOMBRE Y FIRMA USUARIO O REPRESENTANTE LEGAL</td>
    <td style="border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">UBICACION DE LAS MERCANCIAS</td>
    <td colspan="2" style="border-bottom:.5pt solid windowtext;"></td>
    <td colspan="4" align="center" style="border-bottom:.5pt solid windowtext; vertical-align:top;">NOMBRE Y FIRMA USUARIO O REPRESENTANTE LEGAL</td>
    <td style="border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
    
    <td colspan="5" style="border-left:.5pt solid windowtext; border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;">UBICACION DE LAS MERCANCIAS</td>
    <td colspan="2" style="border-bottom:.5pt solid windowtext;"></td>
    <td colspan="4" align="center" style="border-bottom:.5pt solid windowtext; vertical-align:top;">NOMBRE Y FIRMA USUARIO O REPRESENTANTE LEGAL</td>
    <td style="border-bottom:.5pt solid windowtext; border-right:.5pt solid windowtext;"></td>
  </tr>
  <tr height="25" style="font-size:12px; vertical-align:middle;">
    <td colspan="12" align="center">ORIGINAL - ADUANA SEC. Z.FRANCA</td>
    
    <td colspan="12" align="center">1a. COPIA - Sociedad Administradora</td>
    
    <td colspan="12" align="center">2a. COPIA - Usuario</td>
  </tr>
  <tr height="5"><td></td></tr>
<%
end sub

sub Imprime_TD_en_Blanco()
%>
  <tr height="18" style="font-size: 10px; font-family: courier; vertical-align:middle;">
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
    <td colspan="2" style="border:.5pt solid windowtext;"></td>
    <td style="border:.5pt solid windowtext;"></td>
  </tr>
<%
end sub
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
	{margin:.1in 0in 0in 1.1in;
	mso-header-margin:0in;
	mso-footer-margin:0in;
	mso-page-orientation:landscape;}
-->
</style>
</head>

<%

sub Get_Totales_Compra_Sub_Itemes(v_documento_no_valorizado, v_tipo_documento_de_compra, v_fecha_mov, v_numero_documento_de_compra, v_num_linea_padre)
  strSQL="select IsNull(sum(Round(Round(Cantidad_entrada * Costo_CIF_ADU_US$,2) / cantidad_mercancias,4)),0) total_cif_unitario, " &_
         "IsNull(sum(Round(Cantidad_entrada * Costo_CIF_ADU_US$,2)),0) total_cif_total " &_
         "from movimientos_productos where empresa='SYS' and documento_no_valorizado='"&v_documento_no_valorizado&"' and " &_
         "Tipo_documento_de_compra='"&v_tipo_documento_de_compra&"' and convert(varchar(12),fecha_movimiento,111)='"&v_fecha_mov&"' and " &_
         "Numero_documento_de_compra="&v_numero_documento_de_compra&" and Numero_de_linea_en_RCP_o_documento_de_compra_padre="&v_num_linea_padre
  set v_rs = Conn.Execute(strSQL)
  if not v_rs.EOF then 
    v_total_cif_unitario  = v_rs("total_cif_unitario") 
    v_total_cif_total     = v_rs("total_cif_total") 
  end if
end sub
%>

<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">
<table width="<%=ancho_tabla%>" border=0 cellpadding=0 cellspacing=0">
<%fila = 1
do while not rs.EOF
  if fila = 1 then Imprime_Encabezado_Cambio_Unidad
  
  item            = rs("item")
  item_padre      = rs("item_padre")
  r_item            = Lpad(item,3,0)
  
  cant_c          = rs("cant_c")
  un_c            = rs("un_c")
  descripcion_ori = trim(rs("descripcion_original"))
  if descripcion_ori = "0" then descripcion_ori = ""
  descripcion     = trim(rs("descripcion"))
  cif_unitario_c  = rs("cif_unitario_c")
  cif_total_c     = rs("cif_total_c")
  
  
  r_cant_c          = cant_c
  r_un_c            = un_c
  r_cif_unitario_c  = cif_unitario_c
  r_cif_total_c     = cif_total_c
  
  cant_v          = rs("cant_v")
  un_v            = rs("un_v")
  cif_unitario_v  = rs("cif_unitario_v")
  
  if item <> item_padre then 
    r_item            = ""
    r_cant_c          = ""
    r_un_c            = ""
    r_cif_unitario_c  = ""
    r_cif_total_c     = ""
  else
    v_total_cif_unitario = 0 : v_total_cif_total = 0
    Get_Totales_Compra_Sub_Itemes documento_no_valorizado, documento_respaldo, fecha_recepcion, numero_documento_respaldo, item_padre
    r_cif_unitario_c  = cdbl(r_cif_unitario_c)  + cdbl(v_total_cif_unitario)
    r_cif_total_c     = cdbl(r_cif_total_c)     + cdbl(v_total_cif_total)
  end if
  %>
  <tr height="18" style="font-size: 10px; font-family: courier; vertical-align:middle;">
    <td align="center" style="mso-number-format:'@'" style="border:.5pt solid windowtext;"><%=r_item%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cant_c%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=r_un_c%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion_ori%></td>
    <td align="right" class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=r_cif_unitario_c%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cif_total_c%></td>
    <td align="right" class="FormatNumber_0" style="border:.5pt solid windowtext;"><%=cant_v%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=un_v%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion%></td>
    <td class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=cif_unitario_v%></td>
    
    <td align="center" style="mso-number-format:'@'" style="border:.5pt solid windowtext;"><%=r_item%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cant_c%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=r_un_c%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion_ori%></td>
    <td align="right" class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=r_cif_unitario_c%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cif_total_c%></td>
    <td align="right" class="FormatNumber_0" style="border:.5pt solid windowtext;"><%=cant_v%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=un_v%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion%></td>
    <td class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=cif_unitario_v%></td>
    
    <td align="center" style="mso-number-format:'@'" style="border:.5pt solid windowtext;"><%=r_item%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cant_c%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=r_un_c%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion_ori%></td>
    <td align="right" class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=r_cif_unitario_c%></td>
    <td align="right" class="FormatNumber_2" style="border:.5pt solid windowtext;"><%=r_cif_total_c%></td>
    <td align="right" class="FormatNumber_0" style="border:.5pt solid windowtext;"><%=cant_v%></td>
    <td align="center" style="border:.5pt solid windowtext;"><%=un_v%></td>
    <td colspan="2" style="font-size:9px; border:.5pt solid windowtext;"><%=descripcion%></td>
    <td class="FormatNumber_4" style="border:.5pt solid windowtext;"><%=cif_unitario_v%></td>
  </tr>
<%fila = fila + 1
  if fila > cant_filas_x_hoja then 
    fila = 1
    cant_hojas = cant_hojas + 1
    Imprime_Pie_De_Pagina_Cambio_Unidad
  end if
  rs.MoveNext
loop
for i=fila  to cant_filas_x_hoja
  Imprime_TD_en_Blanco
next
Imprime_Pie_De_Pagina_Cambio_Unidad
%>
</table>
<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>Solicitud_Cambio_Unidad_Medida</x:Name>
    <x:WorksheetOptions>
     <x:DefaultColWidth>10</x:DefaultColWidth>
     <x:Print>
      <x:ValidPrinterInfo/>
      <x:PaperSizeIndex>5</x:PaperSizeIndex>
      <x:Scale>92</x:Scale>
      <x:HorizontalResolution>120</x:HorizontalResolution>
      <x:VerticalResolution>72</x:VerticalResolution>
     </x:Print>
     <!--<x:ShowPageBreakZoom/> --> <!-- Muestra los número de página de Excel -->
     <x:PageBreakZoom>100</x:PageBreakZoom>
     <x:Selected/>
     <x:DoNotDisplayGridlines/>
     <x:Panes>
      <x:Pane>
       <x:Number>3</x:Number>
       <!--<x:ActiveRow>19</x:ActiveRow>-->
       <!--<x:ActiveCol>3</x:ActiveCol>-->
      </x:Pane>
     </x:Panes>
     <x:ProtectContents>False</x:ProtectContents>
     <x:ProtectObjects>False</x:ProtectObjects>
     <x:ProtectScenarios>False</x:ProtectScenarios>
    </x:WorksheetOptions>
    <!--<x:PageBreaks>
     <x:RowBreaks>
      <x:RowBreak>
       <x:Row>22</x:Row>
      </x:RowBreak>
     </x:RowBreaks>
    </x:PageBreaks>-->
   </x:ExcelWorksheet>
  </x:ExcelWorksheets>
  <x:WindowHeight>9210</x:WindowHeight>
  <x:WindowWidth>19995</x:WindowWidth>
  <x:WindowTopX>240</x:WindowTopX>
  <x:WindowTopY>60</x:WindowTopY>
  <x:ProtectStructure>False</x:ProtectStructure>
  <x:ProtectWindows>False</x:ProtectWindows>
 </x:ExcelWorkbook>
 <x:ExcelName>
  <x:Name>Print_Area</x:Name>
  <x:SheetIndex>1</x:SheetIndex>
  <x:Formula>='Solicitud_Cambio_Unidad_Medida'!$A$1:$AJ$<%=cant_hojas * total_filas_hoja%></x:Formula>
 </x:ExcelName>
</xml><![endif]-->
</body>
</html>

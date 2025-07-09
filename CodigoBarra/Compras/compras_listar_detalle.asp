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
Response.AddHeader "Content-Disposition", "attachment; filename=Documento_Compra_" & documento_respaldo & "-" &numero_documento_respaldo&".xls"

OpenConn
'cod_lista_base = Get_Cod_Lista_Base
cod_lista_base = "L01"
if documento_no_valorizado="RCP" then
  strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, A.producto, B.nombre, B.Unidad_de_medida_compra, B.Unidad_de_medida_consumo, " &_
         "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, " &_
         "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, C.valor_unitario precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
         "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
         "D.Codigo_postal prov, A.Cubicaje cubicaje, " &_
         "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
         "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(B.anterior_precio_de_lista,0) Precio_ant " &_
         "from " &_
         "(select distinct(producto) producto, Proveedor, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, " &_
         "Costo_CPA_US$, IsNUll(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cubicaje = (Alto*Ancho*largo) " &_
         "from movimientos_productos where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(producto) producto, nombre, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
         "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
         "Temporada, anterior_costo_CIF_ADU_US$, anterior_costo_CIF_ORI_US$, anterior_costo_CPA_US$, " &_
         "Anterior_Delta_CPA_US$, anterior_precio_de_lista " &_
         "from productos where empresa='SYS') B, " &_
         "(select producto, valor_unitario from productos_en_listas_de_precios " &_
         "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_
         "(select entidad_comercial, Codigo_postal from entidades_comerciales where empresa='SYS' and " &_
         "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
         "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
         "order by Numero_de_linea_en_RCP_o_documento_de_compra"
else 'TCP
  strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, A.producto, B.nombre, B.Unidad_de_medida_compra, B.Unidad_de_medida_consumo, " &_
         "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, " &_
         "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, A.Precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
         "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
         "D.Codigo_postal prov, '0' prom, A.Cubicaje cubicaje, " &_
         "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
         "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(B.anterior_precio_de_lista,0) Precio_ant " &_
         " from " &_
         "(select distinct(producto) producto, Proveedor, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, " &_
         "Costo_CPA_US$, IsNull(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Round(Precio_de_lista_modificado,0) Precio, Cubicaje = (Alto*Ancho*largo) " &_
         "from movimientos_productos with (nolock) where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(producto) producto, nombre, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
         "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
         "Temporada, ultimo_costo_cif_adu_us$ anterior_costo_CIF_ADU_US$, ultimo_costo_cif_ori_us$ anterior_costo_CIF_ORI_US$, ultimo_costo_CPA_US$ anterior_costo_CPA_US$, " &_
         "delta_cpa_us$ Anterior_Delta_CPA_US$, anterior_precio_de_lista " &_
         "from productos where empresa='SYS') B, " &_
         "(select entidad_comercial, Codigo_postal from entidades_comerciales where empresa='SYS' and " &_
         "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
         "where A.producto=B.producto and A.proveedor=D.entidad_comercial " &_
         "order by Numero_de_linea_en_RCP_o_documento_de_compra"
end if
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
width = "900"

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)
%>
<html>
<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">
<head>
<title>Informe Documento Compra <%=documento_respaldo%>-<%=numero_documento_respaldo%></title>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<style>
<!--table
@page
	{margin:0.6in .0in .0in 0in;
	mso-header-margin:0in;
	mso-footer-margin:0in;}
-->
</style>
<%
'@media print {
'@page rotated {size: landscape} 
'TABLE {page: rotated} 
'@page
'	{margin:.10in .0in .10in 0in;
'	mso-header-margin:0in;
'	mso-footer-margin:0in;}
'}
%>
</head>
<table border=0 cellpadding=0 cellspacing=0 width=700>
<tr><td></td></tr>
<tr height="14"><td 
<%if para="" then%>
  colspan="27" 
<%else%>
  colspan="13" 
<%end if%>align="center" style="font-size: 10px;"><b>INFORME DOCUMENTO DE COMPRA</b></td></tr>
<tr height="12"><td align="center" style="font-size: 8px;"
<%if para="" then%>
  colspan="27"
<%else%>
  colspan="13"
<%end if%>>
<%if documento_no_valorizado="TCP" then%>
  [TCP]
<%end if%>
</td></tr>
<tr height="14" id="texto_9">
  <td colspan="2">Documento</td>
  <td><b><%=documento_respaldo%>-<%=numero_documento_respaldo%></b></td>
  <td colspan="3">Fecha Recepción</td>
  <td colspan="2" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_recepcion)%></b></td>
  <%if para="" then%>
  <td></td>
  <td colspan="2">Fecha Emisión</td>
  <td colspan="3" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_emision)%></b></td>
  <%end if%>
</tr>
<%if para="" then%>
<tr height="14" id="texto_9">
  <td colspan="2">Proveedor</td>
  <td colspan="7"><b><%=proveedor%>&nbsp;&nbsp;<%=nombre_proveedor%></b></td>
  <td colspan="2" align="Left">Carpeta</td>
  <td colspan="3"><b><%=carpeta%></b></td>
</tr>
<tr height="14" id="texto_9">
  <td colspan="2">Paridad</td>
  <td align="left" class="FormatNumber_2"><b><%=paridad%></b></td>
  <td colspan="3">Total Cif. Ori.</td>
  <td colspan="3" align="left"><b><%=total_cif_ori%></b></td>
  <td colspan="2">Total Cif. Adu.</td>
  <td colspan="3" align="left"><b><%=total_cif_adu%></b></td>
</tr>
<%end if%>
<tr height="12" id="texto_9">
  <%if para="" then%>
  <td colspan="2"></td>
  <td></td>
  <td colspan="3"></td>
  <td colspan="2"></td>
  <%end if%>
  <td 
  <%if para="" then%>
    colspan="20" 
  <%else%>
    colspan="13" 
  <%end if%>
  align="right" id="texto_8"><b><%=replace(fecha_hoy,"-","/")%></b> - <b><%=hora%></b></td>
</tr>
</table>
<table border=0 cellpadding=0 cellspacing=0">
<tr id="inf_TD_FS_8" align="center">
  <td width=10 style="width:10pt;">N°</td>
  <td width=52 style="width:52pt;">PROD</td>
  <td width=80 style="width:80pt;">DESCRIPCION</td>
  <td width=20 style="width:20pt;">UNC</td>
  <td width=15 style="width:15pt;">UN</td>
  <td width=20 style="width:20pt;">CANT</td>
  <%if para="" then%>
    <td width=20 style="width:20pt;" align="right">C.ORI</td>
    <td width=20 style="width:20pt;" align="right">C.ADU</td>
    <td width=20 style="width:20pt;" align="right">T.C.ADU</td>
    <td width=20 style="width:20pt;" align="right">CPA</td>
    <td width=18 style="width:18pt;" align="right">&Delta;CPA</td>
    <td width=20 style="width:20pt;" align="right">PRECIO</td>
    <td width=20 style="width:20pt;" align="right">MG</td>
    <td width=30 style="width:30pt;">PROV</td>
    <td width=20 style="width:20pt;">TMP</td>
    <td width=16 style="width:16pt;" align="right">ILA</td>
    <td width=25 style="width:19pt;" align="right">P_V</td>
    <td width=28 style="width:28pt;" align="right">PROM</td>
    <td width=24 style="width:24pt;" align="right">MGPROM</td>
    <td width=20 style="width:20pt;" align="right">PLIQ</td>
    <td width=20 style="width:20pt;" align="right">MGLIQ</td>
    <td width=20 style="width:20pt;" align="right">STK</td>
    <td width=24 style="width:24pt;" align="right">C.ADU.A</td>
    <td width=24 style="width:24pt;" align="right">CPA.A</td>
    <td width=18 style="width:18pt;" align="right">&Delta;CPA.A</td>
    <td width=22 style="width:22pt;" align="right">PRE.A</td>
    <td width=22 style="width:22pt;" align="right">MG.A</td>
    <td width=18 style="width:18pt;" align="right">D.CPA</td>
  <%else 'Hoja para bodega%>
    <td style="width:30pt;" align="right">BM7</td>
    <td style="width:30pt;" align="right">M7</td>
    <td style="width:30pt;" align="right">JUG</td>
    <td style="width:30pt;" align="right">M146</td>
    <td style="width:30pt;" align="right">L27</td>
    <td style="width:30pt;" align="right">L238</td>
    <td style="width:30pt;" align="right">L26</td>
  <%end if%>
</tr>
<%v_total_final_adu = 0
fecha_hoy_prom = year(date()) & "/" & Lpad(month(date()),2,0) & "/" & Lpad(day(date()),2,0)
paridad_mg = cdbl(GetParidad_Para_Margen)
TasaImpAdu = cdbl(Get_Tasa_Impuesto_Aduanero)/100
do while not rs.EOF
  v_total_final_ori = cdbl(v_total_final_ori) + Round(cdbl(rs("Cantidad_entrada")) * cdbl(rs("cif_ori")),2)
  v_total_final_adu = cdbl(v_total_final_adu) + Round(cdbl(rs("total_adu")),2)
  
  cif_ori   = cdbl(rs("cif_ori"))
  cif_adu   = cdbl(rs("cif_adu"))
  total_adu = cdbl(rs("total_adu"))
  cpa       = cdbl(rs("cpa"))
  cubicaje  = cdbl(rs("cubicaje"))
  delta_cpa = cdbl(rs("delta_cpa"))
  precio    = cdbl(rs("precio"))
  
  ila       = cdbl(rs("ila"))
  grs       = cdbl(rs("grs"))
  cc        = cdbl(rs("cc"))
     
  rel_1     = precio/paridad_mg - cif_ori * TasaImpAdu
  rel_ila   = 1 + ila/100
  rel_1_sobre_ila = rel_1 / rel_ila
  if ila = 0 then
    rel_2 = rel_1            - (cpa + delta_cpa)
    mg    = Round(rel_2 / rel_1           * 100,2)
  else
    rel_2 = rel_1_sobre_ila  - (cpa + delta_cpa)
    mg    = Round(rel_2 / rel_1_sobre_ila * 100,2)
  end if
  p_v = 0
  if grs  <> 0  then p_v = grs
  if cc   <> 0  then p_v = cc
  
  'Anterior
  cif_ori_ant   = cdbl(rs("cif_ori_ant"))
  cif_adu_ant   = cdbl(rs("cif_adu_ant"))
  cpa_ant       = cdbl(rs("cpa_ant"))
  delta_cpa_ant = cdbl(rs("delta_cpa_ant"))
  precio_ant    = cdbl(rs("precio_ant"))
  
  mg_ant = 0
  if precio_ant = 999999 then precio_ant = 0
  if precio_ant <> 0 then
    rel_1     = precio_ant/paridad_mg - cif_ori_ant * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2 = rel_1            - (cpa_ant + delta_cpa_ant)
      mg_ant    = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2 = rel_1_sobre_ila  - (cpa_ant + delta_cpa_ant)
      mg_ant    = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  if documento_no_valorizado="TCP" then  
    strSQL = "select E1.monto_descuento from " &_
             "(select producto, monto_descuento, promocion " &_
             "from productos_en_promociones where empresa='SYS'and producto='"&trim(rs("producto"))&"') E1, " &_
             "(select promocion from promociones where fecha_termino > '"&fecha_hoy_prom&"') E2 " &_
             "where E1.promocion = E2.promocion "
    set rs_prom = Conn.Execute(strSQL) : prom = 0
    if not rs_prom.EOF then prom = cdbl(rs_prom("monto_descuento"))
  end if
  
  mg_prom = 0
  if prom <> 0 then
    rel_1     = prom/paridad_mg - cif_ori * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2   = rel_1            - (cpa + delta_cpa)
      mg_prom = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2   = rel_1_sobre_ila  - (cpa + delta_cpa)
      mg_prom = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  strSQL = "select IsNull(valor_unitario,0) pliq from productos_en_listas_de_precios " &_
           "where empresa='SYS' and producto='"&trim(rs("producto"))&"' and " &_
           "lista_de_precios = 'L02'"
  set rs_liq = Conn.Execute(strSQL) : pliq = 0
  if not rs_liq.EOF then pliq = cdbl(rs_liq("pliq"))
  
  mg_liq = 0
  if pliq <> 0 then
    rel_1     = pliq/paridad_mg - cif_ori * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2   = rel_1            - (cpa + delta_cpa)
      mg_liq = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2   = rel_1_sobre_ila  - (cpa + delta_cpa)
      mg_liq = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  'Calcular Stock
  strSQL = "select IsNull(sum(stock_real),0) stock from productos_en_bodegas where empresa='SYS' and producto='"&trim(rs("producto"))&"'"
  set rs_stock = Conn.Execute(strSQL) : stock = 0
  if not rs_stock.EOF then stock = rs_stock("stock")
  %>
<tr id="inf_TD_FS_8" align="center" align="center">
  <td><%=rs("Numero_de_linea_en_RCP_o_documento_de_compra")%></td>
  <td><%=trim(rs("producto"))%></td>
  <td align="left" wrap><%=left(trim(rs("nombre")),50)%></td>
  <td><%=rs("Unidad_de_medida_compra")%></td>
  <td><%=rs("Unidad_de_medida_consumo")%></td>
  <td align="right"><%=FormatNumber(rs("Cantidad_entrada"),0)%></td>
  <%if para="" then%>
  <td align="right" class="FormatNumber_4"><%=cif_ori%></td>
  <td align="right" class="FormatNumber_4"><%=cif_adu%></td>
  <td align="right" class="FormatNumber_2"><%=total_adu%></td>
  <td align="right" class="FormatNumber_4"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(cpa) end if else response.write(cpa)end if%></td>
  <!--<td align="right" class="FormatNumber_4"><%=cpa%></td>-->
  <td align="right" class="FormatNumber_2"><%=delta_cpa%></td>
  <td align="right"><%=FormatNumber(precio,0)%></td>
  <td align="right" class="FormatNumber_2"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(FormatNUmber(mg,2)) end if else response.write(FormatNUmber(mg,2)) end if%></td>
  <td align="left">&nbsp;&nbsp;<%=Left(trim(rs("prov")),5)%></td>
  <td align="left"><%=trim(rs("temporada"))%></td>
  <td align="right"><%=rs("ila")%></td>
  <td align="right"><%=p_v%></td>
  <td align="right"><%=FormatNumber(prom,0)%></td>
  <td align="right" class="FormatNumber_2"><%=mg_prom%></td>
  <td align="right"><%=FormatNumber(pliq,0)%></td>
  <td align="right" class="FormatNumber_2"><%=mg_liq%></td>
  <td align="right"><%=FormatNumber(stock,0)%></td>
  <td align="right" class="FormatNumber_4"><%=cif_adu_ant%></td>
  <td align="right" class="FormatNumber_4"><%=cpa_ant%></td>
  <td align="right" class="FormatNumber_2"><%=delta_cpa_ant%></td>
  <td align="right"><%=FormatNumber(precio_ant,0)%></td>
  <td align="right" class="FormatNumber_2"><%=FormatNUmber(mg_ant,2)%></td>
  <td align="right" class="FormatNumber_2"><%if (FormatNumber(cpa - cpa_ant,0) = 0 or FormatNumber(precio,0)=999999) then response.write(" ") else response.write(FormatNumber(cpa - cpa_ant,0)) end if%></td>
  <%else 'Hoja para Bodega%>
    <%
    BM7   = FormatNumber(Get_Stock_En_Bodega("0010", trim(rs("producto")) ),0)
    M7    = FormatNumber(Get_Stock_En_Bodega("0011", trim(rs("producto")) ),0)
    JUG   = FormatNumber(Get_Stock_En_Bodega("0002", trim(rs("producto")) ),0)
    M146  = FormatNumber(Get_Stock_En_Bodega("0004", trim(rs("producto")) ),0)
    L27   = FormatNumber(Get_Stock_En_Bodega("0005", trim(rs("producto")) ),0)
    L238  = FormatNumber(Get_Stock_En_Bodega("0008", trim(rs("producto")) ),0)
    L26   = FormatNumber(Get_Stock_En_Bodega("0009", trim(rs("producto")) ),0)
    
    if M7   = 0 then M7   = "-"
    if JUG  = 0 then JUG  = "-"
    if M146 = 0 then M146 = "-"
    if L27  = 0 then L27  = "-"
    if L238 = 0 then L238 = "-"
    if BM7  = 0 then BM7  = "-"
    if L26  = 0 then L26  = "-"
    %>
    <td align="right"><%=BM7%></td>
    <td align="right"><%=M7%></td>
    <td align="right"><%=JUG%></td>
    <td align="right"><%=M146%></td>
    <td align="right"><%=L27%></td>
    <td align="right"><%=L238%></td>
    <td align="right"><%=L26%></td>
  <%end if%>
</tr>
<%fila = fila + 1
  rs.MoveNext
loop%>
<%if para="" then%>
<tr id="inf_TD_FS_8">
  <td colspan="5">&nbsp;</td>
  <td colspan="2" align="right"><b><%=FormatNumber(v_total_final_ori,2)%></b></td>
  <td colspan="2" align="right"><b><%=FormatNumber(v_total_final_adu,2)%></b></td>
  <td colspan="7">&nbsp;</td>
</tr>
<%end if%>
</table>
</body>
</html>

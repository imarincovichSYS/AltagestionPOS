<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
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
         "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
         "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre " &_
         "from " &_
         "(select distinct(producto) producto, Proveedor, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, " &_
         "Costo_CPA_US$, IsNUll(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, Cubicaje = (Alto*Ancho*largo), " &_ 
         "Round(Precio_de_lista,0) Precio_ant, Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0) " &_
         "from movimientos_productos where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(producto) producto, nombre, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
         "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
         "Temporada, anterior_costo_CIF_ADU_US$, anterior_costo_CIF_ORI_US$, anterior_costo_CPA_US$, " &_
         "Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm " &_
         "from productos where empresa='SYS') B, " &_
         "(select producto, valor_unitario from productos_en_listas_de_precios " &_
         "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_
         "(select entidad_comercial, Codigo_postal from entidades_comerciales where empresa='SYS' and " &_
         "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
         "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
         "order by Numero_de_linea_en_RCP_o_documento_de_compra"
else 'TCP
  strSQL="select A.Numero_de_linea_en_RCP_o_documento_de_compra, A.producto, B.nombre, A.Unidad_de_medida_compra, A.Unidad_de_medida_consumo, " &_
         "A.Cantidad_entrada, A.Costo_CIF_ORI_US$ cif_ori, A.Costo_CIF_ADU_US$ cif_adu, (A.Cantidad_entrada*A.Costo_CIF_ADU_US$) total_adu, " &_
         "A.Costo_CPA_US$ cpa, A.Delta_CPA_US$ delta_cpa, A.precio precio, IsNull(B.porcentaje_impuesto_1,0) ila, " &_
         "IsNull(B.Unidad_de_medida_venta_peso_en_grs,0) grs, IsNull(B.Unidad_de_medida_venta_volumen_en_cc,0) cc, " &_
         "D.Codigo_postal prov, '0' prom, A.Cubicaje cubicaje, " &_
         "B.temporada temporada,  IsNull(B.Anterior_Costo_CIF_ORI_US$,0) cif_ori_ant, IsNull(B.Anterior_Costo_CIF_ADU_US$,0) cif_adu_ant, " &_
         "IsNull(B.Anterior_Costo_CPA_US$,0) cpa_ant, IsNull(B.Anterior_Delta_CPA_US$,0) delta_cpa_ant, IsNull(A.Precio_ant,0) Precio_ant, " &_
         "isnull(b.sma,0) sma, isnull(b.smm,0) smm, Numero_de_linea_en_RCP_o_documento_de_compra_padre " &_         
         " from " &_
         "(select distinct(producto) producto, Proveedor, Unidad_de_medida_compra, Unidad_de_medida_consumo, Numero_de_linea_en_RCP_o_documento_de_compra, Costo_CIF_ORI_US$, Costo_CIF_ADU_US$, " &_
         "Costo_CPA_US$, IsNull(Delta_CPA_US$,0) Delta_CPA_US$, Cantidad_entrada, Monto_impuesto_ILA_US$, " &_
         "Round(Precio_de_lista_modificado,0) Precio, Round(Precio_de_lista,0) Precio_ant,Cubicaje = (Alto*Ancho*largo), Numero_de_linea_en_RCP_o_documento_de_compra_padre = isnull(Numero_de_linea_en_RCP_o_documento_de_compra_padre,0) " &_
         "from movimientos_productos where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
         "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
         "convert(varchar(12),fecha_movimiento,111)='"&fecha_recepcion&"' and Numero_documento_de_compra="&numero_documento_respaldo&") A, " &_
         "(select distinct(producto) producto, nombre, Unidad_de_medida_compra, Unidad_de_medida_consumo, " &_
         "Unidad_de_medida_venta_peso_en_grs, Unidad_de_medida_venta_volumen_en_cc, porcentaje_impuesto_1, " &_
         "Temporada, ultimo_costo_cif_adu_us$ anterior_costo_CIF_ADU_US$, ultimo_costo_cif_ori_us$ anterior_costo_CIF_ORI_US$, ultimo_costo_CPA_US$ anterior_costo_CPA_US$, " &_
         "delta_cpa_us$ Anterior_Delta_CPA_US$, anterior_precio_de_lista, stock_minimo sma, stock_minimo_manual smm  " &_
         "from productos where empresa='SYS') B, " &_         
         "(select producto, valor_unitario from productos_en_listas_de_precios " &_
         "where empresa='SYS' and Lista_de_precios='"&cod_lista_base&"') C, " &_         
         "(select entidad_comercial, Codigo_postal from entidades_comerciales where empresa='SYS' and " &_
         "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial='P') ) D " &_
         "where A.producto=B.producto and B.producto=C.producto and A.proveedor=D.entidad_comercial " &_
         "order by Numero_de_linea_en_RCP_o_documento_de_compra"
end if
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
width = "900"

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)
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
	{
<%if para = "" then%>
	margin:.4in 0in 0in 1.1in;
<%else%>
  margin:0in 0in 0in 0in;
<%end if%>
	mso-header-margin:0in;
	mso-footer-margin:0in;
	<%if para = "" then%>
	mso-page-orientation:landscape;
	<%end if%>}
-->
</style>
</head>
<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">
<table width=1500 border=0 cellpadding=0 cellspacing=0>
<tr><td></td></tr>
<tr height="14"><td 
<%if para="" then%>
  colspan="28" 
<%else%>
  colspan="13" 
<%end if%>align="center" style="font-size: 10px;"><b>INFORME DOCUMENTO DE COMPRA</b></td></tr>
<tr height="12"><td align="center" style="font-size: 8px;"
<%if para="" then%>
  colspan="28"
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
  <td colspan="4">Fecha Recepción</td>
  <td colspan="2" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_recepcion)%></b></td>
  <%if para="" then%>
  <td></td>
  <td colspan="3">Fecha Emisión</td>
  <td colspan="2" align="left" style="mso-number-format:'@'"><b><%=cdate(fecha_emision)%></b></td>
  <%end if%>
</tr>
<%if para="" then%>
<tr height="14" id="texto_9">
  <td colspan="2">Proveedor</td>
  <td colspan="8"><b><%=proveedor%>&nbsp;&nbsp;<%=nombre_proveedor%></b></td>
  <td colspan="3" align="Left">Carpeta</td>
  <td colspan="3"><b><%=carpeta%></b></td>
</tr>
<tr height="14" id="texto_9">
  <td colspan="2">Paridad</td>
  <td align="left" class="FormatNumber_2"><b><%=paridad%></b></td>
  <td colspan="4">Total Cif. Ori.</td>
  <td colspan="3" align="left"><b><%=FormatNumber(total_cif_ori,2)%></b></td>
  <td colspan="3">Total Cif. Adu.</td>
  <td colspan="3" align="left"><b><%=FormatNumber(total_cif_adu,2)%></b></td>
</tr>
<%end if%>
<tr height="12" id="texto_9">
  <td 
  <%if para="" then%>
    colspan="29" 
  <%else%>
    colspan="13" 
  <%end if%>
  align="right" id="texto_8"><b><%=replace(fecha_hoy,"-","/")%></b> - <b><%=hora%></b></td>
</tr>
<tr id="inf_TD_FS_8" align="center">
  <td width="20">N°</td>
  <td width="58">PRODUCTO</td>
  <td width="240">DESCRIPCION</td>
  <td width="24">UNC</td>
  <td width="24">UN</td>
  <td width="30">CANT</td>
  <%if para="" then%>
    <td width="40" align="right">C.ORI</td>
    <td width="40" align="right">C.ADU</td>
    <td width="44" align="right">T.C.ADU</td>
    <td width="42" align="right">CPA</td>
    <td width="34" align="right">&Delta;CPA</td>
    <td width="42" align="right">PRECIO</td>
    <td width="30" align="right">MG</td>
    <td width="44" align="right">C.ADU.A</td>
    <td width="40" align="right">CPA.A</td>
    <td width="36" align="right">&Delta;CPA.A</td>
    <td width="36" align="right">PRE.A</td>
    <td width="28" align="right">MG.A</td>
    <td width="30" align="right">D.CPA</td>
    <td width="26" align="right">STK</td>    
    <td width="40" align="right">PROM</td>
    <td width="32" align="right">MG.P</td>
    <td width="26" align="right">PLIQ</td>
    <td width="26" align="right">MG.L</td>
    <td width="38">PROV</td>
    <td width="28">TMP</td>
    <td width="18" align="right">ILA</td>
    <td width="22" align="right">P_V</td>
    <td width="23" align="Left">St.M</td>
  <%else 'Hoja para bodega%>
    <td width="36" align="right">BM7</td>
    <td width="36" align="right">M7</td>
    <td width="36" align="right">JUG</td>
    <td width="36" align="right">M146</td>
    <td width="36" align="right">L27</td>
    <td width="36" align="right">L238</td>
    <td width="36" align="right">L26</td>
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
  if rs("Numero_de_linea_en_RCP_o_documento_de_compra_padre") = 0 then
    item = rs("Numero_de_linea_en_RCP_o_documento_de_compra")
  else
    item = rs("Numero_de_linea_en_RCP_o_documento_de_compra_padre")
  end if
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
  
  if documento_no_valorizado="RCP" or documento_no_valorizado="TCP" then  
    strSQL = "select E1.monto_descuento from " &_
             "(select producto, monto_descuento, promocion " &_
             "from productos_en_promociones where empresa='SYS' and producto='"&trim(rs("producto"))&"') E1, " &_
             "(select promocion from promociones where fecha_termino > '"&fecha_hoy_prom&"') E2 " &_
             "where E1.promocion = E2.promocion "
    set rs_prom = Conn.Execute(strSQL) : prom = 0
    if not rs_prom.EOF then prom = cdbl(rs_prom("monto_descuento"))
  end if
  
  mg_prom = 0
  if prom <> 0 then
    rel_1     = (precio-prom)/paridad_mg - cif_ori * TasaImpAdu
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
  '''''''''''''''''''''''' pancho ''''''''''''''''''''''''
    if mg_ant = 0 then
    rel_1     = precio/paridad_mg - cif_ori_ant * TasaImpAdu
    rel_ila   = 1 + ila/100
    rel_1_sobre_ila = rel_1 / rel_ila
    if ila = 0 then
      rel_2 = rel_1            - (cpa_ant + delta_cpa_ant)
      mg_ant2    = Round(rel_2 / rel_1           * 100,2)
    else
      rel_2 = rel_1_sobre_ila  - (cpa_ant + delta_cpa_ant)
      mg_ant2    = Round(rel_2 / rel_1_sobre_ila * 100,2)
    end if
  end if
  
  
  'Calcular Stock
  
  stock = 0
  strSQL = "select IsNull(sum(stock_real),0) stock from productos_en_bodegas where empresa='SYS' and producto='"&trim(rs("producto"))&"'"
  set rs_stock = Conn.Execute(strSQL)
  if not rs_stock.EOF then stock = cdbl(rs_stock("stock"))
  
  'Calcula si tiene ventas
  fecha_inicial = cdate(cdate(fecha_recepcion) - 10) 'ESTO ES PARA CALCULAR SI TIENE VENTAS EN LOS ULTIMOS 10 DIAS 
  fecha_inicial = year(fecha_inicial) & "/" & Lpad(month(fecha_inicial),2,0) & "/" & Lpad(day(fecha_inicial),2,0)
  
  ventas = "#FFFFFF"
  strSQL_ventas = "select producto from movimientos_productos where empresa='SYS' and documento_no_valorizado='DVT' " &_
                " and convert(varchar(12),fecha_movimiento,111) between '"&fecha_inicial&"' and '"&fecha_recepcion&"' and producto='"&trim(rs("producto"))&"'"
  set rs_ventas = Conn.Execute(strSQL_ventas) 
  if rs_ventas.EOF then
    if documento_no_valorizado="TCP" then  
        if stock > 0 then 
          ventas = "#CCCCCC"
        end if
    else
        if cdbl(stock) - cdbl(rs("Cantidad_entrada")) > 0 then 
          ventas = "#CCCCCC"
        end if          
    end if
  end if
  
  'Stock Minimo
  stock_pintar = "#FFFFFF"
  if cdbl(rs("smm")) = 0 then
    smin = rs("sma")    
  else
    stock_pintar = "#CCCCCC"
    smin = rs("smm")
  end if
  
  %>
<tr id="inf_TD_FS_9" align="center" align="center">
  
  <td><%=item%></td>
  <td align="left"><%=trim(rs("producto"))%></td>
  <td align="left" wrap style="font-size:8px;"><%=left(trim(rs("nombre")),50)%></td>
  <td style="font-size:8px;"><%=rs("Unidad_de_medida_compra")%></td>
  <td style="font-size:8px;"><%=rs("Unidad_de_medida_consumo")%></td>
  <td align="right"><%=FormatNumber(rs("Cantidad_entrada"),0)%></td>
  <%if para="" then%>
  <td align="right" class="FormatNumber_4"><%=cif_ori%></td>
  <td align="right" class="FormatNumber_4"><%=cif_adu%></td>
  <td align="right" class="FormatNumber_2"><%=total_adu%></td>
  <td align="right" class="FormatNumber_4"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(cpa) end if else response.write(cpa)end if%></td>
  <!--<td align="right" class="FormatNumber_4"><%=cpa%></td>-->
  <td align="right" class="FormatNumber_2"><%if delta_cpa=0 then Response.Write " " else Response.Write delta_cpa end if%></td>
  <td align="right"><%=FormatNumber(precio,0)%></td>
  <td align="right" class="FormatNumber_2"><%if documento_respaldo ="R" then if cubicaje = 0 then response.write(" ") else response.write(FormatNUmber(mg,2)) end if else response.write(FormatNUmber(mg,2)) end if%></td>
  <td align="right" class="FormatNumber_4" style="font-size:8px;"><%if cif_adu_ant=0 then response.write(" ") else response.write(FormatNUmber(cif_adu_ant,4)) end if%></td>
  <td align="right" class="FormatNumber_4" style="font-size:8px;"><%if cpa_ant=0 then response.write(" ") else response.write(FormatNUmber(cpa_ant,4)) end if%></td>
  <td align="right" class="FormatNumber_2" style="font-size:8px;"><%if (delta_cpa_ant = 0 and cpa_ant=0) then response.write(" ") else response.write(FormatNUmber(delta_cpa_ant,4)) end if%></td>
  <td align="right" style="font-size:8px;"><%if (FormatNumber(precio_ant,0) = 0 and cpa_ant=0) then response.write(" ") else if FormatNumber(precio_ant,0) = 0 then response.write(FormatNUmber(precio,0)) else response.write(FormatNUmber(precio_ant,0)) end if%></td>
  <td align="right" class="FormatNumber_2" style="font-size:8px;"><%if (FormatNUmber(mg_ant,2) = 0 and cpa_ant=0) then response.write(" ") else if FormatNUmber(mg_ant,2) = 0 then response.write(FormatNUmber(mg_ant2,2)) else  response.write(FormatNUmber(mg_ant,2)) end if%></td>
  <td align="right" style="font-size:8px;" class="FormatNumber_2"><%if (FormatNumber(cpa - cpa_ant,0) = 0 or FormatNumber(precio,0)=999999 or FormatNumber(cpa_ant,0)=0) then response.write(" ") else response.write(FormatNumber(cpa - cpa_ant,2)) end if%></td>
  <td bgcolor="<%=ventas%>" align="right" style="font-size:8px;"><%=FormatNumber(stock,0)%></td>  
  <td align="right"><%if FormatNumber(prom,0) <> 0 then response.write(FormatNumber(precio - prom,0)) else response.write(" ") end if%></td>
  <td align="right" class="FormatNumber_2"><% if mg_prom<>0 then response.write(mg_prom) else response.write(" ") end if%></td>
  <!--<td align="right"><%'=FormatNumber(pliq,0)%></td>-->
  <td align="right"><%=" "%></td>  
  <!--<td align="right" class="FormatNumber_2"><%'=mg_liq%></td>-->
  <td align="right" class="FormatNumber_2"><%=" "%></td>
  <td align="left" style="font-size:8px;"><%=Left(trim(rs("prov")),5)%></td>
  <td align="left" style="font-size:8px;"><%=trim(rs("temporada"))%></td>
  <td align="right"><%if cdbl(rs("ila")) = 0 then Response.Write " " else Response.Write rs("ila") end if%></td>
  <td align="right"><%if p_v = 0 then Response.Write " " else Response.Write p_v end if%></td>
  <td bgcolor="<%=stock_pintar%>" align="right"><%=formatNumber(smin,0)%></td>
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
<tr id="inf_TD_FS_9">
  <td colspan="5">&nbsp;</td>
  <td colspan="2" align="right"><b><%=FormatNumber(v_total_final_ori,2)%></b></td>
  <td colspan="2" align="right"><b><%=FormatNumber(v_total_final_adu,2)%></b></td>
  <td colspan="19">&nbsp;</td>
</tr>
<%end if%>
</table>
<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>Documento_Compra</x:Name>
    <x:WorksheetOptions>
     <x:DefaultColWidth>10</x:DefaultColWidth>
     <x:Print>
      <x:ValidPrinterInfo/>
      <%if para <> "" then
          tipo_hoja=14
        else
          tipo_hoja=5
        end if
      %>
      <x:PaperSizeIndex><%=tipo_hoja%></x:PaperSizeIndex>
      <x:Scale>100</x:Scale>
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
  <%
  col_rango_final = "AC"
  if para <> "" then 
    fila = fila - 1
    col_rango_final = "M"
  end if
  %>
  <x:Formula>='Documento_Compra'!$A$1:$<%=col_rango_final%>$<%=(fila+9)%></x:Formula>
 </x:ExcelName>
</xml><![endif]-->
</body>
</html>

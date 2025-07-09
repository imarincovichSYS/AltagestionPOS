<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

busqueda_aprox            = Request.Form("busqueda_aprox")
documento_respaldo        = Request.Form("documento_respaldo")
anio                      = Request.Form("anio")
mes                       = Request.Form("mes")
numero_documento_respaldo = Request.Form("numero_documento_respaldo")
check_TCP                 = Request.Form("check_TCP")
check_RCP                 = Request.Form("check_RCP")
campo_order_by            = Request.Form("campo_order_by")
vista                     = Request.Form("vista")

if campo_order_by = "" then campo_order_by = "A.Fecha_recepcion"
strAscDesc = ""
if campo_order_by = "A.Fecha_recepcion" then strAscDesc = " desc "

if numero_documento_respaldo <> "" then 
  strWhere = " and (numero_documento_respaldo="&numero_documento_respaldo&" or numero_factura = "&numero_documento_respaldo&") "
  if busqueda_aprox = "1" then strWhere = " and (numero_documento_respaldo like '%"&numero_documento_respaldo&"%' or numero_factura like '%"&numero_documento_respaldo&"%') "
end if  

if vista = "PEDIDO" then strWhere = strWhere & " and tipo_oc='P' "

strWhere_Doc_No_Valorizado = ""
if (check_TCP = "false" and check_RCP = "false") or (check_TCP = "true" and check_RCP = "true") then
  strWhere_Doc_No_Valorizado = "documento_no_valorizado='TCP' or documento_no_valorizado='RCP'"
else
  if check_TCP = "true" then 
    strWhere_Doc_No_Valorizado = "documento_no_valorizado='TCP'"
  end if
  
  if check_RCP = "true" then 
    if strWhere_Doc_No_Valorizado <> "" then
      strWhere_Doc_No_Valorizado = strWhere_Doc_No_Valorizado & " or documento_no_valorizado='RCP'"
    else
      strWhere_Doc_No_Valorizado = "documento_no_valorizado='RCP'"
    end if
  end if
end if 

strWhereBusquedaFecha = " year(fecha_recepcion) = "&anio
if mes <> "" then strWhereBusquedaFecha = " year(fecha_recepcion) = "&anio&" and month(fecha_recepcion) = "&mes

strWhere_Doc_No_Valorizado = " (" & strWhere_Doc_No_Valorizado & ") "
OpenConn
'on error resume next
set ObjDict_PROVEEDOR = Server.CreateObject("Scripting.Dictionary")
'Cargar_Diccionario ObjDict_PROVEEDOR,"select distinct(Entidad_comercial) value, Apellidos_persona_o_nombre_empresa text from entidades_comerciales where Entidad_comercial is not null and Entidad_comercial <>'' order by value"
'OJO, existen registros repetidos de NOMBRES DE ENTIDA COMERCIAL (valor en el diccionario no se puede repetir)
'Cargar_Diccionario ObjDict_PROVEEDOR,"select top 10 producto value, valor_unitario text from productos_en_listas_de_precios where empresa='SYS' order by value"
paridad_margen = cdbl(GetParidad_Para_Margen)
'strSQL = "select A.documento_no_valorizado, A.Numero_documento_respaldo, " &_
'         "A.Proveedor, A.Proveedor_2, A.Fecha_emision, A.Fecha_recepcion, " &_
'         "A.numero_factura, A.fecha_factura, IsNull(A.Monto_neto_US$,0) total_cif_ori, " &_
'         "IsNull(A.Monto_adu_US$,0) total_cif_adu, " &_
'         "A.Monto_total_moneda_oficial total_peso, A.Paridad_conversion_a_dolar, " &_
'         "A.Bodega, A.Numero_interno_documento_no_valorizado, A.Numero_documento_no_valorizado, " &_
'         "B.nombre_proveedor, A.carpeta , A.tipo_oc, A.bultos, B.codigo_postal codigo_postal from  " &_
'         "(select documento_no_valorizado, numero_documento_no_valorizado, Numero_documento_respaldo, " &_
'         "Proveedor, Proveedor_2, Fecha_emision, Fecha_recepcion, Numero_factura, Fecha_factura, Monto_neto_US$, Monto_adu_US$, " &_
'         "Monto_total_moneda_oficial, Paridad_conversion_a_dolar, " &_
'         "Bodega, Numero_interno_documento_no_valorizado, carpeta, tipo_oc, IsNull(bultos,0) as bultos  " &_
'         "from documentos_no_valorizados where empresa='SYS' and "&strWhereBusquedaFecha&" and " &_
'         "documento_respaldo='"&documento_respaldo&"' and "&strWhere_Doc_No_Valorizado&" " & strWhere & " ) A, " &_
'         "(select distinct(entidad_comercial) proveedor, " &_
'         "Apellidos_persona_o_nombre_empresa nombre_proveedor, codigo_postal " &_
'         "from entidades_comerciales where empresa='SYS' and Entidad_comercial is not null and codigo_postal is not null) B " &_
'         "where A.proveedor*=B.proveedor order by " & campo_order_by & " " & strAscDesc'

'Modificación: Cmartinez 20160822, Nueva sinntaxis LEFT OUTER JOIN por actualización a SQL Server 2008
strSQL = "select A.documento_no_valorizado, A.Numero_documento_respaldo, " &_
         "A.Proveedor, A.Proveedor_2, A.Fecha_emision, A.Fecha_recepcion, " &_
         "A.numero_factura, A.fecha_factura, IsNull(A.Monto_neto_US$,0) total_cif_ori, " &_
         "IsNull(A.Monto_adu_US$,0) total_cif_adu, IsNull(A.total_ex_fab,0) as total_ex_fab, " &_
         "A.Monto_total_moneda_oficial total_peso, A.Paridad_conversion_a_dolar, " &_
         "A.Bodega, A.Numero_interno_documento_no_valorizado, A.Numero_documento_no_valorizado, " &_
         "B.nombre_proveedor, A.carpeta , A.tipo_oc, A.bultos, B.codigo_postal codigo_postal from  " &_
         "(select documento_no_valorizado, numero_documento_no_valorizado, Numero_documento_respaldo, " &_
         "Proveedor, Proveedor_2, Fecha_emision, Fecha_recepcion, Numero_factura, Fecha_factura, Monto_neto_US$, Monto_adu_US$, total_ex_fab, " &_
         "Monto_total_moneda_oficial, Paridad_conversion_a_dolar, " &_
         "Bodega, Numero_interno_documento_no_valorizado, carpeta, tipo_oc, IsNull(bultos,0) as bultos  " &_
         "from documentos_no_valorizados where empresa='SYS' and "&strWhereBusquedaFecha&" and " &_
         "documento_respaldo='"&documento_respaldo&"' and "&strWhere_Doc_No_Valorizado&" " & strWhere & " ) A " &_
         "LEFT OUTER JOIN " &_
         "(select distinct(entidad_comercial) proveedor, " &_
         "Apellidos_persona_o_nombre_empresa nombre_proveedor, codigo_postal " &_
         "from entidades_comerciales where empresa='SYS' and Entidad_comercial is not null and codigo_postal is not null) B " &_
         "ON A.proveedor=B.proveedor order by " & campo_order_by & " " & strAscDesc
		 
'"Right( '00000000' + Rtrim(Ltrim(Proveedor)),8) Proveedor, Proveedor_2, Fecha_emision, " &_
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  width           = "1240"
  height          = 564
  w_radio         = 25
  w_t_doc         = 50
  w_num_doc       = 70
  w_num_factura   = 70
  w_rut           = 80
  w_sigla         = 80
  w_proveedor     = 340
  w_fec_recep     = 80
  w_usd           = 50
  w_total_adu_usd = 110
  w_total         = 90
  w_bultos        = 60
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0>
  <tr>
    <td>
    <div name="capaEncListaCompra" id="capaEncListaCompra" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" style="height: 20px;">
      <td style="width:<%=w_radio%>px;" id='grid_TH_1'>&nbsp;</td>
      <td style="width:<%=w_t_doc%>px;" id='grid_TH_1'>T. DOC.</td>
      <td title="Ordenar por n° documento" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='pointer';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Numero_documento_respaldo')" 
      style="width:<%=w_num_doc%>px;" id='grid_TH_1'>N° DOC.</td>
      <td style="width:<%=w_num_factura%>px;" id='grid_TH_1'>N° FACT.</td>
      <td title="Ordenar por rut" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='pointer';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Proveedor')" 
      style="width:<%=w_rut%>px;" id='grid_TH_1'>RUT</td>
      <td style="width:<%=w_sigla%>px;" id='grid_TH_1'>SIGLA</td>
      <td title="Ordenar por nombre proveedor" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='pointer';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'B.nombre_proveedor')" 
      style="width:<%=w_proveedor%>px;" id='grid_TH_1'>PROVEEDOR</td>
      <td title="Ordenar por fecha de recepción" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='pointer';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Fecha_recepcion')" 
      style="width:<%=w_fec_recep%>px;" id='grid_TH_1'>FEC. RECEP.</td>
      <td style="width:<%=w_usd%>px;" id='grid_TH_1'>US$</td>
      <td style="width:<%=w_total_adu_usd%>px;" id='grid_TH_1'>TOTAL ADU US$</td>
      <td style="width:<%=w_total%>px;" id='grid_TH_1'>TOTAL</td>
      <td style="width:<%=w_bultos%>px;" id='grid_TH_1'>BULTOS</td>
      <td title="Ordenar por Carpeta"
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='pointer';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Carpeta')" id='grid_TH_1'>CARPETA</td>
    </tr>
    </table>
    </div>
    <div align="left" name="capaListaCompra" onscroll="capaEncListaCompra.scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: <%=height%>px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    fila = 0
    do while not rs.EOF
      'Proveedor = "" : Proveedor_2 = ""
      'if not IsNull(rs("Proveedor"))    then Proveedor    = Lpad(trim(rs("Proveedor")),8,0)
      'if not IsNull(rs("Proveedor_2"))  then Proveedor_2  = Lpad(trim(rs("Proveedor_2")),8,0)
      'nombre_proveedor  = PROVEEDOR.Item(trim(rs("Proveedor")))
      color_bg_bulto = ""
      if cdbl(rs("bultos")) = 0 then color_bg_bulto = "#FF0000"
    %>
    <tr 
    OnDblClick="Editar_Compra()"
    Onclick="Set_Opciones_Compra(<%=fila%>);"
    OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='pointer'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id="tr_compras_<%=fila%>" name="tr_compras_<%=fila%>">
      <td style="width:20px;" id="grid_TD_1"><input 
      anio                                    = "<%=anio%>"
      numero_interno_documento_no_valorizado  = "<%=rs("Numero_interno_documento_no_valorizado")%>"
      documento_no_valorizado                 = "<%=rs("documento_no_valorizado")%>"
      numero_documento_no_valorizado          = "<%=rs("numero_documento_no_valorizado")%>"  
      numero_documento_respaldo               = "<%=rs("Numero_documento_respaldo")%>" 
      documento_respaldo                      = "<%=documento_respaldo%>"
      proveedor                               = "<%=trim(rs("Proveedor"))%>"
      proveedor_2                             = "<%=trim(rs("Proveedor_2"))%>"
      nombre_proveedor                        = "<%=Ucase(trim(rs("Nombre_Proveedor")))%>"
      codigo_postal                           = "<%=trim(rs("codigo_postal"))%>"
      fecha_emision                           = "<%=rs("Fecha_emision")%>"
      fecha_recepcion                         = "<%=rs("fecha_recepcion")%>"
      numero_factura                          = "<%=rs("numero_factura")%>"
      fecha_factura                           = "<%=rs("fecha_factura")%>"
      paridad                                 = "<%=Replace(FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2)),",",".")%>"
      paridad_margen                          = "<%=paridad_margen%>"
      total_cif_ori                           = "<%=FormatNumber(Round(rs("total_cif_ori"),2))%>"
      total_cif_adu                           = "<%=FormatNumber(Round(rs("total_cif_adu"),2))%>"
      total_ex_fab                            = "<%=FormatNumber(Round(rs("total_ex_fab"),2))%>"
      bodega                                  = "<%=trim(rs("bodega"))%>"
      carpeta                                 = "<%=trim(rs("carpeta"))%>"
      tipo_oc                                 = "<%=trim(rs("tipo_oc"))%>"
      bultos                                  = "<%=trim(rs("bultos"))%>"
      
      class="grid_RADIOBOX" id="radio_compras" name="radio_compras" type="radio" 
      style="width:<%=w_radio%>px;"></input></td>
      <td style="width:<%=w_t_doc%>px;" id="grid_TD_1"><%=rs("documento_no_valorizado")%></td>
      <td style="width:<%=w_num_doc%>px;" id="grid_TD_1"><%=rs("Numero_documento_respaldo")%></td>
      <td style="width:<%=w_num_factura%>px;" id="grid_TD_1"><%=rs("numero_factura")%>&nbsp;</td>
      <td style="width:<%=w_rut%>px;" id="grid_TD_1">&nbsp;<%=trim(rs("Proveedor"))%></td>
      <td style="width:<%=w_sigla%>px;" id="grid_TD_1" align="left">&nbsp;<%=trim(rs("codigo_postal"))%></td>      
      <td style="width:<%=w_proveedor%>px;" id="grid_TD_1" align="left">&nbsp;<%=Ucase(trim(rs("Nombre_Proveedor")))%>&nbsp;</td>
      <td style="width:<%=w_fec_recep%>px;" id="grid_TD_1"><%=rs("Fecha_recepcion")%></td>
      <td style="width:<%=w_usd%>px;" id="grid_TD_1" align="right"><%=Replace(FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2)),",",".")%>&nbsp;</td>
      <td style="width:<%=w_total_adu_usd%>px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("total_cif_adu"),2))%>&nbsp;</td>
      <td style="width:<%=w_total%>px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("total_peso"),0),0)%>&nbsp;</td>
      <td style="width:<%=w_bultos%>px;" id="grid_TD_1" align="right" bgcolor="<%=color_bg_bulto%>"><%=FormatNumber(rs("bultos"),0)%>&nbsp;</td>
      <td id="grid_TD_1" align="left">&nbsp;<%=rs("carpeta")%></td>
    </tr>
    <%fila = fila + 1
      rs.MoveNext
    loop%>
    </table>
    </div>
    </td>
  </tr>
  </table>
<%end if%>

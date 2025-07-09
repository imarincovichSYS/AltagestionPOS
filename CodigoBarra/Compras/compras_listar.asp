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

if campo_order_by = "" then campo_order_by = "A.Fecha_recepcion"
strAscDesc = ""
if campo_order_by = "A.Fecha_recepcion" then strAscDesc = " desc "

if numero_documento_respaldo <> "" then 
  strWhere = " and numero_documento_respaldo="&numero_documento_respaldo&" "
  if busqueda_aprox = "1" then strWhere = " and numero_documento_respaldo like '%"&numero_documento_respaldo&"%' "
end if  

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
strWhere_Doc_No_Valorizado = " (" & strWhere_Doc_No_Valorizado & ") "
OpenConn
'on error resume next
set ObjDict_PROVEEDOR = Server.CreateObject("Scripting.Dictionary")
'Cargar_Diccionario ObjDict_PROVEEDOR,"select distinct(Entidad_comercial) value, Apellidos_persona_o_nombre_empresa text from entidades_comerciales where Entidad_comercial is not null and Entidad_comercial <>'' order by value"
'OJO, existen registros repetidos de NOMBRES DE ENTIDA COMERCIAL (valor en el diccionario no se puede repetir)
'Cargar_Diccionario ObjDict_PROVEEDOR,"select top 10 producto value, valor_unitario text from productos_en_listas_de_precios where empresa='SYS' order by value"
paridad_margen = cdbl(GetParidad_Para_Margen)
strSQL = "select A.documento_no_valorizado, A.Numero_documento_respaldo, " &_
         "A.Proveedor, A.Proveedor_2, A.Fecha_emision, A.Fecha_recepcion, " &_
         "A.numero_factura, A.fecha_factura, IsNull(A.Monto_neto_US$,0) total_cif_ori, " &_
         "IsNull(A.Monto_adu_US$,0) total_cif_adu, " &_
         "A.Monto_total_moneda_oficial total_peso, A.Paridad_conversion_a_dolar, " &_
         "A.Bodega, A.Numero_interno_documento_no_valorizado, A.Numero_documento_no_valorizado, " &_
         "B.nombre_proveedor, A.carpeta from  " &_
         "(select documento_no_valorizado, numero_documento_no_valorizado, Numero_documento_respaldo, " &_
         "Proveedor, Proveedor_2, Fecha_emision, Fecha_recepcion, Numero_factura, Fecha_factura, Monto_neto_US$, Monto_adu_US$, " &_
         "Monto_total_moneda_oficial, Paridad_conversion_a_dolar, " &_
         "Bodega, Numero_interno_documento_no_valorizado, carpeta  " &_
         "from documentos_no_valorizados where empresa='SYS' and " &_
         "year(fecha_recepcion) = "&anio&" and month(fecha_recepcion) = "&mes&" and " &_
         "documento_respaldo='"&documento_respaldo&"' and "&strWhere_Doc_No_Valorizado&" " & strWhere & " ) A, " &_
         "(select distinct(entidad_comercial) proveedor, " &_
         "Apellidos_persona_o_nombre_empresa nombre_proveedor " &_
         "from entidades_comerciales where empresa='SYS' and Entidad_comercial is not null and codigo_postal is not null) B " &_
         "where A.proveedor*=B.proveedor order by " & campo_order_by & " " & strAscDesc
'"Right( '00000000' + Rtrim(Ltrim(Proveedor)),8) Proveedor, Proveedor_2, Fecha_emision, " &_
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  width = "970"
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0>
  <tr>
    <td>
    <div name="capaEncListaCompra" id="capaEncListaCompra" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="20">
      <td style="width:15px;" id='grid_TH_1'>&nbsp;</td>
      <td style="width:60px;" id='grid_TH_1'>TIPO DOC.</td>
      <td title="Ordenar por n° documento" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Numero_documento_respaldo')" style="width:80px;" id='grid_TH_1'>N° DOC.</td>
      <td title="Ordenar por rut" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Proveedor')" style="width:90px;" id='grid_TH_1'>RUT</td>
      <td title="Ordenar por nombre proveedor" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'B.nombre_proveedor')" style="width:300px;" id='grid_TH_1'>PROVEEDOR</td>
      <td title="Ordenar por fecha de recepción" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Compras(true,1,'A.Fecha_recepcion')" style="width:100px;" id='grid_TH_1'>FEC. RECEPCION</td>
      <td style="width:60px;" id='grid_TH_1'>US$</td>
      <td style="width:90px;" id='grid_TH_1'>TOTAL ADU US$</td>
      <td style="width:70px;" id='grid_TH_1'>TOTAL</td>
      <td id='grid_TH_1'>CARPETA</td>
    </tr>
    </table>
    </div>
    <div align="left" name="capaListaCompra" onscroll="capaEncListaCompra.scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: 406px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    fila = 0
    do while not rs.EOF
      'Proveedor = "" : Proveedor_2 = ""
      'if not IsNull(rs("Proveedor"))    then Proveedor    = Lpad(trim(rs("Proveedor")),8,0)
      'if not IsNull(rs("Proveedor_2"))  then Proveedor_2  = Lpad(trim(rs("Proveedor_2")),8,0)
      'nombre_proveedor  = PROVEEDOR.Item(trim(rs("Proveedor")))
    %>
    <tr 
    OnDblClick="Editar_Compra()"
    Onclick="Set_Opciones_Compra(<%=fila%>);"
    OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='hand'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id="tr_compras_<%=fila%>" name="tr_compras_<%=fila%>">
      <td style="width:15px;" id="grid_TD_1"><input 
      anio                                    = "<%=anio%>"
      numero_interno_documento_no_valorizado  = "<%=rs("Numero_interno_documento_no_valorizado")%>"
      documento_no_valorizado                 = "<%=rs("documento_no_valorizado")%>"
      numero_documento_no_valorizado          = "<%=rs("numero_documento_no_valorizado")%>"  
      numero_documento_respaldo               = "<%=rs("Numero_documento_respaldo")%>" 
      documento_respaldo                      = "<%=documento_respaldo%>"
      proveedor                               = "<%=trim(rs("Proveedor"))%>"
      proveedor_2                             = "<%=trim(rs("Proveedor_2"))%>"
      nombre_proveedor                        = "<%=Ucase(trim(rs("Nombre_Proveedor")))%>"
      fecha_emision                           = "<%=rs("Fecha_emision")%>"
      fecha_recepcion                         = "<%=rs("fecha_recepcion")%>"
      numero_factura                          = "<%=rs("numero_factura")%>"
      fecha_factura                           = "<%=rs("fecha_factura")%>"
      paridad                                 = "<%=FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2))%>"
      paridad_margen                          = "<%=paridad_margen%>"
      total_cif_ori                           = "<%=FormatNumber(Round(rs("total_cif_ori"),2))%>"
      total_cif_adu                           = "<%=FormatNumber(Round(rs("total_cif_adu"),2))%>"
      bodega                                  = "<%=trim(rs("bodega"))%>"
      carpeta                                 = "<%=trim(rs("carpeta"))%>"
      id="grid_CHECKBOX" name="radio_compras" type="radio" style="width:15px;"></input></td>
      <td style="width:60px;" id="grid_TD_1"><%=rs("documento_no_valorizado")%></td>
      <td style="width:80px;" id="grid_TD_1"><%=rs("Numero_documento_respaldo")%></td>
      <td style="width:90px;" id="grid_TD_1"><%=trim(rs("Proveedor"))%>&nbsp;</td>
      <td style="width:300px;" id="grid_TD_1" align="left"><%=Ucase(trim(rs("Nombre_Proveedor")))%>&nbsp;</td>
      <td style="width:100px;" id="grid_TD_1"><%=rs("Fecha_recepcion")%></td>
      <td style="width:60px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("Paridad_conversion_a_dolar"),2))%></td>
      <td style="width:90px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("total_cif_adu"),2))%></td>
      <td style="width:70px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("total_peso"),0),0)%></td>
      <td id="grid_TD_1" align="left"><%=rs("carpeta")%></td>
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
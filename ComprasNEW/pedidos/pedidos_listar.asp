<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

busqueda_aprox  = Request.Form("busqueda_aprox")
anio            = Request.Form("anio")
mes             = Request.Form("mes")
numero_pedido   = Request.Form("numero_pedido")
campo_order_by  = Request.Form("campo_order_by")

if campo_order_by = "" then campo_order_by = "A.fecha"
strAscDesc = ""
if campo_order_by = "A.fecha" then strAscDesc = " desc "

if numero_pedido <> "" then 
  strWhere = " and numero_pedido="&numero_pedido&" "
  if busqueda_aprox = "1" then strWhere = " and numero_pedido like '%"&numero_pedido&"%' "
end if  
OpenConn
'on error resume next
set ObjDict_PROVEEDOR = Server.CreateObject("Scripting.Dictionary")
'Cargar_Diccionario ObjDict_PROVEEDOR,"select distinct(Entidad_comercial) value, Apellidos_persona_o_nombre_empresa text from entidades_comerciales where Entidad_comercial is not null and Entidad_comercial <>'' order by value"
'OJO, existen registros repetidos de NOMBRES DE ENTIDA COMERCIAL (valor en el diccionario no se puede repetir)
'Cargar_Diccionario ObjDict_PROVEEDOR,"select top 10 producto value, valor_unitario text from productos_en_listas_de_precios where empresa='SYS' order by value"
strSQL = "select A.Numero_interno_pedido, A.numero_pedido, A.Proveedor, A.fecha, B.nombre_proveedor, A.moneda_origen, A.paridad_moneda_origen from  " &_
         "(select Numero_interno_pedido, numero_pedido, fecha, proveedor, moneda_origen, paridad_moneda_origen  " &_
         "from pedidos where year(fecha) = "&anio&" and month(fecha) = "&mes&" "&strWhere&" ) A, " &_
         "(select distinct(entidad_comercial) proveedor, " &_
         "Apellidos_persona_o_nombre_empresa nombre_proveedor " &_
         "from entidades_comerciales where empresa='SYS' and Entidad_comercial is not null and codigo_postal is not null) B " &_
         "where A.proveedor*=B.proveedor order by " & campo_order_by & " " & strAscDesc
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  width = "900"
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0>
  <tr>
    <td>
    <div name="capaEncListaPedido" id="capaEncListaPedido" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="20">
      <td style="width:15px;" id='grid_TH_1'>&nbsp;</td>
      <td title="Ordenar por n° pedido" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Pedidos(true,1,'A.numero_pedido')" style="width:80px;" id='grid_TH_1'>N°</td>
      <td title="Ordenar por rut" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Pedidos(true,1,'A.Proveedor')" style="width:90px;" id='grid_TH_1'>RUT</td>
      <td title="Ordenar por nombre proveedor" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Pedidos(true,1,'B.nombre_proveedor')" style="width:300px;" id='grid_TH_1'>PROVEEDOR</td>
      <td title="Ordenar por fecha" 
      OnMouseOver="this.style.fontSize='12px';this.style.cursor='hand';"
      OnMouseOut="this.style.fontSize='';"
      OnClick="Buscar_Pedidos(true,1,'A.fecha')" style="width:100px;" id='grid_TH_1'>FECHA</td>
      <td style="width:60px;" id='grid_TH_1'>MONEDA </td>
      <td style="width:90px;" id='grid_TH_1'>PARIDAD</td>
    </tr>
    </table>
    </div>
    <div align="left" name="capaListaPedido" onscroll="capaEncListaPedido.scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: 406px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    fila = 0
    do while not rs.EOF
    %>
    <tr 
    OnDblClick="Editar_Pedido()"
    Onclick="Set_Opciones_Pedido(<%=fila%>);"
    OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='hand'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id="tr_pedidos_<%=fila%>" name="tr_pedidos_<%=fila%>">
      <td style="width:15px;" id="grid_TD_1"><input 
      anio                  = "<%=anio%>"
      numero_interno_pedido = "<%=rs("numero_interno_pedido")%>"
      numero_pedido         = "<%=rs("numero_pedido")%>" 
      proveedor             = "<%=trim(rs("Proveedor"))%>"
      nombre_proveedor      = "<%=Ucase(trim(rs("Nombre_Proveedor")))%>"
      fecha                 = "<%=rs("fecha")%>"
      moneda_origen         = "<%=rs("moneda_origen")%>"
      paridad_moneda_origen = "<%=FormatNumber(Round(rs("paridad_moneda_origen"),2))%>"
      id="grid_CHECKBOX" name="radio_pedidos" type="radio" style="width:15px;"></input></td>
      <td style="width:80px;" id="grid_TD_1"><%=rs("numero_pedido")%></td>
      <td style="width:90px;" id="grid_TD_1"><%=trim(rs("Proveedor"))%>&nbsp;</td>
      <td style="width:300px;" id="grid_TD_1" align="left"><%=Ucase(trim(rs("Nombre_Proveedor")))%>&nbsp;</td>
      <td style="width:100px;" id="grid_TD_1"><%=rs("fecha")%></td>
      <td style="width:60px;" id="grid_TD_1"><%=rs("moneda_origen")%>&nbsp;</td>
      <td style="width:90px;" id="grid_TD_1" align="right"><%=FormatNumber(Round(rs("paridad_moneda_origen"),2))%></td>
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
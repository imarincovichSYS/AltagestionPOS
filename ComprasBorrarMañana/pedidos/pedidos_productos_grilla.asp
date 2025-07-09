<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<!--#include file="../../ACIDGrid/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                = Request.Form("accion")
anio                  = Request.Form("anio")
numero_pedido         = Request.Form("numero_pedido")
numero_interno_pedido = Request.Form("numero_interno_pedido")
items                 = Request.Form("items")
numero_linea          = Request.Form("numero_linea")
checktodos            = Request.Form("checktodos")

width     = "974"
height    = "304"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")
set rs      = server.CreateObject("ADODB.RECORDSET")

OpenConn
nom_tabla = "pedidos_movimientos"

strSQL="select " &_
       "IsNull(sum(numero_documento_respaldo_1),0) tcp_1, " &_
       "IsNull(sum(numero_documento_respaldo_2),0) tcp_2, " &_
       "IsNull(sum(numero_documento_respaldo_3),0) tcp_3, " &_
       "IsNull(sum(numero_documento_respaldo_4),0) tcp_4, " &_
       "IsNull(sum(numero_documento_respaldo_5),0) tcp_5 " &_
       "from "&nom_tabla&" where " &_
       "numero_pedido="&numero_pedido&" and numero_interno_pedido="&numero_interno_pedido
'Response.Write strSQL
'Response.End
set rs_tcp = Conn.Execute(strSQL) : tcp_1 = false : tcp_2 = false : tcp_3 = false : tcp_4 = false : tcp_5 = false
if not rs_tcp.EOF then
  if rs_tcp("tcp_1") > 0 then tcp_1 = true
  if rs_tcp("tcp_2") > 0 then tcp_2 = true
  if rs_tcp("tcp_3") > 0 then tcp_3 = true
  if rs_tcp("tcp_4") > 0 then tcp_4 = true
  if rs_tcp("tcp_5") > 0 then tcp_5 = true
end if
cant_TCP = 0 'Esta variable se actualiza dentro del siguiente archivo "include"
%><!-- #include file = "pedidos_productos_config_cols.asp" --><%
if accion = "NUEVO" then
  '################## Crear la cantidad=items registros  ######################
  '1°: Obtener el max(num linea) para ingresar los siguientes registros a partir desde ese num linea
  'ITEMES
  strSQL="select IsNull(max(numero_de_linea),0) num_linea from "&nom_tabla&" where " &_
         "numero_pedido="&numero_pedido&" and numero_interno_pedido="&numero_interno_pedido
  'Response.Write strSQL&"<br>"
  'Response.End
  set rs = Conn.Execute(strSQL) 'Si no existen registros, la consultará devolverá un "0" (IsNull(max),0)
  num_linea = rs("num_linea")
  '2°: Insertar la cantidad = items de registros desde el max(num_linea) + 1
  for i=1 to items
    num_linea = num_linea + 1
    strSQL="insert into "&nom_tabla&"(Numero_interno_pedido,Año,Numero_pedido,Numero_de_linea) values(" &_
           ""&Numero_interno_pedido&","&anio&","&Numero_pedido&","&num_linea&")"
    'Response.Write strSQL&"<br><br>"
    'Response.End
    set rs = Conn.Execute(strSQL)
  next
  'Response.End
end if

strSQL="select '', A.Numero_de_linea, A.Producto, A.Producto_cod_prov, B.nombre_producto, " &_
       "A.cantidad_mercancias, A.unidad_de_medida_compra, A.cantidad_um_compra_en_caja_envase_compra "
'strSQL=strSQL & ",A.unidad_de_medida_consumo, A.cantidad_x_un_consumo, A.cantidad_entrada"
'strSQL=strSQL & ",A.alto, A.ancho, A.largo, A.cantidad_x_caja, A.volumen, A.peso_x_caja, A.peso "
if tcp_1 then strSQL=strSQL & ", right(convert(varchar(4),A.año_1),2) + '-'+ ltrim(rtrim(A.documento_respaldo_1)) + '-' + convert(varchar(10),A.numero_documento_respaldo_1) + ': ' + convert(varchar(5),A.numero_de_linea_1) tcp_1, A.cantidad_entrada_1 "
if tcp_2 then strSQL=strSQL & ", right(convert(varchar(4),A.año_2),2) + '-'+ ltrim(rtrim(A.documento_respaldo_2)) + '-' + convert(varchar(10),A.numero_documento_respaldo_2) + ': ' + convert(varchar(5),A.numero_de_linea_2) tcp_2, A.cantidad_entrada_2 "
if tcp_3 then strSQL=strSQL & ", right(convert(varchar(4),A.año_3),2) + '-'+ ltrim(rtrim(A.documento_respaldo_3)) + '-' + convert(varchar(10),A.numero_documento_respaldo_3) + ': ' + convert(varchar(5),A.numero_de_linea_3) tcp_3, A.cantidad_entrada_3 "
if tcp_4 then strSQL=strSQL & ", right(convert(varchar(4),A.año_4),2) + '-'+ ltrim(rtrim(A.documento_respaldo_4)) + '-' + convert(varchar(10),A.numero_documento_respaldo_4) + ': ' + convert(varchar(5),A.numero_de_linea_4) tcp_4, A.cantidad_entrada_4 "
if tcp_5 then strSQL=strSQL & ", right(convert(varchar(4),A.año_5),2) + '-'+ ltrim(rtrim(A.documento_respaldo_5)) + '-' + convert(varchar(10),A.numero_documento_respaldo_5) + ': ' + convert(varchar(5),A.numero_de_linea_5) tcp_5, A.cantidad_entrada_5 "

if tcp_1 or tcp_2 or tcp_3 or tcp_4 or tcp_5 then 
  strSQL=strSQL & ", A.cantidad_anulados "
  strSQL=strSQL & ", (A.cantidad_mercancias - "
  strSQL=strSQL & "  (cantidad_entrada_1 + cantidad_entrada_2 + cantidad_entrada_3 + cantidad_entrada_4 + cantidad_entrada_5 + cantidad_anulados)" &_
                  "   ) diferencia " 
end if

strSQL=strSQL & " from " &_
       "(select Numero_de_linea, Producto, Producto_cod_prov, '' nombre_producto, " &_
       "cantidad_mercancias, unidad_de_medida_compra, cantidad_um_compra_en_caja_envase_compra, "
'strSQL=strSQL & "unidad_de_medida_consumo, cantidad_x_un_consumo, cantidad_entrada, "
'strSQL=strSQL & "alto, ancho, largo, cantidad_x_caja, " 
'strSQL=strSQL & "IsNull(Round( (alto*ancho*largo)/1000000 / Cantidad_x_caja,6),0) volumen, peso_x_caja, peso, "
strSQL=strSQL & "Año_1, documento_respaldo_1, numero_documento_respaldo_1, numero_de_linea_1, IsNull(cantidad_entrada_1,0) cantidad_entrada_1, " &_
       "Año_2, documento_respaldo_2, numero_documento_respaldo_2, numero_de_linea_2, IsNull(cantidad_entrada_2,0) cantidad_entrada_2, " &_
       "Año_3, documento_respaldo_3, numero_documento_respaldo_3, numero_de_linea_3, IsNull(cantidad_entrada_3,0) cantidad_entrada_3, " &_
       "Año_4, documento_respaldo_4, numero_documento_respaldo_4, numero_de_linea_4, IsNull(cantidad_entrada_4,0) cantidad_entrada_4, " &_
       "Año_5, documento_respaldo_5, numero_documento_respaldo_5, numero_de_linea_5, IsNull(cantidad_entrada_5,0) cantidad_entrada_5, " &_
       "IsNull(cantidad_anulados,0) cantidad_anulados from "&nom_tabla&" " &_
       "where numero_interno_pedido="&numero_interno_pedido&" and año="&anio&" " &_
       "and numero_pedido="&numero_pedido&") A, " &_
       "(select producto, Nombre nombre_producto from productos where empresa='SYS') B " &_
       "where A.producto*=B.producto order by numero_de_linea"
'Response.Write strSQL
'Response.End
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
set grid.recordset = rs	
grid.Height = height : grid.Width = width : grid.TH_Height = TH_Height
grid.scroll_Div_Totales = "0"
strHTML = grid.get_drawGrid()
%>
<script language="javascript">
var nom_tabla = "<%=nom_tabla%>", height_tmp= "<%=height%>", cant_TCP = <%=cant_TCP%>;
</script>
<table bgcolor="#FFFFFF" align="center" width="<%=width_tmp%>" border=0 cellpadding=0 cellspacing=0>
<tr><td id="t" name="t"><%=strHTML%></td></tr>
</table>
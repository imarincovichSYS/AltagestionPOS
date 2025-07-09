<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

accion                = Request.Form("accion")
anio                  = Request.Form("anio")
numero_pedido         = Request.Form("numero_pedido")
numero_interno_pedido = Request.Form("numero_interno_pedido")
nom_campo             = Request.Form("nom_campo")
valor                 = Request.Form("valor")
nom_tabla             = "pedidos"
delimiter = "~"
OpenConn
if accion = "insertar" then
  fecha_hoy = year(date()) & "/" & month(date()) & "/" & day(date())
  strSQL="insert into "&nom_tabla&"(Año, Numero_pedido, Fecha) values("&anio&","&numero_pedido&",'"&fecha_hoy&"')"
  set rs = Conn.Execute(strSQL)
  numero_interno_pedido = Get_Numero_Interno_Pedido(anio,numero_pedido)
  Response.Write numero_interno_pedido & delimiter 
elseif accion = "actualizar" then
  if nom_campo = "fecha" or nom_campo = "proveedor" or nom_campo="moneda_origen" then 
    if nom_campo = "fecha" then valor = year(valor) & "/" & month(valor) & "/"&day(valor)
    strSet    = " "&nom_campo&"='"&valor&"' "
  elseif nom_campo = "paridad_moneda_origen" then
    strSet    = " "&nom_campo&"="&valor&" "
  end if
  
  '################################################################################
  if nom_campo = "numero_pedido" then 'Se cambió el numero_pedido
    'Verificar si el n° está ocupado por otro pedido del mismo año
    strSQL="select numero_pedido from pedidos where year(fecha) = "&anio&" and numero_pedido="&numero_pedido
    'Response.Write strSQL
    'Response.End
    set rs = Conn.Execute(strSQL)
    if not rs.EOF then 
      Response.Write "EXISTE"
      Response.End
    end if
    strSQL="update pedidos_movimientos set numero_pedido="&numero_pedido&" " &_
           "where numero_interno_pedido="&numero_interno_pedido
    'Response.Write strSQL
    'Response.End
    set rs = Conn.Execute(strSQL)
  end if
  '################################################################################
  
  
  strSQL="update "&nom_tabla&" set "&strSet&" where numero_interno_pedido="&numero_interno_pedido
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
elseif accion = "eliminar" then
  '1° eliminar el detalle en "pedidos_movimientos"
  strSQL="delete pedidos_movimientos where numero_interno_pedido="&numero_interno_pedido
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
  '2° eliminar cabecera del pedido
  strSQL="delete "&nom_tabla&" where numero_interno_pedido="&numero_interno_pedido
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
end if
%>
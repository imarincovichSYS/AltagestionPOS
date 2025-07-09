<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

Server.ScriptTimeout = 1000

numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
bodega                                  = Request.Form("bodega")

delimiter1 = "~"
delimiter2 = "¬"
OpenConn
strSQL="select producto, cantidad = sum(cantidad_entrada), Item= max(numero_de_linea_en_RCP_o_documento_de_compra), " &_
       "stock_en_transito= ((select sum(stock_en_transito) from productos_en_bodegas b where m.producto=b.producto and bodega='0010' group by producto)), " &_
       "Dif= ((select sum(stock_en_transito) " &_
       "from productos_en_bodegas b where m.producto=b.producto and bodega='"&bodega&"' group by producto)) - sum(cantidad_entrada) " &_
       "from movimientos_productos m (nolock) " &_
       "where  empresa='SYS' and documento_no_valorizado = 'TCP' and " &_
       "numero_interno_documento_no_valorizado = "&numero_interno_documento_no_valorizado&" group by producto " &_
       "having ((select sum(stock_en_transito) from productos_en_bodegas b " &_
       "where m.producto=b.producto and bodega='"&bodega&"' group by producto)) - sum(cantidad_entrada) < 0 " &_
       "order by item"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL) : str_msg = ""
if not rs.EOF then 
  do while not rs.EOF
    producto  = trim(rs("producto"))
    item      = trim(rs("item"))
    'if str_msg <> "" then str_msg   = str_msg & delimiter1
    'str_msg =  str_msg & item & delimiter2 & producto
    
    if str_msg <> "" then str_msg = str_msg & ", "
    str_msg = str_msg & item
    rs.MoveNext
  loop
  str_msg = "Productos Stock(-) ítemes: " & str_msg
else
  str_msg = "OK"
end if
Response.Write str_msg
%>
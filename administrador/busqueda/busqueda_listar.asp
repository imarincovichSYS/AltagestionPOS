<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
OpenConn

Server.ScriptTimeout = 2000

nombre_codigo = trim(Unescape(Request.Form("nombre_codigo")))
tipo_busqueda = Request.Form("tipo_busqueda")
w_screen      = Request.Form("w_screen")

if len(nombre_codigo) < 4 then
%>
  <table style="width:100%; font-size: 11px;" border=0 cellpadding=0 cellspacing=0>
  <tr align="center" style="height: 100px; color: #222222;">
    <td><b>Ingrese al menos 4 caracteres para poder realizar la búsqueda</b></td>
  </tr>
  </table>
<%response.end
end if

'strWhere = " producto like '%" & nombre_codigo & "%'"
strWhere = " producto = '" & nombre_codigo & "'"
if tipo_busqueda = "nombre" then strWhere = " nombre like '%" & nombre_codigo & "%' "

strSQL="select A.producto, A.nombre, B.stock_real as stock, C.valor_unitario as precio from " &_
       "(select producto, nombre from productos where empresa='SYS' and " & strWhere & ") A, " &_
       "(select producto, stock_real from productos_en_bodegas where bodega = '0011' and empresa = 'SYS' and stock_real > 0) B, " &_
       "(select producto, valor_unitario from productos_en_listas_de_precios where empresa = 'SYS' and lista_de_precios = 'L01') C " &_
       "where A.producto = B.producto and A.producto = C.producto order by nombre"
'Response.Write strSQL
'Response.End
color_title = "#FFFFFF"
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  'w_table     = w_screen - 20
  w_table     = 500
  w_producto  = 60
  w_stock     = 60
  w_precio    = 60
	%>
  <div style="width:<%=w_table%>px; background-color:#EEEEEE;">
  	<table class="table_cabecera" style="width:<%=w_table-17%>px; font-size: 10px;" bgcolor="#666" border=0 cellpadding=0 cellspacing=0>
  		<tr style="height:20px; color:<%=color_title%>;">
  			<td class="th_left"   style="width: <%=w_producto%>px;" align="center">Código</td>
        <td class="th_middle" align="center">Descripción</td>  		  
        <td class="th_middle" style="width: <%=w_stock%>px;"  align="right">Stock M7</td>
        <td class="th_middle" style="width: <%=w_precio%>px;" align="right">Precio ($)</td>
  		</tr>
  	</table>
  </div>
  <div style="width: <%=w_table%>px; height:500px; overflow:auto; background-color:#EEEEEE;">
  <table class="table_detalle" style="width:<%=w_table-17%>px; font-size: 11px;" bgcolor="#EEEEEE" border=0 cellpadding=0 cellspacing=0>
  	<%
  	do while not rs.EOF
  	  if bg_color <> "" then 
  	    bg_color = ""
  	  else
  	    bg_color = "#DDDDDD"
  	  end if
      producto  = Ucase(trim(rs("producto")))
      stock     = rs("stock")
      precio    = rs("precio")
  	  %>
  		<tr 
      OnClick="Set_Busqueda_Codigo('<%=producto%>')"
      bgcolor="<%=bg_color%>">
  			<td class="td_middle" style="width: <%=w_producto%>px;"><%=producto%></td>
  			<td class="td_middle" >&nbsp;<%=rs("nombre")%></td>
  			<td class="td_middle" style="width: <%=w_stock%>px;" align="right"><%=FormatNumber(stock,0)%>&nbsp;</td>
        <td class="td_middle" style="width: <%=w_precio%>px;" align="right"><%=FormatNumber(precio,0)%>&nbsp;</td>
  	  </tr>
    <%rs.MoveNext
  	loop%>
  </table>
  <%if tipo_busqueda = "codigo" then
    strSQL = "Exec MOP_Consulta_producto '0011', '0011', '13512435', 'SYS', '"  & producto & "','13512435', 1"
    set rs_datos = Conn.Execute(strSQL)
    if not rs_datos.EOF then 
      prom = cdbl(rs_datos("Monto_descuento"))
      if cdbl(rs_datos("Monto_descuento")) <> 0 then prom = cdbl(rs_datos("Precio_venta_de_lista_$")) - cdbl(rs_datos("Monto_descuento"))
      
      precio_lista_base = rs_datos("Precio_venta_de_lista_$")
      stock_m7 = 0 : stock_bm7 = 0
      do while not rs_datos.EOF
        bodega = trim(rs_datos("bodega"))
        if bodega = "0011" then 
          stock_m7 = rs_datos("Stock_real_en_bodega")
        elseif bodega = "0010" then 
          stock_bm7 = rs_datos("Stock_real_en_bodega")
        end if
        rs_datos.MoveNext
      loop
      
      
    end if%>
    <br>
    <table align="center" style="width:300px;" border=0 cellpadding=0 cellspacing=0>
    <tr align="right">
      <td style="width: 180px; font-size:20px;">Precio ($):&nbsp;</td>
      <td style="color:#0000AA; font-size:30px;"><%=precio_lista_base%></td>
    </tr>
    <tr align="right">
      <td style="width: 120px; font-size:20px;">Promoción ($):&nbsp;</td>
      <td style="color:#0000AA; font-size:30px;"><%=prom%></td>
    </tr>
    <tr align="right">
      <td style="font-size:20px;">Stock M7:&nbsp;</td>
      <td style="color:#006600; font-size:30px;"><%=FormatNumber(stock_m7,0)%></td>
    </tr>
    <tr align="right">
      <td style="font-size:20px;">Stock B7:&nbsp;</td>
      <td style="color:#006600; font-size:30px;"><%=FormatNumber(stock_b7,0)%></td>
    </tr>
    
    </table>
  <%end if%>
  </div>
<%else%>
  <table style="width:100%; font-size: 11px;" border=0 cellpadding=0 cellspacing=0>
  <tr align="center" style="height: 100px; color: #222222;">
    <td><b>No se encontraron registros...</b></td>
  </tr>
  </table>
<%end if%>
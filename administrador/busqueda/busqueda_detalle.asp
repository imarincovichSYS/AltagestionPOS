<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
OpenConn

Server.ScriptTimeout = 2000
producto  = Ucase(trim(Unescape(Request.Form("nombre_codigo"))))

function Existe_ImagenProducto(v_imagen_producto)
  RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "\Imagenes\Productos\"  
  SinImagen   = "noimagen.gif"  
  archivo     = RutaFISICA_ImagenesProductos & v_imagen_producto
  Set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
  imagen      = v_imagen_producto
  if not objFSO.FileExists(archivo) then imagen = SinImagen
  Existe_ImagenProducto = imagen
end function

strSQL="select IsNull(porcentaje_impuesto_1,0) as ila from productos where empresa='SYS' and producto = '" & producto & "'"
set rs = Conn.Execute(strSQL)
if not rs.EOF then 
  ila = cdbl(rs("ila")) / 100
  
  strSQL = "Exec MOP_Consulta_producto '0011', '0011', '13512435', 'SYS', '"  & producto & "','13512435', 1"
  set rs = Conn.Execute(strSQL)
  
  precio  = cdbl(rs("Precio_venta_de_lista_$"))
  nombre  = rs("nombre_producto")
  prom    = cdbl(rs("Monto_descuento"))
  if cdbl(rs("Monto_descuento")) <> 0 then prom = cdbl(rs("Precio_venta_de_lista_$")) - cdbl(rs("Monto_descuento"))
  
  stock_m7 = 0 : stock_bm7 = 0
  do while not rs.EOF
    bodega = trim(rs("bodega"))
    if bodega = "0011" then 
      stock_m7 = rs("Stock_real_en_bodega")
    elseif bodega = "0010" then 
      stock_bm7 = rs("Stock_real_en_bodega")
    end if
    rs.MoveNext
  loop
  
  descuento_institucional =  0
  Set rs = Conn.execute("EXEC PUN_Descuento_institucional '" & Session("Cliente_boleta") & "'" )
  if not rs.eof then descuento_institucional = cdbl( rs("Maximo_porcentaje_descuento_autorizado") )
  
  rut_cajera = "8403656"
  maximo_descuento_cajera = 0
  set rs = Conn.execute("EXEC PUN_Descuentos_cajera '"&rut_cajera&"'" )
  if not rs.eof then maximo_descuento_cajera = cdbl(rs("porcentaje_descuento_maximo_permitido_para_vender"))
  
  maximo_descuento_linea = 0
  set rs = Conn.execute("EXEC PUN_Maximo_descuento_linea" )
  if not rs.eof then maximo_descuento_linea = cdbl( rs("Valor_numerico") )
  
  maximo_descuento_cabecera = 0
  set rs = Conn.execute("EXEC PUN_Maximo_descuento_cabecera" )
  if not rs.eof then maximo_descuento_cabecera = cdbl( rs("Valor_numerico") )
  
  'response.write "<br>descuento_institucional: " & descuento_institucional
  'response.write "<br>maximo_descuento_cajera: " & maximo_descuento_cajera
  'response.write "<br>maximo_descuento_linea: " & maximo_descuento_linea
  'response.write "<br>maximo_descuento_cabecera: " & maximo_descuento_cabecera
  'response.end
  
  descuento_linea = maximo_descuento_cajera
  if descuento_linea > maximo_descuento_cajera    then descuento_linea = maximo_descuento_cajera
  if descuento_linea > maximo_descuento_linea     then descuento_linea = maximo_descuento_linea
  if descuento_linea > maximo_descuento_cabecera  then descuento_linea = maximo_descuento_cabecera
  
  entidad_comercial = "13512435"
  set rs = Conn.execute("EXEC PUN_Descuento_empleado 0" & entidad_comercial )
  porcentaje_descuento_empleado = 0
  if not rs.eof then porcentaje_descuento_empleado = cdbl(rs("Porcentaje_descuento_sobre_margen_para_comprar")) / 100
  
  'Obtener costos desde la compra activa a la cual se le está descontando stock
  strSQL="select costo_cpa_$, Costo_CIF_ADU_$ from movimientos_productos with (nolock) where empresa= 'SYS' and " &_
         "documento_no_valorizado = 'RCP' and producto = '"&producto&"' and " &_
         "Cantidad_de_RCP_vendida > 0 and cantidad_entrada > Cantidad_de_RCP_vendida"
  set rs = Conn.Execute(strSQL) : costo_cpa = 0 : costo_cif_adu = 0
  if not rs.EOF then 
    costo_cpa     = cdbl(rs("Costo_CPA_$"))
    costo_cif_adu = cdbl(rs("Costo_CIF_ADU_$"))
  end if
  'response.write "<br>descuento_linea: " & descuento_linea
  
  monto_descuento             = (precio * (descuento_linea / 100) \ 1)
  precio_sin_ila              = precio/(1 + ila)
  monto_descuento_empleado    =  ( ( ( ( ( precio_sin_ILA - ( costo_cpa + ( costo_cif_adu * ( 0.019 + 0.008 ) ) ) ) * porcentaje_descuento_empleado)) * (1 + ila) ) \ 10 ) * 10
  precio_final_con_descuento  = cdbl(precio) - cdbl(monto_descuento_empleado)
  'response.write "<br>descuento_linea: " & descuento_linea
  'response.write "<br>porcentaje_descuento_empleado: " & porcentaje_descuento_empleado
  'response.write "<br>monto_descuento_empleado: " & monto_descuento_empleado
  
  if monto_descuento_empleado > monto_descuento then 
    precio_final_con_descuento = cdbl(precio) - cdbl(monto_descuento_empleado)
    Descuento_linea = ( 1 - ( ( Precio - Monto_descuento_empleado ) / Precio ) ) * 100
  end if
  
  'response.write "<br>Descuento_linea: " & Descuento_linea
  
  RutaVIRTUAL_ImagenesProductos = "http://cajas/Altagestion/Imagenes/Productos/"
  imagen = RutaVIRTUAL_ImagenesProductos & producto & ".jpg"
else
%>
  <table align="center" style="width:95%;" border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td align="center"><br><br><b><label style="color:#AA0000; background-color:#FFFFFF">No existe el producto</label></b></td>
  </tr>
  </table>
<%response.end
end if
color_border  = "#444444"
w_extremos    = 70
h_tr_img      = 303
%>
<table align="center" style="width:490px;" border=0 cellpadding=0 cellspacing=0 bgcolor="#FFFFFF">
<tr>
  <td style="border: 1px solid <%=color_border%>;">
  <table align="center" style="width:95%;" border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td style="font-size:30px; color: #CC6600;"><b><%=producto%></b></td>
  </tr>
    <td style="border-bottom: 1px solid <%=color_border%>; color:#555555; font-size:22px;"><b><%=nombre%></b></td>
  </tr>
  </table>
  <table align="center" style="width:95%;" border=0 cellpadding=0 cellspacing=0>
  <tr align="right">
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
    <td style="width: 180px; font-size:20px;">Precio ($):&nbsp;</td>
    <td style="color:#0000AA; font-size:30px;"><b><%=Replace(FormatNumber(precio,0),",",".")%></b></td>
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
  </tr>
  <%if prom <> 0 then
    h_tr_img = 267%>
  <tr align="right">
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
    <td style="width: 120px; font-size:20px;">Promoción ($):&nbsp;</td>
    <td style="color:#AA0000; font-size:30px;"><b><%=Replace(FormatNumber(prom,0),",",".")%></b></td>
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
  </tr>
  <%end if%>
  <tr align="right">
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
    <td style="width: 180px; font-size:20px;">Precio final ($):&nbsp;</td>
    <td style="color:#0000AA; font-size:30px;"><b><%=Replace(FormatNumber(precio_final_con_descuento,0),",",".")%></b></td>
    <td style="width:<%=w_extremos%>px;">&nbsp;</td>
  </tr>
  <tr align="right">
  <td style="border-top: 1px solid <%=color_border%>; width:<%=w_extremos%>px;">&nbsp;</td>
    <td style="border-top: 1px solid <%=color_border%>; font-size:20px;">Stock M7:&nbsp;</td>
    <td style="border-top: 1px solid <%=color_border%>; color:#006600; font-size:30px;"><%=Replace(FormatNumber(stock_m7,0),",",".")%></td>
    <td style="border-top: 1px solid <%=color_border%>; width:<%=w_extremos%>px;">&nbsp;</td>
  </tr>
  <tr align="right">
    <td style="border-bottom: 1px solid <%=color_border%>; width:<%=w_extremos%>px;">&nbsp;</td>
    <td style="border-bottom: 1px solid <%=color_border%>; font-size:20px;">Stock B7:&nbsp;</td>
    <td style="border-bottom: 1px solid <%=color_border%>; color:#006600; font-size:30px;"><%=Replace(FormatNumber(stock_b7,0),",",".")%></td>
    <td style="border-bottom: 1px solid <%=color_border%>; width:<%=w_extremos%>px;">&nbsp;</td>
  </tr>
  </table>
  <table align="center" style="width:95%;" border=0 cellpadding=0 cellspacing=0>
  <tr style="height:<%=h_tr_img%>px;">
    <td align="center"><img src="<%=imagen%>" onerror="this.src='http://cajas/Altagestion/Imagenes/Productos/noimagen.gif'" width="250" height="250" style="border: 1px solid #CCCCCC"></td>
  </tr>
  </table>
  </td>
</tr>
</table>
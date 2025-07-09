<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys.sys.local/altagestion/"
'Response.Write RutaProyecto
'Response.End
SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn.commandtimeout=600

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

function Existe_ImagenProducto(v_imagen_producto)
  RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "\Imagenes\Productos\"
  
  SinImagen   = "noimagen.gif"  
  archivo     = RutaFISICA_ImagenesProductos & v_imagen_producto
  Set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
  imagen      = v_imagen_producto
  if not objFSO.FileExists(archivo) then imagen = SinImagen
  Existe_ImagenProducto = imagen
end function

codigo  = Ucase(trim(Request.Form("codigo")))
codigo = Replace(codigo, "Ã±", "ñ")
codigo = Replace(codigo, "Ã‘", "Ñ")
numero_nota_de_venta = Request.Form("numero")
codigo = Ucase(codigo)
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''OBTENGO EL CODIGO INTERNO, PUEDE VENIR EL CODIGO DE BARRAS''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  sql =  "select producto, codigo_alternativo_producto from codigos_alternativos_de_productos " &_
         "where codigo_alternativo_producto='"&codigo&"' or producto='"&codigo&"'"
         'response.write sql
         'response.end
  set rs = Conn.Execute(sql)
if not rs.EOF then
  codigo = rs("producto")
  'codigo = Replace(Mid(codigo,1,20),Mid(codigo,1,2),"Ñ") 'corrige el problema de la Ñ
   
  'codigo  = "8895571320037"
  'if IsNumeric(codigo) then
  ''  num_inicio_L3 = cdbl(left(codigo,3))
  ''  if num_inicio_L3 >= 211 and num_inicio_L3 <= 236 then codigo = left(codigo,len(codigo)-1)
  'end if
  strSQL="select A.producto, A.nombre, B.codigo_alternativo_producto, C.valor_unitario, F.liq, " &_
         "D.Stock_real, D1.Stock_real stock_bodega, D2.Stock_Real stock_total, prom = isnull(C.valor_unitario - e.Monto_descuento,0), entrada = isnull(G.entrada,0) from " &_
         "(select producto, nombre from productos where empresa='SYS') A " &_
         "Left join (select Producto, Monto_descuento, Promocion from productos_en_promociones where empresa='SYS' and Centro_de_venta='0011') E on A.producto=e.producto " &_
         
         "Left join (select producto, isnull(sum(cantidad_entrada),0) entrada from movimientos_productos " &_
         "where empresa='SYS' and documento_no_valorizado='TBE' and fecha_movimiento >= getdate()-2 " &_
         "and Estado_documento_no_valorizado = 'PRE' group by producto) G on A.producto=g.producto ," &_

         
         "(select producto, codigo_alternativo_producto from codigos_alternativos_de_productos " &_
         "where codigo_alternativo_producto='"&codigo&"' or producto='"&codigo&"') B, " &_
         
         "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and Lista_de_precios = 'L01') C, " &_
         
         "(select producto, liq = valor_unitario from productos_en_listas_de_precios where empresa='SYS' and Lista_de_precios = 'L01') F, " &_
         
         "(select Producto, Stock_real from productos_en_bodegas where empresa='SYS' and bodega='0011') D, " &_
         "(select Producto, Stock_real from productos_en_bodegas where empresa='SYS' and bodega='0010') D1, " &_
         "(select Producto, Stock_real = sum(Stock_real) from productos_en_bodegas where empresa='SYS' and producto = '"& codigo &"' group by producto) D2 " &_

           "where A.producto=B.producto and " &_ 
                 "A.producto=C.producto and " &_
                 "a.producto = d.producto and  " &_
                 "a.producto = F.producto and  " &_
                 "E.promocion in ( " &_
                    "select promocion  " &_
                    "from promociones " &_
                    "where fecha_termino+Hora_termino>getdate() and " &_
                    "Estado = 'A' and " &_
                    "Case when DATEPART(dw,GETDATE()) = 1 then Dia_Domingo " &_
                          "when DATEPART(dw,GETDATE()) = 2 then Dia_Lunes " &_
                          "when DATEPART(dw,GETDATE()) = 3 then Dia_Martes " &_
                          "when DATEPART(dw,GETDATE()) = 4 then Dia_Miercoles " &_
                          "when DATEPART(dw,GETDATE()) = 5 then Dia_Jueves " &_
                          "when DATEPART(dw,GETDATE()) = 6 then Dia_Viernes " &_
                          "when DATEPART(dw,GETDATE()) = 7 then Dia_Sabado " &_
                    "end = 'S' " &_
                  ") and " &_
                 "a.producto = d1.producto and " &_
                 "a.producto = d2.producto " 
         
  'Response.Write strSQL
  'Response.End
  set rs = Conn.Execute(strSQL)
  if not rs.EOF then
  %>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border = 0>
  <tr id="texto_12">
        <td>
        <b><u>Código:</u></b>
        <%=rs("producto")%>  <%'Response.Write("Your IP is : " & Request.ServerVariables("REMOTE_ADDR") & "<BR>" & vbcrlf)%>	
        <br><b><u>Descripción:</u></b>
        <br><%=rs("nombre")%>
        <br><b><br><u>Precio:</u></b>
        <%=FormatNumber(rs("valor_unitario"),0)%>&nbsp;&nbsp;&nbsp;&nbsp;
        <b><u>Prom:</u></b>
        <%=FormatNumber(rs("prom"),0)%>  &nbsp;&nbsp;&nbsp;&nbsp;
        <b><u>May:</u></b>
        <%=FormatNumber(rs("entrada"),0)%>  
       <!-- <b><u>Liq:</u></b>
        <%'=FormatNumber(rs("liq"),0)%> -->
        <b><br><br><u>Stock bodega:</u></b>
        <%=FormatNumber(rs("stock_bodega"),0)%>      
        <br><b><u>Stock sala:</u></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <%=FormatNumber(rs("Stock_real"),0)%>
        <br><b><u>Stock Total:</u></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <%=FormatNumber(rs("stock_total"),0)%>
        <%sql = "select cantidad = isnull(sum(cantidad),0)  from ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta & " and producto = '" & codigo & "'"
        set rs = Conn.Execute(sql)%> 
        <b><br><br><u>Cantidad en nota de Venta:</u></b> <%=rs("cantidad")%>
        <%sql = "select total = isnull(sum(cantidad * precio),0)  from ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta 
        set rs = Conn.Execute(sql)%> 
        <b><br><u>    Total nota de Venta</u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</b> <%=FormatNumber(rs("Total"),0)%>
        </td>
  </tr>
  </table>
  <%
  else
  %>
    <center><b>PRODUCTO NO EXISTE</b></center>
  <%
  end if
else
  %>
    <center><b>PRODUCTO NO EXISTE</b></center>
  <%
end if
rs.close
set rs = nothing
Conn.Close
set Conn = nothing%>

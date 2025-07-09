<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=" & session("login") & ";WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

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
codigo = Ucase(codigo)
numero_nota_de_venta = Request.Form("numero")
cantidad = Request.Form("cant")
cliente = Request.Form("cliente")
pedir = 0


sql = "select count (distinct  producto) as cant from ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta & " and cliente ='"& cliente &"'"
set rs = Conn.Execute(sql)
if not rs.eof then
  if cdbl(rs("cant")) > 15 then
    response.write ("No se pueden insertar más productos. Crear nota de venta nueva")
    response.end
  end if  
end if
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''VALIDO LA CANTIDAD INGRESADA NO PUEDE SER NEGATIVO''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sql = "select cantidad = isnull(sum(cantidad),0) from ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta & " and cliente ='"& cliente &"' and  producto = '"& codigo &"'"
set rs = Conn.Execute(sql)
cantidad_total = cdbl(rs("cantidad"))
if cdbl(rs("cantidad")) + cdbl(cantidad) < 0 then
  response.write ("Está eliminando más Unidades de las Existentes")
  response.end
else
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''OBTENGO EL CODIGO INTERNO, PUEDE VENIR EL CODIGO DE BARRAS''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  sql =  "select producto, codigo_alternativo_producto from codigos_alternativos_de_productos " &_
         "where codigo_alternativo_producto='"&codigo&"' or producto='"&codigo&"'"
  set rs = Conn.Execute(sql)
  codigo = rs("producto")
  

  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  '''''''''''''''''''''''VALIDO SI LA CANTIDAD TOTAL SOLICITADA TIENE STOCK EN LA EMPRESA, OJO CON LOS KITS'''''''''''''
  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  sql = "select Producto_insumo, Precio_unitario, cantidad from composicion where producto_final = '"&codigo&"'"
  set rs_kits = Conn.Execute(sql)
  if rs_kits.eof then
    sql = "select producto,	Total = sum(Stock_real) ," &_	
          "sala = (select sum(Stock_real) from productos_en_bodegas where empresa='SYS' and producto = pro.producto and bodega='0011' ), " &_
  	      "Bod  = (select sum(Stock_real) from productos_en_bodegas where empresa='SYS' and producto = pro.producto and bodega='0010' ) " &_
          "from productos_en_bodegas pro " &_
          "where empresa='SYS' and producto = '"& codigo &"' " &_
          "group by producto" 
    set rs = Conn.Execute(sql)
    if cdbl(rs("Total")) < cdbl(cantidad_total) + cdbl(cantidad) then
      response.write("La Cantidad Total Solicitada Supera Stock")
      response.end
    else
      if cdbl(rs("Total")) = cdbl(rs("sala")) then
        pedir = 0
      elseif cdbl(rs("sala")) < cdbl(cantidad_total) + cdbl(cantidad) then
        pedir = 1
      elseif 100-( (cdbl(cantidad_total) + cdbl(cantidad)) / cdbl(rs("sala")) * 100 ) < 30 then
        pedir = 1
      else
        sql = "update ordenes_de_ventas set pedido = 0 where numero_orden_de_venta = " & numero_nota_de_venta & " and cliente ='"& cliente &"' and  producto = '"& codigo &"'"
        Conn.Execute(sql)
        pedir = 0
      end if
    end if
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '''''''''''''''''''''''INSERTO EL PRECIO DE LISTA O DE PROMOCION SEGUN CORRESPONDA, OJO CON LOS KITS''''''''''''''''''
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
 
    sql = "select A.producto, A.valor_unitario, prom = ISNULL(A.valor_unitario - Monto_descuento,0) from " &_ 
          "(select producto, valor_unitario from productos_en_listas_de_precios " &_
          "where empresa='SYS' and Lista_de_precios = (select Valor_texto from parametros where Parametro = 'LP_BASE') " &_
          "and producto = '" & codigo & "') A " &_
        
          "left join (select Producto, Monto_descuento, Promocion from productos_en_promociones where empresa='SYS' and Centro_de_venta='0011' and producto='" & codigo & "') B on A.producto = B.producto " &_
        
          "and B.Promocion in ( " &_
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
              ") " 
    set rs = Conn.Execute(sql)
    if cdbl(rs("PROM")) = 0 then
      precio = rs("valor_unitario")
    else
      precio = rs("PROM")
    end if
  end if
  
  
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''GUARDO LA LINEA LEIDA CON EL PRECIO QUE CORRESPONDE'''''''''''''''''''''''''''''''''''''
  ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  sql = "select top 1 observacion from ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta & " and cliente ='"& cliente &"' and observacion is not Null"
  set rs_obs = Conn.Execute(sql)
  if rs_obs.eof then
    obs = Null
  else
    obs = rs_obs("observacion")
  end if
  if rs_kits.eof then
    sql = "insert into ordenes_de_ventas (numero_orden_de_venta,fecha,cantidad, producto, precio, cliente, pedido, observacion ) " &_
          "values( " & numero_nota_de_venta & ",'" & month(date()) & "-" & day(date()) & "-" & year(date()) & "',"&cantidad&",'"&ucase(codigo)&"',"&precio&",'"&cliente&"',"&pedir&",'"&obs&"')"
    Conn.Execute(sql)
  else
    do while not rs_kits.eof 
      sql = "insert into ordenes_de_ventas (numero_orden_de_venta,fecha,cantidad, producto, precio, cliente, pedido, observacion ) " &_
            "values( " & numero_nota_de_venta & ",'" & month(date()) & "-" & day(date()) & "-" & year(date()) & "',"&cantidad*cdbl(rs_kits("cantidad"))&",'"&ucase(rs_kits("Producto_insumo"))&"',"&rs_kits("Precio_unitario")&",'"&cliente&"',"&pedir&",'"&obs&"')"
      Conn.Execute(sql)
      rs_kits.movenext
    loop
  end if
  'codigo = Replace(Mid(codigo,1,20),Mid(codigo,1,2),"Ñ") 'corrige el problema de la Ñ
   
  'codigo  = "8895571320037"
  'if IsNumeric(codigo) then
  ''  num_inicio_L3 = cdbl(left(codigo,3))
  ''  if num_inicio_L3 >= 211 and num_inicio_L3 <= 236 then codigo = left(codigo,len(codigo)-1)
  'end if
  strSQL="select A.producto,  A.Superfamilia, A.Familia, A.Subfamilia, Genero= Isnull(A.Genero,''), Marca = Isnull((Case when A.Marca = 'OCASIONAL' THEN '' Else A.Marca end),'') ,A.nombre, B.codigo_alternativo_producto, C.valor_unitario, F.liq, " &_
         "D.Stock_real, D1.Stock_real stock_bodega, D2.Stock_Real stock_total, prom = isnull(C.valor_unitario - e.Monto_descuento,0), entrada = isnull(G.entrada,0) from " &_
         "(select producto, nombre, Superfamilia, familia, subfamilia, genero, marca from productos where empresa='SYS') A " &_
         "left join (select Producto, Monto_descuento, Promocion from productos_en_promociones where empresa='SYS' and Centro_de_venta='0011') E on a.producto = E.producto and " &_
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
                  ")  " &_
         "left join (select producto, isnull(sum(cantidad_entrada),0) entrada from movimientos_productos " &_
         "where empresa='SYS' and documento_no_valorizado='TBE' and fecha_movimiento >= getdate()-2 " &_
         "and Estado_documento_no_valorizado = 'PRE' group by producto) G on a.producto = g.producto, " &_

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
      <%=FormatNumber(rs("valor_unitario"),0)%>
      <b><u>Prom:</u></b>
      <%=FormatNumber(rs("prom"),0)%>  
    
      <b><u>May:</u></b>
      <%=FormatNumber(rs("entrada"),0)%>  
     <!-- <b><u>Liq:</u></b>
      <%'=FormatNumber(rs("liq"),0)%> -->
      <b><br><br><u>Stock bodega:</u></b>
      <%=FormatNumber(rs("stock_bodega"),0)%>      
      <br><b><u>Stock sala:</u></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
  rs.close
  set rs = nothing
  Conn.Close
  set Conn = nothing
end if
%>

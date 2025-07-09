<table border="0" cellspacing="1" cellpadding="0">
<%
n = 1
Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
ColorLinea = "#dcdcbb"
do while not rs.eof
    Descuento = cdbl(rs("Porcentaje_descuento_2")) + cdbl(rs("Porcentaje_descuento_1"))  ' Descuento promocional
    Precio = cdbl( rs("Precio_de_lista_modificado") )
    Precio_Normal = cdbl(rs("Precio_de_lista"))
    '***********************************************************************************************
    'Modificación para verificación de cálculo de productos mayoristas con descuento por promoción
    '***********************************************************************************************
    
    Porcentaje_descuento_3 = 0
    if not IsNull(trim(rs("Porcentaje_descuento_3"))) then Porcentaje_descuento_3 = cdbl(rs("Porcentaje_descuento_3"))
    
    'Valores usados para pruebas
    '====================================
    descuento_title			        = Descuento
    Precio_Normal_Con_Descuento = ( Precio_Normal * ( ( 100 - Descuento ) / 100 ) \ 1 )
    'Precio_Normal_Con_Descuento = cdbl(Precio_Normal_Con_Descuento) - cdbl(Precio_Normal_Con_Descuento Mod 10) 'Precio sin pesos (unidades)
    '====================================
    
    temporada = trim(Ucase(rs("temporada")))
    if tipo_cobro_ECO then 'Modificación para productos con descuentos ECONOMATO
      if temporada = "ECO" then Descuento = Porcentaje_descuento_3
    else
      if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" then Descuento = 0
    end if
    
    Precio = ( Precio * ( ( 100 - Descuento ) / 100 ) \ 1 )
    'Precio = cdbl(Precio) - cdbl(Precio Mod 10) 'Precio sin pesos (unidades)
    '***********************************************************************************************
    Descuento1 = Rs("Porcentaje_descuento_1")
    if IsNull(Descuento1) Then Descuento1 = 0

   Error_descuento = ""
   if Descuento > Session("Maximo_descuento_cajera") then
      Error_descuento = "Sobrepasa descuento máximo cajera"
   elseif  cdbl(rs("Porcentaje_descuento_2")) > Session("Maximo_descuento_linea") then
      Error_descuento = "Sobrepasa descuento máximo línea"
   end if
   if ColorLinea = "#dcdcbb" then
      ColorLinea = "#ededbb"
   else
      ColorLinea = "#dcdcbb"
   end if

    if cDbl(Descuento1) > 0 then
        Error_descuento = ""
    end if

   if len(ltrim(trim(rs("Imagen_producto")))) > 0 then
      Imagen = "../../imagenes/productos/" & ltrim(rs("Imagen_producto"))
   else
      Imagen = "../../imagenes/productos/noimagen.gif"
   end if
   %>
<tr id="fila<%=n%>" onclick="javascript:cambio_imagen('fila<%=n%>','<%=Imagen%>')" bgcolor="<%=ColorLinea%>"  class="FuenteInput"> 
    <td align="center" style="width=20px;">&nbsp;<%=n%></td>
    <%if Session("Login")="15309968" or Session("Login")="15711196" or Session("Login")="13884785" or Session("Login")="15308847" or Session("Login")="15923212" or Session("Login")="18184487" or Session("Login")="13859206"  or Session("Login")="17629393" or Session("Login")="17587517"  or Session("Login")="9926612" then%>
        <td style="width=150px;">&nbsp;<%=rs("Producto")%><% response.write("- ") %> <%response.write rs("DOCTO")%></td>        
    <%ELSE%>
        <td style="width=150px;">&nbsp;<%=rs("Producto")%></td>
    <%end if%>

    <td style="width=290px;" nowrap>&nbsp;<%=left(trim(rs("Nombre_producto")),47)%></td>
    <td style="width=30px;" align="center"><%=rs("Cantidad_salida")%></td>
    <td 
    <%if mostrar_valores then%>
		title="<%=temporada%>" 
    <%end if%>
    style="width=10px;">&nbsp;UN&nbsp;</td>
    <td align="right" width="60px">
        <input type="hidden" name="Precio_de_lista_modificado_<%=rs("Numero_de_linea")%>" value="<%=rs("Precio_de_lista_modificado")%>">
        &nbsp;
        <%'if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" then%>
			<%'=formatnumber(rs("Precio_de_lista_modificado"),0)%>
		<%'else%>
			<%=formatnumber(rs("Precio_de_lista"),0)%>
		<%'end if%>&nbsp;
    </td>
    <%
    if tipo_cobro_ECO then
      if temporada = "ECO" then Descuento = 100 - cdbl(Precio)*100/cdbl(rs("Precio_de_lista"))
    else
      if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" then
        Descuento = 100 - cdbl(rs("Precio_de_lista_modificado"))*100/cdbl(rs("Precio_de_lista"))
      end if
    end if
    %>
    <td 
    <%if mostrar_valores then%>
		title="<%=FormatNumber(descuento_title,2)%>" 
    <%end if%>
    align="right" width="40px">&nbsp;<%=formatnumber(Descuento,2)%></td>
    <td 
    <%if mostrar_valores then%>
		title="<%=Precio_Normal_Con_Descuento%>"
	<%end if%>
    align="right" width="70px">&nbsp;<%=FormatNumber(Precio,0)%></td>
    <td 
    <%if mostrar_valores then%>
		title="<%=formatnumber(cint(rs("Cantidad_salida"))*Precio_Normal_Con_Descuento,0)%>"
	  <%end if%>
    align="right" width="70px">&nbsp;<b><%=formatnumber(cint(rs("Cantidad_salida"))*Precio,0)%></b>&nbsp;</td>
    <%if tipo_cobro_ECO and Session("Porcentaje_descuento_empleado") = 0 and Session("xEconomato_temporada") <> "" then%>
      <td align="center" width="10px" style="font-size: 8px;">
      <%if temporada = "ECO" then%>
      <b><font color="#990000">E</font></b>
      <%end if%>
      </td>
    <%else%>
      <%if Existe_Mayorista_en_Lista_DVT then%>
      <td align="center" width="10px" style="font-size: 8px;">
      <%if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" then%>
        <b><font color="#990000">M</font></b>
        <%end if%>  
      </td>
      <%end if%>
    <%end if%>
    <td align="center"><b><%=Error_descuento%></b></td>
</tr>
<%
n = n + 1
rs.movenext
loop
rs.close
set rs = nothing
%>
</table>

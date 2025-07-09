<table border="0" cellspacing="1" cellpadding="0">
<%
n = 1
cSql = "Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'"
Set rs = Conn.execute( cSql )
ColorLinea = "#dcdcbb"
'Response.Write cSql
'Response.End

Do While Not Rs.Eof
    Es_KIT = Rs("Es_KIT")    
    Promocion = Rs("Promocion_nombre")
        if IsNull(Promocion) Then Promocion = ""
    Descuento1 = Rs("Porcentaje_descuento_1")
        if IsNull(Descuento1) Then Descuento1 = 0
    clase = " class='FuenteInput' "     

                                              '------Promocion esto es para detectar un producto en promoción en un boucher--    
    if Es_KIT = "S" Or cDbl(Descuento1) > 0 Or Promocion<>"0" Then
        clase = " class='DatoOutputNumerico' readonly " 
    end if  
    
    Descuento = cdbl(rs("Porcentaje_descuento_2")) + cdbl(rs("Porcentaje_descuento_1"))  ' Descuento promocional
    
    Porcentaje_descuento_3 = 0
    if not IsNull(trim(rs("Porcentaje_descuento_3"))) then Porcentaje_descuento_3 = cdbl(rs("Porcentaje_descuento_3"))
    
    Precio = cdbl( rs("Precio_de_lista_modificado") )
    'Cuando el producto mayorista se vende como mayorista (> a cantidad limite) se está aplicando
    'un descuento de mayorista, por lo tanto NO se le puede aplicar: 
    '(1) Descuento Manual o (2) descuento personal
    
    temporada = trim(Ucase(rs("temporada")))
    
    if tipo_cobro_ECO then 'Modificación para productos con descuentos ECONOMATO
      if temporada = "ECO" then Descuento = Porcentaje_descuento_3
    else
      if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" or temporada="500AÑOS" then 
		    Descuento = 0
		    clase = " class='DatoOutputNumerico' readonly " 
	    end if
	  end if
	  
    Precio = ( Precio * ( ( 100 - Descuento ) / 100 ) \ 1 )
    Error_descuento = ""    
    if Descuento > Session("Maximo_descuento_cajera") then
      Error_descuento = "Sobrepasa descuento máximo cajera"
    elseif  Descuento > Session("Maximo_descuento_linea") then
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
    Imagen = "../../imagenes/productos/noimagen.gif"
   %>
<tr id="fila<%=n%>" valing="top" onclick="javascript:cambio_imagen('fila<%=n%>','<%=Imagen%>')" 
bgcolor="<%=ColorLinea%>" class="FuenteInput"> 
    <td align="center" style="width=20px;">&nbsp;<%=n%></td>
    <%if Session("Login")="15309968" or Session("Login")="17238275" or Session("Login")="15582502" or Session("Login")="13971954" or Session("Login")="13884785" or Session("Login")="15308847" or Session("Login")="15923212" or Session("Login")="18184487" or Session("Login")="13859206"  or Session("Login")="17629393" or Session("Login")="17587517"  or Session("Login")="9926612" Or Session("Login") = "19424203" then%>
        <td style="width=150px;">&nbsp;<%=rs("Producto")%><% response.write("- ") %> <%response.write rs("DOCTO")%></td>        
    <%ELSE%>
        <td style="width=150px;">&nbsp;<%=rs("Producto")%></td>
    <%end if%>
    <td style="width=290px;" nowrap>&nbsp;<%=left(trim(rs("Nombre_producto")),40)%></td>
    <td style="width=30px;" align="center"><%=rs("Cantidad_salida")%></td>
    <td style="width=10px;">&nbsp;UN&nbsp;</td>
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
      if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" or temporada="500AÑOS" then
        Descuento = 100 - cdbl(rs("Precio_de_lista_modificado"))*100/cdbl(rs("Precio_de_lista"))
      end if
    end if
    %>
    <td width="40px">&nbsp;
           <%if Session("Login")="15309968" or Session("Login")="13971954" or Session("Login")="15582502" or Session("Login")="17238275" or Session("Login")="13884785" or Session("Login")="15308847" or Session("Login")="15923212" or Session("Login")="18184487" or Session("Login")="13859206"  or Session("Login")="17893185" Or Session("Login") = "19424203"  then
              clase = " class='FuenteInput' "
              end if
            %>
        <input 
        onkeypress="return Valida_Descuento(event);"
        <%=Clase%> style="width: 34px; height: 18px; text-align: right;" type="text" 
        name="Descuento_linea_<%=rs("Numero_de_linea")%>" maxlength="4" value="<%=formatnumber(Descuento,2)%>" 
        onchange="javascript:modifica_descuento_linea(<%=rs("Numero_de_linea")%>)">    
    </td>
    <td width="70px">&nbsp;
        <input <%=Clase%> style="width: 64px; height: 18px; text-align: right;" type="text" name="Precio_<%=rs("Numero_de_linea")%>" maxlength="7" value="<%=Precio%>" onchange="javascript:modifica_precio_linea(<%=rs("Numero_de_linea")%>)"> 
    </td>
    <td align="right" width="70px">&nbsp;<b><%=formatnumber(cint(rs("Cantidad_salida"))*Precio,0)%></b>&nbsp;</td>
    <%if tipo_cobro_ECO and Session("Porcentaje_descuento_empleado") = 0 and Session("xEconomato_temporada") <> "" then%>
      <td align="center" width="10px" style="font-size: 8px;">
      <%if temporada = "ECO" then%>
      <b><font color="#990000">E</font></b>
      <%end if%>
      </td>
    <%else%>
      <%if Existe_Mayorista_en_Lista_DVT then%>
      <td align="center" width="10px" style="font-size: 8px;">
      <%if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" or temporada="500AÑOS" then%>
        <b><font color="#990000">M</font></b>
        <%end if%>  
      </td>
      <%end if%>
    <%end if%>
    <td align="center" class="FuenteInput"><b><%=Error_descuento%></b></td>
</tr>
<%
n = n + 1
rs.movenext
rs_2.movenext
loop
rs.close
rs_2.close
set rs = nothing
set rs_2 = nothing
%>
</table>

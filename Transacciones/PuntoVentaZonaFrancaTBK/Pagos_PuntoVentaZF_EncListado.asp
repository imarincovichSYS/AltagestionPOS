<input type="hidden" id="Linea" name="Linea">
<%if Admite_descuento and Session("Muestra_descuentos") = "Si" then%>
  <div style="position:absolute; top:292px; left:<%=256-delta%>px; z-index:1" style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;"> 
    Descto. Gral. 
    <input onkeypress="return Valida_Descuento(event);" id="Descuento_documento" type="text" name="Descuento_documento" size="4" maxlength="5" value="<%=Descuento_documento%>" style="background-color:#ffffff; color=#000000; font-size: 12px;" onchange="submitform()">
  </div>
<%end if%>

<%=CajaConBordes(289,28-delta,ancho_caja_bg_derecha,194)%>
<div style="position:absolute; top:294px; left:<%=55-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Producto
</div>
<div style="position:absolute; top:294px; left:<%=491-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Cant.
</div>
<div style="position:absolute; top:294px; left:<%=544-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Precio
</div>
<div style="position:absolute; top:294px; left:<%=604-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Dcto.
</div>
<div style="position:absolute; top:294px; left:<%=646-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  P.c/dcto.
</div>
<div style="position:absolute; top:294px; left:<%=716-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Total
</div>
<%tope_cupon        = 5000
Cantidad_cupones  = int(Total_pesos/ tope_cupon)
es_sorteo = "N"
'es_sorteo = "S"
if es_sorteo = "S" then
  if Session("Tipo_documento_venta") = "BOV" and Session("tipo_entidad_comercial") <> "E" and Cantidad_cupones > 0 then 'IF OFICIAL
  %>
    <div style="position:absolute; top:294px; left:<%=716-delta+120%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: normal; line-height: 150%; color:#993300;">
    <b>TOTAL&nbsp;CUPONES: <label style="font-size:22px;"><%=Cantidad_cupones%></label></b>
    </div>
  <%end if
end if%>

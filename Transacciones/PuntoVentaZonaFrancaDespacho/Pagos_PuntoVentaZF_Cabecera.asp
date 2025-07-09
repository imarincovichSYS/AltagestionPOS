<%=CajaConBordes(14,29-delta,82,82)%>
<div style="position:absolute; top:15px; left:<%=30-delta%>px; z-index:1"><img id="imagen" src="<%=Imagen_actual%>" alt="Imagen producto" width="80" height="80" border="0"/></div>

<%=CajaConBordes(14,136-delta,ancho_caja_bg_derecha-108,82)%>
<div style="position:absolute; top:20px; left:<%=140-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Cliente<br>
Dirección<br>
US$ Cambio
</div>
<div style="position:absolute; top:20px; left:<%=236-delta%>px; z-index:1;"  style="color=#666666; font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
<%=Session("Nombre_cliente_boleta")%> ( <%=Session("Cliente_boleta")%> )<br>
<%=session("Direccion_boleta")%>,<%=session("Nombre_comuna_boleta")%><br>
<%=DolarCambioSupervisoraCajas%>
</div>

<div style="position:absolute; top:68px; left:<%=640-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Doc.
</div>
<div style="position:absolute; top:68px; left:<%=710-delta%>px; z-index:2;"  style="color=#666666; font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
<%if Session("Tipo_documento_venta") = "FAV" then%>
Factura # <input Class="" type="text" name="Folio_factura" size="12" maxlength="10" value="<%=Folio_disponible%>" onchange="submitform()">
<%else%>
Boleta: <%=session("Boleta_Actual")%>
<%end if%>
</div>
<%
if Muestra_Mayorista then Total_Pesos = Total_Precio_Normal
%>
<div style="position:absolute; left:<%=530-delta%>px; z-index:1; text-align=right; width:450px; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 40px;
<%if Muestra_Mayorista then%>
  top:6px;">
<%else%>
  top:16px;">
<%end if%>
  <%=replace(formatnumber(Total_pesos,0),",",".")%>
</div>
<%if Muestra_Mayorista then%>
  <div title="<%=Total_Precio_Mayoristas%>" style="position:absolute; top:44px; left:<%=630-delta%>px; z-index:1; text-align=right; width:350px; color=#0B3861; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 24px;">
  <%=replace(formatnumber(Total_Pesos_Incluye_Mayorista,0),",",".")%>
  </div>
<%end if%>

<%if Session("Ver_CIF") = "S" then%>
<div style="position:absolute; top:70px; left:<%=630-delta%>px; z-index:1; text-align=right; width:350px; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 24px;"><%
'if Total_dolares > 0 then 
  
  'response.write replace(formatnumber(Total_dolares,0),",",".") & "US$"
'end if
%><span id="Total_dolares" name="Total_dolares"></span></div>
<%end if%>

<%
'Response.Write "Total_pesos: "&Total_pesos&", tope: "&Session("xEconomato_tope")&", supera tope: "&Session("xEconomato_supera_tope")
'Response.End
%>
<div style="position:absolute; top:70px; left:<%=310-delta%>px; width:330px; height:200px; z-index:1;">
 <a href="javascript:ventanitaerror()"
 <%if cdbl(Total_Monto_Cobros_Eco)  > cdbl(Cant_Documentos_Cobro_ECO) * cdbl(Session("xEconomato_tope")) then%>
    title="<%=Session("MensajeError")%>"
    style="color=#000099; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 11px; text-decoration: blink;">
    <%=left(Session("MensajeError"),46)%>
 <%else%>
    title="<%=Session("MensajeError")%>"
    style="color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px; text-decoration: blink;">
    <%=left(Session("MensajeError"),30)%>
 <%end if%></a>
</div>
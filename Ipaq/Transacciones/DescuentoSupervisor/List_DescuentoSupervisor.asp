<!-- #include file="../../Scripts/Inc/Paginacion.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

	Cajera = Request("Cajera")

Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
%>

<html>

	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Script/Js/Caracteres.js"></script>
	</head>

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
	<form name="Formulario" method="post" action="Paso.asp" target="Paso">
		<table border=0 cellspacing=1 cellpadding=1  rules=none>
			<tr class=FuenteCabeceraTabla>
				<td align=center>Producto</td>
				<td align=left  >Nombre</td>
				<td align=center>Cant.</td>
        <td align=center>Precio</td>
        <td align=center>Descuento</td>
				<td align=center>Total</td>
			</tr>
      
			<%Lineas = 0
        if not rs.eof then
        do while not rs.eof
           Lineas = Lineas + 1
            Descuento = cdbl( rs("Porcentaje_descuento_1") ) + cdbl( rs("Porcentaje_descuento_2") )
            Precio = cdbl( rs("Precio_de_lista_modificado") )
            Precio = ( Precio * ( ( 100 - Descuento ) / 100 ) \ 1 )
          %>
						<tr class=FuenteDetalleTabla>
							<td >&nbsp;<%=Rs("Producto")%>&nbsp;</td>
							<td >&nbsp;<%=Trim(rs("Nombre_producto"))%></td>
              <td nowrap align=center>&nbsp;<%=Trim(rs("Cantidad_salida"))%></td>
              <td align="right"><%=formatnumber(rs("Precio_de_lista_modificado"),0)%>&nbsp;</td>
              <td align="right">
                 <input type="hidden" name="Numero_linea_<%=Lineas%>" value="<%=rs("Numero_de_linea")%>">
                 <input type="hidden" name="Descuento_anterior_<%=Lineas%>" value="<%=Descuento%>">
                 <input type="text" name="Descuento_<%=Lineas%>" value="<%=Descuento%>" size="4" maxlength="5">
              </td>
              <td align="right"><%=formatnumber(cint(rs("Cantidad_salida"))*Precio,0)%>&nbsp;</td>
						</tr>
					<%	rs.MoveNext
			loop
      else%>
				<table Width=95% border=0 cellspacing=2 cellpadding=2 >
				    <tr >
						<td class=FuenteInput><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
					</tr>
				</table>
			<%End If 
      	Rs.Close
				Set Rs = Nothing
		Conn.Close 
		Set Conn = Nothing
	%>
		</table>
		<input type=hidden name="Lineas" value="<%=Lineas%>">
    <input type=hidden name="Cajera" value="<%=Cajera%>">
	</form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

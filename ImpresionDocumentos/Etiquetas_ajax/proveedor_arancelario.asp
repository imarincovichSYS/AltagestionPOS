<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%>
<table>
	<tr>
		<td>Proveedor</td>
		<td><input type="text" id="proveedor" name="proveedor"></td>
		<td><input type="button" value="Buscar" id="bot_buscar" name="bot_buscar"></td>
	</tr>
</table>
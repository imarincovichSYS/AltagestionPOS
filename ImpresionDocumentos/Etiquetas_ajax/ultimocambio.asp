<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%>
<table>
	<tr>
		<td><td><input type="button" value="Listar los ultimos cambios" id="bot_buscar" name="bot_buscar"></td></td>
	</tr>
</table>
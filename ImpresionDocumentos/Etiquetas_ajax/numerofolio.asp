<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%>
<table>
	<tr>
		<td>Ingrese Numero de Folio</td>
		<td><input OnKeyPress="return Valida_Digito(event)" type="text" id="folio" name="folio" maxlength="6"></td>
		<td><input type="button" value="Buscar" id="bot_buscar" name="bot_buscar"></td>
	</tr>
</table>
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%>
<table>
	<tr>
		<td>Ingrese Numero de Guia</td>
		<td><input OnKeyPress="return Valida_Digito(event)" type="text" id="numeroguia" name="numeroguia" maxlength="6"></td>
		<td><input type="button" value="Buscar" id="bot_buscar" name="bot_buscar"></td>
	</tr>
</table>
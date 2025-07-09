<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%><div id="cuerpo">
<table id="buscarcodxdesc" class="buscarcodxdesc">
	<tr>
		<td>C&oacute;digo</td><td><input OnKeyPress="return Valida_AlfaNumerico(event)" type="text" name="producto" id="producto" maxlength="10"></td>
		<td>Descripci&oacute;n</td><td><input OnKeyPress="return Valida_Texto(event)" type="text" name="nombre" id="nombre" maxlength="35"></td>
		<td><input type="button" value="Buscar" id="bot_buscar" name="bot_buscar"></td>
	</tr>
</table>
</div>
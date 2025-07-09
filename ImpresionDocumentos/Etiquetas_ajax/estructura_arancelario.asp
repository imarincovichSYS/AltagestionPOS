<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn_Alta
strSQL="select superfamilia, (superfamilia+' - '+nombre) as nombre from superfamilias order by nombre"
Set rs = ConnAlta.Execute(strSQL)
%>
</script>
<table>
	<tr>
		<td>Super Familia: </td>
		<td>
			<div id="div_superfamilia" name="div_superfamilia" style="width:210px;">
				<select name="superfamilia" id="superfamilia" style="font-size: 11px; width:200px;">
					<%Do While Not rs.EOF%>
					<option value="<%=rs("superfamilia")%>"><%=Left(rs("nombre"),35)%></option>
					<%rs.MoveNext
					loop%>
				</select>
			</div>
		</td>
		<td><div>Familia:</div></td>
		<td><div id="div_familia" name="div_familia" style="width:210px;"></div></td>
		<td><div>Sub Familia:</div></td>
		<td><div id="div_subfamilia" name="div_subfamilia" style="width:210px;"></div></td>
		<td><input type="button" id="bot_buscar" name="bot_buscar" value="Buscar"></td>
	</tr>
</table>
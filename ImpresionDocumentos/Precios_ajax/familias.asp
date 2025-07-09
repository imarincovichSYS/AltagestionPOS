<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

	superfamilia = unescape(Request.Form("superfamilia"))
	OpenConn_Alta
	strSQL="select familia, (familia+ ' - ' +nombre) as nombre from familias where superfamilia='"&superfamilia&"' order by nombre"
	Set rs = ConnAlta.Execute(strSQL)
%>
<select id="familia" name="familia" style="font-size: 11px; width:200px;">
	<option value=""></option>
	<%Do While Not rs.EOF%>
		<option value="<%=rs("familia")%>"><%=Left(rs("nombre"),35)%></option>
	<%rs.MoveNext
	loop%>
</select>
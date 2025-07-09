<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

	superfamilia = Request.Form("superfamilia")
	familia = Request.Form("familia")
	OpenConn_Alta
	strSQL="select subfamilia, (subfamilia+ ' - ' +nombre) as nombre from subfamilias where superfamilia='"&superfamilia&"' and familia='"&familia&"' order by nombre"
	Set rs = ConnAlta.Execute(strSQL)
%>
<select id="subfamilia" name="subfamilia" style="font-size: 11px; width:200px;">
	<option value=""></option>
	<%Do While Not rs.EOF%>
		<option value="<%=rs("subfamilia")%>"><%=Left(rs("nombre"),35)%></option>
	<%rs.MoveNext
	loop%>
</select>
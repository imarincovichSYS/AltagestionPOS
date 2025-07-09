<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	superfamilia = Request.Form("superfamilia")
	familia = Request.Form("familia")
	OpenConn_Alta
	strSQL="select subfamilia, (familia+ ' - ' +nombre) as nombre from subfamilias where superfamilia='"&superfamilia&"' and familia='"&familia&"' order by nombre"
	Set rs = ConnAlta.Execute(strSQL)
%>
<select id="subfamilia" name="subfamilia">
	<%Do While Not rs.EOF%>
		<option value="<%=rs("subfamilia")%>"><%=Left(rs("nombre"),35)%></option>
	<%rs.MoveNext
	loop%>
</select>
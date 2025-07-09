<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
superfamilia  = Unescape(Request.Form("superfamilia"))
familia       = Unescape(Request.Form("familia"))
strSQL="select subfamilia, nombre from subfamilias where superfamilia='"&superfamilia&"' and familia='"&familia&"' and Vigente = 'S' order by subfamilia"
set rs = Conn.Execute(strSQL)
%>
<select id="subfamilia1" name="subfamilia1" style="width:240px;">
<%do while not rs.EOF%>
  <option value="<%=trim(rs("subfamilia"))%>"><%=trim(rs("subfamilia"))%>-<%=trim(rs("nombre"))%></option>
<%rs.MoveNext
loop%>
</select>
<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
superfamilia  = Unescape(Request.Form("superfamilia"))
familia       = Unescape(Request.Form("familia"))
strSQL="select subfamilia, nombre from subfamilias where superfamilia='"&superfamilia&"' and familia='"&familia&"' order by subfamilia"
set rs = Conn.Execute(strSQL)
%>
<select 
OnkeyUp="SetKey(event);if(key==13)nombre_producto_nuevo.focus();"
OnChange="Get_Nuevo_Codigo('<%=superfamilia%>','<%=familia%>',this.value);"
id="subfamilia" name="subfamilia" style="width:240px;">
<%do while not rs.EOF%>
  <option value="<%=trim(rs("subfamilia"))%>"><%=trim(rs("subfamilia"))%>-<%=trim(rs("nombre"))%></option>
<%rs.MoveNext
loop%>
</select>
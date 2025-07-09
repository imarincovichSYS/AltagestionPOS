<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
superfamilia = Unescape(Request.Form("superfamilia"))
strSQL="select familia, nombre from familias where superfamilia='"&superfamilia&"' and Vigente = 'S' order by familia"
set rs = Conn.Execute(strSQL)
%>
<select 
OnkeyUp="SetKey(event);if(key==13){$('subfamilia1').focus();}"
OnChange="Cargar_SubFamilias1($('td_subfamilia1'));"
id="familia1" name="familia1" style="width:240px;">
<%do while not rs.EOF%>
  <option value="<%=trim(rs("familia"))%>"><%=trim(rs("familia"))%>-<%=trim(rs("nombre"))%></option>
<%rs.MoveNext
loop%>
</select>
<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn
anio = Request.Form("anio")
anio = 2010
strSQL="select carpeta, n_carpeta from carpetas where empresa='SYS' and year(fecha)="&anio
set rs = Conn.Execute(strSQL)
%>
<select 
OnChange=""
id="carpeta" name="carpeta" style="width:120px;">
<%do while not rs.EOF%>
  <option value="<%=trim(rs("familia"))%>"><%=trim(rs("familia"))%>-<%=trim(rs("nombre"))%></option>
<%rs.MoveNext
loop%>
</select>
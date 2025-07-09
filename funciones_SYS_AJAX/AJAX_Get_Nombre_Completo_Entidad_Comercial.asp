<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

entidad_comercial = Ucase(unescape(trim(Request.Form("entidad_comercial"))))
strSQL = "select Apellidos_persona_o_nombre_empresa, Nombres_persona " &_
         "from entidades_comerciales where empresa='SYS' and entidad_comercial='"&entidad_comercial&"'"
'Response.Write strSQL
'Response.End
OpenConn
set rs = Conn.Execute(strSQL)
if not rs.EOF then Response.Write Get_Texto_Tipo_Oracion(rs("Apellidos_persona_o_nombre_empresa") & " " & rs("Nombres_persona"))
%>
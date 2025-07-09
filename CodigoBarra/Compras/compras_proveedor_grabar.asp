<!--#include file="../_private/config.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
on error resume next
accion            = Request.Form("accion")
entidad_comercial = Request.Form("entidad_comercial")
nom_campo         = Unescape(Request.Form("nom_campo"))
valor             = Ucase(trim(Unescape(Request.Form("valor"))))
nom_tabla         = "entidades_comerciales"
OpenConn
if accion = "insertar" then
  strSQL="insert into "&nom_tabla&"(empresa,entidad_comercial,Apellidos_persona_o_nombre_empresa,Cliente_bloqueado,Direccion,Fax," &_
         "Giro_o_profesion,Mail,Nombres_persona,Persona_o_empresa,Telefono,Pais,Rut_entidad_comercial,tipo_entidad_comercial) values " &_
         "('SYS','"&entidad_comercial&"','','N','---',0,'Sin giro','','','E','0','CL','"&entidad_comercial&"','P')"
elseif accion = "actualizar" then
  strSQL="update "&nom_tabla&" set "&nom_campo&"='"&valor&"' where empresa='SYS' and entidad_comercial='"&entidad_comercial&"'"
end if
'Response.Write strSQL
'Response.End
set rs_grabar = Conn.Execute(strsql)
if err <> 0 then
  Response.Write err.Source & ", " & err.number & ", " & err.Description
  Response.End
end if
%>
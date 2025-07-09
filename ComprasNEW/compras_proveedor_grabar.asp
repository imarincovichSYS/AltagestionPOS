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
         "Giro_o_profesion,Mail,Nombres_persona,Persona_o_empresa,Telefono,Pais,Rut_entidad_comercial,tipo_entidad_comercial, Clasificacion_proveedor, comuna) values " &_
         "('SYS','"&entidad_comercial&"','','N','---',0,'Sin giro','','','E','0','CL','"&entidad_comercial&"','P','A','.')"
elseif accion = "actualizar" then
  strSetUpdate = " " & nom_campo & " = '" & valor & "' " 
  if trim(nom_campo) = "comuna" then
    'Obtener información relacionada a la comuna
    strSQL="select comuna, region, pais from comunas with(nolock) where comuna = '" & valor & "'"
    set rs_comuna = Conn.Execute(strSQL)
    if not rs_comuna.EOF then
      estado_o_region = trim(rs_comuna("region"))
      pais            = trim(rs_comuna("pais"))
      strSetUpdate    = strSetUpdate & ", ciudad_o_comuna = '" & valor & "', estado_o_region = '" & estado_o_region & "', pais = '" & pais & "' "
    end if
  end if
  strSQL="update " & nom_tabla & " set  " & strSetUpdate & " where empresa='SYS' and entidad_comercial='" & entidad_comercial & "'"
end if
'Response.Write strSQL
'Response.End
Conn.Execute(strsql)
if err <> 0 then
  Response.Write err.Source & ", " & err.number & ", " & err.Description
  Response.End
end if
%>
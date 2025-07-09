<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

sub Get_Nombre_y_CodigoPostal_Proveedor(v_entidad_comercial)
  strSQL="select Apellidos_persona_o_nombre_empresa as nombre_proveedor, codigo_postal from entidades_comerciales where empresa='SYS' and entidad_comercial='"&v_entidad_comercial&"'"
  set v_rs = Conn.Execute(strsql) : v_nombre_proveedor = "" : v_codigo_postal = ""
  if not v_rs.EOF then 
    v_nombre_proveedor  = v_rs("nombre_proveedor") 
    v_codigo_postal     = v_rs("codigo_postal")
  end if
end sub

OpenConn
proveedor = Request.Form("proveedor")
v_nombre_proveedor = "" : v_codigo_postal = ""
Get_Nombre_y_CodigoPostal_Proveedor proveedor
strOutput = "{""nombre_proveedor"":""" & v_nombre_proveedor & """,""codigo_postal"":""" & v_codigo_postal & """}"
Response.Write strOutput
%>
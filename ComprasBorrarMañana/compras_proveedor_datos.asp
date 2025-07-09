<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

entidad_comercial = Request.Form("entidad_comercial")
fecha_recepcion   = Request.Form("fecha_recepcion")
if fecha_recepcion = "" then fecha_recepcion = date()
nom_tabla         = "entidades_comerciales"
OpenConn
strSQL="select apellidos_persona_o_nombre_empresa, IsNull(condicion_de_pago,'CONTADO') condicion_de_pago, codigo_postal " &_
       "from "&nom_tabla&" where empresa='SYS' and entidad_comercial='"&entidad_comercial&"'"
set rs = Conn.Execute(strsql) : nombre = ""
if not rs.EOF then 
  empresa           = Left(Ucase(trim(rs("apellidos_persona_o_nombre_empresa"))),40)
  codigo_postal     = trim(rs("codigo_postal"))
  condicion_de_pago = Ucase(trim(rs("condicion_de_pago")))
  if condicion_de_pago = "CONTADO" then
    condicion_de_pago = 0
  elseif condicion_de_pago = "PAGO_EN_US$" then
    condicion_de_pago = 0
  else
    condicion_de_pago = replace(condicion_de_pago,right(condicion_de_pago,4),"")
  end if
  fecha_pago = dateadd("d",condicion_de_pago,fecha_recepcion)
  %>
  <script language="javascript">
  $("codprov_proveedor").value                     = "<%=codigo_postal%>"
  //label_fec_pago.innerText                  = "<%=fecha_pago%>"
  //hidden_condicion_de_pago.value            = "<%=condicion_de_pago%>"
  </script>
<%end if%>
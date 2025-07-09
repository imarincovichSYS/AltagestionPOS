<!--#include file="../_private/funciones_generales.asp" -->
<%
Nombre_DSN = "AG_Sanchez_Productivo"
'Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys/altagestion/"

SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn.commandtimeout=600

function Get_Nombre_Entidad_Comercial(v_entidad_comercial)
  strSQL="select Nombres_persona, Apellidos_persona_o_nombre_empresa from entidades_comerciales where empresa='SYS' and entidad_comercial='"&v_entidad_comercial&"'"
  set v_rs = Conn.Execute(strSQL) : nombre = ""
  if not v_rs.EOF then nombre = v_rs("Nombres_persona") & " " & v_rs("Apellidos_persona_o_nombre_empresa")
  Get_Nombre_Entidad_Comercial = nombre
end function

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

'codigo  = Ucase(trim(Request.Form("codigo")))
entidad_comercial = "15309712"

strSQL="select top 1 Fecha_emision fecha, Monto_venta_neta_moneda_oficial valor from Documentos_valorizados where " &_
       "empresa = 'SYS' AND empleado_responsable='"&entidad_comercial&"' AND Tipo_documento = 'VTA' " &_
       "AND Fecha_emision between '2010/12/21 00:00:00' and '2010/12/21 23:59:59'" &_
       "order by Fecha_emision desc"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  v_nombre  = Left(Get_Texto_Tipo_Oracion(Get_Nombre_Entidad_Comercial(entidad_comercial)),17) & "..."
  valor     = rs("valor")
end if

strSQL="select sum(Monto_venta_neta_moneda_oficial) total from Documentos_valorizados where " &_
       "empresa = 'SYS' AND empleado_responsable='"&entidad_comercial&"' AND Tipo_documento = 'VTA' " &_
       "AND Fecha_emision between '2010/12/21 00:00:00' and '2010/12/21 23:59:59'"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then total  = rs("total")
%>
<table width="100%" cellPadding="0" cellSpacing="0" align="center">
<tr id="texto_10" align="center">
  <td colspan="2"><b>Cajero(a):</td>
</tr>
<tr id="texto_10" align="center">
  <td colspan="2"><%=v_nombre%></td>
</tr>
<tr id="texto_10">
  <td width="44"><b>Venta($):</td>
  <td align="right"><%=FormatNumber(valor,0)%></td>
</tr>
<tr id="texto_10">
  <td><b>Total($):</td>
  <td align="right"><%=FormatNumber(total,0)%></td>
</tr>
</table>
<%
rs.close
set rs = nothing
Conn.Close
set Conn = nothing%>
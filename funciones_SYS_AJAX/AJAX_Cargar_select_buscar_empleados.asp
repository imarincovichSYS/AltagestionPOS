<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

datos       = Ucase(unescape(trim(Request.Form("datos"))))
nom_campo   = Request.Form("nom_campo")
width_campo = Request.Form("width_campo")

strSQL = "select entidad_comercial, Apellidos_persona_o_nombre_empresa, Nombres_persona " &_
         "from entidades_comerciales where empresa='SYS' and Tipo_entidad_comercial='E' and Persona_o_empresa='P' and " &_
         "(Upper(ltrim(rtrim(Apellidos_persona_o_nombre_empresa))) like '%"&datos&"%' or " &_
         "ltrim(rtrim(Nombres_persona)) like '%"&datos&"%') order by Apellidos_persona_o_nombre_empresa"
'Response.Write strSQL
'Response.End
OpenConn
set rs = server.CreateObject("ADODB.RECORDSET")		
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
%>
<select OnClick="Seleccionar_Empleado(this.value);Cargar_Ubicacion_Empleado();" total_lista_select = "<%=rs.RecordCount-1%>"
style="width:<%=width_campo%>px; font-family: courier new; font-size: 11px;" 
size="6" id="<%=nom_campo%>" name="<%=nom_campo%>">
<%
do while not rs.EOF
	entidad_comercial = trim(rs("entidad_comercial"))
	nombre            = Left(Get_Texto_Tipo_Oracion(trim(rs("Apellidos_persona_o_nombre_empresa"))),30) & " " & Get_Texto_Tipo_Oracion(trim(rs("Nombres_persona")))
	
	for i=len(nombre) to 30
	  nombre = nombre & "&nbsp;"
	next
	str_datos = nombre & "|" & entidad_comercial
  %>
  <option value="<%=entidad_comercial%>"><%=str_datos%></option>
  <%
  total_lista_tmp=total_lista_tmp+1
  band = true
  rs.MoveNext
loop
%>
</select>
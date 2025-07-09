<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

datos       = Ucase(unescape(trim(Request.Form("datos"))))
nom_campo   = Request.Form("nom_campo")
width_campo = Request.Form("width_campo")

strSQL = "select entidad_comercial, codigo_postal, Apellidos_persona_o_nombre_empresa, Nombres_persona " &_
         "from entidades_comerciales where empresa='SYS' and " &_
         "(Tipo_entidad_comercial='P' or Tipo_entidad_comercial='A') and " &_
         "Persona_o_empresa='E' and codigo_postal is not null and rtrim(ltrim(codigo_postal))<>'' and " &_
         "(Upper(ltrim(rtrim(Apellidos_persona_o_nombre_empresa))) like '%"&datos&"%' or " &_
         "ltrim(rtrim(codigo_postal)) like '%"&datos&"%') order by codigo_postal"
'Response.Write strSQL
'Response.End
OpenConn
set rs = server.CreateObject("ADODB.RECORDSET")		
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
%>
<select OnClick="Seleccionar_Proveedor(this.value);Actualizar_Datos_Inventario('proveedor',$('select_busqueda_proveedor').value)" total_lista_select = "<%=rs.RecordCount-1%>"
style="width:<%=width_campo%>px; font-family: courier new; font-size: 11px;" 
size="6" id="<%=nom_campo%>" name="<%=nom_campo%>">
<%
do while not rs.EOF
	entidad_comercial = trim(rs("entidad_comercial"))
	codigo_postal     = trim(rs("codigo_postal"))
	nombre            = Left(Get_Texto_Tipo_Oracion(trim(rs("Apellidos_persona_o_nombre_empresa"))),30)
	for i=len(codigo_postal) to 12
	  codigo_postal = codigo_postal & "&nbsp;"
	next
	for i=len(nombre) to 30
	  nombre = nombre & "&nbsp;"
	next
	str_datos = codigo_postal & "|" & nombre & "|" & entidad_comercial
  %>
  <option cod_prov="<%=codigo_postal%>" value="<%=entidad_comercial%>"><%=str_datos%></option>
  <%
  total_lista_tmp=total_lista_tmp+1
  band = true
  rs.MoveNext
loop
%>
</select>
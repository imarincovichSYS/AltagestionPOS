<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../ACIDGrid3/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

entidad_comercial = Request.Form("entidad_comercial")

width     = "940"
height    = "50"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")		
set rs      = server.CreateObject("ADODB.RECORDSET")		
%><!-- #include file = "compras_proveedor_config_cols.asp" --><%
OpenConn
nom_tabla = "entidades_comerciales"
num_grid  = 1 'Número de la grilla en la página
tipo_scroll = 4 ' 4 = "overflow: auto;"
strSQL="select apellidos_persona_o_nombre_empresa, direccion, telefono, codigo_postal, comuna " &_
       "from "&nom_tabla&" where empresa='SYS' and entidad_comercial='"&entidad_comercial&"'"
'Response.Write strSQL
'Response.End
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
set grid.recordset = rs	
grid.Height = height : grid.Width = width : grid.TH_Height = TH_Height
grid.num_grid = num_grid : grid.tipo_scroll = tipo_scroll : grid.marcarFilaClickCheckbox = "1"
strHTML = grid.get_drawGrid()
%>
<script language="javascript">var nom_tabla = "<%=nom_tabla%>";</script>
<table bgcolor="#FFFFFF" align="center" width="<%=width_tmp%>" border=0 cellpadding=0 cellspacing=0>
<tr><td id="t<%=num_grid%>" name="t<%=num_grid%>" t_rows=""><%=strHTML%></td></tr>
</table>
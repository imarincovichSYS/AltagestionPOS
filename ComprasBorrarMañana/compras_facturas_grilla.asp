<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../ACIDGrid3/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
cantidad_documentos                     = Request.Form("cantidad_documentos")

width     = "400"
height    = "50"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")		
set rs      = server.CreateObject("ADODB.RECORDSET")		
%><!-- #include file = "compras_facturas_config_cols.asp" --><%
OpenConn
nom_tabla = "documentos_no_valorizados_facturas"
num_grid  = 2 'Número de la grilla en la página
tipo_scroll = 3 ' 4 = "overflow: auto; 3= overflow: scroll;"

if accion = "NUEVO" then
  '1°: Obtener el max(num linea) para ingresar los siguientes registros a partir desde ese num linea
  'ITEMES
  strSQL="select IsNull(max(numero_linea),0) num_linea from "&nom_tabla&" where numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado
  'Response.Write strSQL&"<br>"
  'Response.End
  set rs = Conn.Execute(strSQL) 'Si no existen registros, la consulta devolverá un "0" (IsNull(max),0)
  num_linea = rs("num_linea")
  '2°: Insertar la cantidad = items de registros desde el max(num_linea) + 1
  for i=1 to cantidad_documentos
    num_linea = num_linea + 1
    strSQL="insert into "&nom_tabla&"(numero_interno_documento_no_valorizado, numero_linea) values("&numero_interno_documento_no_valorizado&", "&num_linea&")"       
    'Response.Write strSQL&"<br><br>"
    'Response.End
    set rs = Conn.Execute(strSQL)
  next
  'Response.End
end if

strSQL="select '', numero_linea, tipo_gasto, numero_factura_original, numero_factura_parcial, numero_factura_final, total, monto, observacion " &_
       "from "&nom_tabla&" where numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" order by numero_linea"
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
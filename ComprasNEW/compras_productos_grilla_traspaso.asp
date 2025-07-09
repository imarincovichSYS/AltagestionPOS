<%@ Language=VBScript %>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<!--#include file="../ACIDGrid3/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

anio                            = Request.Form("anio")
documento_respaldo              = Request.Form("documento_respaldo")
numero_documento_respaldo       = Request.Form("numero_documento_respaldo")
documento_no_valorizado         = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado  = Request.Form("numero_documento_no_valorizado")

width     = "546"
height    = "296"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")		
set rs      = server.CreateObject("ADODB.RECORDSET")		
%><!-- #include file = "compras_productos_config_cols_traspaso.asp" --><%
OpenConn
nom_tabla = "movimientos_productos"
num_grid  = 1 'Número de la grilla en la página
tipo_scroll = 4 ' 4 = "overflow: auto;"
strSQL="select numero_de_linea_en_rcp_o_documento_de_compra, numero_de_linea_destino, producto, " &_
       "nombre_producto, cantidad_mercancias, IsNull(cantidad_traspaso,0) cantidad_traspaso from "&nom_tabla&" with(nolock) " &_
       "where empresa='SYS' and documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "cantidad_mercancias > 0 " &_
       "order by numero_de_linea_en_rcp_o_documento_de_compra"
'Response.Write strSQL
'Response.End
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
set grid.recordset = rs	
grid.scroll_Div_Totales = "0"
grid.Height = height : grid.Width = width : grid.TH_Height = TH_Height
grid.num_grid = num_grid : grid.tipo_scroll = tipo_scroll : grid.marcarFilaClickCheckbox = "1"
strHTML = grid.get_drawGrid()
%>
<script language="javascript">
var nom_tabla = "<%=nom_tabla%>";
var height_tmp= "<%=height%>"</script>
<table bgcolor="#FFFFFF" align="center" width="<%=width_tmp%>" border=0 cellpadding=0 cellspacing=0>
<tr><td id="t<%=num_grid%>" name="t<%=num_grid%>" t_rows=""><%=strHTML%></td></tr>
</table>

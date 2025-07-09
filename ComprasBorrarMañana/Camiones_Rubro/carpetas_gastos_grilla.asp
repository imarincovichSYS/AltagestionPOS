<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../ACIDGrid/grid.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
accion              = Request.Form("accion")
fec_anio_mes        = anio & "/" & mes & "/1"

width     = "486"
height    = "336"
TH_Height = "26"

fecha_hoy     = Get_Fecha_Hoy()
hora          = Left(time(),8)
dim grid, col, rscombo
set grid = new agrid	
set rscombo = server.CreateObject("ADODB.RECORDSET")		
set rs      = server.CreateObject("ADODB.RECORDSET")		
%><!-- #include file = "carpetas_gastos_config_cols.asp" --><%
OpenConn
nom_tabla = "carpetas_final_gastos"
strSQL="select '', A.id_gasto, B.n_gasto, A.valor, A.nom_archivo from  " &_
       "(select id_gasto, valor, nom_archivo from "&nom_tabla&" " &_
       "where documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta&") A, " &_
       "(select id_gasto, n_gasto from tb_gastos) B " &_
       "where A.id_gasto=B.id_gasto order by A.id_gasto"
'Response.Write strSQL
'Response.End
rs.CursorType=3 : rs.CursorLocation=3 : rs.LockType=1 : rs.Open strsql, Conn
set grid.recordset = rs	
grid.scroll_Div_Totales = "0"
grid.Height = height : grid.Width = width : grid.TH_Height = TH_Height
strHTML = grid.get_drawGrid()
%>
<script language="javascript">
var nom_tabla = "<%=nom_tabla%>";
var height_tmp= "<%=height%>"</script>
<table bgcolor="#FFFFFF" align="center" width="<%=width%>" border=0 cellpadding=0 cellspacing=0>
<tr><td id="t" name="t"><%=strHTML%></td></tr>
</table>
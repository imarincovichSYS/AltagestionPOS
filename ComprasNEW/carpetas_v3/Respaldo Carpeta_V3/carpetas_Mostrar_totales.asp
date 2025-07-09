<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")

openConn
fec_anio_mes  = anio & "/" & Lpad(mes,2,0) & "/01"

TotalBultos = 0
TotalCBM = 0
TotalKG = 0

strSQL="select " &_
       "TotalBultos = isNull( Total_Bultos, 0 ), " &_
       "TotalCBM = isNull( Total_CBM, 0 ), " &_
       "TotalKG = isNull( Total_KG, 0 ) " &_
       "from carpetas_final where documento_respaldo='"&documento_respaldo&"' and " &_
       "anio_mes = '"&fec_anio_mes&"' and num_carpeta = " & num_carpeta
'response.write strSQL
'response.end
set rs = Conn.Execute(strSQL)
if not rs.EOF then
  TotalBultos = rs("TotalBultos")
  TotalCBM = rs("TotalCBM")
  TotalKG = rs("TotalKG")
  if isNull( TotalBultos ) then TotalBultos = 0
  if isNull( TotalCBM ) then TotalCBM = 0
  if isNull( TotalKG ) then TotalKG = 0
end if
rs.close
set rs = Nothing
Conn.close

Response.write( TotalBultos & "|" & TotalCBM & "|" & TotalKG & "|" )
%>

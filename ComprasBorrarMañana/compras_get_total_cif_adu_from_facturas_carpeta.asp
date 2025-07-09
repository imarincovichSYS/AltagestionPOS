<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

function Get_Tot_Cif_Adu_From_Facturas_Carpeta(x_carpeta)
  array_id_carpeta    = Split(x_carpeta,"-")
  documento_respaldo  = array_id_carpeta(0)
  anio                = array_id_carpeta(1)
  mes                 = array_id_carpeta(2)
  num_carpeta         = array_id_carpeta(3)
  
  fec_anio_mes = anio & "/" & Lpad(mes,2,0) & "/1"
  strSQL="select IsNull(sum(monto_total_us$),0) as tot_cif_adu from carpetas_final_detalle " &_
         "where documento_respaldo='" & documento_respaldo & "' and anio_mes='"  &fec_anio_mes & "' and num_carpeta=" & num_carpeta
  'Response.Write strSQL
  'Response.End
  set v_rs = Conn.Execute(strSQL) : v_tot_cif_adu = 0
  if not v_rs.EOF then v_tot_cif_adu = v_rs("tot_cif_adu")
  Get_Tot_Cif_Adu_From_Facturas_Carpeta = v_tot_cif_adu
end function

carpeta = Request.Form("carpeta")
OpenConn
Response.Write FormatNumber(Get_Tot_Cif_Adu_From_Facturas_Carpeta(carpeta),2)
%>
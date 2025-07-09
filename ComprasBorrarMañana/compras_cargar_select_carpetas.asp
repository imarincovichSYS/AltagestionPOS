<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
if documento_respaldo = "DS" then documento_respaldo = "R"
anio                = Request.Form("anio")
'response.write anio
'response.end
OpenConn
'response.write month(date())
'response.end
if cdbl(month(date())) <= 3 then
  strSQL="select A.anio_mes, A.num_carpeta, B.n_transporte from " &_
         "(select anio_mes, num_carpeta, id_transporte from carpetas_final " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes +1  >= getdate()- 720) A," &_
         "(select id_transporte, n_transporte from tb_transportes) B " &_
         "where A.id_transporte=B.id_transporte order by A.anio_mes desc, A.num_carpeta desc"
else
  strSQL="select A.anio_mes, A.num_carpeta, B.n_transporte from " &_
         "(select anio_mes, num_carpeta, id_transporte from carpetas_final " &_
         "where documento_respaldo='"&documento_respaldo&"' and year(anio_mes)>='"&anio&"' and month(anio_mes)>month(getdate())-15) A," &_
         "(select id_transporte, n_transporte from tb_transportes) B " &_
         "where A.id_transporte=B.id_transporte order by A.anio_mes desc, A.num_carpeta desc"
end if
'response.write strsql
'response.end
set rs = Conn.Execute(strsql)

%>
<select OnChange="if(this.value!='')Asignar_Carpeta();"
id="carpeta" name="carpeta" style="width: 120px;" old_value="">
  <option costo_flete_transporte="1" transporte="" value=""></option>
<%do while not rs.EOF
  id_carpeta  = documento_respaldo & "-" & year(rs("anio_mes")) & "-" & month(rs("anio_mes")) & "-" & rs("num_carpeta")
  n_carpeta   = documento_respaldo & "-" & year(rs("anio_mes")) & "-" & Lpad(month(rs("anio_mes")),2,0) & ", N°: " & rs("num_carpeta") & "(" & Left(rs("n_transporte"),1) & ")"
  if rs("n_transporte") = "TERRESTRE" then
    costo_flete_transporte = Get_Costo_Flete_Transporte_Dolar("COSTOTUS$")
  elseif rs("n_transporte") = "MARITIMO" then
    costo_flete_transporte = Get_Costo_Flete_Transporte_Dolar("COSTOMUS$")
  elseif rs("n_transporte") = "AEREO" then
    costo_flete_transporte = Get_Costo_Flete_Transporte_Dolar("COSTOAUS$")
  end if
  %>
  <option costo_flete_transporte="<%=costo_flete_transporte%>" transporte="<%=rs("n_transporte")%>" value="<%=id_carpeta%>"><%=n_carpeta%></option>
<%rs.MoveNext
loop%>
</select>

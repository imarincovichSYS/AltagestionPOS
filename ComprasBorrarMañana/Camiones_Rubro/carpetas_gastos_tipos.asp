<!--#include file="../../_private/config.asp" -->
<%
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
id_gasto            = Request.Form("id_gasto")
OpenConn
fec_anio_mes = anio & "/" & mes & "/1"
strSQL="select A.id_gasto, B.n_gasto from " &_
       "(select id_gasto from tb_gastos T1 " &_
       "WHERE NOT EXISTS " &_
       "(select id_gasto from carpetas_final_gastos T2 " &_
       "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and " &_
       "num_carpeta=1 and T1.id_gasto=T2.id_gasto)) A, " &_
       "(select id_gasto, n_gasto from tb_gastos) B " &_
       "where A.id_gasto=B.id_gasto order by n_gasto"
set rs = Conn.Execute(strSql)
%>
<select id="id_gasto" name="id_gasto" style="width: 200px;">
<%do while not rs.EOF%>
  <option value="<%=rs("id_gasto")%>"><%=rs("n_gasto")%></option>
<%rs.MoveNext
loop%>
</select>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo = Request.Form("documento_respaldo")
documento_respaldo_original  = Request.Form("documento_respaldo")
if documento_respaldo = "DS" then documento_respaldo = "R"
anio = Request.Form("anio")

OpenConn

' 
if cdbl(month(date())) <= 4 then
  strSQL="select A.anio_mes, A.num_carpeta, B.n_transporte, A.Fecha_recepcion, A.Documento_respaldo, A.Fecha_aduana, A.Numero_aduana, A.carpeta, A.Manifiesto from " &_
         "(select anio_mes, num_carpeta, id_transporte, Fecha_recepcion, Documento_respaldo, Fecha_aduana, Numero_aduana, carpeta, Manifiesto from carpetas_final  (nolock) " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes +1  >= getdate()- 720) A," &_
         "(select id_transporte, n_transporte from tb_transportes  (nolock) ) B " &_
         "where A.id_transporte=B.id_transporte order by A.anio_mes desc, A.num_carpeta desc"

         '"where anio_mes +1  >= getdate()- 720 and Fecha_recepcion is not Null) A," &_
         '"where documento_respaldo='"&documento_respaldo&"' and anio_mes +1  >= getdate()- 720) A," &_
else
  strSQL="select A.anio_mes, A.num_carpeta, B.n_transporte, A.Fecha_recepcion, A.Documento_respaldo, A.Fecha_aduana, A.Numero_aduana, A.carpeta, A.Manifiesto from " &_
         "(select anio_mes, num_carpeta, id_transporte, Fecha_recepcion, Documento_respaldo, Fecha_aduana, Numero_aduana, carpeta, Manifiesto from carpetas_final  (nolock) " &_
         "where documento_respaldo='"&documento_respaldo&"' and year(anio_mes)>='"&anio&"' and month(anio_mes)>month(getdate())-15) A," &_
         "(select id_transporte, n_transporte from tb_transportes (nolock) ) B " &_
         "where A.id_transporte=B.id_transporte order by A.anio_mes desc, A.num_carpeta desc"

         '"where year(anio_mes)>='"&anio&"' and month(anio_mes)>month(getdate())-15) A," &_
         '"where documento_respaldo='"&documento_respaldo&"' and year(anio_mes)>='"&anio&"' and month(anio_mes)>month(getdate())-15) A," &_
end if
'response.write strsql
'response.end
set rs = Conn.Execute(strsql)
%>
<% if documento_respaldo = "Z" then %>
<select OnChange="if(this.value!=''){Asignar_Carpeta();Asignar_NumAduana();}else{alert(this.value)}" <!--'No hay facturas de Mercaderia.'-->
<% else %>
<select OnChange="if(this.value!='')Asignar_Carpeta();"
<% end if %>
id="carpeta" name="carpeta" style="width: 120px;" old_value="">
  <option costo_flete_transporte="1" transporte="" value=""></option>
<%costo_flete_transporte_TERRESTRE = Get_Costo_Flete_Transporte_Dolar("COSTOTUS$")
  costo_flete_transporte_MARITIMO = Get_Costo_Flete_Transporte_Dolar("COSTOMUS$")
  costo_flete_transporte_AEREO = Get_Costo_Flete_Transporte_Dolar("COSTOAUS$")
  do while not rs.EOF
    id_carpeta  = trim( rs( "documento_respaldo" ) ) & "-" & year(rs("anio_mes")) & "-" & month(rs("anio_mes")) & "-" & rs("num_carpeta")
    n_carpeta   = trim( rs( "documento_respaldo" ) ) & "-" & year(rs("anio_mes")) & "-" & Lpad(month(rs("anio_mes")),2,0) & ", N°: " & rs("num_carpeta") & "(" & Left(rs("n_transporte"),1) & ")"
  if rs("n_transporte") = "TERRESTRE" then
    costo_flete_transporte = costo_flete_transporte_TERRESTRE   'Get_Costo_Flete_Transporte_Dolar("COSTOTUS$")
  elseif rs("n_transporte") = "MARITIMO" then
    costo_flete_transporte = costo_flete_transporte_MARITIMO    'Get_Costo_Flete_Transporte_Dolar("COSTOMUS$")
  elseif rs("n_transporte") = "AEREO" then
    costo_flete_transporte = costo_flete_transporte_AEREO       'Get_Costo_Flete_Transporte_Dolar("COSTOAUS$")
  end if

    if documento_respaldo = "Z" then
        valorTotal = 0
        totalBultos = 0
        Proveedor = ""
        ' 
        strSQL = "select Valor = SUM( monto_final_us$ ), nBultos = SUM( case when id_tipo_factura =  1 then Bultos else 0 end ), Proveedor = MAX( case when id_tipo_factura =  1 then entidad_comercial else '' end ) "
        strSQL = strSQL & "from carpetas_final cf (nolock), carpetas_final_detalle cfd (nolock) "
        strSQL = strSQL & "where carpeta = '" & rs( "carpeta" ) & "' "
        strSQL = strSQL & "and cf.documento_respaldo = cfd.documento_respaldo "
        strSQL = strSQL & "and cf.anio_mes = cfd.anio_mes "
        strSQL = strSQL & "and cf.num_carpeta = cfd.num_carpeta "
        set rsTotal = Conn.Execute(strsql)
        if not rsTotal.eof then
            valorTotal = rsTotal( "Valor" )
            totalBultos = rsTotal( "nBultos" )
            Proveedor = rsTotal( "Proveedor" )
        end if
        rsTotal.close
        set rsTotal = Nothing
    end if
  %>
  <option costo_flete_transporte="<%=costo_flete_transporte%>" transporte="<%=rs("n_transporte")%>" fecha_recepcion="<% = rs( "Fecha_recepcion" ) %>" fecha_aduana="<% = rs( "Fecha_aduana" ) %>" numero_aduana="<% = rs( "Numero_aduana" ) %>" total_documento="<% = valorTotal %>" totalBultos="<% = totalBultos %>" Proveedor="<% = Proveedor %>" Manifiesto="<% = rs( "Manifiesto" ) %>" value="<%=id_carpeta%>"><%=n_carpeta%></option>
<%rs.MoveNext
loop%>
</select>

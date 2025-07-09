<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_no_valorizado                 = Request.Form("documento_no_valorizado")
numero_documento_no_valorizado          = Request.Form("numero_documento_no_valorizado")
documento_respaldo                      = Request.Form("documento_respaldo")
numero_documento_respaldo               = Request.Form("numero_documento_respaldo")
numero_interno_documento_no_valorizado  = Request.Form("numero_interno_documento_no_valorizado")
OpenConn
strSQL="select Numero_de_linea_en_RCP_o_documento_de_compra item from movimientos_productos with (nolock) " &_
       "where empresa='SYS' and " &_
       "documento_no_valorizado='"&documento_no_valorizado&"' and " &_
       "numero_documento_no_valorizado="&numero_documento_no_valorizado&" and " &_
       "Tipo_documento_de_compra='"&documento_respaldo&"' and " &_
       "numero_documento_de_compra="&numero_documento_respaldo&" and " &_
       "numero_interno_documento_no_valorizado="&numero_interno_documento_no_valorizado&" and " &_
       "Numero_de_linea_en_RCP_o_documento_de_compra_padre is null order by item"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strsql)
%>
<select OnChange="if(this.value!='')Agrupar_Items(this.value);"
id="items_grupos" name="items_grupos" style="width: 44px;">
  <option value=""></option>
<%do while not rs.EOF%>
  <option value="<%=rs("item")%>"><%=rs("item")%></option>
<%rs.MoveNext
loop%>
</select>
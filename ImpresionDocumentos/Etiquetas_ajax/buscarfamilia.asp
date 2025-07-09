<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
OpenConn_Alta

cSupFamilia = Request("superfamilia")
cFamilia = Request("familia")
cSubFamilia = Request("subfamilia")

'@cSupFamilia	varchar(12),
'@cFamilia		varchar(12),
'@cSubFamilia   varchar(12),
'@cDescripcion  varchar(50),
'@cEmpresa		varchar(12),
'@cVendible		char(1) = Null,
'@cProveedor	varchar(12) = Null,
'@cProducto		varchar(20) = Null,
'@cListaPrecio	Char(1) = 'N',
'@cbodega		varchar(7) = Null, -->cbutendieck
'@cProv			varchar(50) = Null, -->cbutendieck
'@cCertificado	Char(1),  -->cbutendieck
'@producto		varchar(12) = Null,
'@num_guia		varchar(12) = Null,
'@nprecio		int = Null

cSql = "Exec PRO_Lista_Imprime_Precios '"&cSupFamilia&"', '"&cFamilia&"', '"&cSubFamilia&"', '', '', '', '', '', '', '0011-Manzana 7', '', 'N','',0,0"
Set rs = ConnAlta.Execute(cSQL)
If Not rs.EOF then
%>
<div class="tablelistar">
<table>
	<tr>
		<td>Imp</td>
		<td>Cant</td>
		<td>F</td>
		<td>G</td>
		<td>Ofer</td>
		<td>Producto</td>
		<td><%=Date()%></td>
		<td>Precio Venta</td>
		<td>Proovedor</td>
		<td>Precio Promocion</td>
	</tr>
	<%Do While Not rs.EOF%>
	<tr>
		<td><input type="checkbox" name="imprimir" value="imprimir"></td>
		<td><input type="text" size="3"></td>
		<td><input class="ticket" type="radio" name="tipo" value="fleje"></td>
		<td><input class="ticket" type="radio" name="tipo" value="gancho"></td>
		<td><input type="checkbox" name="oferta" value="oferta"></td>
		<td><%=trim(Rs("Codigo_producto"))%></td>
		<td><%=trim(rs("Descripcion"))%></td>
		<td><%=formatNumber(rs("Pvta"),0)%></td>
		<td><%=rs("Prov")%></td><td><%=formatNumber(rs("pprom"),0)%></td>
	</tr>
	<%rs.MoveNext
	loop%>
</table>
</div>
<%End if%>
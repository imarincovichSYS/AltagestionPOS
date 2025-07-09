<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>maqueta punto de venta</title>
		<link rel="stylesheet" type="text/css" href="estilos.css">	
</head>
<body bgcolor="" background="ImagenDfondo.jpeg" leftmargin=0 topmargin=0 text="#000000">

<form name="formulario" method="post" action="maqueta_punto_venta.asp">

<table width="95%" align="center" border="0" cellspacing="5" cellpadding="0">
<tr valign="top">
    <td class="FuenteEncabezados" colspan="2" rowspan="5" align="center" valign="center">
        <img id="imagen" src="00000000000000000001.jpg" alt="Imagen producto" width="400" height="500" border="1">
    </td>
    <td class="pesos" width="40%" colspan="2" align="center" height="40"><b>$ 10.000</b></td>
</tr>
<tr valign="top">
    <td class="dolares" width="40%" colspan="2" align="center" height="40"><b>US $ 20</b></td>
</tr>
<tr valign="top">
    <td class="" width="40%" colspan="2" align="center" height="40"></td>
</tr>
<tr valign="top">
    <td class="" width="40%" colspan="2" align="center" height="40"></td>
</tr>
<tr valign="top">
    <td class="" width="40%" colspan="2" align="center" height="40"></td>
</tr>
<tr valign="top">
    <td class="FuenteEncabezados" width="15%"><b>Centro de venta</b></td>
    <td class="FuenteEncabezados"><b>Centro 1</b></td>
    <td class="FuenteEncabezados"><b>Bodega</b></td>
    <td class="FuenteEncabezados"><b>Bodega 1</b></td>
</tr>
<tr valign="top">
    <td class="FuenteEncabezados"><b>Cliente</b></td>
    <td class="FuenteInput">
        <input Class="FuenteInput" type=text name="cliente" size="16" maxlength="12" value="">
        <a href="javascript:selecciona_cliente()"><img src="find.gif" alt="Selecciona cliente" border="0"></a>
    </td>
    <td class="FuenteEncabezados" align="left"><b>Vendedor</b></td>
    <td class="FuenteEncabezados" align="left">
        <select class="FuenteInput" name="vendedor" style="width:150">
        <option value="Vendedor1">Vendedor 1&nbsp;(Vendedor1)</option>
        <option value="Vendedor2">Vendedor 2&nbsp;(Vendedor2)</option>
        </select>
    </td>
</tr>
<tr valign="top">
    <td class="FuenteEncabezados" align="left"><b>Documento</b></td>
    <td class="FuenteEncabezados" align="left">
        <select class="FuenteInput" name="documento" style="width:150">
        <option value="Boleta">Boleta</option>
        <option value="Factura">Factura</option>
        </select>
    </td>
    <td class="FuenteEncabezados"><b>Numero a imprimir</b></td>
    <td class="FuenteInput">
        <input Class="FuenteInput" type=text name="numero_documento" size="16" maxlength="12" value="">
    </td>
</tr>
<tr valign="top">
    <td class="FuenteEncabezados" align="left"><b>Forma de pago</b></td>
    <td class="FuenteEncabezados" align="left">
        <select class="FuenteInput" name="forma_pago" style="width:150">
        <option value="CHI">Cheque</option>
        <option value="EFI">Efectivo</option>
        <option value="RED">Red compra</option>
        <option value="TAR">Tarjeta crdito</option>
        </select>
    </td>
</tr> 
</table>
<br>
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr class="FuenteCabeceraTabla"> 
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="2%" align="center"><b>#</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="5%" align="center"><b>Producto</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center"><b>Cantidad</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="50%" align="center" nowrap><b>Nombre</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center"><b>Un</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center"><b>Bodega<br>(Stock)</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="5%" align="center"><b>Precio</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="12%" align="center"><b>$ Total</b></td>
</tr>
<%for n = 1 to 5%>
<tr id="fila<%=n%>" onclick="javascript:cambio_imagen('fila<%=n%>','barra_<%=n%>')"> 
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="2%" align="center"><b><%=n%></b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="5%" align="center">
        <input id="barra_<%=n%>" Class="FuenteInput" type=text name="barras_<%=n%>" size="26" maxlength="20" value="0000000000000000000<%=n%>" onfocus="document.all.fila<%=n%>.click()" onchange="document.all.fila<%=n%>.click()">
    </td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center">
        <input Class="FuenteInput" type=text name="cantidad_<%=n%>" size="6" maxlength="4" value="1">
    </td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="50%" align="center" nowrap><b>Producto <%=n%></b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center"><b>UN</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="4%" align="center">
        <select class="FuenteInput" name="stock_<%=n%>">
        <option value="01">01&nbsp;(2)</option>
        <option value="02">02&nbsp;(5)</option>
        </select>
    </td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="5%" align="center"><b><%=n%>00</b></td>
    <td class="FuenteEncabezados" style="border: solid 1px silver" width="12%" align="center"><b><%=n%>00</b></td>
</tr>
<%next%>
</table>

</form>

</body>
</html>

<script language="JavaScript">
var ultimafila="";
function salidafila() {
if ( ultimafila == "" ) {} else {
   ultimafila.className='normal';}
}
function selecciona_cliente()
{
document.formulario.cliente.value='1-9';
}
function cambio_imagen(fila,codigo)
{
salidafila();
document.all[fila].className='seleccionado';
ultimafila=document.all[fila];
if ( document.all[codigo].value == "" ) {} else {
document.all.imagen.src=document.all[codigo].value+'.jpg'; }
}
</script>

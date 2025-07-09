<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--// ================================================================================ //-->
<!--//                              carga componentes                                   //-->
<!--#include file="../../AltanetTBK/ASP/json118.asp" -->
<!--#include file="../../AltanetTBK/ASP/TokenSign.asp" -->
<!--#include file="../../AltanetTBK/ASP/AltanetTBK.asp" -->
<!--// ================================================================================ //-->
<%
Cache

'--// ================================================================================
'--// Es obligacion esta linea, para generar la estructura json
CallTransbank ParamsTBK 
'response.Write("{""TBK"": " & ParamsTBK.Item("TBKInfoToSend") & "}")
'--// ================================================================================
%>
<html>
	<head>
    	<title>Botones transbank</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
		<!--// ================================================================================ //-->
		<!--//                              carga librerias                                     //-->
		<!--//                         javascript // IE or not IE                               //-->
		<script src='../../AltanetTBK/ASP/jquery-1.9.1.min.js'></script>
		<script src='../../AltanetTBK/ASP/json2.js'></script>
		<script src='../../AltanetTBK/ASP/libs.js'></script>
		<script src='../../AltanetTBK/ASP/AltanetTBK_<%If InStr(Request.ServerVariables("HTTP_USER_AGENT"),"MSIE") > 0 then response.Write("MSIE") else response.Write("NOIE") end if%>.js'></script>
		
		<!--// ================================================================================ //-->
    </head>

    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    	<center>

			<table width="265">
				<tr>
					<td align="center" id="WSResponse"></td>
				</tr>
				<tr align="center">
					<input type="hidden" name="Accion" value="">
					<td>
						<input class="FuenteInput" type="button" value="Transacción última venta" name="UltimaVenta" onClick="jsUltima_venta();" >				    </td>
				</tr>
				<tr align="center">
					<td>
						<input class="FuenteInput" type="button" value="Transacción totales" name="Totales" onClick="jsTotales();" >				    </td>
				</tr>
				<tr align="center">
					<td>
						<input class="FuenteInput" type="button" value="Transacción de detalle de ventas" name="DetalleVentas" onClick="jsDetalle_de_Ventas();" >				    </td>
				</tr>
				<tr align="center">
					<td>
						<input class="FuenteInput" type="button" value="Transaccion de poll" name="Poll" onClick="jsPoll();" >				    </td>
				</tr>
				<tr align="center">
					<td>
						<input class="FuenteInput" type="button" size="50" value="Transacción de cambio a POS normal" name="PosNormal" onClick="jsCambio_a_POS_Normal();" >				    </td>
				</tr>
		    </table>
    	</center>
    </body>
</html>
<script language="JavaScript">
var InfoToSend = eval("({\"TBK\": <%=replace(ParamsTBK.Item("TBKInfoToSend"),"""","\""")%>})");
function jsUltima_venta() {
	InfoToSend.TBK.Accion = "Ultima_venta";
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {
			//document.getElementById("WSResponse").innerHTML = err.Mensaje;
		}
		else {
			//document.getElementById("WSResponse").innerHTML = result.DataResponse;
		}
	},true);
}

function jsTotales() {

	InfoToSend.TBK.Accion = "Totales";
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {
			//document.getElementById("WSResponse").innerHTML = err.Mensaje;
//alert(err.Mensaje);
		}
		else {
			//document.getElementById("WSResponse").innerHTML = result.DataResponse;
//alert(result.DataResponse);
		}
	},true);
}

function jsDetalle_de_Ventas() {
	InfoToSend.TBK.Accion = "Detalle_de_Ventas";
	InfoToSend.TBK.TBKInfo.printOnPOS = true;
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {
			//document.getElementById("WSResponse").innerHTML = err.Mensaje;
		}
		else {
			//document.getElementById("WSResponse").innerHTML = result.DataResponse;
		}
	},true);
}

function jsPoll() {
	InfoToSend.TBK.Accion = "Poll";
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {
			//document.getElementById("WSResponse").innerHTML = err.Mensaje;
			alert("Err: " + err.Mensaje);
		}
		else {
			//document.getElementById("WSResponse").innerHTML = result.DataResponse;
			alert("Result: " + result)
		}
	},true);
}

function jsCambio_a_POS_Normal() {
	InfoToSend.TBK.Accion = "Cambio_a_POS_Normal";
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {
			//document.getElementById("WSResponse").innerHTML = err.Mensaje;
		}
		else {
			//document.getElementById("WSResponse").innerHTML = result.DataResponse;
		}
	},true);
}
</script>
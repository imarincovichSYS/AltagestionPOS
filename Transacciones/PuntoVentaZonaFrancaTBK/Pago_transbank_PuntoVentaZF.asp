<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--// ================================================================================ //-->
<!--//                              carga componentes                                   //-->
<!--#include file="../../AltanetTBK/ASP/json118.asp" -->
<!--#include file="../../AltanetTBK/ASP/TokenSign.asp" -->
<!--#include file="../../AltanetTBK/ASP/AltanetTBK.asp" -->
<!--// ================================================================================ //-->
<%
Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

CallTransbank ParamsTBK

'ModPrtFiscal = "BIXOLON"
'cSql = "Exec CDV_ListaCentrosVentas '" & Session("xCentro_de_venta") & "',Null,'" & Session("Empresa_usuario") & "'"
'Set Rs = Conn.Execute ( cSql )
'If Not Rs.Eof then
''	ModPrtFiscal = Rs("Impresora_fiscal")
'end if
'Rs.Close
'set rs = nothing
'Conn.close()

nMonto_total_a_pagar = 0
if right(request("Montos_a_pagar"),1) = "," then nMenos_uno = 1 else nMenos_uno = 0 end if
sPagos = split(request("Montos_a_pagar"),",")
for idx = 0 to ubound(sPagos) - nMenos_uno
	nMonto_total_a_pagar =  nMonto_total_a_pagar + cdbl(sPagos(idx))
next
%>
<html>
    <head>
        <title>Observaciones</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
		<!--// ================================================================================ //-->
		<!--//                              carga librerias                                     //-->
		<!--//                         javascript // IE or not IE                               //-->
		<script src='../../AltanetTBK/ASP/jquery-1.9.1.min.js'></script>
		<script src='../../AltanetTBK/ASP/json2.js'></script>
		<script src='../../AltanetTBK/ASP/libs.js'></script>
		<script src='../../AltanetTBK/ASP/AltanetTBK_<%If InStr(Request.ServerVariables("HTTP_USER_AGENT"),"MSIE") > 0 then response.write("MSIE") else response.write("NOIE") end if%>.js'></script>
		<!--// ================================================================================ //-->
    </head>
    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    <div align="center" id="txtArea">
      <table width="200" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <th scope="col" style="color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 40px;padding-top:15px;padding-bottom:15px;">
		  Monto total venta: $<%=replace(formatNumber(nMonto_total_a_pagar,0),",",".")%><br>
          Esperando pago Transbank...</th>
        </tr>		
        <tr>
          <th scope="row"><textarea name="txtMessages" cols="120" rows="20" id="txtMessages"></textarea></th>
        </tr>
      </table>
    </div>
    </body>
<script type="text/javascript">
var sInterval;
var szLog = false;
var zLog = function (sAction, sMessage) {
    if (szLog) {
        $("#txtMessages").val($("#txtMessages").val() + "[" + new Date().toLocaleTimeString() + "] (" + sAction + ") " + sMessage + '\n');
    }
    else {
        $("#txtMessages").hide();
    }
}
function init() {
	clearInterval(sInterval);
	
	var InfoToSend = eval("({\"TBK\": <%=replace(ParamsTBK.Item("TBKInfoToSend"),"""","\""")%>})");
	var Respuestas = [];
	var TransaccionOK = true;
    var Elimina = false;
	
	var DocumentosCobros = [<%=request("DocumentosCobros") %>];
	var Montos_a_pagar = [<%=request("Montos_a_pagar") %>];
	
//	InfoToSend.TBK.Accion = "Poll";
//	jsTBKTransaccion(InfoToSend, function (err, result) {
//		if (err) {
//			zLog("Poll", err.Mensaje);
//		}
//		else {
//			zLog("Poll", result.DataResponse);
//		}
//	}, true);
	
	for (var ix = 0; ix < DocumentosCobros.length; ix += 1) {
		if (TransaccionOK) {
			InfoToSend.TBK.Accion = "Venta";
			InfoToSend.TBK.TBKInfo.Monto = Montos_a_pagar[ix];
			InfoToSend.TBK.TBKInfo.Numero_Ticket_Boleta = <%=request("Numero_documento_valorizado")%>;
			InfoToSend.TBK.TBKInfo.Enviar_Status = false;
	
			zLog("Venta", DocumentosCobros[ix] + "/" + Montos_a_pagar[ix] + "/<%=request("Numero_documento_valorizado")%>");
	
			jsTBKTransaccion(InfoToSend, function (err, result) {
				if (err) {
					TransaccionOK = false;
                    Elimina = true;
					zLog("Venta", err.Mensaje);
				}
				else {
					var nuevoResultado = JSON.parse(result.DataResponse);
					zLog("Venta", result.DataResponse);
	
					Respuestas.push(result.DataResponse);
					TransaccionOK = nuevoResultado.Result.ResponseCode == 0;
					
					if (nuevoResultado.Result.AuthorizationCode == "") {
						TransaccionOK = false;
                        Elimina = true;
					}
					else 
					{
						//if (TransaccionOK) {
							$.ajax({
								type: "post",
								url: "GrabarResultadoTBK.asp",
								crossDomain: true,
								async: true,
								data: {
									RespTBK: JSON.stringify(result.DataResponse),
									Numero_documento_valorizado: <%=request("Numero_documento_valorizado")%>,
									Documento_valorizado_BOV_o_FAV: "<%=request("DocumentoZF")%>"
									},
								succes: function (Resultado) {
									zLog("GrabarResultadoTBK", Resultado);
								},
								error: function (Error) {
									zLog("GrabarResultadoTBK", Error.statusText);
                                    TransaccionOK = false;
                                    Elimina = true;
								}
							});
						//}
					}
				}
			}, true);	
		}		
	}
	
	if (TransaccionOK) 
    {
		zLog("TransaccionOK", "(" + TransaccionOK + ") Transaccion POS OK, se sigue flujo...");
		var Imprimir = true;
		$.ajax({
			type: "post",
			url: "Generacion_CIN_TBK.asp",
			crossDomain: true,
			async: false,
			beforeSend: function () {
				// console.log(JSON.stringify(Respuestas));
			},
			data: {
				Numero_documento_valorizado: "<%=request("Numero_documento_valorizado")%>",
				Numero_documento_no_valorizado: "<%=request("Numero_documento_no_valorizado")%>",
				RespuestaTBK: JSON.stringify(Respuestas),
				DocumentosCobros: DocumentosCobros,
				Montos_a_pagar: Montos_a_pagar,
				Documento_valorizado_BOV_o_FAV: "<%=request("DocumentoZF")%>"
			},
			success: function (Resultado) {
				if (Resultado != "OK") {
					zLog("Generacion_CIN_TBK", Resultado);
					Imprimir = false;
                    Elimina = true;
					var res = Resultado.split("|");
					alert(res[1]);
				}
			},
			error: function (xhr) {
				zLog("Generacion_CIN_TBK", xhr.status + "/" + xhr.statusText);
                Imprimir = false;
                Elimina = true;
			}
		});
	
		if (Imprimir) {
			if ("<%=request("DocumentoZF")%>" == "BOV") {
				// if (szLog) alert("Pago transbank OK, presione enter para ir a impresion de boleta...");								
				window.location.href = "Imprime_boleta_PuntoVentaZF.asp?Accion=Imprimir&Boleta_actual=<%=session("Boleta_Actual")%>";
			}
			else {
				alert("Prepare impresora para emitir factura y presione enter");
				//parent.Botones.location.href = "../../ImpresionDocumentos/FacturaZonaFranca/SRF.asp?Ticket=N&Documento=FAV&NroFac=<%=request("Numero_interno_documento_Factura_ingresada")%>&NroFactura=<%=request("Numero_documento_Factura_ingresada")%>";
				window.location.href = "Imprime_factura_PuntoVentaZF.asp?Accion=Imprimir"
				//parent.Trabajo.location.href = "Main_PuntoVentaZF.asp?Liberar=1";
			}
		}
	}	
    //else 
    if (Elimina)
    {
		zLog("TransaccionOK", "(" + TransaccionOK + ") Transaccion POS, se detiene flujo...");
		$.ajax({
			type: "post",
			url: "Elimina_CIN_TBK.asp",
			crossDomain: true,
			async: false,
			data: {
				Numero_documento_valorizado: <%=request("Numero_documento_valorizado")%>,
				Documento_valorizado_BOV_o_FAV: "<%=request("DocumentoZF")%>"
			},
			success: function (Resultado) {
				zLog("Elimina_CIN_TBK", Resultado);
				if (Resultado.split("|")[0] == "OK") {
					
					if(szLog) alert("Hubo un problema con el pago de transbank...");
					
					parent.Botones.location.href = "Botones_Pagos_PuntoVentaZF.asp";
					window.location.href = 'Pagos_PuntoVentaZF.asp?Folio_disponible=<%=request("Folio_disponible")%>';
					if (Resultado.split("|")[1] > 0) {
						var sparams =  "dialogWidth:25;dialogHeight:10;center:yes;edge:sunken;unadorned:yes;status:no;help:no;";
						var sValue = window.showModalDialog("VentanaAvisoDocumentosTBK.asp?Numero_despacho_de_venta=" + Resultado.split("|")[2], "valor",sparams);
					}
				}
			},
			error: function (xhr) {
				zLog("Elimina_CIN_TBK", xhr.status + "/" + xhr.statusText);
			}
		});
	}
}

window.onload = function() {
	sInterval = setInterval(function() { init(); }, 1000);
}
</script>
</html>
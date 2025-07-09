<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--// ================================================================================ //-->
<!--//                              carga componentes                                   //-->
<!--#include file="../../AltanetTBK/ASP/json118.asp" -->
<!--#include file="../../AltanetTBK/ASP/TokenSign.asp" -->
<!--#include file="../../AltanetTBK/ASP/AltanetTBK.asp" -->
<!--// ================================================================================ //-->
<%Cache

Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

Numero_despacho_de_venta = request("Numero_despacho_de_venta")

'--// ================================================================================
'--// Es obligacion esta linea, para generar la estructura json
CallTransbank ParamsTBK 
'--// ================================================================================
%>
<html>
	<head>
    	<title>Ventana documentos transbank</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
		<!--// ================================================================================ //-->
		<!--//                              carga librerias                                     //-->
		<!--//                         javascript // IE or not IE                               //-->
		<script src='../../AltanetTBK/ASP/jquery-1.9.1.min.js'></script>
		<script src='../../AltanetTBK/ASP/json2.js'></script>
		<script src='../../AltanetTBK/ASP/libs.js'></script>
		<%If InStr(Request.ServerVariables("HTTP_USER_AGENT"),"MSIE") > 0 then%><script src='../../AltanetTBK/ASP/AltanetTBK_MSIE.js'></script>
		<%else%><script src='../../AltanetTBK/ASP/AltanetTBK_NOIE.js'></script>
		<%end if%>
		<!--// ================================================================================ //-->
    </head>

    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    	<center>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">			
				<%cSql = "Exec DOV_Lista_Pago_POS_TBK_temporal 0" & Numero_despacho_de_venta
				set Rs = Conn.Execute( cSql )
				do while not Rs.Eof
					Tipo_tarjeta = Rs("CardType")
					
					if uCase(Trim(Tipo_tarjeta)) = "DB" then%>
						<tr>
							<td align="center">
								Se realizó el pago con tarjeta debito de forma exitosa. Deberá realizar la devolución de dinero en la opción Devolución de dinero a clientes del menú tesorería.
								La devolución a realizar debe ser del documento RED con número <%=Rs("AuthorizationCode")%>.
							</td>
						</tr>
					<%end if
					
					if uCase(Trim(Tipo_tarjeta)) = "CR" then%>					
						<tr>
							<td align="center">
								Se realizó pago con tarjeta de credito de forma exitosa. Deberá realizar la anulación a traves del POS para volver a realizar la venta. 
							</td>
						</tr>
						<tr>
							<td align="center">
								<input class="FuenteInput" type="button" value="Numero operación tarjeta de credito (<%=Rs("OperationNumber")%>)" name="UltimaVenta" onClick="jsAnulacion(<%=Rs("OperationNumber")%>);" >
							</td>
						</tr>						
					<%end if 
							
					Rs.MoveNext
				loop
				Rs.Close
				set Rs = Nothing%>
		    </table>
    	</center>
    </body>
</html>
<%cSql = "Delete Pago_POS_TBK_temporal where Numero_despacho_de_venta = " & Numero_despacho_de_venta
conn.Execute( cSql )

Conn.close%>
<script language="JavaScript">
var InfoToSend = eval("({\"TBK\": <%=replace(ParamsTBK.Item("TBKInfoToSend"),"""","\""")%>})");

function jsAnulacion(Numero_operacion) {

	InfoToSend.TBK.Accion = "Anulacion";
	InfoToSend.TBK.TBKInfo.Voucher_de_Venta = Numero_operacion;	
	jsTBKTransaccion(InfoToSend, function(err, result) {
		if (err) {						
			//alert(err.DataResponse);
		}
		else {						
			//console.log(result.DataResponse);
			window.close();
		}
	},true);
}
</script>
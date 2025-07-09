<%
''--// Transacción de Venta 
'TBKInfoToSend.Add "Accion", "Venta"
'TBKInfoToSend.Add "Monto", cDbl(1500)
'TBKInfoToSend.Add "Numero_Ticket_Boleta", cDbl(112233)
'TBKInfoToSend.Add "Enviar_Status", false ' default
'
''--// Transacción de Venta Multicodigo
'TBKInfoToSend.Add "Accion", "Venta_Multicodigo"
'TBKInfoToSend.Add "Monto", cDbl(401416)
'TBKInfoToSend.Add "Numero_Ticket_Boleta", cDbl(684611)
'TBKInfoToSend.Add "Codigo_de_Comercio", "ABC4654654XYZ"
'TBKInfoToSend.Add "Enviar_Status", false ' default
'
''--// Transacción de última venta
'TBKInfoToSend.Add "Accion", "Ultima_venta"
'
''--// Transacción de última venta multicodigo
'TBKInfoToSend.Add "Accion", "Ultima_venta_multicodigo"
'
''--// Transacción de Anulación
'TBKInfoToSend.Add "Accion", "Anulacion"
'TBKInfoToSend.Add "Voucher_de_Venta", cDbl(6549865465654)
'
''--// Transacción de Cierre
'TBKInfoToSend.Add "Accion", "Cierre"
'
''--// Transacción Totales
'TBKInfoToSend.Add "Accion", "Totales"
'
''--// Transacción de Detalle de Ventas
'TBKInfoToSend.Add "Accion", "Detalle_de_Ventas"
'TBKInfoToSend.Add "printOnPOS", false
'
''--// Transacción de Detalle de Ventas Multicodigo
'TBKInfoToSend.Add "Accion", "Detalle_de_Ventas_Multicodigo"
'
''--// Transacción de Carga de Llaves
'TBKInfoToSend.Add "Accion", "Carga_de_Llaves"
'
''--// Transacción de Poll
'TBKInfoToSend.Add "Accion", "Poll"
'
''--// Transacción de Cambio a POS Normal
'TBKInfoToSend.Add "Accion", "Cambio_a_POS_Normal"
Dim ParamsTBK: 					Set ParamsTBK = Server.CreateObject("Scripting.Dictionary")
Dim TBKJson:					Set TBKJson = New aspJSON
Dim sAccionesTransaccionesTBK: 	Set sAccionesTransaccionesTBK = Server.CreateObject("Scripting.Dictionary")

nIndex = 0
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "VOID"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Venta"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Venta_Multicodigo"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Ultima_venta"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Ultima_venta_multicodigo"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Anulacion"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Cierre"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Totales"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Detalle_de_Ventas"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Detalle_de_Ventas_Multicodigo"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Carga_de_Llaves"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Poll"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Cambio_a_POS_Normal"

nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Accion"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Monto"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Numero_Ticket_Boleta"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Enviar_Status"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Codigo_de_Comercio"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "Voucher_de_Venta"
nIndex = nIndex + 1: sAccionesTransaccionesTBK.Add nIndex, "printOnPOS"

'--// ================================================================================
'--// Acciones/Transacciones por default
ParamsTBK.Add "Accion"					,"VOID"
ParamsTBK.Add "Monto"					,0
ParamsTBK.Add "Numero_Ticket_Boleta"	,0
ParamsTBK.Add "Enviar_Status"			,false
ParamsTBK.Add "Codigo_de_Comercio"		,""
ParamsTBK.Add "Voucher_de_Venta"		,0
ParamsTBK.Add "printOnPOS"				,false

function CallTransbank (byRef TBKInfoToSend)
	'--// ================================================================================
	'--// default es error de parametros...
	nNoCount = 0
	Ejecutar_Pago_Transbak = false
	nNoCount = nNoCount + 1: TBKInfoToSend.Add "Ejecutar_Pago_Transbak", 0
	nNoCount = nNoCount + 1: TBKInfoToSend.Add "Mensaje", "Accion/Transaccion no definida"

	'--// ================================================================================
	'--// nombre de campos sean correctos
	nCountParams = 0
	for each sItemToSend In TBKInfoToSend
		for each sAccionTransaccion In sAccionesTransaccionesTBK
			if uCase(sItemToSend) = uCase(sAccionesTransaccionesTBK.Item(sAccionTransaccion)) then
				nCountParams = nCountParams + 1
			end if
		next
	next

	if ParamsTBK.Count - nNoCount = nCountParams then
		'--// ================================================================================	
		'--// que la accion/transaccion exista...
		for each sAccionTransaccion In sAccionesTransaccionesTBK
			if uCase(TBKInfoToSend.Item("Accion")) = uCase(sAccionesTransaccionesTBK.Item(sAccionTransaccion)) then
				Ejecutar_Pago_Transbak = true
				exit for
			end if
		next

		'--// ================================================================================	
		'--// carga de datos...
		if Ejecutar_Pago_Transbak then
			with TBKJson.data
				.Add "Accion", TBKInfoToSend.Item("Accion")
				.Add "TBKInfo", TBKJson.Collection()
					With .item("TBKInfo")
						.Add "Monto"				,TBKInfoToSend.Item("Monto")
						.Add "Numero_Ticket_Boleta"	,TBKInfoToSend.Item("Numero_Ticket_Boleta")
						.Add "Codigo_de_Comercio"	,TBKInfoToSend.Item("Codigo_de_Comercio")
						.Add "Enviar_Status"		,TBKInfoToSend.Item("Enviar_Status")
						.Add "Voucher_de_Venta"		,TBKInfoToSend.Item("Voucher_de_Venta")
						.Add "printOnPOS"			,TBKInfoToSend.Item("printOnPOS")
					End With
			end with
		end if		
	end if

	if Ejecutar_Pago_Transbak then
		TBKInfoToSend.Item("Ejecutar_Pago_Transbak") = 1
		TBKInfoToSend.Item("Mensaje") = ""
	end if
	
	'--// ================================================================================	
	'--// carga de otros datos...
	with TBKJson.data
		.Add "Ejecutar_Pago_Transbak", TBKInfoToSend.Item("Ejecutar_Pago_Transbak")
		.Add "Mensaje", TBKInfoToSend.Item("Mensaje")
		.Add "KeySign", uCase(KeySign)
		.Add "TokenSign", uCase(Token_session_usuario)
	end with
	
	TBKInfoToSend.Add "TBKInfoToSend", TBKJson.JSONoutput(false)
	CallTransbank = Ejecutar_Pago_Transbak
end function
%>
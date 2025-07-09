<!-- #include file="../../Scripts/Inc/Cache.inc" -->
<!--#include file="../../Scripts/ASP/aspJSON1.17.asp" -->
<%
Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

Dim TBKJson: Set TBKJson = New aspJSON

Error = "N"
MensajeError = ""

Numero_documento_valorizado_BOV = request("Numero_documento_valorizado")
Numero_documento_no_valorizado = request("Numero_documento_no_valorizado")
RespuestaTBK = request("RespuestaTBK")
DocumentosCobros = split(request("DocumentosCobros"),",")
Montos_a_pagar = split(request("Montos_a_pagar"),",")

RespuestaTBK = replace(RespuestaTBK,"\","")
RespuestaTBK = replace(RespuestaTBK,"""{","{")
RespuestaTBK = replace(RespuestaTBK,"}""","}")
RespuestaTBK = "{""TBK"":"& RespuestaTBK &"}"

TBKJson.loadJSON(RespuestaTBK)

Fecha_emision = year(Now()) & "/" & month(Now()) & "/" & day(Now())
Banco_documento = ""

Conn.BeginTrans

sql = "exec DOV_Lista_DocumentosVenta '" & session("Empresa_usuario") & "','BOV'," & Numero_documento_valorizado_BOV
set rs = conn.execute(sql)
Numero_interno_documento_valorizado_DOCVTA = rs("Numero_interno_documento_valorizado")
Numero_documento_valorizado_DOCVTA = Numero_documento_valorizado_BOV
Numero_despacho_de_venta = rs("Numero_despacho_de_venta")
rs.close
set rs = nothing

cSql = "Exec DOV_Borra_CIN_transbank '" & session("Empresa_usuario") & "', 0" & Numero_despacho_de_venta
Conn.Execute(cSql)

if Conn.Errors.Count <> 0 then
	Error = "S"
	MensajeError = Err.Description
	Log_error sql , Err.Description 	
end if

if Error = "N" then
	For Each Venta In TBKJson.data("TBK")
		Set this = TBKJson.data("TBK").item(Venta)
		
		if this.item("Result").item("ResponseCode") = 0 then	
			if this.item("Result").item("CardType") = "DB" then	
				Documento_pago = "TAR"
				Cantidad_cuotas = 1
				Monto_pago = this.item("Result").item("Amount")
			else
				Documento_pago = "TAC"
				Cantidad_cuotas = this.item("Result").item("SharesNumber")
				if Cantidad_cuotas = 2 or Cantidad_cuotas = 3 then			
					Monto_pago = Fix(this.item("Result").item("Amount") / this.item("Result").item("SharesNumber"))
					DifTotalTemp = Monto_pago * this.item("Result").item("SharesNumber")				
					DifTotal = this.item("Result").item("Amount") - DifTotalTemp
				else
					Cantidad_cuotas = 1
					Monto_pago = Fix(this.item("Result").item("Amount") / Cantidad_cuotas)
					DifTotalTemp = Monto_pago * this.item("Result").item("SharesNumber")				
					DifTotal = this.item("Result").item("Amount") - DifTotalTemp
				end if
			end if
			
			for Cuota = 1 to Cantidad_cuotas
				if Cuota =  this.item("Result").item("SharesNumber") then
					Monto_pago = Monto_pago + DifTotal
				end if
						
				sql="Exec DOC_NuevoFolio 'CIN'"
				set rs=Conn.Execute(sql)
			
				if Conn.Errors.Count <> 0 then
					Error = "S"
					MensajeError = Err.Description
					Log_error sql , Err.Description 
				end if
			
				Folio=rs("Folio")
				rs.close
				set rs=nothing	
			
				sql = "Exec DNV_GrabaComprobanteIngreso '" & Session("Empresa_usuario") & "', 0" & +_
															 Folio & ",'" & +_
															 Fecha_emision & "','C','" & +_
															 Session("Cliente_boleta") & "','" & +_
															 "$" & "','" & Documento_pago & "',0"															
				if Banco_documento = "" then
					sql = sql & Monto_pago & ",null,'"
				else
					sql=sql & Monto_pago & ",'" & Banco_documento & "','Creado al facturar servicio"
				end if
				sql = sql & "','" & Session("Login") & "'"
			
				set RsManejo=Conn.Execute(sql)
				if Conn.Errors.Count <> 0 then
					Error = "S"
					MensajeError = Err.Description
					Log_error sql , Err.Description 
					exit for
				end if
				RsManejo.close
				set RsManejo=nothing
			
				'Comprobante de Ingreso en Documento Valorizado
				If len(trim(Fecha_documento)) = 0 Then
					Fecha_vencimiento = "Null"
				Else
					Fecha_vencimiento = "'" & cambia_fecha( Fecha_documento ) & "'"
				End if
			
				ccBanco = "Null"
				CtaCteBco = "Null"
				ccBanco = Banco_documento
				if len(trim(ccBanco)) = 0 then ccBanco = "Null" else ccBanco = "'" & ccBanco & "'"
				CtaCteBco = "Null"	
				
				sql = "Exec DOV_GrabaComprobanteIngreso '" &Session("Empresa_usuario") & "', '" & Documento_pago & "', 0" & +_													
															this.item("Result").item("Last4Digits") & ", 0" & +_																											
															Monto_pago & ", " & +_
															ccBanco  & ", " & +_
															Fecha_vencimiento  & ", '" & +_
															year(Now()) & Right("00" & Month(Now()),2)  & "', " & +_
															CtaCteBco & ", '" & +_
															Session("Cliente_boleta") & "', '" & +_
															"$" & "', 0" & +_
															Folio & ", '', '" +_
															Session("Login")	& "', Null, Null," & _
															"Null,Null,Null,0,Null,Null,Null,Null,Null,Null,Null,Null," & _
															"'" & Session("xCentro_de_venta") & "','" & Session("xBodega") & "',0" & _																					   
															Numero_despacho_de_venta & ", 0" & Cuota & ", 0" & this.item("Result").item("OperationNumber")
			
				set rs=conn.Execute(sql)
				if Conn.Errors.Count <> 0 then
					Error = "S"
					MensajeError = Err.Description
					Log_error sql , Err.Description
					exit for
				end if
				
				Numero_interno_documento_valorizado = rs("Numero_interno_documento_valorizado")
				Numero_documento_valorizado = rs("Numero_documento_valorizado")
				Numero_interno_DocFav = Rs("Documento")
				rs.close
				set rs=nothing
				
				'ACO_Cobro_pago
				ParidadEfectivo = 1
				sql="ACO Cobro de pago!"
				sql="exec ACO_Cobro_pago 0" &	Numero_interno_documento_valorizado & ",'" & Documento_pago & "',0" &+_
												this.item("Result").item("Last4Digits") & ",0" & +_											
												ParidadEfectivo & ",'" & +_
												"COB', 0" &+_
												Numero_interno_documento_valorizado_DOCVTA & ",'" & Documento_pago & "', 0" & +_											
												Numero_documento_valorizado_DOCVTA & ",0" & +_
												ParidadEfectivo & ",'" & +_
												"S','VTA',0" & +_											
												Monto_pago & ",'$','" &+_
												Session("Login") & "'"
				Conn.Execute(sql)
				
				if Conn.Errors.Count <> 0 then
					Error = "S"
					MensajeError = Err.Description
					Log_error sql , Err.Description 
					exit for
				end if	
			next				
		end if		
	Next
end if

if Error = "N" then
	cSql = "Delete Pago_POS_TBK_temporal where Numero_despacho_de_venta = " & Numero_despacho_de_venta
	conn.Execute( cSql )
	
	if Conn.Errors.Count <> 0 then
		Error = "S"
		MensajeError = Err.Description
		Log_error sql , Err.Description 
	end if	
end if 

if Error = "N" then 
	Conn.CommitTrans
	Response.Write("OK")
else	
	Conn.RollbackTrans	
	Response.Write("Error|" & LimpiaError(MensajeError))
end if 
response.End()%>
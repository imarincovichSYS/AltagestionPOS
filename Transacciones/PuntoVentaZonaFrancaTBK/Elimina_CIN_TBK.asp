<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--#include file="../../Scripts/ASP/aspJSON1.17.asp" -->
<%
Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600
	
Set Conn1 = Server.CreateObject("ADODB.Connection")
	Conn1.Open Session( "DataConn_ConnectionString" )
	Conn1.CommandTimeout = 3600

Error = "N"
MensajeError = ""

Numero_documento_valorizado_BOV = Request("Numero_documento_valorizado")
Documento_valorizado_BOV_o_FAV = Request("Documento_valorizado_BOV_o_FAV")

sql = "exec DOV_Lista_DocumentosVenta '" & session("Empresa_usuario") & "','" & Documento_valorizado_BOV_o_FAV & "'," & Numero_documento_valorizado_BOV
set rs = Conn1.execute(sql)
if not rs.eof then
	Numero_interno_documento_valorizado_DOCVTA = rs("Numero_interno_documento_valorizado")
	Numero_documento_valorizado_DOCVTA = Numero_documento_valorizado_BOV
	Numero_despacho_de_venta = rs("Numero_despacho_de_venta")
end if
rs.close
set rs = nothing

Fecha_emision = year(Now()) & "/" & month(Now()) & "/" & day(Now())

sql=""

Conn.BeginTrans

cSql = "Exec DOV_Lista_Documentos_para_borrar_TBK '" & session("Empresa_usuario") & "', 0" & Numero_despacho_de_venta
set Rs = Conn1.Execute( cSql )
if not Rs.eof then
	do while not Rs.eof	
		sql = sql & "Exec DOV_Borra_DocumentoValorizado 0" & Rs("Numero_interno_documento_valorizado") & ";"
		Cliente = Rs("Cliente")
		
		Rs.MoveNext
	loop
end if
Rs.close
set Rs = Nothing

if len(trim(sql)) > 0 then
	sDOV_Borra_DocumentoValorizado = split(sql,";")
	for idx = 0 to ubound(sDOV_Borra_DocumentoValorizado) - 1
		Conn.Execute(sDOV_Borra_DocumentoValorizado(idx))

		if Conn.Errors.Count <> 0 then
			Error = "S"
			MensajeError = Err.Description
			Log_error sql, Err.Description 	
		end if		
	next
end if

Total_pagos_transbank = 0

if Error = "N" then 
	TempSql = "Exec DOV_Lista_Pago_POS_TBK_temporal 0" & Numero_despacho_de_venta
	set RsTemp = Conn1.Execute( TempSql )
	
	if not RsTemp.eof then
		do while not RsTemp.eof
			if Trim(RsTemp("CardType")) = "DB" then	
				Documento_pago = "TAR"			
				Monto_pago = RsTemp("Amount")			
				
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
			
				sql = "Exec DNV_GrabaComprobanteIngreso '" & 	Session("Empresa_usuario") & "', 0" & +_
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
					exit do
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
															cDbl(RsTemp("AuthorizationCode")) & ", 0" & +_																											
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
															", 0" & Cuota & ", 0" & cDbl(RsTemp("OperationNumber"))
			
				set rs=Conn.Execute(sql)
				if Conn.Errors.Count <> 0 then
					Error = "S"
					MensajeError = Err.Description
					Log_error sql , Err.Description
					exit do
				end if				
			end if

			Total_pagos_transbank = Total_pagos_transbank + 1		
			RsTemp.MoveNext	
		loop	
	end if

	RsTemp.close
	set RsTemp = nothing
end if 

if Error = "N" then 
	Conn.CommitTrans
	Response.Write("OK|"& Total_pagos_transbank & "|" & Numero_despacho_de_venta)
else	
	Conn.RollbackTrans	
	Response.Write("Error|" & LimpiaError(MensajeError))
end if 

Conn1.close()
Conn.Close()
response.End()%>
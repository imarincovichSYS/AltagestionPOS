<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
<%
	SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=3600	
	
	Ticket	  = Request("Ticket")
	NroDoc    = Request("NroDoc")	
	NroIntDOV = Request("NroIntDOV")
	
	Numero_OrdenVenta = Request("Numero_OrdenVenta")

	cSql = "Exec MOP_ListaMovimientosProductos Null, Null, '" & Session("Empresa_usuario") & "', 'OVT', 0" & Numero_OrdenVenta & ", Null, Null, Null"
	Set Rs = Conn.Execute ( cSql ) 
	Do While Not Rs.Eof
		Items		= Items & Rs("Numero_interno_movimiento_producto") & "|" & Rs("Control") & "¬"
		Rs.MoveNext
	Loop
	Rs.close
	Set Rs = Nothing
	
	cSql = "Exec MOP_ListaMovimientosProductos Null, Null, '" & Session("Empresa_usuario") & "', 'DVT', 0" & Request("NroDoc") & ", Null, Null, Null"
	Set Rs = Conn.Execute ( cSql ) 
	Imprimir = "S"

	Detalle = ""
	
	Do While Not Rs.Eof
		Bodega = Rs("Bodega")
		if cDbl("0" & Rs("Cantidad_salida")) > 0 then
			' 0000000000111111111 122222222 223333333 333444444 44445555555555666666666677777777778888888888
			' 0123456789012345678 901234567 890123456 789012345 67890123456789012345678901234567890123456789	    
			'" 131113210987654321 000001000 000000100 000000100 YOGHURT HUESITOS" 'Detalles
			'" 13111375972        000001000 000035730 000000000 IMPRESORA LEXMARK Z605|¬|
			Producto    = cStr(Left(Rs("Producto") & Space(13),13))
			ProductoCat = cStr(Left(Rs("Producto_Catalago") & Space(13),13))
			Descripcion = cStr(Left(Rs("Desc_producto"),90))
			Cantidad    = cStr(Right("000000" & Int(cDbl(Rs("Cantidad_salida"))),6))
			'Decimales	= cStr(cDbl(Rs("Cantidad_salida")) - Int(cDbl(Rs("Cantidad_salida"))))
			Decimales	= Round(cStr(cDbl(Rs("Cantidad_salida")) - Int(cDbl(Rs("Cantidad_salida")))),4)
			Decimales	= Left(Replace(Decimales,"0.","") & "000", 3)

			PrecioNeto   = cDbl("0" & Rs("Neto")) 'cDbl("0" & Rs("Precio_de_lista_modificado"))
			PrecioConIva = PrecioNeto  * ( 1 + ( cDbl("0" & Session("PCTGEIVA")) / 100 ) )

			PrecioUnit   = cStr(Right("000000000" & Redondear(PrecioConIva+.1,0),9))  

			SubTotalNeto = cDbl("0" & Redondear(PrecioConIva+.1,0)) * cDbl("0" & Rs("Cantidad_salida"))
			TotalNeto    = cStr(Right("000000000" & Redondear(SubTotalNeto+.1,0),9))

			Detalle		= Detalle & ("13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & ProductoCat & " -- " & Descripcion & "|¬|")

			Total		= Total + cDbl("0" & Redondear(SubTotalNeto,0))
		end if
		Rs.MoveNext
	Loop
	Rs.Close
	Set Rs = Nothing	
	Conn.Close

'if Numero_OrdenVenta = 3921 then
'	Response.Write Detalle & chr(13)
'	Response.Write Total
'	Break
'end if

if Imprimir = "S" Then %>
	<script language="VbScript">
		'On Error resume next
			Dim xError
			Dim MSComm1, Buffer
			Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
			'if Err.Number > 0 then				
			'	if Instr(1,Err.Description, "ActiveX") > 0 then
			'		Msgbox ( "No se puede imprimir boletas desde este computador. Comuniquese con el Administrador." )
			'	else
			'		Msgbox ( Err.Description )
			'	end if
			'	xError = "060"
			'else
				MSComm1.Settings = "19200,N,8,1"
				MSComm1.CommPort = 1
				MSComm1.PortOpen = True          ' open port
				MSComm1.InBufferCount = 0
				MSComm1.InputLen = 0              ' disable input
				MSComm1.InputMode = comInputModeText
				MSComm1.RTSEnable = True         ' Ensure high for power

				Delay(3)

				aDetalle = Split("<%=Detalle%>","|¬|")

				ReDim mtxDetalle(Ubound(aDetalle)+5)
				mtxDetalle(0) = "000"
				mtxDetalle(1) = "12"
				For a=0 to Ubound(aDetalle)-1
					mtxDetalle(a+2) = aDetalle(a)
				next
				mtxDetalle(a+2) = "20" & cStr(Right("0000000000" & <%=Total%>,10)) 'Detalles
				'2611 + 01 = Efectivo
				'2611 + 02 = Cheque
				'2611 + 03 = Tarjeta de credito
				'2611 + 04 = Tarjeta de debito
				'2611 + 05 = Tarjeta Propia
				'2611 + 06 = Cupon
				'2611 + 07 = Otros 1
				'2611 + 08 = Otros 2
				'2611 + 09 = Otros 3
				'2611 + 10 = Otros 4
				mtxDetalle(a+3) = "261101" & cStr(Right("0000000000" & <%=Total%>,10)) 'Forma de pago
				mtxDetalle(a+4) = "271000000000" 'Donación
				mtxDetalle(a+5) = "99" 'Fin linea con corte de papel

			    if Err <> "060" then
					For a = 0 To Ubound(mtxDetalle)
						MSComm1.Output = Chr(135) + mtxDetalle(a) + Chr(136)
						if a=0 then Delay(3) else Delay(1)
						xError = Lectura(0)
					    
						If InStr(1, xError, "La impresora no responde") > 0 Then
						    MsgBox ("La impresora no está conectada u otro problema la afecta, apague y encienda.")
						    xError = "060"
						    exit for
						End If
						
						If Len(Trim(xError)) > 0 Then
							Msgbox "Se ha producido un error " & Trim(xError), vbOKOnly, " :. Advertencia .: " 
						    Do While Len(Trim(xError)) > 0
								if Instr(1,xError,"Se espera comando repetir") > 0 then
									MSComm1.Output = Chr(135) + "18" + Chr(136)
								elseif Instr(1,xError,"Falta Papel o la Tapa de Impresora está abierta") > 0 then
									Msgbox "Para continuar coloque más papel o cierre la tapa de impresora.",vbOKOnly," :. Advertencia .: "
									MSComm1.Output = Chr(135) + mtxDetalle(a) + Chr(136)						
								elseif Instr(1,xError,"Comando no puede hacerse en período de No Venta") > 0 then
									MSComm1.Output = Chr(135) + "99" + Chr(136)
									xError = "060"
									Exit Do
								elseif Instr(1,xError,"Han transcurrido más de 26 horas de período de venta") > 0 then
									MSComm1.Output = Chr(135) + "99" + Chr(136)
									xError = "060"
									Exit Do
								else
									Msgbox ( xError )
								end if        
								If InStr(1, xError, "La impresora no responde") > 0 Then
								    MsgBox ("La impresora no está conectada u otro problema la afecta, apague y encienda.")
								    xError = "060"
								    exit do
								End If
								Delay(1)
								xError = Lectura(0)
						    Loop 
						    if xError = "060" then exit for
						End If
					Next
			    
					if xError <> "060" Then
						'Para rescatar el numero de la boleta impresa
						MSComm1.Output = Chr(135) + "482" + Chr(136)
						Delay(1)
						xError = Lectura(1)
						If InStr(1, xError, ":") > 0 Then
						    NumeroBoleta = Split(xError, ":")
						End If
					end if
				end if					
				MSComm1.PortOpen = False
			'end if

			if xError = "060" Then
				'alert ( 1 )
				location.href = "ActualizaBoleta.asp?NroIntDOV=<%=NroIntDOV%>&Funcion=<%=Request("Funcion")%>&Err=" + xError + "&Items=<%=Items%>&NroDOV=<%=Request("NroDOV")%>&Numero_OrdenVenta=<%=Numero_OrdenVenta%>"
			else
				'alert ( 2 )
				location.href = "ActualizaBoleta.asp?NroIntDOV=<%=NroIntDOV%>&Funcion=<%=Request("Funcion")%>&NroBoleta=" & NumeroBoleta(0) & "&Err=" + xError + "&Items=<%=Items%>&NroDOV=<%=Request("NroDOV")%>&Numero_OrdenVenta=<%=Numero_OrdenVenta%>&Ticket=<%=Ticket%>&NroDoc=<%=NroDoc%>&Bodega=<%=Bodega%>"
			end if
	</script>
<% end if%>
</body>
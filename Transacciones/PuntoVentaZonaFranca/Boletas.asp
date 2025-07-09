<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
<%
    Cache 
    
	SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=100	
	
	Ticket	  = Request("Ticket")
	NroDoc    = Request("NroDoc")	
	NroIntDOV = Request("NroIntDOV")
	
	Numero_OrdenVenta = Request("Numero_OrdenVenta")

    cSql = "Exec PAR_ListaParametros 'IMPBOLEVTA'"
    Set Rs = Conn.Execute ( cSql )
    If Not Rs.Eof then
        Puerto = Rs("Valor_Texto")
    else
        Puerto = "COM1"
    end if
    Rs.Close
    if Puerto = "COM1" Then 
        Puerto = 1
    elseif Puerto = "COM2" Then
        Puerto = 2
    elseif Puerto = "COM3" Then
        Puerto = 3
    elseif Puerto = "COM4" Then
        Puerto = 4
    elseif Puerto = "COM7" Then
        Puerto = 7
    end if    

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
'Response.Write cSql
	
	nMontoDescuento = 0
	nPrecioCero = 0
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
			Decimales	= Round(cStr(cDbl(Rs("Cantidad_salida")) - Int(cDbl(Rs("Cantidad_salida")))),4)
			Decimales	= Left(Replace(Decimales,"0.","") & "000", 3)

			MontoDescuento = 0
		    Porcentaje_Dscto = cDbl("0" & Rs("Pctje_Desc"))
		    
			PrecioNeto   = cDbl("0" & Rs("Precio_de_lista_modificado")) 
			'if PrecioNeto = 0 then
            ''    PrecioNeto = 1
    		'	PrecioUnit   = cStr(Right("000000000" & PrecioNeto,9))
    		'	SubTotalNeto = cDbl("0" & PrecioNeto ) * cDbl("0" & Rs("Cantidad_salida"))
            ''    nPrecioCero = nPrecioCero + SubTotalNeto
            ''    PrecioNeto = 0
			'else
    			if Session("ValoresConIva") = "S" then
                    PrecioConIva = Redondear( PrecioNeto  * ( 1 + ( cDbl("0" & Session("PCTGEIVA")) / 100 ) ) + 0.001,0)
    			else
                    PrecioConIva = PrecioNeto
    			end if
    			PrecioUnit   = cStr(Right("000000000" & PrecioConIva,9))
    			SubTotalNeto = cDbl("0" & PrecioConIva ) * cDbl("0" & Rs("Cantidad_salida"))
            'end if           
			
			TotalNeto    = cStr(Right("000000000" & Redondear(SubTotalNeto + 0.001,0),9))
			Detalle		= Detalle & ("13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & ProductoCat & " -- " & Descripcion & "|¬|")

            if PrecioNeto > 0 then
    			if cDbl("0" & Rs("Pctje_Desc")) > 0 then
                    MontoDescuento = Redondear( (SubTotalNeto * ( Porcentaje_Dscto / 100 ) ) + 0.001,0)
                    nMontoDescuento = nMontoDescuento + MontoDescuento  
                    MontoDescuento = cStr(Right("000000000" & MontoDescuento,9))
                    Detalle = Detalle & ("1511" & MontoDescuento & Right( Repetir("*", 30) & " DESCUENTO",30) & "|¬|")
    			end if
    		end if

			Total		= Total + cDbl("0" & Redondear(SubTotalNeto,0)) 
		end if
		Rs.MoveNext
	Loop
	Rs.Close
	Set Rs = Nothing	
	Conn.Close
	Total = Round( (Total - nMontoDescuento ) + 0.001, 0) 
    
'Response.Write REPLACE( Detalle, "|¬|", CHR(13) ) & chr(13)
'Response.Write Total & " --- " & nPrecioCero
'Response.End

if Imprimir = "S" Then %>
	<script language="VbScript">
        On Error resume next
		    Dim nSegundos 
			Dim xError
			Dim TextoError
			Dim MSComm1, Buffer
			Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
				MSComm1.Settings = "19200,N,8,1"
				if len(Trim(Err.Description)) > 0 then
				    xError = "060"
                    TextoError = Err.Description
                end if
                if xError <> "060" then  
				    MSComm1.CommPort = <%=Puerto%>
				    if len(Trim(Err.Description)) > 0 then
				        xError = "060"
                        TextoError = Err.Description
                    end if
				end if
                if xError <> "060" then  
    				MSComm1.PortOpen = True          ' open port
				    if len(Trim(Err.Description)) > 0 then
				        xError = "060"
                        TextoError = Err.Description
                    end if
				end if
                if xError <> "060" then  
    				MSComm1.InBufferCount = 0
    				MSComm1.InputLen = 0              ' disable input
    				MSComm1.InputMode = comInputModeText
    				MSComm1.RTSEnable = True         ' Ensure high for power
				end if

    			if len(trim(TextoError)) > 0 then 
                    Msgbox "Se produjo un error con la impresora: " & chr(13) & TextoError, vbOkOnly + 16, "Error"
                end if
				
			    if xError <> "060" then
        			nSegundos = 250

    				aDetalle = Split("<%=Detalle%>","|¬|")
    
    				ReDim mtxDetalle(Ubound(aDetalle)+5)
    				mtxDetalle(0) = "000"
    				mtxDetalle(1) = "12"
    				For a=0 to Ubound(aDetalle)-1
    					mtxDetalle(a+2) = aDetalle(a)
    				next
    				'mtxDetalle(a+2) = "1711" & cStr(Right("000000000" & <%=nPrecioCero%>,9)) & Right( Space(30) & "DESCUENTO TOTAL",30) 'Descuento Total
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
    
					For a = 0 To Ubound(mtxDetalle)
'Msgbox ( mtxDetalle(a) )
						MSComm1.Output = Chr(135) + mtxDetalle(a) + Chr(136)
						'if a=0 then pausecomp( nSegundos ) else 
                        pausecomp( nSegundos )
						xError = Lectura(0)
					    if a <> Ubound(mtxDetalle) then
    						If InStr(1, xError, "La impresora no responde") > 0 Then
                                TextoError = "La impresora no está conectada u otro problema la afecta, apague y encienda." & mtxDetalle(a)  						    
    						    MsgBox ( TextoError & xError ) 
    						    xError = "060"
    						    exit for
    						End If
    						
    						If Len(Trim(xError)) > 0 Then
                                TextoError = "Se ha producido un error " & Trim(xError) 						    
    							Msgbox TextoError, vbOKOnly, " :. Advertencia .: " 
    						    Do While Len(Trim(xError)) > 0
    								if Instr(1,xError,"Se espera comando repetir") > 0 then
    									MSComm1.Output = Chr(135) + "18" + Chr(136)
    								elseif Instr(1,xError,"Falta Papel o la Tapa de Impresora está abierta") > 0 then
    									Msgbox "Para continuar coloque más papel o cierre la tapa de impresora.",vbOKOnly," :. Advertencia .: "
    									MSComm1.Output = Chr(135) + mtxDetalle(a) + Chr(136)						
    								elseif Instr(1,xError,"Comando no puede hacerse en período de No Venta") > 0 then
    									MSComm1.Output = Chr(135) + "99" + Chr(136)
    									xError = "060"
                                        TextoError = "Comando no puede hacerse en período de No Venta"
    									Exit Do
    								elseif Instr(1,xError,"Han transcurrido más de 26 horas de período de venta") > 0 then
    									MSComm1.Output = Chr(135) + "99" + Chr(136)
    									xError = "060"
                                        TextoError = "Han transcurrido más de 26 horas de período de venta"
    									Exit Do
    								else
    									Msgbox ( xError )
    									'Nuevo
    									TextoError = mtxDetalle(a)
    								    xError = "060"
    								    exit do
    								    'Fin nuevo
    								end if        
    								If InStr(1, xError, "La impresora no responde") > 0 Then
    								    TextoError = "La impresora no está conectada u otro problema la afecta, apague y encienda." & mtxDetalle(a)
    								    MsgBox ( TextoError )
    								    xError = "060"
    								    exit do
    								End If
    								pausecomp( nSegundos )
    								xError = Lectura(0)
    						    Loop 
    						    if xError = "060" then exit for
    						End If
						End If
					Next
'msgbox ( "Aqui ")
					if xError <> "060" Then
					    xError = ""
						'Espera hasta rescatar el numero de la boleta impresa
						NumeroBoleta = 0
						Do While len(trim(xError)) = 0   
    						MSComm1.Output = Chr(135) + "482" + Chr(136)
    						Delay( 2 )
    						xError = Lectura(1)
                            If InStr(1, xError, ":") > 0 Then
    						    aNumeroBoleta = Split(xError, ":")
    						    NumeroBoleta = aNumeroBoleta(0)
    						    if NumeroBoleta = 0 then
    						      xError = ""
    						    end if
    						else
    						  xError = ""
    						End If
						Loop
					end if

				end if					
				MSComm1.PortOpen = False
				
'xError = "060"

			if xError = "060" Then
				'alert ( 1 )
				location.href = "ActualizaBoleta.asp?NroIntDOV=<%=NroIntDOV%>&Funcion=<%=Request("Funcion")%>&Err=" + xError + "&Items=<%=Items%>&NroDOV=<%=Request("NroDOV")%>&Numero_OrdenVenta=<%=Numero_OrdenVenta%>&Ticket=<%=Ticket%>&TextoError=" + TextoError
			else
				'alert ( 2 )
				location.href = "ActualizaBoleta.asp?NroIntDOV=<%=NroIntDOV%>&Funcion=<%=Request("Funcion")%>&NroBoleta=" & NumeroBoleta & "&Err=" + xError + "&Items=<%=Items%>&NroDOV=<%=Request("NroDOV")%>&Numero_OrdenVenta=<%=Numero_OrdenVenta%>&Ticket=<%=Ticket%>&NroDoc=<%=NroDoc%>&Bodega=<%=Bodega%>&TextoError=" + TextoError
			end if
	</script>
<% end if%>
</body>

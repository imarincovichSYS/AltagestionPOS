<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->
<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

  Impresora = "\\192.168.30.12\texto"

	Function TxtPrint(Margen_izquierdo,valor)
    valor = cambia_chr(valor)
		if Instr(1,valor,chr(13)) > 0 then
			cTexto = ""
			caracter = "¬"
			valor = Replace(valor,chr(13),caracter)
			Do While Instr(1,valor,caracter) > 0 
				nPosIni = Instr(1,valor,caracter)
				cTexto = cTexto & "Locales.imprimir " & chr(34) & space(Margen_izquierdo) & Mid(valor,1,nPosIni-1) & chr(34) & chr(13)
				valor =  Mid(valor,nPosIni+1)
			Loop
			cTexto = cTexto & "Locales.imprimir " & chr(34) & space(Margen_izquierdo) & valor & chr(34) & chr(13)
			TxtPrint = cTexto
		else
			TxtPrint = "Locales.imprimir " & chr(34) & valor & chr(34)
		end if
	End Function
  
  Function PadR(Texto,Posiciones)
     PadR = Left( Texto & Space(500) , Posiciones)
  End Function
  
  Function PadL(Texto,Posiciones)
     PadL = Right( Space(500) & Texto , Posiciones)
  End Function

  Function StrZero(Numero,Posiciones)
     StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
  End Function

	Function FechaLarga( valor )
		Dia = Day(Valor)
		Mes = Month(Valor)
		Ano = Year(Valor)
		FechaLarga = Right("00" & Dia,2) & "/" & Ucase(Left(NombreMes(Mes),3)) & "/" & Ano
	End Function

	Margen_izquierdo =  5 'Margen izquierdo ?
  Crlf = chr(13)
  Comprimida = chr(18) & chr(15)
  Normal = chr(27) & chr(54) & chr(18) & chr(27) & chr(58) ' chr(27) & "M" <- EPSON ' chr(18) & chr(27) & chr(58) <- OKI '               'chr(28) 'chr(27) & chr(63) & chr(2)
  SaltoPagina = chr(12)
  Inicio_bold = chr(27) & chr(69)
  Fin_bold = chr(27) & chr(70)
  Inicio_doble = chr(27) & chr(87) & chr(49)
  Fin_doble = chr(27) & chr(87) & chr(48)

  Tipo_cambio = 534.23
  Factura = space(60) & Inicio_doble & "78128" & Fin_doble & Crlf & Crlf & _
            space(60) & FormatNumber(Tipo_cambio,2) & Crlf & Crlf & _
            space(50) & FechaLarga(now()) & Crlf & Crlf & Crlf & _
            PadR("Jorge Mason Salinas",30) & PadR("Monitor Araucano 0680",33) & PadL("9.150.843-5",12) & Crlf & Crlf

  Factura = Factura & Comprimida & Crlf & Crlf
  Total_cif = 0
  Total = 0
  For n = 1 to 3
      Cantidad = n
      Precio = 23600
      Cif = 23.21
      Total_cif = Total_cif + Cif * Cantidad
      Total = Total + Precio * Cantidad
      Factura = Factura & PadL(Cantidad,7) & "     " & _
                PadL("UNIDAD",9) & "  " & _
                PadR("PR01",10) & "  " & _
                PadR("Descripción del producto",30) & "     " & _
                PadL( FormatNumber(Precio,0) , 12 ) & "   " & _
                PadR("TIP,234,2006,12",20) & "  " & _
                PadL( FormatNumber(Cif * Cantidad,2) , 8 ) & "       " & _
                PadL( FormatNumber(Precio * Cantidad,0) , 10 ) & Crlf
  Next
  For u = n to 18
      Factura = Factura & Crlf
  Next
  Impuesto = ( Total_cif * Tipo_cambio * 0.011 \ 1 )
  Factura = Factura & Space(20) & "SON: " & Escribir( Total + Impuesto ) & Crlf
  Factura = Factura & Space(107) & PadL( FormatNumber( Total_cif ,2) , 8 ) & "     " & _
                                   PadL( FormatNumber( Total,0) , 12 ) & Crlf & Crlf
  Factura = Factura & Space(120) & PadL( FormatNumber( Impuesto ,0) , 12 ) & Crlf & Crlf
  Factura = Factura & Space(120) & PadL( FormatNumber( Total + Impuesto ,0) , 12 ) & Crlf

  Factura = Factura & Normal

  
  Factura = TxtPrint(Margen_izquierdo,Factura)

%>
<HTML>
	<OBJECT classid="CLSID:B829BCD0-3892-11D3-A519-0000216ABE11" 
	      codebase="../../Impresion/Impresora.CAB#version=2,0,0,1" 
		id=Locales style="LEFT: 0px; TOP: 0px">
		<PARAM NAME="_ExtentX" VALUE="503">
		<PARAM NAME="_ExtentY" VALUE="503">
	</OBJECT>

	<Script language="VBScript">
	    Dim Puerto    
			If Locales.InicioImpresion("<%=Impresora%>") then
			<%	Response.Write Factura %>
				Locales.FinImpresion
			Else
				Msgbox "Verifique el estado de la impresora",16,"Error" 	
			End if
	</Script>

</HTML>

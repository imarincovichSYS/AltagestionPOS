<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->

<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	Ticket = Request("Ticket")	

	cSql = "Exec PAR_ListaParametros 'IMPFACTURAS'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		Impresora = Rs("Valor_texto")
	else
		Impresora = "LPT1"
	end if
	Rs.Close
	Set Rs = Nothing
  
  'Impresora = "C:\Impresora\impresora.txt"

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

	NroDoc		= Request("NroFac")
	if len(trim(NroDoc)) = 0 then NroDoc = "Null"
	Documento		= Request("Documento")
	if len(trim(Documento)) = 0 then Documento = "Null" Else Documento = "'" & Documento & "'"
	NroFactura		= Request("NroFactura")
	if len(trim(NroFactura)) = 0 then NroFactura = "Null"
	Pagina		= Request("Pagina")

	cSql_C = "Exec FAC_ListaCabeceraFactura '" & Session("Empresa_usuario") & "', " & NroDoc & ", " & Documento & ", " & NroFactura
'Response.Write cSql_C	
	SET RsC	=	Conn.Execute( cSql_C )

		NroFactura			= RsC("NroFactura")
		Senores				= cambia_chr( RsC("Nombre_Cliente") )
			Digito		= Replace(RsC("Rut_Cliente"),".","")
			Digito		= valida_rut(Right(cStr("00000000" & Digito),8))
			Rut_Cliente	= RsC("Rut_Cliente") & "-" & cStr(Digito)
		
		Direccion		= cambia_chr( RsC("Direccion") )
		Moneda			= cambia_chr( RsC("Moneda") )
		Vendedor		= cambia_chr( RsC("Vendedor") )
		Fecha			= RsC("Fecha")
		
		Comuna			= cambia_chr( RsC("Comuna") )
		Nombre_Comuna	= cambia_chr( RsC("Nombre_Comuna") )
		
		Giro			= cambia_chr( RsC("Giro") )
		Telefono		= RsC("Telefono")
		
		Guia			= RsC("Guia")
		CondicionPago	= cambia_chr( RsC("CondicionPago") )
		Vencimiento		= RsC("Vencimiento")
		
		NotaVenta		= RsC("NotaDeVenta")
		DespacharA		= cambia_chr( RsC("DespacharA") )
		OrdenDeCompra	= RsC("OrdenDeCompra")
		
		Transporte		= cambia_chr( RsC("Transporte") )
		Peso			= RsC("Peso")

		Nombre_vendedor	= RsC("Nombre_vendedor")
	
		NombreBodega	= cambia_chr( RsC("Nombre_Bodega") )
    DireccionBodega	= cambia_chr( RsC("Direccion_Bodega") )
		Bodega			= RsC("Bodega")

		MontoExento		= cDbl("0" & RsC("Exento") )
		MontoNeto		= cDbl("0" & RsC("Afecto")   )
		MontoIva		= cDbl("0" & RsC("Iva")    )
		MontoTotal		= cDbl("0" & RsC("Total")  )
    
    Tipo_documento_zona_franca_OrdenVtaSUP = RsC("Tipo_documento_zona_franca")

    Aduana_presentacion_OrdenVtaSUP = cambia_chr( RsC("Aduana_presentacion_documento_venta") )
    Persona_que_presenta_OrdenVtaSUP = cambia_chr( RsC("Persona_que_presenta_documento_venta") )

		Observaciones	= cambia_chr( RsC("Observaciones") )

  	Margen_izquierdo =  5 'Margen izquierdo ?
    Marca_impresora = "EPSON"
    Crlf = chr(13)
    SaltoPagina = chr(12)
    Inicio_bold = chr(27) & chr(69)
    Fin_bold = chr(27) & chr(70)
    Inicio_doble = chr(27) & chr(87) & chr(49)
    Fin_doble = chr(27) & chr(87) & chr(48)
    if Marca_impresora = "IBM" then
       Comprimida = chr(18) & chr(15)
       Normal = chr(27) & chr(54) & chr(18) & chr(27) & chr(58)
    elseif Marca_impresora = "EPSON" then
       Comprimida = chr(27) & chr(15)
       Normal = chr(27) & chr(77)
    end if

    Factura = Normal & Crlf

    if Tipo_docuento_zona_franca_OrdenVtaSUP = "TU" then
       Factura = Factura & space(25) & "SOLICITUD DE TRASPASO A USUARIO      TU         " & Fecha
    elseif Tipo_docuento_zona_franca_OrdenVtaSUP = "SRF" then
       Factura = Factura & space(25) & "SOLICITUD DE REGISTRO FACTURA        R         " & Fecha
    else
       Factura = Factura & space(25) & "SOLICITUD DE REEXPEDICION FACTURA    SRF         " & Fecha
    end if
    
    Factura = Factura & Crlf & Crlf & Crlf

	 'Código de la aduana para impresión
   cSql = "Exec PAR_ListaParametros 'ADUCODIGO'"
   Set Rs = Conn.Execute ( cSql )
	 If Not Rs.Eof then
		  Codigo_aduana_presentacion_OrdenVtaSUP = Rs("Valor_texto")
   end if
	 Rs.Close
	 Set Rs = Nothing
    
    Factura = Factura & space(25) & padR(Aduana_presentacion_OrdenVtaSUP,26) & space(5) & Codigo_aduana_presentacion_OrdenVtaSUP & Crlf & Crlf
    Factura = Factura & space(25) & padR(Persona_que_presenta_OrdenVtaSUP,26) & Crlf

    Factura = Factura & space(65) & "CIF TOTAL US$    <TCUS$>" & Crlf
    Factura = Factura & Crlf & Crlf & Crlf & Crlf & Crlf

    Factura = Factura & PadR(Senores,46) & Rut_cliente & Crlf
    Factura = Factura & space(5) & PadR( trim(Direccion) & "," & Nombre_Comuna,40) & Crlf & Crlf

    Factura = Factura & PadR(DireccionBodega,25) & Crlf
    Factura = Factura & PadR(NombreBodega,25) & space(5) & PadR(Bodega,3) & space(5)
    
    if trim(Moneda) = "$" then
       Factura = Factura + "PESOS               01" & Crlf
    else
       Factura = Factura + "DOLARES             02" & Crlf
    end if

		'Cabecera = ""
		'Cabecera = Cabecera & TxtPrint( chr(15) & space(7+x_Pos) & Senores & space(52-len(Senores)) & Rut_Cliente & space(35-len(Rut_Cliente)) & NroFactura ) & chr(13)					' Señores - Rut - Factura
		'Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		'Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Direccion & space(40-len(Left(Direccion,40))) & space(12) & Nombre_vendedor & Space(26-len(Left(Nombre_vendedor,26))) & space(9) & Fecha )	& chr(13)	' Dirección - Vendedor - Fecha
		'Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Nombre_Comuna & space(52-len(left(Nombre_Comuna,52))) & Giro & Space(27-len(Left(Giro,27))) & space(8) & Telefono )	& chr(13)						' Dirección - Giro - Telefono
		'Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		'Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & Guia & space(24-len(Guia)) & space(18) & Trim(CondicionPago) & space(28-len(Trim(left(CondicionPago,28)))) & space(13) & Vencimiento ) & chr(13)	' Guia - Condicion de pago - Vencimiento
		'Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & NotaVenta & space(23-len(NotaVenta)) & space(16) & DespacharA ) & chr(13)	' Nota de venta - Despacha a
		'Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 	& chr(13)
		'Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & OrdenDeCompra & space(23-len(OrdenDeCompra)) & space(16) & Left(Transporte,30) & Space(38-len(Left(Transporte,30))) & Space(11) & Peso ) & chr(13)	' Orden de compra - Transporte - Peso
		'Cabecera = Cabecera & TxtPrint( space(8+x_Pos) & Observaciones )						& chr(13)	' Observaciones
		'Cabecera = Cabecera & TxtPrint( Space(20) & NombreBodega )							& chr(13)
		'Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		'Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)

	RsC.Close
	SET RsC = Nothing
		
	cSql_D = "Exec FAC_ListaCuerpoFactura '" & Session("Empresa_usuario") & "', " & NroDoc & ", " & Documento & ", " & NroFactura
'Response.Write cSql_C	
	SET RsD	=	Conn.Execute( cSql_D )
  
  Factura = Factura & Crlf & Crlf & Crlf
    
  'Cuerpo de la Factura
  n = 1
  nl = 0
  Total_impuesto_US = 0
  Total_impuesto_pesos = 0
  Tipo_cambio = ""
  Total_pesos = 0
  Total_cif_US = 0
	Do While Not RsD.Eof
     Tipo_cambio = RsD("Valor_paridad_moneda_oficial")
     Cantidad = cdbl(RsD("Cantidad"))
     Cif = cdbl(RsD("Costo_cif_ori_US$"))
     Total_cif_US = Total_cif_US + Cif * Cantidad
     Total_impuesto_US = Total_impuesto_US + cdbl( rsD("Monto_impuesto_aduanero_US$") )
     Total_impuesto_pesos = Total_impuesto_pesos + cdbl( rsD("Monto_impuesto_aduanero_moneda_oficial") )
     Total_pesos = Total_pesos + cdbl( RsD("Total") )
	   Factura = Factura & strzero(n,2) & "  " & _
               PadL(Cantidad,8) & "   " & _
               PadR(RsD("Unidad_de_medida_consumo"),3) & "   " & _
               PadR( RsD("Descripcion") , 27 ) & "  " & _
               PadR( RsD("Tipo_documento_de_compra") & "," & _
                     RsD("Numero_documento_de_compra") & "," & _
                     RsD("Año_Doc_Compra") & "," & _
                     RsD("Numero_de_linea_en_RCP_o_documento_de_compra") , 18 ) & _
               PadL( FormatNumber(RsD("Precio"),0) , 10 ) & _
               PadL( FormatNumber(RsD("Total"),0) , 12 ) & CrLf
     Factura = Factura & space(21) & _
               "CIF Uni US$  " & RsD("Tipo_documento_de_compra") & _
               "   CIF TOTAL US$ " & ( Cantidad * Cif ) & CrLf
     n = n + 1
     nl = nl + 2
     RsD.MoveNext
	Loop
	
  Factura = replace( Factura , "<TCUS$>" , Total_cif_US & "" )
  For n = nl to 26 'Aquí dejar en 30 para hoja real
      Factura = Factura & Crlf
  Next

  'Resumen Impuestos
  Factura = Factura & _
            space(40) & "IMPUESTO 0.9% US$: " & FormatNumber(Total_impuesto_US,2) & CrLf & _
            space(40) & "T/C AL " & Fecha & " $ " & FormatNumber(Tipo_cambio,2) & CrLf & _
            space(40) & "IMPUESTO 0.9 % M/N: $ " & FormatNumber(Total_impuesto_pesos,2) & CrLf & CrLf & CrLf

  'Totales finales
  Factura = Factura & space( 66 ) & _
            PadL( FormatNumber(Total_impuesto_US,2) , 12 ) & _
            PadL( FormatNumber(Total_pesos,0) , 12 ) & CrLf & CrLf & CrLf & CrLf & CrLf & CrLf
  Factura = Factura & space( 78 ) & _
            PadL( FormatNumber(Total_pesos,0) , 12 )

	MontoEscrito = Trim( Escribir(MontoTotal) )

  Factura = TxtPrint(0,Factura)

	RsD.Close
	SET RsD = Nothing
	Conn.Close
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

		if "<%=Ticket%>" = "S" Then
			parent.location.href = "../Ticket/Ticket.asp?NroDoc=<%=Request("NroDoc")%>&Despacho=S&Funcion=<%=Request("Funcion")%>&Bodega=<%=Bodega%>"
		else
			if "<%=Request("Funcion")%>" = "Despacho" then
				parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaZonaFranca/Inicial_DespachoZf.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaZonaFranca/Botones_DespachoZf.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			elseif "<%=Request("Funcion")%>" = "DespachoIPAQ" then
				parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Inicial_DespachoIPAQ.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Botones_DespachoIPAQ.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			end if
		end if
	</Script>

</HTML>

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

	cSql_C = "Exec FAC_ListaCabeceraActaDestruccion '" & Session("Empresa_usuario") & "', " & NroDoc & ", " & Documento & ", " & NroFactura
'Response.Write cSql_C & "<br>"

	SET RsC	=	Conn.Execute( cSql_C )

		NroFactura			= RsC("NroFactura")
		Fecha			= RsC("Fecha")
		
		NotaVenta		= RsC("NotaDeVenta")

		NombreBodega	= cambia_chr( RsC("Nombre_Bodega") )
    DireccionBodega	= cambia_chr( RsC("Direccion_Bodega") )
		Bodega			= RsC("Bodega")
    
    Nombre_empresa = cambia_chr( RsC("Nombre_empresa") )

		Rut_empresa	= RsC("Rut_empresa")

    Rut_empresa = cambia_chr( RsC("Rut_empresa") )

    Aduana_presentacion_OrdenVtaSUP = cambia_chr( RsC("Aduana_presentacion_documento_venta") )
    Persona_que_presenta_OrdenVtaSUP = cambia_chr( RsC("Persona_que_presenta_documento_venta") )
    
		Observaciones	= cambia_chr( RsC("Observaciones") )	

  	Margen_izquierdo =  5 'Margen izquierdo ?
    Marca_impresora = "IBM"
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
    
    
  ''  if Marca_impresora = "IBM" then
  ''     Normal = chr(27) & chr(54) & chr(18) & chr(27) & chr(58)
   '' elseif Marca_impresora = "EPSON" then
    ''   Normal = chr(18) & chr(27) & chr(77)
    'end if
    'Comprimida = chr(15)
		Largo_66 = chr(27) & chr(67) & chr(66)
    Largo_78 = chr(27) & chr(67) & chr(78)

    Cabecera = Largo_78 & Normal & CrLf & CrLf

    Cabecera = Cabecera & space(45) &    "ACTA DE DESTRUCCION                         AD"

    Cabecera = Cabecera & Crlf & Crlf & Crlf

	 'Código de la aduana para impresión
   cSql = "Exec PAR_ListaParametros 'ADUCODIGO'"
   Set Rs = Conn.Execute ( cSql )
	 If Not Rs.Eof then
		  Codigo_aduana_presentacion_OrdenVtaSUP = Rs("Valor_texto")
   end if
	 Rs.Close
	 Set Rs = Nothing
    
   Cabecera = Cabecera & space(32) & padR(Aduana_presentacion_OrdenVtaSUP,26) & space(5) & Codigo_aduana_presentacion_OrdenVtaSUP & Crlf & Crlf
   Cabecera = Cabecera & space(32) & padR(Persona_que_presenta_OrdenVtaSUP,26)

   Cabecera = Cabecera + "             DOLARES                02" & Crlf & Crlf & Crlf

   Cabecera = Cabecera & space(66) & PadR(NombreBodega,22) & space(3) & PadR(Bodega,3) & Crlf & CrLf
   Cabecera = Cabecera & space(66) & PadR(NombreBodega,22) & space(3) & PadR(Bodega,3) & Crlf

   Cabecera = Cabecera & Crlf & Crlf

   Cabecera = Cabecera & space(4) & PadR(Nombre_empresa,46) & Rut_empresa & Crlf & Crlf  
   Cabecera = Cabecera & space(14) & "MANZANA 7 Z.FRANCA" & space(18) & "T-217 21/07/2017"

   Cabecera = Cabecera & Crlf & Crlf & Crlf & Crlf

	RsC.Close
	SET RsC = Nothing
		
	cSql_D = "Exec FAC_ListaCuerpoFactura '" & Session("Empresa_usuario") & "', " & NroDoc & ", " & Documento & ", " & NroFactura
'Response.Write cSql_D & "<br>"
	SET RsD	=	Conn.Execute( cSql_D )

  'Cuerpo de la Factura

  Factura = Cabecera & Comprimida

  Pagina = 1
  n = 1
  nl = 0
  Lineas_detalle = 35
  Total_cif_US = 0
	Do While Not RsD.Eof
	   if trim(RsD("Unidad_de_medida_consumo")) = "UN" then
		    siglaunidad = "01"
		 elseif trim(RsD("Unidad_de_medida_consumo")) = "PAR" then
		    siglaunidad = "18"
		 else
		    siglaunidad = "19"
		 end if
     Cantidad = cdbl(RsD("Cantidad"))
     Cif = cdbl(RsD("Costo_cif_ori_US$_total_2_decimales"))
     Total_cif_US = Total_cif_US + Cif
		 Precio = cdbl( RsD("Costo_cif_ori_US$") )
     Total = Cif
	   Factura = Factura & comprimida & space(5) & strzero(n,2) & "  " & _
               PadL(Cantidad,10) & space(10) & _
               PadR(RsD("Unidad_de_medida_consumo"),3) & space(5) & _
               siglaunidad & space(3) & _
               PadR( replace(RsD("Descripcion"),chr(34),"P") , 43 ) & "  " & _
               PadR( trim(RsD("Tipo_documento_de_compra")) & "-" & _
                     RsD("Numero_documento_de_compra") & "-" & _
                     RsD("Año_recepcion_compra") & "-" & _
                     strzero(RsD("Numero_de_linea_en_RCP_o_documento_de_compra"),3) , 20 ) & _
               PadL( FormatNumber(Precio,4) , 9) & _
               PadL( FormatNumber(Total,2) , 21 ) & CrLf
     n = n + 1
     nl = nl + 1
     if nl > Lineas_detalle then
        Factura = Factura & _
                  space(60) & "continua en página " & Pagina & _
                  SaltoPagina & _
                  Cabecera & Comprimida
        Pagina = Pagina + 1
     end if
     RsD.MoveNext
	Loop
	
  'Se completa el largo de la página
  For n = nl to Lineas_detalle
      Factura = Factura & Crlf
  Next

  'Totales finales
  Factura = Factura &  "     MERCADERIA NO APTA PARA SU COMERCIALIZACION" & space( 115 - 45 ) & _
            PadL( FormatNumber(Total_cif_US,2) , 18 ) & CrLf & CrLf & CrLf
  Factura = Factura & space( 118 ) & _
            PadL( FormatNumber(Total_cif_US,2) , 18 )

  Factura = Factura & Largo_66
  'Se convierte el string completo a formato de script impresión activex
  Factura = TxtPrint(0,Factura & SaltoPagina)
  
	RsD.Close
	SET RsD = Nothing
	Conn.Close

'if Session.SessionID = 606495990 then
'	Response.Write Factura	
'	Response.End 
'end if
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
				parent.top.frames(1).location.href = "../../Transacciones/DespachoActaDestruccionZonaFranca/Inicial_DespachoActaZf.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoActaDestruccionZonaFranca/Botones_DespachoActaZf.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			elseif "<%=Request("Funcion")%>" = "DespachoIPAQ" then
				parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Inicial_DespachoIPAQ.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Botones_DespachoIPAQ.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			end if
		end if
	</Script>

</HTML>

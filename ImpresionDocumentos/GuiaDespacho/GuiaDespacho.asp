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
	NroDoc = Request("NroDoc")

	cSql = "Exec PAR_ListaParametros 'IMPGUIADESP'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		Impresora = Rs("Valor_texto")
	else
		Impresora = "LPT1"
	end if
	Rs.Close
	Set Rs = Nothing
	
	y_Pos = -1
	x_Pos =  27
	
	Function TxtPrint(valor)
		if Instr(1,valor,chr(13)) > 0 then
			cTexto = ""
			caracter = "¬"
			valor = Replace(valor,chr(13),caracter)
			Do While Instr(1,valor,caracter) > 0 
				nPosIni = Instr(1,valor,caracter)
				cTexto = cTexto & "Locales.imprimir " & chr(34) & Mid(valor,1,nPosIni-1) & chr(34) & chr(13)
				valor = space(8+x_Pos) & Mid(valor,nPosIni+2)
			Loop
			cTexto = cTexto & "Locales.imprimir " & chr(34) & valor & chr(34) & chr(13)
			TxtPrint = cTexto
		else
			TxtPrint = "Locales.imprimir " & chr(34) & valor & chr(34)
		end if
	End Function
	
	Function Replicar(valor, caract)
		Dim cCadena
		for r=1 to valor
			cCadena = cCadena & caract
		next
		Replicar = cCadena
	End Function
		
	Function FechaLarga( valor )
		Dia = Day(Valor)
		Mes = Month(Valor)
		Ano = Year(Valor)
		FechaLarga = Right("00" & Dia,2) & "/" & Ucase(Left(NombreMes(Mes),3)) & "/" & Ano
	End Function

	Function Blancos(valor, cantidad)
		cCad = ""
		qBlcos = cantidad - len(FormatNumber(valor,0))
		for z=1 to qBlcos
			cCad = cCad & " "
		next
		Blancos = cCad & FormatNumber(valor,0)
	End Function

	function valida_rut(entrada)
	   largo=len(trim(entrada))
	   if largo>8 or largo<7 then
		valida_rut=""
		exit function
	   end if

	   desde=largo

	   suma=0

	   for n=0 to 5
		suma=suma+mid(entrada,desde-n,1)*(n+2)
	   next
	   suma=suma+mid(entrada,desde-6,1)*2

	   if largo=8 then
		suma=suma+mid(entrada,1,1)*3
	   end if

	   resultado=11-(suma mod 11)

	   if resultado=10 then
		valida_rut="K"
		exit function
	   end if
	   if resultado=11 then
		valida_rut="0"
		exit function
	   end if
	   valida_rut=resultado
	end function

	LargoFila = 80
	LargoLineas = 27

	NroDoc		= Request("NroFac")
	Pagina		= Request("Pagina")

	cSql_C = "Exec DNV_Lista_GDV '" & Session("Empresa_usuario") & "', 0" & NroDoc
'Response.Write cSql_C	
	SET RsC	=	Conn.Execute( cSql_C )

		Bodega			= RsC("Bodega")

		NroFactura		= ""
		Senores			= cambia_chr( RsC("Nombre_Cliente") )
			Digito		= Replace(RsC("Rut_Cliente"),".","")
			Digito		= valida_rut(Right(cStr("00000000" & Digito),8))
			Rut_Cliente	= RsC("Rut_Cliente") & "-" & cStr(Digito)
		
		Direccion		= cambia_chr( RsC("Direccion") )
		Vendedor		= cambia_chr( RsC("Vendedor") )
		Fecha			= RsC("Fecha")
		
		Comuna			= cambia_chr( RsC("Comuna") )
		Giro			= cambia_chr( RsC("Giro") )
		Telefono		= RsC("Telefono")
		
		Guia			= RsC("NroGuia")
		CondicionPago	= cambia_chr( RsC("CondicionPago") )
		Vencimiento		= RsC("Vencimiento")
		
		NotaVenta		= RsC("NotaDeVenta")
		DespacharA		= cambia_chr( RsC("DespacharA") )
		OrdenDeCompra	= RsC("OrdenDeCompra")
		
		Transporte		= cambia_chr( RsC("Transporte") )
		Peso			= RsC("Peso")

		Observaciones	= cambia_chr( RsC("Observaciones") )

		Cabecera = ""

		Cabecera = ""

		Cabecera = Cabecera & TxtPrint( chr(15) & space(7+x_Pos) & Senores & space(52-len(Senores)) & Rut_Cliente & space(35-len(Rut_Cliente)) & NroFactura ) & chr(13)					' Señores - Rut - Factura
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Direccion & space(40-len(Direccion)) & space(12) & Nombre_vendedor & Space(26-len(Left(Nombre_vendedor,26))) & space(9) & Fecha )	& chr(13)	' Dirección - Vendedor - Fecha
		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Nombre_Comuna & space(52-len(left(Nombre_Comuna,52))) & Giro & Space(27-len(Left(Giro,27))) & space(8) & Telefono )	& chr(13)						' Dirección - Giro - Telefono
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & Guia & space(24-len(Guia)) & space(18) & Trim(CondicionPago) & space(28-len(Trim(left(CondicionPago,28)))) & space(13) & Vencimiento ) & chr(13)	' Guia - Condicion de pago - Vencimiento
		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & NotaVenta & space(23-len(NotaVenta)) & space(16) & DespacharA ) & chr(13)	' Nota de venta - Despacha a
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 	& chr(13)
		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & OrdenDeCompra & space(23-len(OrdenDeCompra)) & space(16) & Left(Transporte,30) & Space(38-len(Left(Transporte,30))) & Space(11) & Peso ) & chr(13)	' Orden de compra - Transporte - Peso
		Cabecera = Cabecera & TxtPrint( space(8+x_Pos) & Observaciones )						& chr(13)	' Observaciones
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
	'RsC.Close
	'SET RsC = Nothing
	Set RsD = RsC.NextRecordset
	
		b = 1
		Inferior = ""
		Detalle = ""		
		Total	= 0
		nLinea  = 0
		nGuia	= 0
		Ln		= 0
		TotalGral = 0
		
		'Cuerpo de la Factura
		Do While Not RsD.Eof
			If cDbl(RsD("Cantidad")) > 0 then
				Detalle = Detalle & TxtPrint( space(23) & RsD("Cantidad") & space(7-len(RsD("Cantidad"))) & Left(RsD("Catalogo"),18) & space(18-len(Left(RsD("Catalogo"),18))) & space(3) & RsD("Descripcion") & space(51-len(Left(RsD("Descripcion"),51))) & space(1) & Right(space(11) & FormatNumber(RsD("Precio"),0),11) & space(17-len(Right(space(11) & FormatNumber(RsD("Precio"),0),11))) & Right(space(11) & FormatNumber(RsD("Total"),0),11) ) & chr(13)
				TotalGral = TotalGral + Cdbl("0" & RsD("Total"))
				Ln = Ln + 1
			end if
			RsD.MoveNext
		Loop
		
		for d=1 to LargoLineas-Ln
			Detalle = Detalle & TxtPrint( space(10) ) & chr(13)
		next

		Detalle = Detalle & TxtPrint( Space(LargoFila) ) & chr(13)

		Dscto	= 0

		for mj=1 to 22
			Inferior = Inferior & TxtPrint( Space(LargoFila) ) & Chr(13)
		next

		Inferior = Inferior & TxtPrint( Space(LargoFila) & Chr(18) ) & Chr(13)
				
		Factura = Factura & Cabecera & Detalle & Inferior 

'Response.Write Factura
'break
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

		if "<%=Ticket%>" = "S" then
			parent.location.href = "../Ticket/Ticket.asp?NroDoc=<%=NroDoc%>&Despacho=S&Funcion=<%=Request("Funcion")%>&Bodega=<%=Bodega%>"
		else
			if "<%=Request("Funcion")%>" = "Despacho" then
				parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVenta/Inicial_Despacho.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVenta/Botones_Despacho.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			elseif "<%=Request("Funcion")%>" = "DespachoIPAQ" then
				parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Inicial_DespachoIPAQ.asp"
				parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Botones_DespachoIPAQ.asp"
				parent.top.frames(3).location.href = "../../Mensajes.asp"
			end if
		end if
	</Script>

</HTML>

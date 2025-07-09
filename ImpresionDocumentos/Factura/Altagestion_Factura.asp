<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->

<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec PAR_ListaParametros 'IMPFACTURAS'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		Impresora = Rs("Valor_texto")
	else
		Impresora = "LPT1"
	end if
	Rs.Close
	Set Rs = Nothing
	
	y_Pos = -1
	x_Pos =  29
	Ln_Det = 12
	
	Function TxtPrint(valor)
		TxtPrint = "Locales.imprimir " & chr(34) & valor & chr(34)
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

	cSql_D = "Exec FAC_ListaCuerpoFactura '" & Session("Empresa_usuario") & "', " & NroDoc & ", " & Documento & ", " & NroFactura
'Response.Write cSql_C	
	SET RsD	=	Conn.Execute( cSql_D )

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

		Observaciones	= cambia_chr( RsC("Observaciones") )

		Cabecera = ""
		'for a=1 to 9+y_Pos
		'	if a=1 then
		'		Cabecera = Cabecera & TxtPrint( chr(15) & Space(LargoFila) ) & chr(13)
		'	else
		'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) & chr(13)
		'	end if
		'next

		Cabecera = Cabecera & TxtPrint( chr(15) & space(80+x_Pos) & NroFactura )							& chr(13)	' Nro Factura		
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Senores & space(52-len(Senores)) & Rut_Cliente & space(34-len(Rut_Cliente)) & NroFactura ) & chr(13)					' Señores - Rut - Factura
		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Direccion & space(40-len(Direccion)) & space(12) & Vendedor & Space(26-len(vendedor)) & space(5) & Fecha )	& chr(13)	' Dirección - Vendedor - Fecha
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Comuna & space(52-len(Comuna)) & Giro & Space(27-len(Giro)) & space(7) & Telefono )	& chr(13)						' Dirección - Giro - Telefono
		Cabecera = Cabecera & TxtPrint( space(10+x_Pos) & Guia & space(24-len(Guia)) & space(11) & CondicionPago & space(28-len(CondicionPago)) & space(19) & Vencimiento ) & chr(13)	' Guia - Condicion de pago - Vencimiento
		Cabecera = Cabecera & TxtPrint( space(10+x_Pos) & NotaVenta & space(23-len(NotaVenta)) & space(12) & DespacharA ) & chr(13)	' Nota de venta - Despacha a
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & OrdenDeCompra & space(23-len(OrdenDeCompra)) & space(12) & Transporte & Space(38-len(Transporte)) & Space(6) & Peso ) & chr(13)	' Orden de compra - Transporte - Peso
		Cabecera = Cabecera & TxtPrint( space(8+x_Pos) & Observaciones )						& chr(13)	' Observaciones
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
	RsC.Close
	SET RsC = Nothing
		
	
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
			Detalle = Detalle & TxtPrint( space(22) & RsD("Cantidad") & space(12-len(RsD("Cantidad"))) & RsD("Catalogo") & space(18-len(RsD("Catalogo"))) & space(3) & RsD("Descripcion") & space(51-len(RsD("Descripcion"))) & space(1) & RsD("Precio") & space(18-len(RsD("Precio"))) & RsD("Total") ) & chr(13)
			TotalGral = TotalGral + Cdbl("0" & RsD("Total"))
			Ln = Ln + 1
			RsD.MoveNext
		Loop
		
		for d=Ln+20+y_Pos+1 to 44+y_Pos-4
			Detalle = Detalle & TxtPrint( space(10) ) & chr(13)
		next

		MontoEscrito = Trim(Escribir(TotalGral))
		LargoTxt = 60
		a = LargoTxt
		b = 1
		z = 0

		Error = 0
		Dim ExtraeMonEsc(3)
		if len(Trim(MontoEscrito)) <= a then
			ExtraeMonEsc(0) = MontoEscrito
		else			
			Do While Error = 0
				Frase = Mid(MontoEscrito,b,LargoTxt)
				Ok = 1			
				Do While Ok = 1
					Letra = Mid(Frase,a,1)
					if letra = " " then						
						ExtraeMonEsc(z) = Mid(Frase,b,a)
						MontoEscrito = Left(Mid(MontoEscrito,a+1,len(MontoEscrito)) & space(32),60)
						Ok = 0
						z = z + 1
					end if
					a = a - 1
				Loop
				if len(Trim(MontoEscrito)) = 0 then
					Error = 1
				end if
			Loop
		end if

		Neto	= FormatNumber(Round(TotalGral / (1 + (Cdbl(Session("PCTGEIVA"))/100)) ,0),0)
		Dscto	= 0
		Iva		= FormatNumber(Round(TotalGral - Neto,0),0)
		TotalGral = FormatNumber(Round(TotalGral,0),0)
		
		for g=1 to 7
			Detalle = Detalle & TxtPrint( Space(LargoFila) ) & chr(13)
		next
		if Ucase(trim(Moneda)) = "$" Then txtMoneda = " pesos." Else txtMoneda = " dólares." 
		if len(trim(ExtraeMonEsc(1))) = 0 then			
			Detalle = Detalle & TxtPrint( space(x_Pos-3) & ExtraeMonEsc(0) & txtMoneda & space(LargoTxt-len(ExtraeMonEsc(0))) & space(70 - len(Neto)) & Neto ) & chr(13)
			Detalle = Detalle & TxtPrint( space(x_Pos-3) & space(LargoTxt) & space(37 - len(Dscto) ) & Dscto ) & chr(13)
		else
			Detalle = Detalle & TxtPrint( Left(ExtraeMonEsc(0), LargoTxt) & space(LargoTxt-len(ExtraeMonEsc(0))) & space(70 - len(Neto) ) & Neto ) & chr(13)
			ln2 = Left(Trim(ExtraeMonEsc(1)) & Replicar(LargoTxt-7,"-"), LargoTxt-7)
			Detalle = Detalle & TxtPrint( Left(Trim(ExtraeMonEsc(1)) & Replicar(LargoTxt-7,"-"), LargoTxt-7) & txtMoneda & space(x_Pos-3) & space(LargoTxt-len(ln2)) & space(37 - len(Neto) ) & Neto ) & chr(13)
		end if

		Inferior = Inferior & TxtPrint( space(x_Pos-3) & space(LargoTxt) & space(44 - len(Neto) ) & Neto ) & Chr(13)
		Inferior = Inferior & TxtPrint( space(x_Pos-3) & space(LargoTxt) & space(44 - len(Iva)  ) & Iva ) & Chr(13)
		Inferior = Inferior & TxtPrint( space(x_Pos-3) & space(LargoTxt) & space(44 - len(TotalGral) ) & TotalGral ) & Chr(13)
		Inferior = Inferior & TxtPrint( Space(LargoFila) & Chr(18) ) & Chr(13)
				
		Factura = Cabecera & Detalle & Inferior 

'Response.Write Factura
'break
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

		if "<%=Request("Funcion")%>" = "Despacho" then
			parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVenta/Inicial_Despacho.asp"
			parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVenta/Botones_Despacho.asp"
			parent.top.frames(3).location.href = "../../Mensajes.asp"
		elseif "<%=Request("Funcion")%>" = "DespachoIPAQ" then
			parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Inicial_DespachoIPAQ.asp"
			parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Botones_DespachoIPAQ.asp"
			parent.top.frames(3).location.href = "../../Mensajes.asp"
		end if
	</Script>

</HTML>

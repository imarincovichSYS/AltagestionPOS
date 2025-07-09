<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->

<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec HAB_ListaBodega '" & Session("Empresa_usuario") & "', '" & Request("Bodega") & "'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		Impresora = Rs("Impresora")
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

	NroDoc		= Request("NroDoc")

	if Request("TipoDoc") = "DVT" Then
		cSql = "Exec MOP_Impresion_ticket_reserva_DVT " & NroDoc 'DVT
	else
		if Request("Reserva") = "S" Then
			cSql = "Exec MOP_Impresion_ticket_reserva " & NroDoc 'OVT
		else
			cSql = "Exec MOP_Impresion_ticket " & NroDoc 'OVT
		end if
	end if

	SET Rs	=	Conn.Execute( cSql )
	if Not Rs.Eof then
		RutCliente = cStr(Rs("RutCliente")) & "-" & cStr(valida_rut(Rs("RutCliente")))

		Prn_Ticket = "Locales.Imprimir CHR(27) + " & Chr(34) & "L" & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(27) + " & Chr(34) & "W" & Chr(34) & "+ CHR(0) + CHR(0) + CHR(0) + CHR(0) + CHR(255) + CHR(0) + CHR(50) + CHR(0)" & CHR(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(27) + " & Chr(34) & "T" & Chr(34) & "+ Chr(0)" & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(27) + " & Chr(34) & "M" & Chr(34) & "+ Chr(1)" & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(12) " & CHR(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "CLIENTE  : " & Rs("NomCliente") & Chr(34)  & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "R.U.T.   : " & RutCliente & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & cambia_chr("Nº O.C.  : ") & Rs("NroOrdCompra") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "SUCURSAL : " & Rs("Sucursal") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "BODEGA   : " & Rs("Nombre_Bodega") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "VENDEDOR : " & Rs("NomVendedor") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "FECHA    : " & Rs("Fecha") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & cambia_chr("Nº Doc.  : ") & Rs("NroDocVta") & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "ENVIO    : "  & Rs("Forma_envio") & Chr(34) & chr(13)
		
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "DESCRIPCION" & Space(7) & "CATALOGO" & Space(8) & " U/V" & Space(2) & " CNT" & Space(2) & " NRO" & Chr(34) & chr(13)
		
		ImpresionTicket = ""
		Do While Not Rs.Eof 
			Ubicacion = Rs("Ubicacion")
			Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "UBICACION: " & cambia_chr(Ubicacion) & Chr(34) & chr(13)
			Do While Ubicacion = Rs("Ubicacion")
				Descripcion = Left(cambia_chr(Rs("Descripcion"))  & Space(18),17) & " "
				Catalogo	= Left(cambia_chr(Rs("Catalogo"))	 & Space(16),16) & " "
				UnidadVenta	= Left(cambia_chr(Rs("UnidadVenta")) & Space(5),5) & " "
				Cantidad	= Left(cambia_chr(Rs("Cantidad"))	 & Space(5),5) & " "
				NroLinea	= cambia_chr(Rs("Linea"))

				Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & Descripcion & Catalogo & UnidadVenta & Cantidad & NroLinea & Chr(34) & chr(13)
				if len(trim(ImpresionTicket)) = 0 then
					ImpresionTicket = Descripcion & " - " & Catalogo & " - " & UnidadVenta & " - " & Cantidad & " - " & NroLinea 
				end if
				TotalGral = TotalGral + ( cDbl(Rs("Cantidad")) * cDbl("0" & Rs("Precio")) )
				
				Rs.MoveNext	
				if Rs.Eof then exit do
			Loop
			if Rs.Eof then exit do
		Loop
	Rs.Close
	SET Rs = Nothing

	
		TotalGral = Round(TotalGral * ( 1 + ( cDbl(Session("PCTGEIVA"))/100 ) ),0)

		Prn_Ticket = Prn_Ticket & "Locales.Imprimir " & Chr(34) & "TOTAL" & Space(40) & TotalGral & Chr(34) & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(10) + Chr(10) " & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(12)" & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.Imprimir Chr(29) + " & CHR(34) & "V" & CHR(34) & " + CHR(1) " & chr(13)
		Prn_Ticket = Prn_Ticket & "Locales.FinImpresion" & chr(13)

		Ticket = Cabecera
	End if
'Response.Write Prn_Ticket
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
		<%	Response.Write Prn_Ticket %>
		<%  if Request("Listado") = "S" Then %>
				alert ( "Impresión del ticket finalizada." & chr(10) & "<%=ImpresionTicket%>" )
		<%	end if%>
		Else
			Locales.FinImpresion
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

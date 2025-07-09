<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->

<%
	Cache

'On Error Resume Next

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
	x_Pos =  27
	
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
	LargoLineas = 18

	aNroFavs = Split(Request("Nroint"),"¬")
	'	Response.Write aNroFavs
'response.end
	NroFacturaIni = Request("NroFacturaIni")
	Factura = ""
	CntNvoFac = 0

for IdFav=0 to Ubound(aNroFavs)-1

	Conn.BeginTrans 

	aDet = 	Split(aNroFavs(IdFav),"|")
	NroDoc = "Null"
	NroInterno = aDet(0)
	NroFactura = aDet(1)
	NroFacIngresado = aDet(2)
	Documento = "'" & request("Tipo_documento") & "'"
	tipo_Documento_zf = "'" & request("tipo_documento_zf") & "'"
	
	MsgError = ""
'	if cDbl("0" & NroFacturaIni) > 0 then
'		if NroFacIngresado = 0 then
'			NvoNroFactura = NroFacturaIni + CntNvoFac
'			cSql = "Exec DOV_Actualiza_Nro_DOV 0" & NroInterno & ", " & NvoNroFactura & ", '" & Session("Login") & "'"
'			Conn.Execute ( cSql )
'			if Conn.Errors.Count > 0 then
'				MsgError = Replace(Err.Description,"[Microsoft][ODBC SQL Server Driver][SQL Server]","") & "- Documento Nº " & NvoNroFactura
'			else
'				CntNvoFac = CntNvoFac + 1
'				NroFactura = NvoNroFactura
'			end if
'		else
'			NvoNroFactura = NroFacIngresado
'			cSql = "Exec DOV_Actualiza_Nro_DOV 0" & NroInterno & ", " & NvoNroFactura & ", '" & Session("Login") & "'"
'			Conn.Execute ( cSql )
'			if Conn.Errors.Count > 0 then
'				MsgError = Replace(Err.Description,"[Microsoft][ODBC SQL Server Driver][SQL Server]","") & "- Documento Nº " & NvoNroFactura
'			else
'				NroFactura = NvoNroFactura
'			end if
'		end if
'	else
		NvoNroFactura = NroFacIngresado
'		cSql = "Exec DOV_Actualiza_Nro_DOV 0" & NroInterno & ", " & NvoNroFactura & ", '" & Session("Login") & "'"
'		Conn.Execute ( cSql )
'		if Conn.Errors.Count > 0 then
'			MsgError = Replace(Err.Description,"[Microsoft][ODBC SQL Server Driver][SQL Server]","") & "- Documento Nº " & NvoNroFactura
'		else
'			NroFactura = NvoNroFactura
'		end if
'	end if

	if conn.Errors.Count = 0 then
		Conn.CommitTrans()
	else
		Conn.RollbackTrans 
	end if

if MsgError <> "" Then
	exit for
end if
	cSql_C = "Exec FAC_ListaCabeceraFactura '" & Session("Empresa_usuario") & "', " & NroInterno & ", " & Documento & ", " & NroFactura & "," & tipo_Documento_zf
'Response.Write cSql_C & "<br>"
	SET RsC	=	Conn.Execute( cSql_C )
  
  if RsC("Tipo_documento_zona_franca") <> "" then
	   if trim(RsC("Tipo_documento_zona_franca")) = "AD" then
		 		 response.redirect "../../ImpresionDocumentos/FacturaZonaFranca/actadestruccion.asp?Documento=FAE&NroFactura=" & trim(RsC("NroFactura")) & "&Funcion=Reimpresion&Ticket=N&NroFac=" & trim(RsC("Numero_interno_documento_valorizado"))
		 else
		 		'' response.redirect "../../ImpresionDocumentos/FacturaZonaFranca/" & trim(RsC("Tipo_documento_zona_franca")) & ".asp?Documento=FAV&NroFactura=" & trim(RsC("NroFactura")) & "&Funcion=Reimpresion&Ticket=N&NroFac=" & trim(RsC("Numero_interno_documento_valorizado"))
		 end if
  end if

	cSql_D = "Exec FAC_ListaCuerpoFactura '" & Session("Empresa_usuario") & "', " & NroInterno & ", " & Documento & ", " & NroFactura
'Response.Write cSql_D & "<br>"
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
		Nombre_Comuna	= cambia_chr( RsC("Nombre_Comuna") )
		
		Giro			= cambia_chr( RsC("Giro") )
		Telefono		= RsC("Telefono")
		
		Guia			= RsC("Guia")
			'Solamente para floracenter
			if cDbl(Guia) >= 1000000 then
				Guia = ""				
			end if
		CondicionPago	= cambia_chr( RsC("CondicionPago") )
		Vencimiento		= RsC("Vencimiento")
		
		NotaVenta		= RsC("NotaDeVenta")
		DespacharA		= cambia_chr( RsC("DespacharA") )
		OrdenDeCompra	= RsC("OrdenDeCompra")
		
		Transporte		= cambia_chr( RsC("Transporte") )
		Peso			= RsC("Peso")

		Nombre_vendedor	= RsC("Nombre_vendedor")
	
		Observaciones	= cambia_chr( RsC("Observaciones") )
			'Solamente para floracenter
			if cDbl(Guia) >= 1000000 then
				Observaciones = ""				
			end if

		NombreBodega	= cambia_chr( RsC("Nombre_Bodega") )

		MontoExento		= cDbl("0" & RsC("Exento") )
		MontoNeto		= cDbl("0" & RsC("Afecto")   )
		MontoNetoSinIla = cDbl(RsC("Afecto"))  + cdbl(RsC("Monto_ila_1_moneda_oficial")) + cdbl(RsC("Monto_ila_2_moneda_oficial")) + cdbl(RsC("Monto_ila_3_moneda_oficial")) + cdbl(RsC("Monto_ila_4_moneda_oficial"))
		MontoIva		= Cdbl(RsC("Total")) - cDbl(MontoNetoSinIla)
		MontoTotal		= cDbl("0" & RsC("Total")  )
		CifTotal = cDbl("0" & RsC("Costo_CIF_ORI_US$_2_decimales"))
		Ila_10 = Cdbl(RsC("Monto_ila_1_moneda_oficial"))
		Ila_18 = Cdbl(RsC("Monto_ila_2_moneda_oficial"))
		Ila_20_5 = Cdbl(RsC("Monto_ila_3_moneda_oficial"))		
		Ila_31_5 = Cdbl(RsC("Monto_ila_4_moneda_oficial"))		
    Comprimida = chr(18) & chr(15)
    Normal = chr(27) & chr(54) & chr(18) & chr(27) & chr(58) ' chr(27) & "M" <- EPSON ' chr(18) & chr(27) & chr(58) <- OKI '               'chr(28) 'chr(27) & chr(63) & chr(2)

		Cabecera = ""

	  Cabecera = Cabecera & TxtPrint( Comprimida & space(7+x_Pos) & SPACE(60) & Fecha )	& chr(13)	& chr(13) & chr(13)' Dirección - Vendedor - Fecha
    Cabecera = Cabecera & TxtPrint( space(10) ) & chr(13)	
    Cabecera = Cabecera & TxtPrint( space(10) ) & chr(13)		  
	  Cabecera = Cabecera & TxtPrint( chr(15) & space(7) & Senores & space(40-len(Left(Senores,40))) & space(12) & LTRIM(RTRIM(Direccion)) & Space(26-len(Left(Direccion,26))) & space(25) & Rut_Cliente & space(10-len(Rut_Cliente)) )	& chr(13)	& chr(13) & chr(13)' Dirección - Vendedor - Fecha

'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
'		Cabecera = Cabecera & TxtPrint( space(7+x_Pos) & Nombre_Comuna & space(52-len(left(Nombre_Comuna,52))) & Giro & Space(27-len(Left(Giro,27))) & space(8) & Telefono )	& chr(13)						' Dirección - Giro - Telefono
'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
'		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & Guia & space(24-len(Guia)) & space(18) & Trim(CondicionPago) & space(28-len(Trim(left(CondicionPago,28)))) & space(13) & Vencimiento ) & chr(13)	' Guia - Condicion de pago - Vencimiento
'		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & NotaVenta & space(23-len(NotaVenta)) & space(16) & DespacharA ) & chr(13)	' Nota de venta - Despacha a
'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 	& chr(13)
'		Cabecera = Cabecera & TxtPrint( space(11+x_Pos) & OrdenDeCompra & space(23-len(OrdenDeCompra)) & space(16) & Left(Transporte,30) & Space(38-len(Left(Transporte,30))) & Space(11) & Peso ) & chr(13)	' Orden de compra - Transporte - Peso
'		Cabecera = Cabecera & TxtPrint( space(8+x_Pos) & Observaciones )						& chr(13)	' Observaciones
'		Cabecera = Cabecera & TxtPrint( Space(20) & NombreBodega )							& chr(13)
'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
'		Cabecera = Cabecera & TxtPrint( Space(LargoFila) ) 										& chr(13)
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
		i = 0

		Detalle = Detalle & TxtPrint( space(10) ) & chr(13)
		Detalle = Detalle & TxtPrint( space(10) ) & chr(13)
		Detalle = Detalle & TxtPrint( space(10) ) & chr(13)

		Do While Not RsD.Eof

		  Detalle = Detalle & chr(13) & chr(13) & chr(13) 
'			Detalle = Detalle & TxtPrint( space(23) & RsD("Cantidad") & space(7-Left(len(RsD("Cantidad")),7)) & RsD("Catalogo") & space(20-Left(len(RsD("Catalogo")),20)) & space(3) & RsD("Descripcion") & space(51-Left(len(RsD("Descripcion")),51)) & space(1) & Right(space(8) & FormatNumber(RsD("Precio"),0),8) & space(9-len(Right(space(8) & FormatNumber(RsD("Precio"),0),8))) & space(4) & Right(space(6) & RsD("Dscto_1") & "%",6) & space(2) & Right(space(10) & FormatNumber(RsD("Total"),0),10) ) & chr(13)
'			Detalle = Detalle & TxtPrint( space(12) & RsD("Cantidad") & space(3-Left(len(RsD("Cantidad")),3)) & space (5) & ltrim(rtrim(RsD("Unidad_de_medida_consumo"))) & space(3-Left(len(ltrim(rtrim(RsD("Unidad_de_medida_consumo")))),3)) & space(3) & LTRIM(RTRIM(RsD("Producto"))) & space(10-Left(len(LTRIM(RTRIM(RsD("Producto")))),10)) & space(3) & LTRIM(RTRIM(RsD("Descripcion"))) & space(35-Left(len(LTRIM(RTRIM(RsD("Descripcion")))),35)) & space(3) & Right(space(8) & FormatNumber(RsD("Precio_con_descuento"),0),8) & space(6) & RsD("Docto") & space(15-Left(len(RsD("Docto")),15)) & space(3) & Right(space(13) & FormatNumber(RsD("Costo_cif_ori_US$_total_2_decimales"),2),10) & space(6) & Right(space(13) & FormatNumber(RsD("Total"),0),10) ) & chr(13)
'			Detalle = Detalle & TxtPrint( space(12) & RsD("Cantidad") & space(3-Left(len(RsD("Cantidad")),3)) & space (5) & ltrim(rtrim(RsD("Unidad_de_medida_consumo"))) & space(3-Left(len(ltrim(rtrim(RsD("Unidad_de_medida_consumo")))),3)) & space(3) & LTRIM(RTRIM(RsD("Producto"))) & space(10-Left(len(LTRIM(RTRIM(RsD("Producto")))),10)) & space(3) & LTRIM(RTRIM(RsD("Descripcion"))) & space(35-Left(len(LTRIM(RTRIM(RsD("Descripcion")))),35)) & space(3) & Right(space(8) & FormatNumber(RsD("Precio_con_descuento"),0),8) & space(6) & RsD("Docto") & space(15-Left(len(RsD("Docto")),15)) & space(3) & Right(space(13) & FormatNumber(RsD("Costo_cif_ori_US$_total_2_decimales"),2),10) & space(6) & Right(space(13) & FormatNumber(RsD("Total_final_con_descuentos_impreso"),0),10) ) & chr(13)
			Detalle = Detalle & TxtPrint( space(12) & RsD("Cantidad") & space(3-Left(len(RsD("Cantidad")),3)) & space (5) & ltrim(rtrim(RsD("Unidad_de_medida_consumo"))) & space(3-Left(len(ltrim(rtrim(RsD("Unidad_de_medida_consumo")))),3)) & space(3) & LTRIM(RTRIM(RsD("Producto"))) & space(10-Left(len(LTRIM(RTRIM(RsD("Producto")))),10)) & space(3) & LTRIM(RTRIM(RsD("Descripcion"))) & space(35-Left(len(LTRIM(RTRIM(RsD("Descripcion")))),35)) & space(3) & Right(space(8) & FormatNumber(RsD("Precio_final_con_descuentos_impreso"),0),8) & space(6) & RsD("Docto") & space(15-Left(len(RsD("Docto")),15)) & space(3) & Right(space(13) & FormatNumber(RsD("Costo_cif_ori_US$_total_2_decimales"),2),10) & space(6) & Right(space(13) & FormatNumber(RsD("Total_final_con_descuentos_impreso"),0),10) ) & chr(13)
			'TotalGral = TotalGral + Cdbl("0" & RsD("Total"))
			Ln = Ln + 1
			RsD.MoveNext

		Loop
		
		if Ila_10 + Ila_18 + Ila_20_5 + Ila_31_5 > 0 then
      ILA_TXT = "Impto I.L.A.: "
		  if Ila_10 > 0 then 
        ILA_TXT = ILA_TXT & "(10%) " & FormatNumber(Ila_10,0) 
      end if
      if Ila_18 > 0 then 
        ILA_TXT = ILA_TXT & "  (18%) " & FormatNumber(Ila_18,0) 
      end if
      if Ila_20_5 > 0 then 
        ILA_TXT = ILA_TXT & "  (20.5%) " & FormatNumber(Ila_20_5,0) 
      end if
      if Ila_31_5 > 0 then 
        ILA_TXT = ILA_TXT & "  (31.5%) " & FormatNumber(Ila_31_5,0) 
      end if
    	Detalle = Detalle & TxtPrint( space(12) & ILA_TXT ) & chr(13)
    	Ln = Ln + 1
    End if
		for d=1 to LargoLineas-Ln
			Detalle = Detalle & TxtPrint( space(10) ) & chr(13)
		next

		Detalle = Detalle & TxtPrint( Space(LargoFila) ) & chr(13)

		Dscto	= 0
		'Neto	= TotalGral
		'Iva		= Neto * (0 + (Cdbl(Session("PCTGEIVA"))/100))
		'TotalGral = FormatNumber(Round(cDbl(Neto)+cDbl(Iva),0),0)
		'nTotalGral = Round(cDbl(Neto)+cDbl(Iva),0)

		'MontoEscrito = Trim(Escribir(nTotalGral))
		MontoEscrito = Trim( Escribir(MontoTotal) )
		LargoTxt = 60
		a = LargoTxt
		b = 1
		z = 0

		Error = 0
		ReDim ExtraeMonEsc(3)
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

		if Ucase(trim(Moneda)) = "$" Then txtMoneda = " pesos." Else txtMoneda = " dólares." 
		if len(trim(ExtraeMonEsc(1))) = 0 then			
			Detalle = Detalle & TxtPrint( space(x_Pos-2) & ExtraeMonEsc(0) & txtMoneda & space(3) & space(LargoTxt-len(ExtraeMonEsc(0))) & space(15) & FormatNumber(Round(CifTotal,2),2) & space(20 - len(FormatNumber(Round(MontoTotal,0),0))) & FormatNumber(Round(MontoTotal,0),0) ) & chr(13)
			'Detalle = Detalle & TxtPrint( space(x_Pos-3) & space(LargoTxt) & space(46 - len(Dscto) ) & Dscto ) & chr(13)
		else
			Detalle = Detalle & TxtPrint( Left(ExtraeMonEsc(0), LargoTxt) & space(LargoTxt-len(ExtraeMonEsc(0))) & space(72 - len(FormatNumber(Round(MontoNeto,0),0)) ) & FormatNumber(Round(MontoNeto,0),0) ) & chr(13)
			ln2 = Left(Trim(ExtraeMonEsc(1)) & Replicar(LargoTxt-7,"-"), LargoTxt-7)
			Detalle = Detalle & TxtPrint( Left(Trim(ExtraeMonEsc(1)) & Replicar(LargoTxt-7,"-"), LargoTxt-7) & txtMoneda & space(x_Pos-3) & space(LargoTxt-len(ln2)) & space(39 - len(FormatNumber(Round(MontoNeto,0),0)) ) & FormatNumber(Round(MontoNeto,0),0) ) & chr(13)
		end if
    Inferior = Inferior & TxtPrint( space(10) ) & chr(13)
		Inferior = Inferior & TxtPrint( space(x_Pos-2) & space(LargoTxt) & space(3) & space(46 - len(FormatNumber(Round(MontoIva,0),0))  ) & FormatNumber(Round(MontoIva,0),0) ) & Chr(13)
    Inferior = Inferior & TxtPrint( space(10) ) & chr(13)
		Inferior = Inferior & TxtPrint( space(x_Pos-2) & space(LargoTxt) & space(3) & space(46 - len(MontoTotal) ) & MontoTotal ) & Chr(13)
		'for mj=1 to 18
	'		Inferior = Inferior & TxtPrint( Space(LargoFila) ) & Chr(13)
	'	next

		'Inferior = Inferior & TxtPrint( Space(LargoFila) & Chr(18) ) & Chr(13)
				
		Factura = Factura & Cabecera & Detalle & Inferior 

	RsD.Close
	SET RsD = Nothing

next

'if Session.SessionID = 606495990 then
'	Response.Write Factura	
'	Response.End 
'end if

if MsgError = "" Then
%>
<HTML>
	<OBJECT classid="CLSID:B829BCD0-3892-11D3-A519-0000216ABE11" 
	      codebase="../../Impresion/Impresora.CAB#version=2,0,0,1" 
		id=Locales style="LEFT: 0px; TOP: 0px" VIEWASTEXT>
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

<%
else %>
	<script language="javascript">
		parent.top.frames[3].location.href = "../../mensajes.asp?msg=<%=MsgError%>"
	</script>
<%end if

Conn.Close
%>
</HTML>

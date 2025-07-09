<%
Function Genera_DTE(NroInt_FAV, ArchivoTMP, Folio)

	Dim oBitacora, ArchivoSinFirmar, ArchivoFirmado, NombreTxt
	Dim objShell, objExec, strResult, oTextStream
	Dim fs,f

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	FinLinea	= Chr(13) & Chr(10)

	Fecha = Date()
	Fecha_Hora =  Mid(Fecha,7,4) & "-" & Mid(Fecha,4,2) & "-" & Mid(Fecha,1,2) & "T" & Mid(Time(),1,8)

	NroCheques = 0

	error=""

' ******************************* Inicio Carga Parametros *******************************
	cSQL = "Exec PAR_ListaParametros 'RUTA_SII_PK'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		UrlSII = Rs("VALOR_TEXTO")
	else
		UrlSII = "XMLSEC"
	end if
	Rs.Close

	cSQL = "Exec PAR_ListaParametros 'PCTGEIVA'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("PCTGEIVA") = Rs("VALOR_NUMERICO")
	else
		Session("PCTGEIVA") = 19
	end if
	Rs.Close

	cSQL = "Exec PAR_ListaParametros 'RUTA_DTE'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		UrlDTE = Rs("VALOR_TEXTO")
	else
		UrlDTE = "DTE"
	end if
	Rs.Close
' ******************************* Termino Carga Parametros *******************************

	Documento = "FAV"

'Inicio generación de archivo XML DTEs
	cSql = "Exec DOV_Lista_Facturas 0" & NroInt_FAV & ", '" & Session("empresa_usuario") & "', "
	cSql = cSql & "'FAV', 0" & Folio & ", Null, Null, Null, Null, 'S'"
	SET Rs	=	Conn.Execute( cSQL )				
	if Not Rs.Eof then
		FolioElectronico = Rs("Numero_documento_valorizado")
		Switch = 1		
		TotalCampos = Rs.FIELDS.COUNT		
		Nombre_cliente	 = Rs("Nombre_cliente")
		
		OrdenCompra = Rs("OrdenCompra")
		FechaOrdenCompra = Rs("OrdenCompra")
		
		RutCliente = Rs("Rut_entidad_comercial")
		if Not IsNull(RutCliente) Then 
			RutCliente = cStr(RutCliente) & "-" & cStr(Verificador_CI(RutCliente))
		else
			RutCliente = "ERROR"
		end if
		NroDocumento = Rs("Numero_documento_valorizado")
		FechaEmisionDocto = Mid(Rs("Fecha_emision"),7,4) & "-" & Mid(Rs("Fecha_emision"),4,2) & "-" & Mid(Rs("Fecha_emision"),1,2)
		Empresa = Rs("Empresa")
		Cliente = Rs("Cliente")

		if IsNull(Rs("Monto_total_moneda_oficial")) then 
			Total = 0
		else
			Total = cDbl("0" & Rs("Monto_total_moneda_oficial"))
		end if
		MontoExento = cDbl("0" & Rs("Monto_exento_moneda_oficial")) 

		'if cDbl(FolioElectronico) = 128 then
		'	Neto        = 135100
		'	Iva         = 25669
		'	Total       = 160769
		'else
			Neto        = cDbl("0" & Rs("Monto_afecto_moneda_oficial"))
			Iva         = cDbl("0" & Rs("Monto_iva_moneda_oficial"))
			Total       = cDbl("0" & Rs("Monto_total_moneda_oficial"))
		'end if

		Referencia	= Rs("Referencia")
			aReferencia = Split(Referencia, "||")

		Observaciones = Rs("Observaciones_generales")
		Numero_despacho_de_venta = Rs("Numero_despacho_de_venta")
	end if
	Rs.Close
				
	cSql = "Exec FAE_Datos_Caratula '" & Empresa & "'"
	Set RsCAR = Conn.Execute ( cSql )
	if Not RsCAR.Eof then
		RutEmisor		= RsCAR("RutEmisor")
		RutEnviador		= RsCAR("RutEnviador")
		FechaResolucion	= Mid(RsCAR("FechaResolucion"),7,4) & "-" & Mid(RsCAR("FechaResolucion"),4,2) & "-" & Mid(RsCAR("FechaResolucion"),1,2)
		NroResolucion	= RsCAR("NroResolucion")
		RazonSocial		= RsCAR("Razon_Social")
		Giro			= Left(RsCAR("Giro"),80)
		Direccion		= RsCAR("Direccion")
		Comuna			= RsCAR("Comuna")
		Ciudad			= RsCAR("Ciudad")
	end if
	RsCAR.Close
	Set RsCAR = Nothing

	cSql = "Exec ECP_ListaEntidadesComerciales '" & Cliente & "', Null, Null, Null, Null, Null, '" & Empresa & "'"
	Set RsECP = Conn.Execute ( cSql )
	if Not RsECP.Eof then
		DireccionCliente	= RsECP ( "Direccion" )
		if IsNull(DireccionCliente) then DireccionCliente = "."
		if len(trim(DireccionCliente)) = 0 then DireccionCliente = "."
		
		ComunaReceptor		= Left(trim(RsECP ( "NombreComuna" )),20)
		if IsNull(ComunaReceptor) then ComunaReceptor = "."
		if len(trim(ComunaReceptor)) = 0 then ComunaReceptor = "."
		
		CiudadReceptor		= RsECP ( "NombreRegion" )
		if IsNull(CiudadReceptor) then CiudadReceptor = "."
		if len(trim(CiudadReceptor)) = 0 then CiudadReceptor = "."
		
		GiroReceptor		= Left(RsECP ( "Giro_o_profesion" ),40)
		if IsNull(GiroReceptor) then GiroReceptor = "."
		if len(trim(GiroReceptor)) = 0 then GiroReceptor = "."
	end if
	RsECP.close

	NombreDTE = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6) & ".xml"
	Doc_Elec = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6)
	Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
	Set fnBitacora = oBitacora.OpenTextFile(UrlDTE & NombreDTE, 2, True, 0)

	DTE = "<?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "ISO-8859-1" & chr(34) & "?>" & FinLinea
	DTE = DTE & "<!DOCTYPE test [ " & FinLinea 
	DTE = DTE & "<!ATTLIST SetDTE " & FinLinea 
	DTE = DTE & "ID ID #IMPLIED> " & FinLinea 
	DTE = DTE & "<!ATTLIST Documento " & FinLinea 
	DTE = DTE & "ID ID #IMPLIED > " & FinLinea 
	DTE = DTE & "] " & FinLinea
	DTE = DTE & "> " & FinLinea
	DTE = DTE & "<DTE version=" & chr(34) & "1.0" & Chr(34) & ">" & FinLinea
	DTE = DTE & "<Documento ID=" & Chr(34) & Doc_Elec & Chr(34) & ">" & FinLinea
	DTE = DTE & "<Encabezado>" & FinLinea
	DTE = DTE & "<IdDoc>" & FinLinea
	DTE = DTE & "<TipoDTE>33</TipoDTE>" & FinLinea
	DTE = DTE & "<Folio>" & Folio & "</Folio>" & FinLinea
'	DTE = DTE & "<FchEmis>" & FechaEmisionDocto & "</FchEmis>" & FinLinea
	DTE = DTE & "<FchEmis>" & Mid(Fecha_Hora,1,10) & "</FchEmis>" & FinLinea
	DTE = DTE & "</IdDoc>" & FinLinea 
	DTE = DTE & "<Emisor>" & FinLinea 
	DTE = DTE & "<RUTEmisor>" & RutEmisor & "</RUTEmisor>" & FinLinea
	DTE = DTE & "<RznSoc>" & AscToISO8859Entities(RazonSocial) & "</RznSoc>" & FinLinea
	DTE = DTE & "<GiroEmis>" & AscToISO8859Entities(Giro) & "</GiroEmis>" & FinLinea
	DTE = DTE & "<Acteco>31341</Acteco>" & FinLinea
	DTE = DTE & "<DirOrigen>" & AscToISO8859Entities(Direccion) & "</DirOrigen>" & FinLinea
	DTE = DTE & "<CmnaOrigen>" & AscToISO8859Entities(Comuna) & "</CmnaOrigen>" & FinLinea
	DTE = DTE & "<CiudadOrigen>" & AscToISO8859Entities(Ciudad) & "</CiudadOrigen>" & FinLinea
	DTE = DTE & "</Emisor>" & FinLinea
	DTE = DTE & "<Receptor>" & FinLinea
	DTE = DTE & "<RUTRecep>" & RutCliente & "</RUTRecep>" & FinLinea
	DTE = DTE & "<RznSocRecep>" & AscToISO8859Entities(Nombre_cliente) & "</RznSocRecep>" & FinLinea
	DTE = DTE & "<GiroRecep>" & AscToISO8859Entities(GiroReceptor) & "</GiroRecep>" & FinLinea
	DTE = DTE & "<DirRecep>" & AscToISO8859Entities(DireccionCliente) & "</DirRecep>" & FinLinea
	DTE = DTE & "<CmnaRecep>" & AscToISO8859Entities(ComunaReceptor) & "</CmnaRecep>" & FinLinea
	DTE = DTE & "<CiudadRecep>" & AscToISO8859Entities(CiudadReceptor) & "</CiudadRecep>" & FinLinea
	DTE = DTE & "</Receptor>" & FinLinea
	DTE = DTE & "<Totales>" & FinLinea
	DTE = DTE & "<MntNeto>" & Neto & "</MntNeto>" & FinLinea
	if MontoExento > 0 then
	   DTE = DTE & "<MntExe>" & MontoExento & "</MntExe>" & FinLinea
	end if
	DTE = DTE & "<TasaIVA>" & Session("PCTGEIVA") & "</TasaIVA>" & FinLinea
	DTE = DTE & "<IVA>" & Iva & "</IVA>" & FinLinea
	DTE = DTE & "<MntTotal>" & Total & "</MntTotal>" & FinLinea
	DTE = DTE & "</Totales>" & FinLinea
	DTE = DTE & "</Encabezado>" & FinLinea

	fnBitacora.Write ( DTE )

	cSql = "Exec MOP_ListaMovimientosProductos Null, Null, '" & Empresa & "', 'DVT', 0" & Numero_despacho_de_venta & ", Null, Null"
	Set RsDet = Conn.Execute ( cSql )
	j = 0
	if Not RsDet.Eof then
		idLinea = 1
		Do While Not RsDet.Eof			
			Pctje_Desc = RsDet("Pctje_Desc")
			if IsNull(Pctje_Desc) Then Pctje_Desc = 0
			Monto_Desc = RsDet("Monto_Desc")
			if IsNull(Monto_Desc) Then Monto_Desc = 0

			if j = 0 then 
				j = 1
				PrimerArticulo = Replace(Replace(Left(Trim(RsDet("Desc_producto")),80),chr(13),""),chr(10),"")
			end if
			Detalles = "<Detalle>" & FinLinea
			Detalles = Detalles & "<NroLinDet>" & idLinea & "</NroLinDet>" & FinLinea
			Detalles = Detalles & "<CdgItem>" & FinLinea
			if Session("Empresa_usuario") = "79741700-7" then
				if Cliente = "96439000" then 'D&S
					Detalles = Detalles & "<TpoCodigo>EAN13</TpoCodigo>" & FinLinea
					Detalles = Detalles & "<VlrCodigo>" & RsDet("EAN13") & "</VlrCodigo>" & FinLinea
				else
					Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
					Detalles = Detalles & "<VlrCodigo>" & RsDet("Producto_Catalago") & "</VlrCodigo>" & FinLinea
				end if
			else
				Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
				Detalles = Detalles & "<VlrCodigo>" & RsDet("Producto") & "</VlrCodigo>" & FinLinea
			end if
			Detalles = Detalles & "</CdgItem>" & FinLinea
			if Trim(Ucase(RsDet("Afecto_o_Exento"))) = "E" then
				Detalles = Detalles & "<IndExe>1</IndExe>" & FinLinea
			end if
			Detalles = Detalles & "<NmbItem>" & AscToISO8859Entities(Trim(RsDet("Desc_producto"))) & "</NmbItem>" & FinLinea
			Detalles = Detalles & "<DscItem>" & AscToISO8859Entities(Trim(RsDet("Producto_cliente"))) & "</DscItem>" & FinLinea
			
			If IsNull(RsDet("DUN14_Codigo")) Then CantidadSalida = cDbl("0" & RsDet("Cantidad_salida"))
			if len(trim(RsDet("DUN14_Codigo"))) > 0 then 
				CantidadSalida = cDbl("0" & RsDet("Cantidad_salida")) / cDbl("0" & RsDet("DUN14_Cantidad"))
			Else 
				CantidadSalida = cDbl("0" & RsDet("Cantidad_salida"))
			end if
			
			Detalles = Detalles & "<QtyItem>" & CantidadSalida & "</QtyItem>" & FinLinea
			if Session("Empresa_usuario") = "79741700-7" then
				Detalles = Detalles & "<PrcItem>" & RsDet("Precio_DTE") & "</PrcItem>" & FinLinea
			else
				Detalles = Detalles & "<PrcItem>" & RsDet("Precio_de_lista_modificado") & "</PrcItem>" & FinLinea
			end if
			if len(trim(Referencia)) = 0 then
				if cDbl("0" & Pctje_Desc) > 0 then
					Detalles = Detalles & "<DescuentoPct>" & FormatNumber(Pctje_Desc,2) & "</DescuentoPct>" & FinLinea
					Detalles = Detalles & "<DescuentoMonto>" & Monto_Desc & "</DescuentoMonto>" & FinLinea
				end if
			end if
			if Session("Empresa_usuario") = "79741700-7" then
				Detalles = Detalles & "<MontoItem>" & RsDet("Total_DTE") & "</MontoItem>" & FinLinea
			else
				Detalles = Detalles & "<MontoItem>" & RsDet("Valor_movimiento") & "</MontoItem>" & FinLinea
			end if
			Detalles = Detalles & "</Detalle>" & FinLinea

			fnBitacora.Write ( Detalles )

			RsDet.MoveNext
			idLinea = idLinea + 1
		Loop
	Else
		Pctje_Desc = 0
		Monto_Desc = 0
		PrimerArticulo = "SIN ARTICULO"
		Detalles = "<Detalle>" & FinLinea
		Detalles = Detalles & "<NroLinDet>1</NroLinDet>" & FinLinea
		Detalles = Detalles & "<CdgItem>" & FinLinea
		Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
		Detalles = Detalles & "<VlrCodigo></VlrCodigo>" & FinLinea
		Detalles = Detalles & "</CdgItem>" & FinLinea
		Detalles = Detalles & "<NmbItem>SIN ARTICULO</NmbItem>" & FinLinea
		Detalles = Detalles & "<DscItem>0</DscItem>" & FinLinea
		Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
		Detalles = Detalles & "<PrcItem>1</PrcItem>" & FinLinea
		Detalles = Detalles & "<MontoItem>0</MontoItem>" & FinLinea
		Detalles = Detalles & "</Detalle>" & FinLinea
		fnBitacora.Write ( Detalles )
	End If
	RsDet.Close			
	Set RsDet = Nothing

	DscGlobal = ""
	for f=0 to Ubound(aReferencia)-1
		Det = Split(aReferencia(f),"@@")
		DscGlobal = "<DscRcgGlobal>" & FinLinea
		DscGlobal = DscGlobal & "<NroLinDR>1</NroLinDR>" & FinLinea
		DscGlobal = DscGlobal & "<TpoMov>D</TpoMov>" & FinLinea
		DscGlobal = DscGlobal & "<GlosaDR>" & Det(1) & "</GlosaDR>" & FinLinea
		DscGlobal = DscGlobal & "<TpoValor>%</TpoValor>" & FinLinea
		DscGlobal = DscGlobal & "<ValorDR>" & Det(0) & "</ValorDR>" & FinLinea
		DscGlobal = DscGlobal & "</DscRcgGlobal>" & FinLinea
	next
	if len(trim(DscGlobal)) > 0 then
		fnBitacora.Write ( DscGlobal )
	end if

if Cliente = "96439000" then
	cReferencia = "<Referencia>" & FinLinea
	cReferencia = cReferencia & "<NroLinRef>1</NroLinRef>" & FinLinea
	cReferencia = cReferencia & "<TpoDocRef>801</TpoDocRef>" & FinLinea
	cReferencia = cReferencia & "<FolioRef>" & OrdenCompra &"</FolioRef>" & FinLinea
	cReferencia = cReferencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	cReferencia = cReferencia & "</Referencia>" & FinLinea
	fnBitacora.Write ( cReferencia )

	cReferencia = "<Referencia>" & FinLinea
	cReferencia = cReferencia & "<NroLinRef>2</NroLinRef>" & FinLinea
	cReferencia = cReferencia & "<TpoDocRef>MER</TpoDocRef>" & FinLinea
	cReferencia = cReferencia & "<FolioRef>1</FolioRef>" & FinLinea
	cReferencia = cReferencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	cReferencia = cReferencia & "</Referencia>" & FinLinea
	fnBitacora.Write ( cReferencia )
end if

if 1 = 0 then
	cReferencia = "<Referencia>" & FinLinea
	cReferencia = cReferencia & "<NroLinRef>1</NroLinRef>" & FinLinea
	cReferencia = cReferencia & "<TpoDocRef>SET</TpoDocRef>" & FinLinea
	cReferencia = cReferencia & "<FolioRef>0</FolioRef>" & FinLinea
	cReferencia = cReferencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	cReferencia = cReferencia & "<RazonRef>" & Observaciones & "</RazonRef>" & FinLinea
	cReferencia = cReferencia & "</Referencia>" & FinLinea

	fnBitacora.Write ( cReferencia )
end if

	cSql = "Exec CAF_Lista_Folio '" & Empresa & "', 0" & NroDocumento
	Set RsCAF = Conn.Execute ( cSql )
	if Not RsCAF.Eof then
		ID_PubKey_en_SII	= RsCAF("ID_PubKey_en_SII")
		Fecha_autorizacion	= RsCAF("Fecha_autorizacion")
			Fecha_autorizacion = Mid(Fecha_autorizacion,7,4) & "-" & Mid(Fecha_autorizacion,4,2) & "-" & Mid(Fecha_autorizacion,1,2)
		ExponenteRSA		= RsCAF("PubKey_Contribuyente_Exponente")
		ModuloRSA			= RsCAF("PubKey_Contribuyente_Modulo")
		LlavePrivada_SII	= RsCAF("SII_PrivateKey")
		LlavePublica_SII	= RsCAF("SII_PublicKey")				
		Rango_Inicio		= RsCAF("Rango_Inicio")
		Rango_Fin			= RsCAF("Rango_Fin")
		Tipo_DTE			= RsCAF("Tipo_DTE")
		FRMA				= ExtraeDatos( "<FRMA algoritmo=" & chr(34) & "SHA1withRSA" & chr(34) & ">", "</FRMA>", RsCAF("Archivo_XML") )
		CAF					= ExtraeDatos( "<CAF version=" & chr(34) & "1.0" & chr(34) & ">", "</CAF>", RsCAF("Archivo_XML") )
	end if
	RsCAF.Close
	Set RsCAF = Nothing

		TED = "<TED version=" & chr(34) & "1.0" & chr(34) & ">" & FinLinea
		TED = TED & "<DD>" & FinLinea
		TED = TED & "<RE>" & RutEmisor & "</RE>" & FinLinea
		TED = TED & "<TD>" & Tipo_DTE & "</TD>" & FinLinea
		TED = TED & "<F>" & FolioElectronico & "</F>" & FinLinea
		TED = TED & "<FE>" & Mid(Fecha_Hora,1,10) & "</FE>" & FinLinea
		TED = TED & "<RR>" & RutCliente & "</RR>" & FinLinea
		TED = TED & "<RSR>" & AscToISO8859Entities(RazonSocial) & "</RSR>" & FinLinea
		TED = TED & "<MNT>" & Total & "</MNT>" & FinLinea
		TED = TED & "<IT1>" & Left(AscToISO8859Entities(PrimerArticulo),40) & "</IT1>" & FinLinea
		TED = TED & "<CAF version=" & chr(34) & "1.0" & chr(34) & ">" & FinLinea
		TED = TED &	CAF & FinLinea
		TED = TED & "</CAF>" & FinLinea
		TED = TED & "<TSTED>" & Fecha_Hora & "</TSTED>" & FinLinea
		TED = TED & "</DD>" & FinLinea
		TED = TED & "<FRMT algoritmo=" & chr(34) & "SHA1withRSA" & chr(34) & "></FRMT>" & FinLinea
		TED = TED & "</TED>" & FinLinea
		TED = TED & "<TmstFirma>" & Fecha_Hora & "</TmstFirma>" & FinLinea
		TED = TED & "</Documento>" & FinLinea

		fnBitacora.Write ( TED )

		cFirma = "		<Signature xmlns=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#" & chr(34) & ">" & FinLinea
		cFirma = cFirma & "<SignedInfo>" & FinLinea
		cFirma = cFirma & "<CanonicalizationMethod Algorithm=" & chr(34) & "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<SignatureMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#rsa-sha1" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<Reference URI=" & chr(34) & "#" & Doc_Elec & chr(34) & ">" & FinLinea
		cFirma = cFirma & "<Transforms>" & FinLinea
		cFirma = cFirma & "<Transform Algorithm=" & chr(34) & "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "</Transforms>" & FinLinea
		cFirma = cFirma & "<DigestMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#sha1" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<DigestValue></DigestValue>" & FinLinea
		cFirma = cFirma & "</Reference>" & FinLinea
		cFirma = cFirma & "</SignedInfo>" & FinLinea
		cFirma = cFirma & "<SignatureValue></SignatureValue>" & FinLinea
		cFirma = cFirma & "<KeyInfo>" & FinLinea
		cFirma = cFirma & "<KeyValue>" & FinLinea
		cFirma = cFirma & "<RSAKeyValue>" & FinLinea
		cFirma = cFirma & "<Modulus></Modulus>" & FinLinea
		cFirma = cFirma & "<Exponent></Exponent>" & FinLinea
		cFirma = cFirma & "</RSAKeyValue>" & FinLinea
		cFirma = cFirma & "</KeyValue>" & FinLinea
		cFirma = cFirma & "<X509Data>" & FinLinea
		cFirma = cFirma & "<X509Certificate></X509Certificate>" & FinLinea
		cFirma = cFirma & "</X509Data>" & FinLinea
		cFirma = cFirma & "</KeyInfo>" & FinLinea
		cFirma = cFirma & "</Signature>" & FinLinea
		cFirma = cFirma & "</DTE>" & FinLinea
			
		fnBitacora.Write ( cFirma )				
			
	fnBitacora.Close

	SET objShell = Server.CreateObject("Wscript.Shell")
	Set oBitacoras = Server.CreateObject("Scripting.FileSystemObject")
	
	NombreDTE_S = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6) & "_S.xml"
	XMLURL = Server.MapPath("/") & "\XMLSEC\"
	Comando = "eFact_SII.exe /k " & XMLURL & "firmated.exe " & UrlDTE & NombreDTE & " > " & UrlDTE & NombreDTE_S & " " & XMLURL & "Certificados\" & Session("Empresa_usuario") & "_key.pem " & XMLURL & "Certificados\" & Session("Empresa_usuario") & ".pem " & UrlSII & ArchivoTMP
'if Request.ServerVariables("REMOTE_ADDR") = "192.168.30.12" then
'Response.Write Comando
'else
	SET objExec = objShell.Exec ( Comando )
'end if

End Function


'Solo para Altanet - SERVICIOS
Function Genera_DTE_Simulacion(NroInt_FAV, ArchivoTMP, Folio)

	Dim oBitacora, ArchivoSinFirmar, ArchivoFirmado, NombreTxt
	Dim objShell, objExec, strResult, oTextStream
	Dim fs,f

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	FinLinea	= Chr(13) & Chr(10)

	Fecha = Date()
	Fecha_Hora =  Mid(Fecha,7,4) & "-" & Mid(Fecha,4,2) & "-" & Mid(Fecha,1,2) & "T" & Mid(Time(),1,8)

	NroCheques = 0

	error=""

' ******************************* Inicio Carga Parametros *******************************
	cSQL = "Exec PAR_ListaParametros 'RUTA_SII_PK'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		UrlSII = Rs("VALOR_TEXTO")
	else
		UrlSII = "XMLSEC"
	end if
	Rs.Close

	cSQL = "Exec PAR_ListaParametros 'PCTGEIVA'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("PCTGEIVA") = Rs("VALOR_NUMERICO")
	else
		Session("PCTGEIVA") = 19
	end if
	Rs.Close

	cSQL = "Exec PAR_ListaParametros 'RUTA_DTE'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		UrlDTE = Rs("VALOR_TEXTO")
	else
		UrlDTE = "DTE"
	end if
	Rs.Close
' ******************************* Termino Carga Parametros *******************************

	Documento = "FAV"

'Inicio generación de archivo XML DTEs
	cSql = "Exec DOV_Lista_Facturas 0" & NroInt_FAV & ", '" & Session("empresa_usuario") & "', "
	cSql = cSql & "'FAV', 0" & Folio & ", Null, Null, Null, Null, 'S'"
	SET Rs	=	Conn.Execute( cSQL )				
	if Not Rs.Eof then
		FolioElectronico = Rs("Numero_documento_valorizado")
		Switch = 1		
		TotalCampos = Rs.FIELDS.COUNT
		Nombre_cliente	 = Rs("Nombre_cliente")
		RutCliente = Rs("Rut_entidad_comercial")
		if Not IsNull(RutCliente) Then 
			RutCliente = cStr(RutCliente) & "-" & cStr(Verificador_CI(RutCliente))
		else
			RutCliente = "ERROR"
		end if
		NroDocumento = Rs("Numero_documento_valorizado")
		FechaEmisionDocto = Mid(Rs("Fecha_emision"),7,4) & "-" & Mid(Rs("Fecha_emision"),4,2) & "-" & Mid(Rs("Fecha_emision"),1,2)
		Empresa = Rs("Empresa")
		Cliente = Rs("Cliente")

		if IsNull(Rs("Monto_total_moneda_oficial")) then 
			Total = 0
		else
			Total = cDbl("0" & Rs("Monto_total_moneda_oficial"))
		end if
		MontoExento = cDbl("0" & Rs("Monto_exento_moneda_oficial")) 
		Neto        = cDbl("0" & Rs("Monto_afecto_moneda_oficial"))
		Iva         = cDbl("0" & Rs("Monto_iva_moneda_oficial"))
		Total       = cDbl("0" & Rs("Monto_total_moneda_oficial"))
		Referencia	= Rs("Referencia")
			aReferencia = Split(Referencia, "||")

		Observaciones = Rs("Observaciones_generales")
		Numero_despacho_de_venta = Rs("Numero_despacho_de_venta")
	end if
	Rs.Close
				
	cSql = "Exec FAE_Datos_Caratula '" & Empresa & "'"
	Set RsCAR = Conn.Execute ( cSql )
	if Not RsCAR.Eof then
		RutEmisor		= RsCAR("RutEmisor")
		RutEnviador		= RsCAR("RutEnviador")
		FechaResolucion	= Mid(RsCAR("FechaResolucion"),7,4) & "-" & Mid(RsCAR("FechaResolucion"),4,2) & "-" & Mid(RsCAR("FechaResolucion"),1,2)
		NroResolucion	= RsCAR("NroResolucion")
		RazonSocial		= RsCAR("Razon_Social")
		Giro			= Left(RsCAR("Giro"),80)
		Direccion		= RsCAR("Direccion")
		Comuna			= RsCAR("Comuna")
		Ciudad			= RsCAR("Ciudad")
	end if
	RsCAR.Close
	Set RsCAR = Nothing

	cSql = "Exec ECP_ListaEntidadesComerciales '" & Cliente & "', Null, Null, Null, Null, Null, '" & Empresa & "'"
	Set RsECP = Conn.Execute ( cSql )
	if Not RsECP.Eof then
		DireccionCliente	= RsECP ( "Direccion" )
		if IsNull(DireccionCliente) then DireccionCliente = "."
		if len(trim(DireccionCliente)) = 0 then DireccionCliente = "."
		
		ComunaReceptor		= Left(trim(RsECP ( "NombreComuna" )),20)
		if IsNull(ComunaReceptor) then ComunaReceptor = "."
		if len(trim(ComunaReceptor)) = 0 then ComunaReceptor = "."
		
		CiudadReceptor		= RsECP ( "NombreRegion" )
		if IsNull(CiudadReceptor) then CiudadReceptor = "."
		if len(trim(CiudadReceptor)) = 0 then CiudadReceptor = "."
		
		GiroReceptor		= Left(RsECP ( "Giro_o_profesion" ),40)
		if IsNull(GiroReceptor) then GiroReceptor = "."
		if len(trim(GiroReceptor)) = 0 then GiroReceptor = "."
	end if
	RsECP.close

	NombreDTE = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6) & ".xml"
	Doc_Elec = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6)
	Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
	Set fnBitacora = oBitacora.OpenTextFile(UrlDTE & NombreDTE, 2, True, 0)

	DTE = "<?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "ISO-8859-1" & chr(34) & "?>" & FinLinea
	DTE = DTE & "<!DOCTYPE test [ " & FinLinea 
	DTE = DTE & "<!ATTLIST SetDTE " & FinLinea 
	DTE = DTE & "ID ID #IMPLIED> " & FinLinea 
	DTE = DTE & "<!ATTLIST Documento " & FinLinea 
	DTE = DTE & "ID ID #IMPLIED > " & FinLinea 
	DTE = DTE & "] " & FinLinea
	DTE = DTE & "> " & FinLinea
	DTE = DTE & "<DTE version=" & chr(34) & "1.0" & Chr(34) & ">" & FinLinea
	DTE = DTE & "<Documento ID=" & Chr(34) & Doc_Elec & Chr(34) & ">" & FinLinea
	DTE = DTE & "<Encabezado>" & FinLinea
	DTE = DTE & "<IdDoc>" & FinLinea
	DTE = DTE & "<TipoDTE>33</TipoDTE>" & FinLinea
	DTE = DTE & "<Folio>" & Folio & "</Folio>" & FinLinea
'	DTE = DTE & "<FchEmis>" & FechaEmisionDocto & "</FchEmis>" & FinLinea
	DTE = DTE & "<FchEmis>" & Mid(Fecha_Hora,1,10) & "</FchEmis>" & FinLinea
	DTE = DTE & "</IdDoc>" & FinLinea 
	DTE = DTE & "<Emisor>" & FinLinea 
	DTE = DTE & "<RUTEmisor>" & RutEmisor & "</RUTEmisor>" & FinLinea
	DTE = DTE & "<RznSoc>" & AscToISO8859Entities(RazonSocial) & "</RznSoc>" & FinLinea
	DTE = DTE & "<GiroEmis>" & AscToISO8859Entities(Giro) & "</GiroEmis>" & FinLinea
	DTE = DTE & "<Acteco>31341</Acteco>" & FinLinea
	DTE = DTE & "<DirOrigen>" & AscToISO8859Entities(Direccion) & "</DirOrigen>" & FinLinea
	DTE = DTE & "<CmnaOrigen>" & AscToISO8859Entities(Comuna) & "</CmnaOrigen>" & FinLinea
	DTE = DTE & "<CiudadOrigen>" & AscToISO8859Entities(Ciudad) & "</CiudadOrigen>" & FinLinea
	DTE = DTE & "</Emisor>" & FinLinea
	DTE = DTE & "<Receptor>" & FinLinea
	DTE = DTE & "<RUTRecep>" & RutCliente & "</RUTRecep>" & FinLinea
	DTE = DTE & "<RznSocRecep>" & AscToISO8859Entities(Nombre_cliente) & "</RznSocRecep>" & FinLinea
	DTE = DTE & "<GiroRecep>" & AscToISO8859Entities(GiroReceptor) & "</GiroRecep>" & FinLinea
	DTE = DTE & "<DirRecep>" & AscToISO8859Entities(DireccionCliente) & "</DirRecep>" & FinLinea
	DTE = DTE & "<CmnaRecep>" & AscToISO8859Entities(ComunaReceptor) & "</CmnaRecep>" & FinLinea
	DTE = DTE & "<CiudadRecep>" & AscToISO8859Entities(CiudadReceptor) & "</CiudadRecep>" & FinLinea
	DTE = DTE & "</Receptor>" & FinLinea
	DTE = DTE & "<Totales>" & FinLinea
	DTE = DTE & "<MntNeto>" & Neto & "</MntNeto>" & FinLinea
	if MontoExento > 0 then
	   DTE = DTE & "<MntExe>" & MontoExento & "</MntExe>" & FinLinea
	end if
	DTE = DTE & "<TasaIVA>" & Session("PCTGEIVA") & "</TasaIVA>" & FinLinea
	DTE = DTE & "<IVA>" & Iva & "</IVA>" & FinLinea
	DTE = DTE & "<MntTotal>" & Total & "</MntTotal>" & FinLinea
	DTE = DTE & "</Totales>" & FinLinea
	DTE = DTE & "</Encabezado>" & FinLinea

	fnBitacora.Write ( DTE )

	PrimerArticulo = Replace(Replace(Left(Trim(Observaciones),80),chr(13),""),chr(10),"")
	'PrimerArticulo = AscToISO8859Entities(PrimerArticulo)
	
	Detalles = "<Detalle>" & FinLinea
	Detalles = Detalles & "<NroLinDet>1</NroLinDet>" & FinLinea
	Detalles = Detalles & "<NmbItem>" & PrimerArticulo & "</NmbItem>" & FinLinea
	Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
	Detalles = Detalles & "<PrcItem>" & Neto & "</PrcItem>" & FinLinea
	if len(trim(Referencia)) = 0 then
		if cDbl("0" & Pctje_Desc) > 0 then
			Detalles = Detalles & "<DescuentoPct>" & FormatNumber(Pctje_Desc,2) & "</DescuentoPct>" & FinLinea
			Detalles = Detalles & "<DescuentoMonto>" & Monto_Desc & "</DescuentoMonto>" & FinLinea
		end if
	end if
	Detalles = Detalles & "<MontoItem>" & Neto & "</MontoItem>" & FinLinea
	Detalles = Detalles & "</Detalle>" & FinLinea

	fnBitacora.Write ( Detalles )

	if cDbl("0" & MontoExento) > 0 then
		Detalles = "<Detalle>" & FinLinea
		Detalles = Detalles & "<NroLinDet>2</NroLinDet>" & FinLinea
		Detalles = Detalles & "<IndExe>1</IndExe>" & FinLinea
		Detalles = Detalles & "<NmbItem>" & PrimerArticulo & "</NmbItem>" & FinLinea
		Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
		Detalles = Detalles & "<PrcItem>" & MontoExento & "</PrcItem>" & FinLinea
		Detalles = Detalles & "<MontoItem>" & MontoExento & "</MontoItem>" & FinLinea
		Detalles = Detalles & "</Detalle>" & FinLinea

		fnBitacora.Write ( Detalles )

	end if

	DscGlobal = ""
	for f=0 to Ubound(aReferencia)-1
		Det = Split(aReferencia(f),"@@")
		DscGlobal = "<DscRcgGlobal>" & FinLinea
		DscGlobal = DscGlobal & "<NroLinDR>1</NroLinDR>" & FinLinea
		DscGlobal = DscGlobal & "<TpoMov>D</TpoMov>" & FinLinea
		DscGlobal = DscGlobal & "<GlosaDR>" & Det(1) & "</GlosaDR>" & FinLinea
		DscGlobal = DscGlobal & "<TpoValor>%</TpoValor>" & FinLinea
		DscGlobal = DscGlobal & "<ValorDR>" & Det(0) & "</ValorDR>" & FinLinea
		DscGlobal = DscGlobal & "</DscRcgGlobal>" & FinLinea
	next

	if len(trim(DscGlobal)) > 0 then
		fnBitacora.Write ( DscGlobal )
	end if

if 1 = 0 then
	cReferencia = "<Referencia>" & FinLinea
	cReferencia = cReferencia & "<NroLinRef>1</NroLinRef>" & FinLinea
	cReferencia = cReferencia & "<TpoDocRef>SET</TpoDocRef>" & FinLinea
	cReferencia = cReferencia & "<FolioRef>0</FolioRef>" & FinLinea
	cReferencia = cReferencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	cReferencia = cReferencia & "<RazonRef>" & Observaciones & "</RazonRef>" & FinLinea
	cReferencia = cReferencia & "</Referencia>" & FinLinea

	fnBitacora.Write ( cReferencia )
end if

	cSql = "Exec CAF_Lista_Folio '" & Empresa & "', 0" & NroDocumento
	Set RsCAF = Conn.Execute ( cSql )
	if Not RsCAF.Eof then
		ID_PubKey_en_SII	= RsCAF("ID_PubKey_en_SII")
		Fecha_autorizacion	= RsCAF("Fecha_autorizacion")
			Fecha_autorizacion = Mid(Fecha_autorizacion,7,4) & "-" & Mid(Fecha_autorizacion,4,2) & "-" & Mid(Fecha_autorizacion,1,2)
		ExponenteRSA		= RsCAF("PubKey_Contribuyente_Exponente")
		ModuloRSA			= RsCAF("PubKey_Contribuyente_Modulo")
		LlavePrivada_SII	= RsCAF("SII_PrivateKey")
		LlavePublica_SII	= RsCAF("SII_PublicKey")				
		Rango_Inicio		= RsCAF("Rango_Inicio")
		Rango_Fin			= RsCAF("Rango_Fin")
		Tipo_DTE			= RsCAF("Tipo_DTE")
		FRMA				= ExtraeDatos( "<FRMA algoritmo=" & chr(34) & "SHA1withRSA" & chr(34) & ">", "</FRMA>", RsCAF("Archivo_XML") )
		CAF					= ExtraeDatos( "<CAF version=" & chr(34) & "1.0" & chr(34) & ">", "</CAF>", RsCAF("Archivo_XML") )
	end if
	RsCAF.Close
	Set RsCAF = Nothing

		TED = "<TED version=" & chr(34) & "1.0" & chr(34) & ">" & FinLinea
		TED = TED & "<DD>" & FinLinea
		TED = TED & "<RE>" & RutEmisor & "</RE>" & FinLinea
		TED = TED & "<TD>" & Tipo_DTE & "</TD>" & FinLinea
		TED = TED & "<F>" & FolioElectronico & "</F>" & FinLinea
		TED = TED & "<FE>" & Mid(Fecha_Hora,1,10) & "</FE>" & FinLinea
		TED = TED & "<RR>" & RutCliente & "</RR>" & FinLinea
		TED = TED & "<RSR>" & AscToISO8859Entities(RazonSocial) & "</RSR>" & FinLinea
		TED = TED & "<MNT>" & Total & "</MNT>" & FinLinea
		TED = TED & "<IT1>" & Left(PrimerArticulo,40) & "</IT1>" & FinLinea
		TED = TED & "<CAF version=" & chr(34) & "1.0" & chr(34) & ">" & FinLinea
		TED = TED &	CAF & FinLinea
		TED = TED & "</CAF>" & FinLinea
		TED = TED & "<TSTED>" & Fecha_Hora & "</TSTED>" & FinLinea
		TED = TED & "</DD>" & FinLinea
		TED = TED & "<FRMT algoritmo=" & chr(34) & "SHA1withRSA" & chr(34) & "></FRMT>" & FinLinea
		TED = TED & "</TED>" & FinLinea
		TED = TED & "<TmstFirma>" & Fecha_Hora & "</TmstFirma>" & FinLinea
		TED = TED & "</Documento>" & FinLinea

		fnBitacora.Write ( TED )

		cFirma = "		<Signature xmlns=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#" & chr(34) & ">" & FinLinea
		cFirma = cFirma & "<SignedInfo>" & FinLinea
		cFirma = cFirma & "<CanonicalizationMethod Algorithm=" & chr(34) & "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<SignatureMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#rsa-sha1" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<Reference URI=" & chr(34) & "#" & Doc_Elec & chr(34) & ">" & FinLinea
		cFirma = cFirma & "<Transforms>" & FinLinea
		cFirma = cFirma & "<Transform Algorithm=" & chr(34) & "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "</Transforms>" & FinLinea
		cFirma = cFirma & "<DigestMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#sha1" & chr(34) & "/>" & FinLinea
		cFirma = cFirma & "<DigestValue></DigestValue>" & FinLinea
		cFirma = cFirma & "</Reference>" & FinLinea
		cFirma = cFirma & "</SignedInfo>" & FinLinea
		cFirma = cFirma & "<SignatureValue></SignatureValue>" & FinLinea
		cFirma = cFirma & "<KeyInfo>" & FinLinea
		cFirma = cFirma & "<KeyValue>" & FinLinea
		cFirma = cFirma & "<RSAKeyValue>" & FinLinea
		cFirma = cFirma & "<Modulus></Modulus>" & FinLinea
		cFirma = cFirma & "<Exponent></Exponent>" & FinLinea
		cFirma = cFirma & "</RSAKeyValue>" & FinLinea
		cFirma = cFirma & "</KeyValue>" & FinLinea
		cFirma = cFirma & "<X509Data>" & FinLinea
		cFirma = cFirma & "<X509Certificate></X509Certificate>" & FinLinea
		cFirma = cFirma & "</X509Data>" & FinLinea
		cFirma = cFirma & "</KeyInfo>" & FinLinea
		cFirma = cFirma & "</Signature>" & FinLinea
		cFirma = cFirma & "</DTE>" & FinLinea
			
		fnBitacora.Write ( cFirma )				
			
	fnBitacora.Close

	SET objShell = Server.CreateObject("Wscript.Shell")
	Set oBitacoras = Server.CreateObject("Scripting.FileSystemObject")
	
	NombreDTE_S = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6) & "_S.xml"
	XMLURL = Server.MapPath("/") & "\XMLSEC\"
	'Se debe copiar el archivo cmd.exe a eFact_sii.exe
	Comando = "eFact_SII.exe /k " & XMLURL & "firmated.exe " & UrlDTE & NombreDTE & " > " & UrlDTE & NombreDTE_S & " " & XMLURL & "Certificados\" & Session("Empresa_usuario") & "_key.pem " & XMLURL & "Certificados\" & Session("Empresa_usuario") & ".pem " & UrlSII & ArchivoTMP
'Response.Write Comando & chr(13)
	SET objExec = objShell.Exec ( Comando )

End Function

%>

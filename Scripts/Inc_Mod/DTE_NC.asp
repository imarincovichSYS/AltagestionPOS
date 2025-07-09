<%
Function Genera_DTE_NC(NroInt, ArchivoTMP, Folio)
	NroDocInicial = Folio
	Dim oBitacora, ArchivoSinFirmar, ArchivoFirmado, NombreTxt
	Dim objShell, objExec, strResult, oTextStream
	Dim fs,f

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	FinLinea	= Chr(13) & Chr(10)
	TipoDTE = 61

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

	Documento = "NCV"

'Inicio generación de archivo XML DTEs
	cSql = "Exec DOV_Lista_NotasCredito 0" & NroInt & ", '" & Session("Empresa_usuario") & "', 'NCV', " & Folio & ", Null, Null, Null, Null, Null, Null, Null, Null, 'S'"
'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
	if Not Rs.Eof then
		FolioElectronico = Rs("Numero_documento_valorizado")
		Switch = 1		
		TotalCampos = Rs.FIELDS.COUNT
		Nombre_cliente	= Rs("Nombre_cliente")
		RutCliente		= Rs("Rut_entidad_comercial")
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

		MontoExento = Round(cDbl("0" & Rs("Monto_exento_moneda_oficial"))+0.0001,0)
		Neto        = Round(cDbl("0" & Rs("Monto_afecto_moneda_oficial"))+0.0001,0)
		Iva         = Round(cDbl("0" & Rs("Monto_iva_moneda_oficial"))+0.0001,0)
		Total       = Round(cDbl("0" & Rs("Monto_total_moneda_oficial"))+0.0001,0)
		
		Observaciones = Rs("Observaciones_generales")
		Numero_despacho_de_venta = Rs("Numero_despacho_de_venta")
		NroFactura = Rs("NumRespaldo")
		NumRespaldo = Rs("NumRespaldo")
		DTE_Referencia = Rs("DTE_Referencia")
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
		Giro			= RsCAR("Giro")
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
		
		ComunaReceptor		= Left(Trim(RsECP ( "Ciudad_o_comuna" )),20)
		if IsNull(ComunaReceptor) then ComunaReceptor = "."
		if len(trim(ComunaReceptor)) = 0 then ComunaReceptor = "."
		
		CiudadReceptor		= Trim(RsECP ( "NombreRegion" ))
		if IsNull(CiudadReceptor) then CiudadReceptor = "."
		if len(trim(CiudadReceptor)) = 0 then CiudadReceptor = "."
		
		GiroReceptor		= Left(RsECP ( "Giro_o_profesion" ),40)
		if IsNull(GiroReceptor) then GiroReceptor = "."
		if len(trim(GiroReceptor)) = 0 then GiroReceptor = "."
	end if
	RsECP.close
	
	Folio = NroDocInicial
	
	NombreDTE = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6) & ".xml"
	Doc_Elec = Documento & Session("Empresa_usuario") & "_" & Right(String(9,"0") & Folio,6)
'Response.Write 	Folio
'Response.End 
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
	DTE = DTE & "<TipoDTE>" & TipoDTE & "</TipoDTE>" & FinLinea
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
	if DTE_Referencia = "2" then
		PrimerArticulo = "ITEM 1"
		Detalles = "<Detalle>" & FinLinea
		Detalles = Detalles & "<NroLinDet>1</NroLinDet>" & FinLinea
		Detalles = Detalles & "<NmbItem>" & Left(Observaciones,40) & "</NmbItem>" & FinLinea
	'	Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
	'	Detalles = Detalles & "<PrcItem>" & cDbl("0" & Neto) & "</PrcItem>" & FinLinea
		Detalles = Detalles & "<MontoItem>" & cDbl("0" & Neto) & "</MontoItem>" & FinLinea
		Detalles = Detalles & "</Detalle>" & FinLinea
	else
		PrimerArticulo = "ITEM 1"
		Detalles = "<Detalle>" & FinLinea
		Detalles = Detalles & "<NroLinDet>1</NroLinDet>" & FinLinea
		Detalles = Detalles & "<NmbItem>" & Left(PrimerArticulo,40) & "</NmbItem>" & FinLinea
		Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
		if cDbl("0" & Neto) > 0 then
			Detalles = Detalles & "<PrcItem>" & cDbl("0" & Neto) & "</PrcItem>" & FinLinea
		else
			Detalles = Detalles & "<PrcItem>1</PrcItem>" & FinLinea
		end if
		Detalles = Detalles & "<MontoItem>" & cDbl("0" & Neto) & "</MontoItem>" & FinLinea
		Detalles = Detalles & "</Detalle>" & FinLinea
		if cDbl("0" & MontoExento) > 0 then
			Detalles = Detalles & "<Detalle>" & FinLinea
			Detalles = Detalles & "<NroLinDet>2</NroLinDet>" & FinLinea
			Detalles = Detalles & "<IndExe>1</IndExe>" & FinLinea
			Detalles = Detalles & "<NmbItem>ITEM2</NmbItem>" & FinLinea
			Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
			Detalles = Detalles & "<PrcItem>" & cDbl("0" & MontoExento) & "</PrcItem>" & FinLinea
			Detalles = Detalles & "<MontoItem>" & cDbl("0" & MontoExento) & "</MontoItem>" & FinLinea
			Detalles = Detalles & "</Detalle>" & FinLinea
		end if
	end if
	
	fnBitacora.Write ( Detalles )

nLineas = 1
if 1 = 0 then
	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>SET</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>0</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	Referencia = Referencia & "<RazonRef>CASO 8561-5</RazonRef>" & FinLinea
	Referencia = Referencia & "</Referencia>" & FinLinea
	nLineas = nLineas + 1
	fnBitacora.Write ( Referencia )
end if

	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>33</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>" & NumRespaldo & "</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & FechaEmisionDocto & "</FchRef>" & FinLinea
	Referencia = Referencia & "<CodRef>" & DTE_Referencia & "</CodRef>" & FinLinea
	Referencia = Referencia & "<RazonRef>" & AscToISO8859Entities(Observaciones) & "</RazonRef>" & FinLinea
	Referencia = Referencia & "</Referencia>" & FinLinea

	fnBitacora.Write ( Referencia )

	cSql = "Exec CAF_Lista_Folio '" & Empresa & "', 0" & NroDocumento & ",'" & TipoDTE & "'"
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
	
	NombreDTE_S = Documento & "_" & Session("Empresa_usuario") & "_" &  Right(String(9,"0") & Folio,6) & "_S.xml"
	XMLURL = Server.MapPath("/") & "\XMLSEC\"
	Comando = "eFact_SII.exe /k " & XMLURL & "firmated.exe " & UrlDTE & NombreDTE & " > " & UrlDTE & NombreDTE_S & " " & XMLURL & "Certificados\" & Session("Empresa_usuario") & "_key.pem " & XMLURL & "Certificados\" & Session("Empresa_usuario") & ".pem " & UrlSII & ArchivoTMP
	SET objExec = objShell.Exec ( Comando )
'Response.Write Comando
	Genera_DTE_NC = UrlDTE & NombreDTE_S

End Function

Function Genera_DTE_NC_DEV(NroInt, ArchivoTMP, Folio)
	Dim oBitacora, ArchivoSinFirmar, ArchivoFirmado, NombreTxt
	Dim objShell, objExec, strResult, oTextStream
	Dim fs,f

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	FinLinea	= Chr(13) & Chr(10)
	TipoDTE = 61

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

	Documento = "NCV_"

'Inicio generación de archivo XML DTEs
	cSql = "Exec DOV_Lista_NotasCredito 0" & NroInt & ", '" & Session("Empresa_usuario") & "', 'NCV', " & Folio & ", Null, Null, Null, Null, Null, Null, Null, Null, 'S'"
'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
	if Not Rs.Eof then
		NroDevolucion = Rs("Numero_devolucion_de_venta")
		FolioElectronico = Rs("Numero_documento_valorizado")
		Switch = 1		
		TotalCampos = Rs.FIELDS.COUNT
		Nombre_cliente	= Rs("Nombre_cliente")
		RutCliente		= Rs("Rut_entidad_comercial")
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

		MontoExento = Round(cDbl("0" & Rs("Monto_exento_moneda_oficial"))+0.0001,0)
		Neto        = Round(cDbl("0" & Rs("Monto_afecto_moneda_oficial"))+0.0001,0)
		Iva         = Round(cDbl("0" & Rs("Monto_iva_moneda_oficial"))+0.0001,0)
		Total       = Round(cDbl("0" & Rs("Monto_total_moneda_oficial"))+0.0001,0)
		
		NroFactura  = Rs("NumRespaldo")
		NumRespaldo = Rs("NumRespaldo")
		Observaciones = Rs("Observaciones_generales")
		Numero_despacho_de_venta = Rs("Numero_despacho_de_venta")
		DTE_Referencia = Rs("DTE_Referencia")
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
		Giro			= RsCAR("Giro")
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
		
		ComunaReceptor		= Left(Trim(RsECP ( "Ciudad_o_comuna" )),20)
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

	NombreDTE = Documento & Session("Empresa_usuario") & "_" &  Right(String(9,"0") & FolioElectronico,6) & ".xml"
	Doc_Elec = Documento & Session("Empresa_usuario") & "_" & Right(String(9,"0") & FolioElectronico,6)
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
	DTE = DTE & "<TipoDTE>" & TipoDTE & "</TipoDTE>" & FinLinea
	DTE = DTE & "<Folio>" & FolioElectronico & "</Folio>" & FinLinea
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

	Referencia = ""
	
	cSql = "Exec MOP_ListaMovimientosProductos Null, Null, '" & Empresa & "', 'DDV', 0" & NroDevolucion & ", Null, Null, Null"
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
				PrimerArticulo = RsDet("Desc_producto")
			end if
			Detalles = "<Detalle>" & FinLinea
			Detalles = Detalles & "<NroLinDet>" & idLinea & "</NroLinDet>" & FinLinea
			Detalles = Detalles & "<CdgItem>" & FinLinea
			Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
			if Session("Empresa_usuario") = "79741700-7" then
				Detalles = Detalles & "<VlrCodigo>" & RsDet("Producto_Catalago") & "</VlrCodigo>" & FinLinea
			else
				Detalles = Detalles & "<VlrCodigo>" & RsDet("Producto") & "</VlrCodigo>" & FinLinea
			end if
			Detalles = Detalles & "</CdgItem>" & FinLinea
			if Trim(Ucase(RsDet("Afecto_o_Exento"))) = "E" then
				Detalles = Detalles & "<IndExe>1</IndExe>" & FinLinea
			end if

			Detalles = Detalles & "<NmbItem>" & Left(AscToISO8859Entities(Trim(RsDet("Desc_producto"))),40) & "</NmbItem>" & FinLinea
			Detalles = Detalles & "<DscItem>" & AscToISO8859Entities(Trim(RsDet("Producto_cliente"))) & "</DscItem>" & FinLinea

			if cDbl("0" & RsDet("Precio_de_lista_modificado") ) > 0 then
				If IsNull(RsDet("DUN14_Codigo")) Then Cantidad = cDbl("0" & RsDet("Cantidad_entrada"))
				if len(trim(RsDet("DUN14_Codigo"))) > 0 then 
					Cantidad = cDbl("0" & RsDet("Cantidad_salida")) / RsDet("DUN14_Cantidad")
				Else 
					Cantidad = cDbl("0" & RsDet("Cantidad_entrada"))
				end if
			
				Detalles = Detalles & "<QtyItem>" & Cantidad & "</QtyItem>" & FinLinea
				'Detalles = Detalles & "<QtyItem>" & RsDet("Cantidad_entrada") & "</QtyItem>" & FinLinea
				Detalles = Detalles & "<PrcItem>" & RsDet("Precio_de_lista_modificado") & "</PrcItem>" & FinLinea
			end if

			if len(trim(Referencia)) = 0 then
				if cDbl("0" & Pctje_Desc) > 0 then
					Detalles = Detalles & "<DescuentoPct>" & FormatNumber(Pctje_Desc,2) & "</DescuentoPct>" & FinLinea
					Detalles = Detalles & "<DescuentoMonto>" & Monto_Desc & "</DescuentoMonto>" & FinLinea
				end if
			end if
			Detalles = Detalles & "<MontoItem>" & RsDet("Valor_movimiento") & "</MontoItem>" & FinLinea
			Detalles = Detalles & "</Detalle>" & FinLinea

			fnBitacora.Write ( Detalles )

			RsDet.MoveNext
			idLinea = idLinea + 1
		Loop
	End If
	RsDet.Close			
	Set RsDet = Nothing

nLineas = 1
if 1 = 0 then
	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>SET</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>0</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	if Folio = 5 then
		Referencia = Referencia & "<RazonRef>CASO 8561-6</RazonRef>" & FinLinea
	else
		Referencia = Referencia & "<RazonRef>CASO 8561-7</RazonRef>" & FinLinea
	end if
	Referencia = Referencia & "</Referencia>" & FinLinea
	nLineas = nLineas + 1
	fnBitacora.Write ( Referencia )
end if	

	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>33</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>" & NumRespaldo & "</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & FechaEmisionDocto & "</FchRef>" & FinLinea
	Referencia = Referencia & "<CodRef>" & DTE_Referencia & "</CodRef>" & FinLinea
	Referencia = Referencia & "<RazonRef>" & AscToISO8859Entities(Observaciones) & "</RazonRef>" & FinLinea
	Referencia = Referencia & "</Referencia>" & FinLinea

	fnBitacora.Write ( Referencia )

	cSql = "Exec CAF_Lista_Folio '" & Empresa & "', 0" & NroDocumento & ",'" & TipoDTE & "'"
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
	
	NombreDTE_S = Documento & Session("Empresa_usuario") & "_" &  Right(String(9,"0") & FolioElectronico,6) & "_S.xml"
	XMLURL = Server.MapPath("/") & "\XMLSEC\"
	Comando = "eFact_SII.exe /k " & XMLURL & "firmated.exe " & UrlDTE & NombreDTE & " > " & UrlDTE & NombreDTE_S & " " & XMLURL & "Certificados\" & Session("Empresa_usuario") & "_key.pem " & XMLURL & "Certificados\" & Session("Empresa_usuario") & ".pem " & UrlSII & ArchivoTMP
	SET objExec = objShell.Exec ( Comando )
'Response.Write Comando
	Genera_DTE_NC_DEV = UrlDTE & NombreDTE_S

End Function


Function Genera_DTE_NDV(NroInt, ArchivoTMP, Folio)
	NroDocInicial = Folio
	Dim oBitacora, ArchivoSinFirmar, ArchivoFirmado, NombreTxt
	Dim objShell, objExec, strResult, oTextStream
	Dim fs,f

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	FinLinea	= Chr(13) & Chr(10)
	TipoDTE = 56

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

	Documento = "NDV"
'Inicio generación de archivo XML DTEs
	cSql = "Exec DOV_Lista_Facturas 0" & NroInt & ", '"  & Session("Empresa_usuario") & "', 'NDV', " & Folio & ", Null, Null, Null, Null, 'S'"
'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
	if Not Rs.Eof then
		FolioElectronico = Rs("Numero_documento_valorizado")
		Switch = 1		
		TotalCampos = Rs.FIELDS.COUNT
		Nombre_cliente	= Rs("Nombre_cliente")
		RutCliente		= Rs("Rut_entidad_comercial")
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
		
		MontoExento = Round(cDbl("0" & Rs("Monto_exento_moneda_oficial"))+0.0001,0)
		Neto        = Round(cDbl("0" & Rs("Monto_afecto_moneda_oficial"))+0.0001,0)
		Iva         = Round(cDbl("0" & Rs("Monto_iva_moneda_oficial"))+0.0001,0)
		Total       = Round(cDbl("0" & Rs("Monto_total_moneda_oficial"))+0.0001,0)
		
		Observaciones = Rs("Observaciones_generales")
		Numero_despacho_de_venta = Rs("Numero_despacho_de_venta")
		NroFactura = Rs("Numero_factura_venta_para_nota_credito_o_debito")
		DTE_Referencia = Rs("DTE_Referencia")
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
		Giro			= RsCAR("Giro")
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
		
		ComunaReceptor		= Left(Trim(RsECP ( "Ciudad_o_comuna" )),20)
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

	NombreDTE = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & FolioElectronico,6) & ".xml"
	Doc_Elec = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & FolioElectronico,6)
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
	DTE = DTE & "<TipoDTE>" & TipoDTE & "</TipoDTE>" & FinLinea
	DTE = DTE & "<Folio>" & FolioElectronico & "</Folio>" & FinLinea
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
	PrimerArticulo = "ITEM 1"
	Detalles = "<Detalle>" & FinLinea
	Detalles = Detalles & "<NroLinDet>1</NroLinDet>" & FinLinea
'	Detalles = Detalles & "<CdgItem>" & FinLinea
'	Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
'	Detalles = Detalles & "<VlrCodigo>ITEM1</VlrCodigo>" & FinLinea
'	Detalles = Detalles & "</CdgItem>" & FinLinea
	Detalles = Detalles & "<NmbItem>" & left(Observaciones,40) & "</NmbItem>" & FinLinea
	if cDbl("0" & Neto) > 0 then
		Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
		Detalles = Detalles & "<PrcItem>" & cDbl("0" & Neto) & "</PrcItem>" & FinLinea
	end if
	Detalles = Detalles & "<MontoItem>" & cDbl("0" & Neto) & "</MontoItem>" & FinLinea
	Detalles = Detalles & "</Detalle>" & FinLinea

	if cDbl("0" & MontoExento) > 0 then
		Detalles = Detalles & "<Detalle>" & FinLinea
		Detalles = Detalles & "<NroLinDet>2</NroLinDet>" & FinLinea
		Detalles = Detalles & "<CdgItem>" & FinLinea
		Detalles = Detalles & "<TpoCodigo>INT1</TpoCodigo>" & FinLinea
		Detalles = Detalles & "<VlrCodigo>ITEM2</VlrCodigo>" & FinLinea
		Detalles = Detalles & "</CdgItem>" & FinLinea
		Detalles = Detalles & "<IndExe>1</IndExe>" & FinLinea
		Detalles = Detalles & "<NmbItem>ITEM2</NmbItem>" & FinLinea
	if cDbl("0" & MontoExento) > 0 then
		Detalles = Detalles & "<QtyItem>1</QtyItem>" & FinLinea
		Detalles = Detalles & "<PrcItem>" & cDbl("0" & MontoExento) & "</PrcItem>" & FinLinea
	end if 
		Detalles = Detalles & "<MontoItem>" & cDbl("0" & MontoExento) & "</MontoItem>" & FinLinea
		Detalles = Detalles & "</Detalle>" & FinLinea
	end if

	fnBitacora.Write ( Detalles )

nLineas = 1
if 1 = 0 then
	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>SET</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>0</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & Mid(Fecha_Hora,1,10) & "</FchRef>" & FinLinea
	Referencia = Referencia & "<RazonRef>CASO 8561-8</RazonRef>" & FinLinea
	Referencia = Referencia & "</Referencia>" & FinLinea
	nLineas = nLineas + 1
	fnBitacora.Write ( Referencia )
end if	

	Referencia = "<Referencia>" & FinLinea
	Referencia = Referencia & "<NroLinRef>" & nLineas & "</NroLinRef>" & FinLinea
	Referencia = Referencia & "<TpoDocRef>61</TpoDocRef>" & FinLinea
	Referencia = Referencia & "<FolioRef>" & NroFactura & "</FolioRef>" & FinLinea
	Referencia = Referencia & "<FchRef>" & FechaEmisionDocto & "</FchRef>" & FinLinea
	Referencia = Referencia & "<CodRef>" & DTE_Referencia & "</CodRef>" & FinLinea
	Referencia = Referencia & "<RazonRef>" & AscToISO8859Entities(Observaciones) & "</RazonRef>" & FinLinea
	Referencia = Referencia & "</Referencia>" & FinLinea

	fnBitacora.Write ( Referencia )

	cSql = "Exec CAF_Lista_Folio '" & Empresa & "', 0" & NroDocumento & ",'" & TipoDTE & "'"
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
	
	NombreDTE_S = Documento & "_" & Session("Empresa_usuario") & "_" & Right(String(9,"0") & FolioElectronico,6) & "_S.xml"
	XMLURL = Server.MapPath("/") & "\XMLSEC\"
	Comando = "eFact_SII.exe /k " & XMLURL & "firmated.exe " & UrlDTE & NombreDTE & " > " & UrlDTE & NombreDTE_S & " " & XMLURL & "Certificados\" & Session("Empresa_usuario") & "_key.pem " & XMLURL & "Certificados\" & Session("Empresa_usuario") & ".pem " & UrlSII & ArchivoTMP
	SET objExec = objShell.Exec ( Comando )
'Response.Write Comando
	Genera_DTE_NDV = UrlDTE & NombreDTE_S

End Function

%>

<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
	Function fSemilla( Servidor )
		On Error Resume Next
		Dim cSemilla
		Dim oSOAP, Semilla, Token 
		Set oSOAP = Server.CreateObject("MSSOAP.SoapClient30")	
		oSOAP.ClientProperty("ServerHTTPRequest") = True
		oSOAP.MSSoapInit("https://" & Servidor & ".sii.cl/DTEWS/CrSeed.jws?WSDL")	
		SemillaWSDL = oSOAP.getSeed
		if Instr(1,SemillaWSDL,"Client:") = 0 then
			if len(trim(Err.Description)) > 0 then
				fSemilla = "ERROR: " & Replace(Replace(Replace(Err.Description,"'",""),chr(13),""),chr(10),"")
			else
				fSemilla = SemillaWSDL
			end if
		else
			fSemilla = "ERROR: "
		end if
	End Function

	Function fToken( SemillaFirmada, Servidor )
	    On Error Resume Next
		Set oSOAP = Server.CreateObject("MSSOAP.SoapClient30")
		oSOAP.ClientProperty("ServerHTTPRequest") = True
		oSOAP.MSSoapInit("https://" & Servidor & ".sii.cl/DTEWS/GetTokenFromSeed.jws?WSDL")
		Token = oSOAP.getToken(SemillaFirmada)
		if Instr(1,Token,"Client:") = 0 then
			if len(trim(Err.Description)) > 0 then
				fToken = "ERROR: " & Replace(Replace(Replace(Err.Description,"'",""),chr(13),""),chr(10),"")
			else
				fToken = Token
			end if
		else
			fToken = "ERROR: "
		end if
	End Function

	Function fFirmaSemilla( Semilla, UrlST, Empresa )

		cSemilla = "<?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8" & chr(34) & "?>" & FinLinea
		cSemilla = cSemilla & "<getToken>" & FinLinea
		cSemilla = cSemilla & "<item>"& FinLinea
		cSemilla = cSemilla & "<Semilla>" & cStr(Trim(Semilla)) & "</Semilla>"& FinLinea
		cSemilla = cSemilla & "</item>"  & FinLinea
		cSemilla = cSemilla & "<Signature xmlns=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#" & chr(34) & ">" & FinLinea
	    cSemilla = cSemilla & "<SignedInfo>" & FinLinea
		cSemilla = cSemilla & "<CanonicalizationMethod Algorithm=" & chr(34) & "http://www.w3.org/TR/2001/REC-xml-c14n-20010315" & chr(34) & "/>" & FinLinea
		cSemilla = cSemilla & "<SignatureMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#rsa-sha1" & chr(34) & "/>" & FinLinea
		cSemilla = cSemilla & "<Reference URI=" & chr(34) & chr(34) & ">" & FinLinea
		cSemilla = cSemilla & "<Transforms>" & FinLinea
		cSemilla = cSemilla & "<Transform Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#enveloped-signature" & chr(34) & "/>" & FinLinea
		cSemilla = cSemilla & "</Transforms>" & FinLinea
		cSemilla = cSemilla & "<DigestMethod Algorithm=" & chr(34) & "http://www.w3.org/2000/09/xmldsig#sha1" & chr(34) & "/>" & FinLinea
		cSemilla = cSemilla & "<DigestValue></DigestValue>" & FinLinea
		cSemilla = cSemilla & "</Reference>" & FinLinea
		cSemilla = cSemilla & "</SignedInfo>" & FinLinea
		cSemilla = cSemilla & "<SignatureValue/>" & FinLinea
		cSemilla = cSemilla & "<KeyInfo>" & FinLinea
		cSemilla = cSemilla & "<KeyValue>" & FinLinea
		cSemilla = cSemilla & "<RSAKeyValue>" & FinLinea
		cSemilla = cSemilla & "<Modulus></Modulus>" & FinLinea
		cSemilla = cSemilla & "<Exponent></Exponent>" & FinLinea
		cSemilla = cSemilla & "</RSAKeyValue>" & FinLinea
		cSemilla = cSemilla & "</KeyValue>" & FinLinea
		cSemilla = cSemilla & "<X509Data>" & FinLinea
		cSemilla = cSemilla & "</X509Data>" & FinLinea
		cSemilla = cSemilla & "</KeyInfo>" & FinLinea
		cSemilla = cSemilla & "</Signature>" & FinLinea
		cSemilla = cSemilla & "</getToken>" & FinLinea

	'Se genera archivo XML semilla
		UrlDesarrollo = UrlST
		ArchivoFuente = "Seed_" & GeneraPwd(10) & ".xml"
		ArchivoSalida = Replace(ArchivoFuente, ".xml", "_S.xml")	
		Dim oBitacora, fnBitacora
		Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
		Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo & ArchivoFuente, 2, True, 0)
			fnBitacora.Write ( cSemilla )
			fnBitacora.Close
	'Firma la Semilla
		Dim Comando
		SET objShell = Server.CreateObject("Wscript.Shell")
		Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
		XMLURL = Server.MapPath("/") & "\XMLSEC\"
		Comando = "eFact_SII.exe /k " & XMLURL & "firmasemilla.exe " & UrlST & ArchivoFuente & " > " & UrlST & ArchivoSalida & " " & XMLURL & "Certificados\" & Empresa & "_key.pem " & XMLURL & "Certificados\" & Empresa & ".pem "
		SET objExec = objShell.Exec( Comando )

		Do While Not oBitacora.FileExists( UrlST & ArchivoSalida )
		Loop 

		Do While oBitacora.FileExists( UrlST & ArchivoSalida )
			set fil = oBitacora.getFile(UrlST & ArchivoSalida) 
			if fil.size > 0 then 
				exit do
			end if
		Loop 
		
	'Se lee semilla ya firmada
		sFileContents = ""
		Dim fil
		If oBitacora.FileExists(UrlST & ArchivoSalida) = True Then
			set fil = oBitacora.getFile(UrlST & ArchivoSalida) 
			if fil.size > 0 then 
				Dim TextStream
				Set TextStream = fil.OpenAsTextStream(1, -2)

				set fs = oBitacora.opentextfile(UrlST & ArchivoSalida) 
				sFileContents = fs.readall() 

				fs.close
				set fs = nothing 

				Set TextStream = nothing
			end if 
			set fil = nothing 
			set fso = nothing 
		end if
		
		SemillaFirmada = sFileContents
		
		fFirmaSemilla = SemillaFirmada
	End Function	
	
	Function fQueryDTE( Servidor, RutConsultante,DvConsultante,RutCompania,DvCompania,RutReceptor,DvReceptor,TipoDte,Folio,FchEmis,MntTotal,Token )
	    On Error Resume Next
		Set oSOAP = Server.CreateObject("MSSOAP.SoapClient30")
		oSOAP.ClientProperty("ServerHTTPRequest") = True
		oSOAP.MSSoapInit("https://" & Servidor & ".sii.cl/DTEWS/QueryEstDte.jws?WSDL")
		Respuesta = oSOAP.getEstDte(RutConsultante, DvConsultante, RutCompania, DvCompania, RutReceptor, DvReceptor, TipoDte, Folio, FchEmis, MntTotal, Token)
		if Instr(1,Respuesta,"Client:") = 0 then
			if len(trim(Err.Description)) > 0 then
				fQueryDTE = "ERROR: " & Replace(Replace(Replace(Err.Description,"'",""),chr(13),""),chr(10),"")
			else
				fQueryDTE = Respuesta
			end if
		else
			fQueryDTE = "ERROR: "
		end if
	End Function
		
	Function fSRV_CODE( valor )
		if valor = 0 then
			fSRV_CODE = "Envio Recibido Conforme"
		elseif valor = 1 then
			fSRV_CODE = "Envio Rechazado - Error de Schema"
		elseif valor = 2 then
			fSRV_CODE = "Envio Rechazado - Error de Firma"
		elseif valor = 3 then
			fSRV_CODE = "Envio Rechazado - Rut Receptor No Corresponde"
		elseif valor = 90 then
			fSRV_CODE = "Envio Rechazado - Archivo repetido"
		elseif valor = 91 then
			fSRV_CODE = "Envio Rechazado - Archivo Ilegible"
		elseif valor = 99 then
			fSRV_CODE = "Envio Rechazado - Otros"
		else
			fSRV_CODE = valor
		end if
	End Function

	Function fSQL_CODE( valor )
		if valor = 0 then
			fSQL_CODE = "Schema validado"
		else
			fSQL_CODE = "Código de Oracle"
		end if
	End Function
	
	Function fEstado( valor )
		if valor = "DOK" then
			fEstado = 0
		else
			fEstado = 99
		end if
	End Function
	
</script>
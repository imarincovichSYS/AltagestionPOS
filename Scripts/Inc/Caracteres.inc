<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

Sub SinEspacios (ByRef vardato) 
    Dato = vardato
    varDato = ""
 For nStep = 1 To Len(Dato)
     If Mid(Dato,nStep,1) <> " " Then
     vardato = vardato + Mid(Dato,nStep,1)
  End if
 Next
End Sub

Function ReverseString(sText)

  Dim lenText, lPos
  If Len(sText) = 0 Then Exit Function
  
  lenText = Len(sText)
  ReverseString = Space(lenText)
  
  For lPos = lenText To 1 Step -1
    txt1 = Mid(sText, lPos, 1)
    txt2 = txt2 & txt1 
'    Mid(ReverseString, lenText - lPos + 1, 1) = Mid(sText, lPos, 1)
  Next

  ReverseString = txt2

End Function

Function Verificador_CI(rut)
     if IsNumeric(rut) = false then 
	Verificador_CI = ""
	exit function
    end if
    tur = ReverseString(rut)
    mult = 2

    For i = 1 To Len(tur)
        If mult > 7 Then
            mult = 2
        End If
        
        Suma = mult * Mid(tur, i, 1) + Suma
        mult = mult + 1
    Next
    
    valor = 11 - (Suma Mod 11)
    
    If valor = 11 Then
        Verificador_CI = "0"
    ElseIf valor = 10 Then
        Verificador_CI = "K"
    Else
        Verificador_CI = valor
    End If
End Function


function valida_rut(entrada)

   largo=len(trim(entrada))
   if largo>8 or largo<7 then
	valida_rut=""
	exit function
   end if

   entrada = Right("00000000" & entrada,8)
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

Function ValidaRut(Rut,Digito)

   DigitoCorrecto = ""

   If not isnumeric(Rut) then 
      ValidaRut = False
      exit function
   End if

   largo = len(trim(Rut))

   If largo > 8 or largo < 7 then
      ValidaRut = False
      exit function
   End If

   desde   = largo
   lasuma  = 0

   For n = 0 to 5
       lasuma = lasuma + Mid(Rut,desde - n,1) * (n + 2)
   Next

   lasuma = lasuma + mid(Rut,desde - 6,1) * 2

   If largo = 8 then
	  lasuma = lasuma + mid(Rut,1,1) * 3
   End If

   resultado = 11 - (lasuma mod 11)

   If resultado = 10 then
      DigitoCorrecto = "K"
   Else   
      If resultado = 11 then
         DigitoCorrecto = "0"
      Else
         DigitoCorrecto = resultado      
      End If
   End If  

   If Cstr(DigitoCorrecto) <> Cstr(Digito) then
      ValidaRut = False
   Else
      ValidaRut = True
   End if

End Function

function valida_perfil(Funcion)

   session("mensaje_error")  = ""
   'Session("session_pagina") = Request.ServerVariables("SCRIPT_NAME")
   valida_perfil             = TRUE

   Funcion = trim(lcase( Funcion ))
   do while instr( Funcion , "/" ) > 0
      Funcion = mid(Funcion,instr( Funcion , "/" )+1)
   loop
   nAt = instr( Funcion , "_" )
   if nAt > 0 then Funcion = mid(Funcion,nAt+1)
   nAt = instr( Funcion , ".asp" )
   if nAt > 0 then Funcion = mid(Funcion,1,nAt-1)

 '  if Session("valida_"&Funcion) <> Session("session_codigo_usuario") then

      set conn = server.createobject("adodb.connection")
      conn.open Session("DataConn_ConnectionString")

      if valida_perfil then

		  Sql = "exec FPR_ListaFuncionesPerfil " +_
                "'" &  Session("session_codigo_perfil") &"'," + _
                "'" &  Funcion & "',1"
'response.write (sql)
		  Set RS = Conn.Execute (sql)

'response.write(RS("Fecha_caducidad") & "-" & date())
         if RS.Eof or len(Session("session_codigo_perfil"))=0 or (RS("Fecha_caducidad") < date() and RS("Fecha_caducidad") <> "01/01/1900") then
            valida_perfil = FALSE
         end if
      end if

      RS.close
      Conn.close

	'  if valida_perfil then Session("valida_"&Funcion) = Session("session_codigo_usuario")

 '  end if
end function

     Function AjustaTexto( texto, ancho )
          for c=1 to ancho
	     cCadena = cCadena & " "
	  next
		  NvoTexto = ""

	if len(texto) < ancho then 
	   AjustaTexto = Trim(texto)
	else
	   for a=1 to len(texto)
	         texto = texto & cCadena
	      for b=ancho to 1 step -1
	          if Mid(texto,b,1) = " " then
		     NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "<br>"
		     texto = Trim(Mid(texto,b,len(texto) ))
		     exit for
		   end if     
	      next
	    next
	    AjustaTexto = Trim(NvoTexto)
  	 end if
     End function


     Function AjustaTextoFAC( texto, ancho )
          for c=1 to ancho
	     cCadena = cCadena & " "
	  next
		  NvoTexto = ""

	if len(texto) < ancho then 
	   AjustaTextoFAC = Trim(texto)
	else
	   for a=1 to len(texto)
	         texto = texto & cCadena
	      for b=ancho to 1 step -1
	          if Mid(texto,b,1) <> "|" then
		     NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "|"
		     texto = Trim(Mid(texto,33,len(texto) ))
		     exit for
		   end if     
	      next
	    next
	    AjustaTextoFAC = Trim(NvoTexto)
  	 end if
     End function
	


   Function AjustaTexto_2( texto, ancho, sangria )
	NvoTexto = ""
	TotalLineas = 0
	if len(trim(sangria)) = 0 then
		sangria = 10
	end if
	Texto = cambia_chr(texto)
	Sangria = cDbl(Sangria)
	if len(texto) < ancho then 
	   AjustaTexto_2 = "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim(texto) & chr(34) & chr(13) & "¬1"			   
	else
		'Texto = Replace( Replace( Texto, chr(13), ""), chr(10), " ")
		Texto = Replace( Texto, chr(10), " ")
		for a=1 to len(texto)	       
			for b=ancho to 1 step -1
				if len(texto) <= ancho then
					if Instr(1, texto, Chr(13)) = 0 then 'No tiene corte de linea
						NvoTexto = NvoTexto & "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim(texto) & chr(34) & chr(13)
						texto = ""
						TotalLineas = TotalLineas + 1
						exit for
					else
						for k=1 to len(texto)
							nPos = Instr(1, texto, Chr(13) )
							if nPos > 0 then
								NvoTexto = NvoTexto & "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim( Mid(texto,1,nPos-1) ) & chr(34) & chr(13)
								texto = Trim( Mid(texto,nPos+1,len(texto)) )
								TotalLineas = TotalLineas + 1
							else
								NvoTexto = NvoTexto & "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim(texto) & chr(34) & chr(13)
								texto = ""
								TotalLineas = TotalLineas + 1
								exit for
							end if
						next
						exit for
					end if
				else
					if Mid(texto,b,1) = " " then						
						if Instr(1, Trim(Mid(texto,1,b)), Chr(13)) = 0 then 'No tiene corte de linea
							NvoTexto = NvoTexto & "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim(Mid(texto,1,b)) & chr(34) & chr(13)
							texto = Trim(Mid(texto,b,len(texto)))
							TotalLineas = TotalLineas + 1
							exit for
						else
							nPos = Instr(1, Trim(Mid(texto,1,b)), Chr(13) )
							NvoTexto = NvoTexto & "Locales.Imprimir " & chr(34) & Space(Sangria) & Trim( Mid(texto,1,nPos-1) ) & chr(34) & chr(13)
							texto = Trim(Mid(texto,nPos+1,len(texto)))
							TotalLineas = TotalLineas + 1
							exit for
						end if
					end if     
				end if
			next
			if len(trim(texto))=0 then 
				exit for
			end if
		next
	    AjustaTexto_2 = Trim(Mid(NvoTexto,1,len(NvoTexto)-1)) & "¬" & cStr(TotalLineas)
  	 end if
   End function

	Function Repetir( caracter, cantidad)		
		Cadena = ""
		for a=1 to Int(cantidad)
			Cadena = Cadena & caracter
		next
		Repetir = Cadena
	End function

	Function FormateoNumerico( valor, Decimales )
		if valor > 0 then
		  Dec = Int( Round((valor - Int(valor)) * 10^int(Decimales),0) )
		  Entera = Replace(Replace(Int(valor),",",""),".","")
                   if Int(Decimales) = 0 then
		     FormateoNumerico =  cStr(Entera) 
		   else
                      if Dec < 10 then
		         FormateoNumerico =  cStr(Entera) & ".0" & left(cStr(Dec) & Repetir("0", cdbl(Decimales)-1),cdbl(Decimales)-1)
		      else
			 FormateoNumerico =  cStr(Entera) & "." & left(cStr(Dec) & Repetir("0", cdbl(Decimales)),cdbl(Decimales))
		      end if
		   end if
		Else
		  FormateoNumerico = 0
		end if
	End function


	function cambia_chr(entrada)
	      if IsNull(entrada) then
		 entrada = ""
              end if
		salida =   replace(entrada, "Ñ", Chr(165))
		salida =   replace(salida , "ñ", Chr(164))
		salida =   replace(salida , "é", Chr(130))
		salida =   replace(salida , "á", Chr(160))
		salida =   replace(salida , "í", Chr(161))
		salida =   replace(salida , "ó", Chr(162))
		salida =   replace(salida , "ú", Chr(163))
		salida =   replace(salida , "º", Chr(248))
		cambia_chr=salida
	end function

	function cambia_chr2(entrada)
	      if IsNull(entrada) then
		 entrada = ""
              end if
		salida =   replace(entrada, "é", "e")
		salida =   replace(salida , "á", "a")
		salida =   replace(salida , "í", "i")
		salida =   replace(salida , "ó", "o")
		salida =   replace(salida , "ú", "u")
		cambia_chr2=salida
	end function


	Function Stuff(cCadena, nPosINI, nCaracteres, cCambio)
    		Dim cPaso 
	    	cPaso = Left(cCadena, nPosINI - 1) & cCambio & Mid(cCadena, nPosINI + nCaracteres)
    		Stuff = cPaso
	End Function

	Function DV_EAN(cCodigo)
		Dim cBase, nCont, nSum 	 
		DV_EAN = " "
		cCodigo = LTrim(RTrim(cCodigo))
		If Len(cCodigo) <> 7 And Len(cCodigo) <> 12 Then Exit Function
		cBase = "131313131313"
		nSum = 0
		For nCont = 1 To Len(cCodigo)
		    nSum = nSum + Val(Mid(cCodigo, nCont, 1)) * Val(Mid(cBase, nCont, 1))
		Next
		nCont = Val(Right(Str(nSum), 1))
		If nCont > 0 Then nCont = 10 - nCont
		DV_EAN = Trim(Str(nCont))
	End Function

	Function EAN13_para_Impresion(cString)
		Dim cFormato(9), cPaso , cDV , nPrimerNum , cInicial, cLateral , cCentral, cRestoCodigo , nCont , cKit
		 
		cFormato(0) = "AAAAAACCCCCC"    ' 0
		cFormato(1) = "AABABBCCCCCC"    ' 1
		cFormato(2) = "AABBABCCCCCC"    ' 2
		cFormato(3) = "AABBBACCCCCC"    ' 3
		cFormato(4) = "ABAABBCCCCCC"    ' 4
		cFormato(5) = "ABBAABCCCCCC"    ' 5
		cFormato(6) = "ABBBAACCCCCC"    ' 6
		cFormato(7) = "ABABABCCCCCC"    ' 7
		cFormato(8) = "ABABBACCCCCC"    ' 8
		cFormato(9) = "ABBABACCCCCC"    ' 9
		 
		cPaso = RTrim(LTrim(cString))
		cDV = DV_EAN(cPaso)
		cPaso = cPaso + cDV
		nPrimerNum = EVal(Left(cPaso, 1))
		 
		cInicial = Chr(nPrimerNum + 35)
		cLateral = Chr(33)
		cCentral = Chr(45)
		 
		cRestoCodigo = Mid(cPaso, 2, 12)
		For nCont = 1 To 12
			cKit = Mid(cFormato(nPrimerNum), nCont, 1)
			If cKit = "A" Then
					cRestoCodigo = Stuff(cRestoCodigo, nCont, 1, Chr(eVal(Mid(cRestoCodigo, nCont, 1)) + 48))
			ElseIf cKit = "B" Then
					cRestoCodigo = Stuff(cRestoCodigo, nCont, 1, Chr(eVal(Mid(cRestoCodigo, nCont, 1)) + 65))
			ElseIf cKit = "C" Then
					cRestoCodigo = Stuff(cRestoCodigo, nCont, 1, Chr(eVal(Mid(cRestoCodigo, nCont, 1)) + 97))
			End If
		Next
		 
		EAN13_para_Impresion = cInicial + cLateral + Mid(cRestoCodigo, 1, 6) + cCentral + Mid(cRestoCodigo, 7, 6) + cLateral
	End Function


     Function AjustaTexto_3( texto, ancho )
		for c=1 to ancho
			cCadena = cCadena & " "
		next
		NvoTexto = ""

		if len(texto) < ancho then 
		   AjustaTexto_3 = Trim(texto)
		else
			for a=1 to len(texto)
				texto = texto & cCadena
				for b=ancho to 1 step -1
					if Instr(1,Trim(Mid(texto,1,b)),"|@") > 0 then
						Posicion = Instr(1,Trim(Mid(texto,1,b)),"|@")
						NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,Posicion-1)) & "<br>"
						texto = Trim(Mid(texto,Posicion+2,len(texto) ))
						exit for
					else
					   if Trim(Mid(texto,1,b)) <> "" then
						NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "<br>"
						texto = Trim(Mid(texto,b+1,len(texto) ))
						exit for
					   end if     
					end if
				next
			next
		    AjustaTexto_3 = Trim(NvoTexto)
  		 end if
     End function

     Function AjustaTexto_4( texto, ancho )
	for c=1 to ancho
		cCadena = cCadena & " "
	next
        NvoTexto = ""

	if len(texto) < ancho then 
	   AjustaTexto_4 = Trim(texto)
	else
	   for a=1 to len(texto)
	         texto = texto & cCadena
	      for b=ancho to 1 step -1
	          if Mid(texto,b,1) = " " then
		     NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "<br>"
		     texto = Trim(Mid(texto,b,len(texto) ))
		     exit for
		   end if     
	      next
	    next
	    AjustaTexto_4 = Trim(NvoTexto)
  	 end if
     End function

   function cambia_chr_html(entrada)
	if IsNull(entrada) Then entrada = ""
	salida =   replace(entrada, "Ñ", "&Ntilde;")
	salida =   replace(salida , "ñ", "&ntilde;")
	salida =   replace(salida , "á", "&aacute;")
	salida =   replace(salida , "é", "&eacute;")
	salida =   replace(salida , "í", "&iacute;")
	salida =   replace(salida , "ó", "&oacute;")
	salida =   replace(salida , "ú", "&uacute;")
	salida =   replace(salida , "º", "&ordm;")
	cambia_chr_html=salida
   end function

   Function WordWrap( texto, ancho )
		dim a
		texto = cambia_chr_html(Trim(texto))
		
		NvoTexto = ""
			do while len(trim(texto)) > 0 
				if Instr(1,Mid(texto,1,ancho+1),chr(10)) > 0 then					
					FinPos = Instr(1,Mid(texto,1,ancho+1),chr(10))
					NvoTexto = NvoTexto & Mid(texto,1,FinPos) & "<br>"
					texto = Mid(texto,FinPos+1)
				elseif Instr(1,Mid(texto,1,ancho+1)," ") = 0 then 'Si no hay blanco
					FinPos = Mid(texto,1,ancho)
					NvoTexto = NvoTexto & Mid(texto,1,ancho) & "<br>"
					texto = Mid(texto,ancho+1)
				else
					if len(trim(texto)) < ancho then 
						NvoTexto = Trim(NvoTexto) & texto
						texto = ""						
					else
						for b=ancho to 1 step -1
							if Mid(texto,b,1) = " " then
								NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "<br>"
								texto = Trim(Mid(texto,b))
								exit for
							end if     
						next
					end if
				end if				
			Loop
			WordWrap = Trim(NvoTexto)
	End function
	
Function GeneraPwd(largo)
	Dim intCounter, intDecimal, cGenRand
	For intCounter = 1 To largo
	    Randomize
	    intDecimal =  Int((26 * Rnd) + 1) + 64
	    cGenRand = cGenRand & Chr(intDecimal)
	Next
	GeneraPwd = cGenRand
End Function


	function ExtraeDatos( tagIni, tagFin, Cadena )
		Dim nPosIni, nPosFin
		nPosIni = Instr(1,Cadena, tagIni)
		nPosFin = Instr(1,Cadena, tagFin)
		if nPosIni <> -1 and nPosFin <> -1 Then 'Existe tagIni - tagFin
			ExtraeDatos = Mid(Cadena, nPosIni+len(tagIni), nPosFin-(nPosIni+len(tagIni)))
		else
			ExtraeDatos = "No encontrado"
		end if
	end function

Sub Delay(DelaySeconds)
	SecCount = 0
	Sec2 = 0
	While SecCount < DelaySeconds + 1
		Sec1 = Second(Time())
		If Sec1 <> Sec2 Then
			Sec2 = Second(Time())
			SecCount = SecCount + 1
		End If
	Wend
End Sub

function fPrint(texto)
	Response.Write(Texto)
	Response.Flush
end function

Function NoCharParaNombreArchivo( NombreArchivo )
   cChars = "\/:*?" & chr(34) & "<>|"
   Largo = len(cChars)
   Flag = False
   For a=1 to Largo
      Caracter = Mid(cChars,a,1)
      if Instr(1, NombreArchivo, Caracter ) > 0 then
	 Flag = True
	 exit for
      end if
   Next
   NoCharParaNombreArchivo = Flag
End Function

'FUNCTIONS:
'- replaceRightOne(strWholeTekst): 
'						Most right character will be replaced in some cases with ""
'- WordWrapped_String(sWWText, lWWRowWidth, sWWSplitChar, bWWMinChar):
'						Split the sWWText to parts (rows) width only whole words
'- GetAmmountRows(sGAText, lGARowWidth, sGASplitChar, bGAMinChar):
'						Get the amount of rows from a long string (to calculate with the calculated amount)
'- GetArrayRows(sGArrText, lGArrRowWidth, sGArrSplitChar, bGArrMinChar):
'						Make an array of rows of the given string
'- GetTotalText(introTXT, iLenTextRow, iMaxAmountRows):
'						Get a recalculated string for the amount of given rows to show in an
'						HTML page, BUT only "Courier fonts" can be exactly recalculated, for 
'						other fonts you must choose the most best length for a row (sentence)!
'************************************************'
'Function:		replaceRightOne
'Description:	Most right character will be replaced in some cases with ""
'Parameters:	strWholeTekst= string to check most right character
'************************************************'
function replaceRightOne(strWholeTekst)
	dim arrChars
	strWholeTekst = Trim(strWholeTekst)
		
	if len(strWholeTekst) > 0 then
		'Make array with characters to replace
		arrChars = Array(";", ":", ",", ".", "?", "!", "-", "+", "~")
		for i = 0 to ubound(arrChars)
			if right(strWholeTekst,1) = arrChars(i) then
				strWholeTekst = left(strWholeTekst, len(strWholeTekst)-1)
				exit for
			end if
		next
  	end if
	replaceRightOne = Trim(strWholeTekst)
end function

'************************************************'
'Function:		WordWrapped_String
'Description:	Split the sWWText to parts (rows) width only whole words '
'Parameters:	sWWText= string to Wrap'
'				lWWRowWidth = maxlength for wrapped string parts  '
'				sWWSplitChar = the char you specify for splitting the string to an array '
'				bWWMinChar = True or False to break on a - char   '
'************************************************'
Function WordWrapped_String(sWWText, lWWRowWidth, sWWSplitChar, bWWMinChar)
    
    Dim sWWTextRows
    Dim lWWPos
    Dim sWWTemp
    Dim sWWPos
    
    'String WordWrappen on RowWidth
    sWWText = Trim(sWWText)

    If Len(sWWText) > lWWRowWidth Then
        sWWTemp = sWWText
        lWWPos = lWWRowWidth

        Do While Len(sWWTemp) > lWWRowWidth
            sWWPos = Trim(Mid(sWWTemp, lWWPos, 1))
            If sWWPos = "" Or _
				sWWPos = "." Or _
				sWWPos = "?" Or _
				sWWPos = "!" Or _
				sWWPos = "," Or _
				sWWPos = ";" Or _
				sWWPos = ":" Or _
				(bWWMinChar And sWWPos = "-") Then
	            
				'Check is there is a very long word on this row 
				'which can cause the wrong amount of rows and cut this long word with a "-".
				'if lWWPos < ((lWWRowWidth / 2)-1) then
				'	sWWTextRows = sWWTextRows & Trim(Left(sWWTemp, lWWRowWidth - 1)) & "-" & Trim(sWWSplitChar)
				'	sWWTemp = Trim(Right(sWWTemp, (Len(sWWTemp) - (lWWRowWidth -1))))
				'else
					sWWTextRows = sWWTextRows & Trim(Left(sWWTemp, lWWPos)) & Trim(sWWSplitChar)
					sWWTemp = Trim(Right(sWWTemp, (Len(sWWTemp) - lWWPos)))
				'end if
				lWWPos = lWWRowWidth
			Else
				lWWPos = lWWPos - 1
				if lWWPos = 0 then
					'There is a word which is longer then the given rowlength, so cut it with "-".
					sWWTextRows = sWWTextRows & Trim(Left(sWWTemp, lWWRowWidth - 1)) & "-" & Trim(sWWSplitChar)
					sWWTemp = Trim(Right(sWWTemp, (Len(sWWTemp) - (lWWRowWidth -1))))
					lWWPos = lWWRowWidth
				end if
			End If
		Loop
		sWWTextRows = sWWTextRows & Trim(sWWTemp)
	Else
		sWWTextRows = sWWText & Trim(sWWSplitChar)
	End If
	WordWrapped_String = sWWTextRows
End Function
'************************************************'
'Function:		GetAmmountRows
'Description:	Get the amount of rows from a long string (to calculate with the calculated amount)'
'Parameters:	sWWText= string to Wrap'
'				lWWRowWidth = maxlength for wrapped string parts  '
'				sWWSplitChar = the char you specify for splitting the string to an array '
'				bWWMinChar = True or False to break on a - char   '
'************************************************'
Function GetAmmountRows(sGAText, lGARowWidth, sGASplitChar, bGAMinChar)
    Dim sGATemp
    Dim arrGATemp 
    
    if len(trim(sGAText)) > 0 then
		sGATemp = WordWrapped_String(trim(sGAText), lGARowWidth, sGASplitChar, bGAMinChar)
		arrGATemp = Split(sGATemp, sGASplitChar)
		GetAmmountRows = UBound(arrGATemp) + 1
    else
		GetAmmountRows = 0
    end if
End Function

'************************************************'
'Function:		GetArrayRows
'Description:	Make an array of rows of the given string'
'Parameters:	sWWText= string to Wrap'
'				lGArrRowWidth = maxlength for wrapped string parts (rows)  '
'				sGArrSplitChar = the char you specify for splitting the string to an array '
'				bGArrMinChar = True or False to break on a - char   '
'************************************************'
Function GetArrayRows(sGArrText, lGArrRowWidth, sGArrSplitChar, bGArrMinChar)
    Dim sGArrTemp
    
    if len(trim(sGArrText)) > 0 then
			sGArrTemp = WordWrapped_String(trim(sGArrText), lGArrRowWidth, sGArrSplitChar, bGArrMinChar)
			GetArrayRows = Split(sGArrTemp, sGArrSplitChar)
    else
			GetArrayRows = null
    end if
End Function

'************************************************'
'Function:		GetTotalText
'Description:	Get a recalculated string for the amount of given rows to show in an HTML page'
'				But only Courier fonts can be exactly recalculated, other fonts you must choose '
'				the best length for a row!'
'Parameters:	introTXT= string to recalculate'
'				iLenTextRow = maxlength for a rows  '
'				iMaxAmountRows = The maximum amount of rows to return   '
'************************************************'
Function GetTotalText(introTXT, iLenTextRow, iMaxAmountRows)
	
	dim GTIntro, arrAmountRows, iAmount_Rows, sTotalTXT, iTxtRows
	
	arrAmountRows = GetArrayRows(introTXT, iLenTextRow, "|", true)
	
	'check the array
	if IsArray(arrAmountRows) then
		iAmount_Rows = ubound(arrAmountRows)
	
		if iAmount_Rows > iMaxAmountRows then
			iAmount_Rows = iMaxAmountRows
		end if
		
		sTotalTXT = ""
	
		'Pay attention: Array of rows starts with row 0 (zero)!
		for iTxtRows = 0 to iAmount_Rows
			if iTxtRows < iAmount_Rows then
				sTotalTXT = sTotalTXT & arrAmountRows(iTxtRows) & " "
			else
				GTIntro = trim(arrAmountRows(iTxtRows))
				if trim(right(GTIntro,3)) <> "..." then
					GTIntro = replaceRightOne(GTIntro)
					GTIntro = GTIntro & "..."
				end if
				sTotalTXT = sTotalTXT & GTIntro
			end if
		next 
		'set the result
		GetTotalText = sTotalTXT
	else
		'set the result
		GetTotalText = "" 	
	end if
end Function


</SCRIPT>
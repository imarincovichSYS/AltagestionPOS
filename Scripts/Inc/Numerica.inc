<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
	Sub ChequeaNumero(objeto,Indice)		'Ricardo              
	    
	    Tecla = window.event.keyCode                            

	    If Not Isnumeric(Indice) Then  
	       
	       If Trim(document.all(objeto).value) <> "" Then       
			  If Tecla = 190 Or _
	             Tecla = 110 Or _
	             (Tecla >= 48 And Tecla <=57) Or _
	             (Tecla >= 96 And Tecla <=105) Then 
	          
	             If Tecla = 190 Or Tecla = 110 Then
	                Puntos = 0             
	             
	                For i = 1 to Len(document.all(objeto).value)
	                    If Mid(document.all(objeto).value,i,1) = "." Then
	                       Puntos = Puntos + 1
	                    End if
	                Next
	          
	                If Puntos > 1 Then
	                   document.all(objeto).value = Left(document.all(objeto).value,Len(document.all(objeto).value)-1)   
	                End if   
	             End if          
	          Else
	             If Not Isnumeric(Mid(document.all(objeto).value,Len(document.all(objeto).value))) Then          
	                document.all(objeto).value = Left(document.all(objeto).value,Len(document.all(objeto).value)-1)
	             End if   
	          End if       
	       End if
	    
	    Else 'If Not Isnumeric(Indice) Then  
	       Indice = CInt(Indice)
	       
	       If Trim(document.all(objeto)(Indice).value) <> "" Then       
	          If Tecla = 190 Or _
	             Tecla = 110 Or _
	             (Tecla >= 48 And Tecla <=57) Or _
	             (Tecla >= 96 And Tecla <=105) Then 
	          
	             If Tecla = 190 Or Tecla = 110 Then
	                Puntos = 0             
	             
	                For i = 1 to Len(document.all(objeto)(Indice).value)
	                    If Mid(document.all(objeto)(Indice).value,i,1) = "." Then
	                       Puntos = Puntos + 1
	                    End if
	                Next
	          
	                If Puntos > 1 Then
	                   document.all(objeto)(Indice).value = Left(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value)-1)   
	                End if   
	             End if          
	          Else
	             If Not Isnumeric(Mid(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value))) Then          
	                document.all(objeto)(Indice).value = Left(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value)-1)
	             End if   
	          End if       
	       End if

	    End if 'If Not Isnumeric(Indice) Then  
	End Sub

	Function validaEan13(cCodigo)
		Dim cBase , nCont, nSum
		cBase = "13131313131313"
		cCodigo = Right("00000000000000" + cCodigo, 14)
		cCodigo = Left(cCodigo,14)
		nSum = 0
		For nCont = 1 To Len(cCodigo)
		    nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
		Next

		nCont = cDbl("0" & Right(cStr(nSum), 1))

		If nCont > 0 Then nCont = 10 - nCont
		validaEan13 = cDbl(nCont)
	End function

	FUNCTION valida_Ean( valor )	
		vx_cod = Mid(valor,1,len(valor)-1)
		vx_ta = len(vx_cod)
		digito = Mid(valor,len(valor),1)
	'Response.Write vx_cod & " -- " & digito & "<br>"
		vx_soma = 0
		vx_ret=0
		vx_cal=0
		FOR vx_i=1 TO vx_ta
			vx_cal = Mid(vx_cod,vx_i,1)
			IF (vx_i Mod 2) = 0 then
				vx_cal=vx_cal*3
			END IF
			vx_soma = vx_soma + vx_cal
		NEXT
			DO WHILE ( (vx_soma/10) <> INT(vx_soma/10) )
				vx_ret = vx_ret + 1
				vx_soma = vx_soma + 1
			LOOP
		if cDbl(digito) = cDbl(vx_ret) then
			valida_Ean = true
		else
			valida_Ean = false
		end if
	End Function

	Function DV_EAN13(cCodigo)
		Dim cBase , nCont, nSum
		if len(trim(cCodigo)) = 11 then
			cCodigo = cCodigo & Space(12)
			cCodigo = Left(LTrim(RTrim(cCodigo)),11)
			cBase = "313131313131"
			nSum = 0
			For nCont = 1 To Len(cCodigo)
			    nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
			Next
			nCont = cDbl("0" & Right(cStr(nSum), 1))
			If nCont > 0 Then nCont = 10 - nCont
			DV_EAN13 = cDbl(nCont)
		elseif len(trim(cCodigo)) = 12 then
			cCodigo = cCodigo & Space(13)
			cDigito = Mid(LTrim(RTrim(cCodigo)),13,1)
			cCodigo = Left(LTrim(RTrim(cCodigo)),12)

			cBase = "131313131313"
			nSum = 0
			For nCont = 1 To Len(cCodigo)
			    nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
			Next
			nCont = cDbl("0" & Right(cStr(nSum), 1))
			If nCont > 0 Then nCont = 10 - nCont
			DV_EAN13 = cDbl(nCont)
		end if
	End Function

	Function validaDun14(cCodigo)
	    Dim cBase , nCont, nSum
	    cCodigo = cCodigo & Space(14)
	    cDigito = Mid(LTrim(RTrim(cCodigo)),14,1)
	    cCodigo = Left(LTrim(RTrim(cCodigo)),13)

	    If Len(cCodigo) <> 7 And Len(cCodigo) <> 13 Then Exit Function
	    cBase = "3131313131313"
	    nSum = 0
	    For nCont = 1 To Len(cCodigo)
	        nSum = nSum + cDbl("0" & Mid(cCodigo, nCont, 1)) * cDbl("0" & Mid(cBase, nCont, 1))
	    Next
	    nCont = cDbl("0" & Right(cStr(nSum), 1))
	    If nCont > 0 Then nCont = 10 - nCont

	    validaDun14 = nCont
	End function

	Function Redondear (dblnToR, intCntDec)
    	    Dim lMultiplicador, dRetorno
	    If intCntDec > 9 Then intCntDec = 9
    	    lMultiplicador = 10 ^ intCntDec
    	    dRetorno = CDbl(CLng(dblnToR * lMultiplicador)) / lMultiplicador
    	    Redondear = dRetorno
	End Function 

	Function HexToDec(valHex)
	  Dim valDec
	  ValLen = Len(valHex)     ' length of the input
	  valLen2 = Len(valHex)    ' Second copy
	  intPof = ValLen          ' To the Power of (^)
	  Const conBase = 16

	        ' Loop through each char in input string
	     For i = 1 To ValLen
	          
	      ' Get each individual char (left to right)
	      valDec = Left(Mid(valHex, i, 1), i)
	      ' Replace chars with the correct value
	      If InStr(UCase(valDec), "A") Then valDec = 10
	      If InStr(UCase(valDec), "B") Then valDec = 11
	      If InStr(UCase(valDec), "C") Then valDec = 12
	      If InStr(UCase(valDec), "D") Then valDec = 13
	      If InStr(UCase(valDec), "E") Then valDec = 14
	      If InStr(UCase(valDec), "F") Then valDec = 15
	      
	      ' Array of Valid HEX values
	             isValid = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F"
	      
	      If InStr(isValid, UCase(Left(valDec, 1))) Then
	           ' Good input
	      Else
			myRslt = isValid
			exit for
	      End If
	            
	      If valLen2 >= 3 Then
	          rslt = valDec * conBase ^ (intPof - i)
	          valLen2 = valLen2 - 1
	      ElseIf valLen2 = 2 Then
	      rslt = valDec * conBase
	      valLen2 = valLen2 - 1
	      ElseIf valLen2 = 1 Then
	      rslt = valDec
	      End If
	     
	      ' Save the results & Add them together
	      myRslt = myRslt + rslt
	     Next

	     HexToDec = myRslt

	End Function


	function validaNumero( valor )		
		cNum = "0123456789"
		Flag = True
		nCnt = 0
        if len(trim(valor)) > 0 then
            for i=1 to len(valor)
                cChr = Mid(valor, i, 1 )
                if Instr(1, cNum, cChr) > 0 then
                    nCnt = nCnt + 1
                end if                
            next

            if nCnt = len(valor) then
                Flag = true
            else
                Flag = false
            end if
        end if
		validaNumero = Flag
	end function

</script>
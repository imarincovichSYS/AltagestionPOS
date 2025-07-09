<SCRIPT RUNAT=SERVER LANGUAGE=VBSCRIPT>
	Function Asc2Bin(cChar)
		Dim nAsc, cBinario, i, nDiv
	    nAsc = Asc(cChar)
	    cBinario = ""
	    For i = 7 To 0 Step -1
	        nDiv = 2 ^ i
	        If nAsc < nDiv Then
	            cBinario = cBinario + "0"
	        Else
	            cBinario = cBinario + "1"
	            nAsc = nAsc - nDiv
	        End If
	    Next
	    Asc2Bin = cBinario
	End Function

	Function AscToBase64(cAscii)
		Dim i, cBase64, cBinario, nAncho6, nAncho8, nAsc
	    cBase64 = ""
	    nAncho8 = Len(cAscii)
	    For i = 1 To nAncho8
	        cBase64 = cBase64 + Asc2Bin(Mid(cAscii, i, 1))
	    Next
	    If (nAncho8 * 8 / 6) = (nAncho8 * 8 \ 6) Then
	        nAncho6 = nAncho8 * 8 / 6
	    Else
	        nAncho6 = (nAncho8 * 8 \ 6) + 1
	    End If
	    cBase64 = Left(cBase64 + String(nAncho6 * 6, "0"), nAncho6 * 6)
	    For i = 1 To nAncho6
	        nAsc = Bin2Asc(Mid(cBase64, (i - 1) * 6 + 1, 6))
	        If nAsc <= 25 Then
	            cBinario = cBinario + Chr(nAsc + 65)
	        ElseIf nAsc <= 51 Then
	            cBinario = cBinario + Chr(nAsc + 71)
	        ElseIf nAsc <= 61 Then
	            cBinario = cBinario + Chr(nAsc - 4)
	        ElseIf nAsc = 62 Then
	            cBinario = cBinario + Chr(nAsc - 19)
	        ElseIf nAsc = 63 Then
	            cBinario = cBinario + Chr(nAsc - 16)
	        End If
	    Next
	    If (nAncho6 / 4) = (nAncho6 \ 4) Then
	        AscToBase64 = cBinario
	    Else
	        AscToBase64 = Left(cBinario + String((nAncho6 \ 4) + 1, "="), ((nAncho6 \ 4) + 1) * 4)
	    End If
	End Function

	Function Base64ToAsc(cBase64)
		Dim i, cChar, cAscii, cBinario, nAncho6, nAncho8, nAsc
	    cBase64 = Replace(cBase64, "=", "")
	    nAncho6 = Len(cBase64)
	    cBinario = ""
	    For i = 1 To nAncho6
	        cChar = Mid(cBase64, i, 1)
	        nAsc = Asc(cChar)
	        If nAsc >= 65 And nAsc <= 90 Then
	            cBinario = cBinario + Right(Asc2Bin(Chr(nAsc - 65)), 6)
	        ElseIf nAsc >= 97 And nAsc <= 122 Then
	            cBinario = cBinario + Right(Asc2Bin(Chr(nAsc - 71)), 6)
	        ElseIf nAsc >= 48 And nAsc <= 57 Then
	            cBinario = cBinario + Right(Asc2Bin(Chr(nAsc + 4)), 6)
	        ElseIf nAsc = 43 Then
	            cBinario = cBinario + Right(Asc2Bin(Chr(nAsc + 19)), 6)
	        ElseIf nAsc = 47 Then
	            cBinario = cBinario + Right(Asc2Bin(Chr(nAsc + 16)), 6)
	        End If
	    Next
	    nAncho8 = Len(cBinario) \ 8
	    cChar = ""
	    For i = 1 To nAncho8
	        cChar = cChar + Chr(Bin2Asc(Mid(cBinario, (i - 1) * 8 + 1, 8)))
	    Next
	    Base64ToAsc = cChar
	End Function

	Function Bin2Asc(cBinario)
		Dim nAsc, i, nDiv
	    cBinario = Right("00000000" + cBinario, 8)
	    nAsc = 0
	    For i = 7 To 0 Step -1
	        nDiv = 2 ^ i
	        nAsc = nAsc + CInt(Mid(cBinario, 8 - i, 1)) * nDiv
	    Next
	    Bin2Asc = nAsc
	End Function
</SCRIPT>

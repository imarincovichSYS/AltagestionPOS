<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

Function Escribir(nCifra)
Dim v1, v2, v3, v4, v5, v6
v1 = LTrim(cStr(nCifra))
v2 = Len(v1)
v4 = Len(v1)
v3 = cInt(v2/3 + 0.2)

ReDim v7(v3)
For v5 = 1 to v3
 v6 = cLng(Mid(v1, Iif(v4 > 3, v2 - 3 * v5 + 1, 1), Iif(v4 > 3, 3, v4)))
 v7(v5) = Cifra(v6)
 v4 = v4 - 3
 If (v5 = 2 Or v5 = 4) And v6<>0 Then
  v7(v5) = Mid(v7(v5), 1, IIF(v6 = 1, 2, Len(v7(v5)))) + " MIL "
 Elseif v5 = 3 Then
  v7(v5) = v7(v5) + " MILLON" + IIF(nCifra > 999999 And nCifra < 2000000, " ", "ES ")
 End if
Next
v6 = ""
For v5 = v3 to 1 step - 1
 v6 = v6 + v7(v5)
Next
Escribir = v6
End Function

Function Cifra(nNumero)
Dim v1, v2, v3, uni(20), may(8)
uni(1) = "UN"
uni(2) = "DOS"
uni(3) = "TRES"
uni(4) = "CUATRO"
uni(5) = "CINCO"
uni(6) = "SEIS"
uni(7) = "SIETE"
uni(8) = "OCHO"
uni(9) = "NUEVE"
uni(10) = "DIEZ"
uni(11) = "ONCE"
uni(12) = "DOCE"
uni(13) = "TRECE"
uni(14) = "CATORCE"
uni(15) = "QUINCE"
uni(16) = "DIECISEIS"
uni(17) = "DIECISIETE"
uni(18) = "DIECIOCHO"
uni(19) = "DIECINUEVE"
uni(20) = "VEINTE"
may(1) = "TREINTA"
may(2) = "CUARENTA"
may(3) = "CINCUENTA"
may(4) = "SESENTA"
may(5) = "SETENTA"
may(6) = "OCHENTA"
may(7) = "NOVENTA"
may(8) = "CIENTOS"

v1 = LTrim(cStr(nNumero))
v2 = Len(v1)
If v2 = 0 Or nNumero = 0 Then
 v3 = ""
Elseif v2 = 1 Then
 v3 = uni(nNumero)
Elseif v2 = 2 Then
 If nNumero <= 20 Then
  v3 = uni(nNumero)
 Elseif Mid(v1, 2, 1) = "0" Then
  v3 = may(cInt(Mid(v1, 1, 1)) - 2)
 Elseif nNumero >= 21 And nNumero <= 29 Then
  v3 = Mid(uni(20), 1, 5) + "I" + uni(nNumero - 20)
 Else
  v3 = may(cInt(Mid(v1, 1, 1)) - 2) + " Y " + uni(cInt(Mid(v1, 2, 1)))
 End if
Else
 If nNumero > 99 And nNumero < 200 Then
  v3 = IIF(nNumero = 100, "CIEN", "CIENTO")
 Elseif nNumero > 499 And nNumero < 600 Then
  v3 = "QUINIENTOS" 
 Elseif nNumero > 699 And nNumero < 800 Then
  v3 = "SETECIENTOS"
 Elseif nNumero > 899 And nNumero < 1000 Then
  v3 = "NOVECIENTOS"
 Else
  v3 = uni(cInt(Mid(v1, 1, 1))) + may(8)
 End if
 If Mid(v1, 2, 2)<>"00" Then
  IF cLng(Mid(v1, 2, 2)) <= 20 Then
   v3 = v3 + " " + uni(cInt(Mid(v1, 2, 2)))
  Elseif cLng(Mid(v1, 2, 2)) >= 21 And cLng(Mid(v1, 2, 2)) <= 29 Then
   v3 = v3 + " " + Mid(uni(20), 1, 5) + "I" + uni(cInt(Mid(v1, 2, 2)) - 20)
  Elseif Mid(v1, 3, 1) = "0" Then
   v3 = v3 + " " + may(cInt(Mid(v1, 2, 1)) - 2)
  Else
   v3 = v3 + " " + may(cInt(Mid(v1, 2, 1)) - 2) + " Y " + uni(cInt(Mid(v1, 3, 1)))
  End if
 End if
End if
Cifra = v3
End Function

Function Iif(bCond, vParam, fParam)
   If bCond Then
      Iif = vParam
   Else
      Iif = fParam
   End if
End Function
Function PadD(cParam, nLong)
	PadD = Left(cParam & String(nLong, " "), nLong)
End Function
Function PadI(cParam, nLong)
	PadI = Right(String(nLong, " ") & cParam, nLong)
End Function

</SCRIPT>

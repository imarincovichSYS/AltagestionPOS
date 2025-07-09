<% 
Dim Encryption_Key, Encryption_KeyLocation, DECRYPTED_CYPHERTEXT, g_CryptThis
Encryption_KeyLocation = Server.MapPath(".") & "/../../Scripts/Asp/key.txt" 'Server.MapPath("Scripts/Asp/key.txt") 
g_CryptThis = request.querystring("data")
Encryption_Key = mid(ReadKeyFromFile(Encryption_KeyLocation),1,Len(g_CryptThis))

If Len(g_CryptThis) > 1 then
	DECRYPTED_CYPHERTEXT = DeCrypt(g_CryptThis)
End If

Function request_equerystring(GetQueryString)

    Dim i,Found_It,Chop_DECRYPTED_CYPHERTEXT,Found_It_Here, TrimExcess
    Found_It_Here = 0
    TrimExcess = 0
    Chop_DECRYPTED_CYPHERTEXT = ""

    for i = 0 to Len(GetQueryString)
	Found_It = InStr(1, DECRYPTED_CYPHERTEXT, "&" & GetQueryString & "=", 1)
	If CInt(Found_It) > 0 then
		Found_It_Here = Found_It
		TrimExcess = 1
	End If

	If Found_It_Here < 1 then
		Found_It = InStr(1, DECRYPTED_CYPHERTEXT, "?" & GetQueryString & "=", 1)
		If (CInt(Found_It) > 0) then
			Found_It_Here = Found_It
			TrimExcess = 2
		End If
	End If

	if Found_It_Here > 0 then
		Chop_DECRYPTED_CYPHERTEXT = Right(DECRYPTED_CYPHERTEXT,(Len(DECRYPTED_CYPHERTEXT))-Found_It-Len(GetQueryString)-TrimExcess)
		Found_It = InStr(1, Chop_DECRYPTED_CYPHERTEXT, "&", 1)
		if CInt(Found_It) > 0 then
			Chop_DECRYPTED_CYPHERTEXT = Left(Chop_DECRYPTED_CYPHERTEXT,Found_It-1)
		End If
	End If

    Next

   request_equerystring = Chop_DECRYPTED_CYPHERTEXT

End Function




Function EnCrypt(strCryptThis)

	strCryptThis = ChkString(strCryptThis)

   Dim strChar, iKeyChar, iStringChar, i
   for i = 1 to Len(strCryptThis)
      iKeyChar = Asc(mid(Encryption_Key,i,1))
      iStringChar = Asc(mid(strCryptThis,i,1))
      iCryptChar = iStringChar + iKeyChar

	If iCryptChar > 255 then
		iCryptChar = iCryptChar - 256
	End If

      'iCryptChar = iKeyChar Xor iStringChar
      strEncrypted =  strEncrypted & Chr(iCryptChar)
   next
   EnCrypt = Server.URLEncode(strEncrypted)
End Function





Function DeCrypt(strEncrypted)

    Dim strChar, iKeyChar, iStringChar, i, iDeCryptChar

   for i = 1 to Len(strEncrypted)
      iKeyChar = (Asc(mid(Encryption_Key,i,1)))
      iStringChar = Asc(mid(strEncrypted,i,1))
      iDeCryptChar = iStringChar - iKeyChar
      'iDeCryptChar = iKeyChar Xor iStringChar

If iDeCryptChar < 0  then
	iDeCryptChar = iDeCryptChar + 256
End If

	If (iDeCryptChar = 34) or (iDeCryptChar = 39) then
	      Response.write "We detected a possible encryption ERROR<br>"
	      Response.write "please contact webmaster@LasVeg.as?subject=Encryption Error:" & g_CryptThis & "<br>"
	      Response.end
	Else
	      strDecrypted =  strDecrypted & Chr(iDeCryptChar)
	End If
   next
   DeCrypt = strDecrypted
End Function

Function ReadKeyFromFile(strFileName)
   Dim keyFile, fso, f
   set fso = Server.CreateObject("Scripting.FileSystemObject") 
   set f = fso.GetFile(strFileName) 
   set ts = f.OpenAsTextStream(1, -2)

   Do While not ts.AtEndOfStream
     keyFile = keyFile & ts.ReadLine
   Loop 

   ReadKeyFromFile =  keyFile
End Function


Function ChkString(string)
	If string = "" then 
		string = " "
	End If
	 ChkString = Replace(string, """", "")
	 ChkString = Replace(ChkString, "'", "")
End Function

%> 

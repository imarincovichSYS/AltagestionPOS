<!-- #include file="../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../Scripts/Inc/Caracteres.Inc" -->
<!-- #include file="../Scripts/Asp/Encryption.asp" -->
<%
	Cache
	NroIntFAV		= request_equerystring("NroFAV")
	Documento		= request_equerystring("Documento")
	Pagina			= request_equerystring("Url")

	Encryption_String = "?NroIntFAV=" & NroIntFAV
	Encryption_String = Encryption_String & "&Documento=" & Documento
	Encryption_Key = mid(ReadKeyFromFile(Encryption_KeyLocation),1,Len(Encryption_String))
	ENCRYPTED_CYPHERTEXT = "data=" & EnCrypt(Encryption_String)

	Response.Redirect "../" & Pagina & "?" & ENCRYPTED_CYPHERTEXT
	
%>

<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

Function enviaMail(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject = cResumen
	objMensaje.Text    = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function


Function enviaMailHTML(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject 	 = cResumen
	objMensaje.MessageFormat = 0
	objMensaje.HtmlText	 = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

</script>
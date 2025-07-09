<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
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

Function enviaMailconattach(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, attach)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3
	Const CdoFileData = 1

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente
	Dim objAttach

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject       = cResumen
	objMensaje.MessageFormat = 0
	objMensaje.HTMLText      = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

'Attachar objeto

'	Set	objAttach=objMensaje.Attachments
'		objAttach.Add "Objeto", CdoFileData , attach
'			objAttach.Source="../../relojregalo.gif"
 
	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

Function enviaMailCC(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, cc)
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
	Set objRecipiente = objMensaje.Recipients.Add(,cc, CdoCC)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

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

Function enviaMailCC_2(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, cc)

'Importance of the e-mail (0=Low, 1=Normal, 2=High) 
	Dim objSendmail 
	Set objSendmail = Server.CreateObject("CDONTS.NewMail")
		With objSendmail
		  .From = cEmailOrigen
		  .to = cDestinatario
		  .Subject = cResumen
		  .Body = cMensaje
		  .Importance = 2
		  .mailFormat = 0
		  .Cc = cc
		  .Send
		End With
	Set objSendMail = NOTHING
			
End Function

Function enviaMailAttach_2(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, attach)

'Importance of the e-mail (0=Low, 1=Normal, 2=High) 
	Dim objSendmail 
	Set objSendmail = Server.CreateObject("CDONTS.NewMail")
		With objSendmail
		  .From = cEmailOrigen
		  .to = cDestinatario
		  .Subject = cResumen
		  .Body = cMensaje
		  .Importance = 2
		  .mailFormat = 0
	   	  .AttachFile attach
		  .Send
		End With
	Set objSendMail = NOTHING
			
End Function

</SCRIPT>
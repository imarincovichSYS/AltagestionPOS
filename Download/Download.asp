<%
	Response.Buffer = True
	Response.Clear


	Archivo  = Request("Archivo")	
	' set the directory that contains the files here
	'strFileName = Server.MapPath( Archivo ) --> Esta se usa cuando el archivo de bajada reside en el mismo directorio
	strFileName = Replace(Request("RutaArchivo" ),"*","\")


	Dim Shell
	'This Function reads content type from windows registry
	Function GetContentTypeByExt(Extension)
		Dim CT
		If isempty(Shell) Then Set Shell = CreateObject("WScript.Shell")
		on error resume Next
		CT = Shell.regRead("HKCR\." & Extension & "\Content Type")
		If Len(CT) = 0 Then CT = "application/x-msdownload"
		GetContentTypeByExt = CT
	End Function 

	Function GetFileName(fullPath)
	  GetFileName = Mid(fullPath, SplitFileName(fullPath) + 1)
	End Function

	Function SplitFileName(FileName)
	  SplitFileName = InStrRev(FileName, "\")
	End Function

	Function ReadBinaryFile(FileName)
	  Const adTypeBinary = 1	  
	  'Create Stream object
	  Dim BinaryStream
	  Set BinaryStream = CreateObject("ADODB.Stream")  
	  'Specify stream type - we want To get binary data.
	  BinaryStream.Type = adTypeBinary	  
	  'Open the stream
	  BinaryStream.Open	  
	  'Load the file data from disk To stream object
	  BinaryStream.LoadFromFile FileName
	  'Open the stream And get binary data from the object
	  ReadBinaryFile = BinaryStream.Read
	End Function

	Function GetFileSize(FileName)
	  On Error Resume Next
	  Dim FS: Set FS = CreateObject("Scripting.FileSystemObject")
	  GetFileSize = FS.GetFile(FileName).Size
	  If err<>0 Then GetFileSize = -1 
	End Function

	Sub WriteFilePart(FileName)
		Dim CT
		Call Response.AddHeader( "Content-Disposition", "attachment; filename=" & Archivo )
		Response.ContentType = "application/octet-stream"
		Response.BinaryWrite ReadBinaryFile(FileName)
	End Sub

	Call WriteFilePart(strFileName)
%>
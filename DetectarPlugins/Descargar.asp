<%
	Response.Buffer = True
	Response.Clear

	strFileName = Server.MapPath(".") & "\j2re-1_4_2_08-windows-i586-p.exe"

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
		Response.Write vbCrLf
	End Sub

	Call WriteFilePart(strFileName)
	
%>
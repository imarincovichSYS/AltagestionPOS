<%
'funciones para validar archivo si existe genera un nombre de acuerdo a la fecha y hora del sistema
'se utiliza especificamente en informes
  function FileExists(FileName)
    Dim objFSO
    Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(FileName) Then
      flag = true    
    Else
      flag = false
    End If 
    Set objFSO = Nothing
    FileExists = flag
  end function

  function GenerateName(Head)
    FileName = Head & "_" &replace(date, "/", "-")& "(" & Session("login") &")"& Hour(time())&Minute(time())&Second(time())
    GenerateName = FileName
  end function
%>

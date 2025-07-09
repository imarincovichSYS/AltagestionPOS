<% 
Const g_KeyLocation = Server.MapPath("/Scripts/Asp/key.txt")
Const g_KeyLen = 512

On Error Resume Next

Call WriteKeyToFile(KeyGeN(g_KeyLen),g_KeyLocation)

if Err <> 0 Then
   Response.Write "ERROR GENERATING KEY." & "<P>"
   Response.Write Err.Number & "<BR>"
   Response.Write Err.Description & "<BR>"  
Else
   Response.Write "KEY SUCCESSFULLY GENERATED."
End If

Sub WriteKeyToFile(MyKeyString,strFileName)
   Dim keyFile, fso
   set fso = Server.CreateObject("scripting.FileSystemObject") 
   set keyFile = fso.CreateTextFile(strFileName, true) 
   keyFile.WriteLine(MyKeyString)
   keyFile.Close
End Sub

Function KeyGeN(iKeyLength)
Dim k, iCount, strMyKey
   lowerbound = 35
   upperbound = 96
   Randomize
   for i = 1 to iKeyLength
      s = 255
      k = Int(((upperbound - lowerbound) + 1) * Rnd + lowerbound)
      strMyKey =  strMyKey & Chr(k) & ""
   next
   KeyGeN = strMyKey
End Function

%> 

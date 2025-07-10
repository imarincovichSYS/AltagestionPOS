<%
' Solo cargar el .env si no se ha cargado antes en la sesión
If IsEmpty(Session("DB_HOST")) Then
    Function CargarEnv(ruta)
        Dim fso, archivo, linea, partes, clave, valor
        Set fso = Server.CreateObject("Scripting.FileSystemObject")

        If fso.FileExists(ruta) Then
            Set archivo = fso.OpenTextFile(ruta, 1)
            Do Until archivo.AtEndOfStream
                linea = Trim(archivo.ReadLine)
                If linea <> "" And Left(linea, 1) <> "#" Then
                    partes = Split(linea, "=", 2)
                    If UBound(partes) = 1 Then
                        clave = Trim(partes(0))
                        valor = Trim(partes(1))
                        Session(clave) = valor
                    End If
                End If
            Loop
            archivo.Close
            Set archivo = Nothing
        End If
        Set fso = Nothing
    End Function

    Call CargarEnv(Server.MapPath("config/.env"))
End If
%>

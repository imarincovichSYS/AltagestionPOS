<!--#include file="config/config.asp" -->
<%
website = Request.ServerVariables("SERVER_NAME")
websystem = "AltaGestion"
webtitle = "AltaGestion, el primer sistema de control y gestión por internet."

Dim cUser
If Len(Session("Nombre_usuario")) > 0 Then
    cUser = " (" & Session("Nombre_usuario") & ")"
Else
    cUser = ""
End If
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%=websystem & cUser%></title>
    <style>
        html, body {
            margin: 0;
            height: 100%;
            overflow: hidden;
        }
        #frame1 {
            height: calc(100% - 1px);
            width: 100%;
            border: none;
        }
        #frame2 {
            height: 1px;
            width: 100%;
            border: none;
        }
    </style>
</head>
<body>
    <iframe id="frame1" src="usuario.asp" name="Clave"></iframe>
    <iframe id="frame2" src="Empty.asp" name="Paso"></iframe>
</body>
</html>

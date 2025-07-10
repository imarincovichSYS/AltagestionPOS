<%
Dim RutaProyecto, RutaInf, version_sis
version_sis   = "v2.0"
nom_proyecto  = "AltaGestion"
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" & Request.ServerVariables("Server_Name") & StrSite
RutaInf       = "/altagestion/tmp/"

' Usar valores desde Session cargadas por Autentificacion.asp
APP = Session("Nombre_Aplicacion") & " (" & Session("login") & ")"
WSID = Session("login") & " (" & Request.ServerVariables("REMOTE_ADDR") & ")"

strConnect = "Provider=MSOLEDBSQL;" & _
             "Password=" & Session("DB_PASS") & ";" & _
             "WSID=" & WSID & ";" & _
             "Database=" & Session("DB_NAME") & ";" & _
             "User ID=" & Session("DB_USER") & ";" & _
             "TrustServerCertificate=True;" & _
             "Server=" & Session("DB_SERVER") & ";" & _
             "APP=" & APP & ";"

strConnect_Replica = "DSN=" & Session("DB_REPLICA_DSN") & ";" & _
                     "UID=" & Session("DB_USER") & ";" & _
                     "PWD=" & Session("DB_PASS") & ";" & _
                     "APP=" & APP & ";" & _
                     "WSID=" & WSID & ";" & _
                     "DATABASE=" & Session("DB_NAME")

Dim Conn : Set Conn = Server.CreateObject("ADODB.Connection")
Dim Conn1x : Set Conn1x = Server.CreateObject("ADODB.Connection")
Dim ConnReplica : Set ConnReplica = Server.CreateObject("ADODB.Connection")

Sub OpenConn()
  Conn.Open strConnect
End Sub

Sub OpenConn1()
  Conn1x.Open strConnect
End Sub

Sub OpenConn_Replica()
  ConnReplica.Open strConnect_Replica
End Sub
%>

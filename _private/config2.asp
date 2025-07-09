<%
Dim RutaProyecto, RutaInf, version_sis
version_sis   = "v2.0"
nom_proyecto  = "AltaGestion"
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite
RutaInf       = "/altagestion/tmp/"

Nombre_DSN    = "AG_Sanchez" 'BD oficial del servidor


APP = Session("Nombre_Aplicacion") & "(" & session("login") & ")"
WSID = Session("Login") & " (" & Request.ServerVariables("REMOTE_ADDR") & ")"

'strConnect = "DSN=" & Nombre_DSN & ";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;id=SYSGestion;password=;APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez"
strConnect = "Driver={SQL Server};Server=SRVSQL01,1433;Database=Sanchez;Uid=AG_Sanchez;Pwd=Vp?T+!mZpJds;"
strConnect_Replica = "DSN=AG_Sanchez_Replica;UID=AG_Sanchez_Replica;PWD=Vp?T+!mZpJds;APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez"

'strConnect = "Driver={ODBC Driver 17 for SQL Server};Server=SRVSQL01,1433;Database=Sanchez;Uid=AG_Sanchez;Pwd=Vp?T+!mZpJds;"



Dim Conn : set Conn = Server.CreateObject("ADODB.Connection")
Dim Conn1x : set Conn1x = Server.CreateObject("ADODB.Connection")
Dim ConnReplica : set ConnReplica = Server.CreateObject("ADODB.Connection")

sub OpenConn()
  Conn.Open strConnect
end sub

sub OpenConn1()
  Conn1x.Open strConnect
end sub

sub OpenConn_Replica()
  ConnReplica.Open strConnect_Replica
end sub
%>
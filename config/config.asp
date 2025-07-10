<!--#include file="load_env.asp" -->

<%
Dim APP, WSID

APP = Session("Nombre_Aplicacion") & " (" & Session("login") & ")"
WSID = Session("login") & " (" & Request.ServerVariables("REMOTE_ADDR") & ")"

Session("DataConn_ConnectionString") = _
    "Provider=MSOLEDBSQL;" & _
    "Password=" & Session("DB_PASS") & ";" & _
    "WSID=" & WSID & ";" & _
    "Database=" & Session("DB_NAME") & ";" & _
    "User ID=" & Session("DB_USER") & ";" & _
    "TrustServerCertificate=True;" & _
    "Server=" & Session("DB_SERVER") & ";" & _
    "APP=" & APP & ";"
%>

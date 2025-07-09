<%
Dim RutaProyecto, version_sis
version_sis   = "v1.0"
nom_proyecto  = "Reportes Flexline"
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite

'response.write Request.ServerVariables( "REMOTE_ADDR" )
'response.end

Nombre_DSN    = "AG_Flexline" 'BD Flexline
strConnect_Flexline = "DSN="&Nombre_DSN&";UID=AG_Flexline;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=flexlineERP"
'strConnect_Flexline= "driver={SQL Server};server=192.168.0.62;database=flexlineERP;trusted_Connection=Yes;uid=sa;pwd=force;"

Dim Conn_Flexline : set Conn = Server.CreateObject("ADODB.Connection")

sub OpenConn_Flexline()
  Conn.Open strConnect_Flexline
end sub

OpenConn_Flexline

%>

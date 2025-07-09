<%
Dim RutaProyecto, version_sis
version_sis   = "v1.0"
nom_proyecto  = "Reportes Flexline"
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite

strConnect_Flexline = "driver={SQL Server};Server=192.168.0.62;Database=FlexlineERP;UID=flexline;PWD=flexline;User Id=flexline;Password=flexline;"
strConnect_Alta     = "driver={SQL Server};Server=192.168.0.2;Database=sanchez;UID=cajas;PWD=c1j1s;User Id=cajas;Password=c1j1s; Trusted_Connections=yes;"
strConnect_Alta_Rep = "driver={SQL Server};Server=192.168.0.169;Database=sanchez;UID=cajas;PWD=c1j1s;User Id=cajas;Password=c1j1s; Trusted_Connections=yes;"
'strConnect_Alta     = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
Dim ConnFlexline, ConnAlta, ConnAltaRep
set ConnFlexline  = Server.CreateObject("ADODB.Connection")
set ConnAlta      = Server.CreateObject("ADODB.Connection")
set ConnAltaRep   = Server.CreateObject("ADODB.Connection")

sub OpenConn_Flexline()
  ConnFlexline.Open strConnect_Flexline
end sub

sub OpenConn_Alta()
  ConnAlta.Open strConnect_Alta
end sub

sub OpenConn_Alta_Replica()
  ConnAltaRep.Open strConnect_Alta_Rep
end sub
'OpenConn_Flexline
'OpenConn_Alta
%>
<%
Dim RutaProyecto
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite

strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
'strConnect_MSAccess = "DRIVER={Microsoft Access Driver (*.mdb)}; DBQ=\\192.168.0.21\novaXion\General\Datos\GesCom.mdb"
strConnect_MSAccess = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=\\192.168.0.21\novaXion\General\Datos\GesCom.mdb;Mode=Share Exclusive"
Dim ConnAccess : set ConnAccess = Server.CreateObject("ADODB.Connection")

sub OpenConn_Access()
  ConnAccess.Open strConnect_MSAccess
end sub

OpenConn_Access

strSQL="select * from empleados"
set rs = ConnAccess.Execute(strSQL)
%>
<table width="100%" border=0>
<%
do while not rs.EOF%>
<tr>
  <td><%=rs(0)%></td>
  <td><%=rs(1)%></td>
</tr>
<%rs.MoveNext
loop%>

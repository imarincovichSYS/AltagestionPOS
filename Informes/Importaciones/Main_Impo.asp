<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	if len(trim(Request("NomFun"))) > 0 then
		cSQL = "Exec FUN_ListaFunciones '" & Request("NomFun") & "', Null, Null"
		SET Rs	=	Conn.Execute( cSQL )
			'Session("Title") = Rs("Nombre")
		Rs.Close
		Conn.Close
	end if
session("pagenum")=""
session("nombre")=""
%>
<html>
  <body qonload="javascript:{if(parent.top.frames[0]&&parent.top.frames['Menu'].Go)parent.top.frames['Menu'].Go()}">
	<script language="JavaScript">
		parent.Botones.location.href = "Botones_Impo.asp"
		parent.Trabajo.location.href = 'Inicial_Impo.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>'
		parent.Mensajes.location.href = '../../Mensajes.asp';
	</script>
  </body>
</html>
     
<%else
	Response.Redirect "../../index.htm"
end if%>
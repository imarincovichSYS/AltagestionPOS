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
		set Rs=nothing
		Conn.Close
	end if
session("pagenum")=""
%>
<html>
  <body qonload="javascript:{if(parent.top.frames[0]&&parent.top.frames['Menu'].Go)parent.top.frames['Menu'].Go()}">
	<script language="JavaScript">
		parent.Botones.location.href = "Botones_DifeCambio.asp"
		parent.Trabajo.location.href = 'Inicial_DifeCambio.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>'
		parent.Mensajes.location.href = '../../Mensajes.asp';
	</script>
  </body>
</html>
     
<%else
	Response.Redirect "../../index.htm"
end if%>
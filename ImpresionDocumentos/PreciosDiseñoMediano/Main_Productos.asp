<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
'if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
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
	Session("CodigoProducto") = ""
	Session("NombreProducto") = ""
	Session("Orden")	  = ""
%>
<html>
  <body >
	<script language="JavaScript">
		//parent.Botones.location.href = "Botones_Productos.asp" 
		//parent.Trabajo.location.href = 'Inicial_Productos.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>' 
		//parent.Mensajes.location.href = '../../Mensajes.asp';
		//parent.Trabajo.location.href = 'Inicial_Productos.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>' 
	</script>
  </body>
</html>
<%'else
	'Response.Redirect "../../index.htm"
'end if%>

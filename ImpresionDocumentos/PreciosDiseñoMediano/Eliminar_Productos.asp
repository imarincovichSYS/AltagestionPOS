<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	On Error Resume Next
	Codigo		= Request ( "Codigo_pais" )
	Nombre		= Request ( "Nombre_pais" )	
	Orden		= Request ( "Orden" )	
	
' En Request ( "Afectados" ) se están recibiendo los registros que serán afectados

	aAfectados  = Split ( Request ( "Afectados" ), "|" )
' En aAfectados queda el arreglo de los elementos que contiene Request ( "Afectados" ) 

	MsgError = ""
	Error    = 0

	Set ConnManejo = Server.CreateObject("ADODB.Connection")
	ConnManejo.Open Session( "DataConn_ConnectionString" )

	For b = 0 to Ubound(aAfectados)-1
		aLinea = Split ( aAfectados(b), ",")
		cSql = "Exec PRO_BorraProducto '" & aLinea(0) & "'"
		Set Rs = ConnManejo.Execute ( cSql )
		if Rs("Eliminados") = 0 then
			NoEliminados = NoEliminados + aAfectados(b) + "|"
			MsgError = MsgError + aAfectados(b) + "\n"		
		else
			Eliminados = Eliminados + aAfectados(b) + "|"
		end if
		Rs.Close
	Next

	ConnManejo.close

%>

<!--
	El siguiente formulario muestra los registros que fueron eliminados y cuales tuvieron
	Problemas.
-->
<body bgcolor="<%=Session("ColorFondo")%>" background="<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000"  v a>
	<form name="Lista_Eliminados" action="Listado_Eliminados.asp" method="post" target="Trabajo">
		<input type=hidden name="Codigo_pais"	value="<%=Codigo%>">
		<input type=hidden name="Nombre_pais"	value="<%=Nombre%>">
		<input type=hidden name="Orden"			value="<%=Orden%>">
		<input type=hidden name="pagenum"		value='<%=Request("pagenum")%>'>	
		<input type=hidden name="Eliminados"	value="<%=Eliminados%>">
		<input type=hidden name="NoEliminados"	value="<%=NoEliminados%>">
	</form>
</body>

<script language="JavaScript">
	parent.top.frames[2].location.href = "../../Empty.asp";
	document.Lista_Eliminados.submit();
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
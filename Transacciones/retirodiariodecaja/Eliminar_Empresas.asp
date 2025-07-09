<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	On Error Resume Next
	Codigo		= Request ( "Empresa" )
	Nombre		= Request ( "Empresa" )	
	Orden		= Request ( "Orden" )	
	
' En Request ( "Afectados" ) se están recibiendo los registros que serán afectados
' para eliminarlos estos vienen en Cadena 1,Perú|2,Bolivia|3,Chile| ... etc

	aAfectados  = Split ( Request ( "Afectados" ), "|" )
' En aAfectados queda el arreglo de los elementos que contiene Request ( "Afectados" ) 
'	aAfectados(0) = 1,Perú
'	aAfectados(1) = 2,Bolivia
'	aAfectados(3) = 3,Chile| ... etc

	MsgError = ""
	Error    = 0

	Set ConnManejo = Server.CreateObject("ADODB.Connection")
	ConnManejo.Open Session( "DataConn_ConnectionString" )

	For b = 0 to Ubound(aAfectados)-1
		aLinea = Split ( aAfectados(b), ",")
		cSql = "Exec EMP_BorraEmpresa '" & aLinea(0) & "'"
		Set Rs = ConnManejo.Execute ( cSql )
		if Rs("Eliminados") = 0 then
			NoEliminados = NoEliminados + aAfectados(b) + "|"
			MsgError = MsgError + aAfectados(b) + "\n"		
		else
			Eliminados = Eliminados + aAfectados(b) + "|"
		end if
		Rs.Close
	Next


	ConnManejo.Close
   Set ConnManejo = Nothing

%>

<!--
	El siguiente formulario muestra los registros que fueron eliminados y cuales tuvieron
	Problemas.
-->
<body bgcolor="<%=Session("ColorFondo")%>" background="<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000"  v a>
	<form name="Lista_Eliminados" action="Listado_Eliminados.asp" method="post" target="Trabajo">
		<input type=hidden name="Empresa"	value="<%=Codigo%>">
		<input type=hidden name="Empresa"	value="<%=Nombre%>">
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
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Codigo		= Request ( "Codigo_pais" )
	Nombre		= Request ( "Nombre_pais" )	
	Orden		= Request ( "Orden" )	

	Procesada	= Request("Eliminados")
	NoProcesada = Request("NoEliminados")
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<script language="JavaScript">
	function Aceptar()
	{
		parent.top.frames[2].location.href = "Botones_Productos.asp";
		parent.top.frames[1].location.href = 'Inicial_Productos.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>';
	}
</script>

<body background="../../<%=Session("ImagenFondo")%>">
<form name="Listado">
	<table width="95%" cellspacing=0 cellpadding=0 border=1 align=center>
	<%
		if Len(Procesada) > 0 then
			Datos = Split(Procesada, "|") %>
			<tr class="FuenteCabeceraTabla">
				<td colspan=2><B>Nómina de <%=Lcase(Session("Title"))%> eliminados.</B></td>
			</tr>
			<tr class="FuenteCabeceraTabla">    
				<td align=left>&nbsp;<B>Código</B>&nbsp;</td>
				<td align=left>&nbsp;<B>Nombre</B>&nbsp;</td>
			</tr>
	<%		For i=0 to Ubound(Datos) - 1
				aDatosLineas = Split(Datos(i), ",")%>
				<tr class="FuenteInput">
					<td class="FuenteEncabezados" align=left width=15%>&nbsp;<%=aDatosLineas(0)%>&nbsp;</td>
					<td class="FuenteEncabezados" align=left width=65%>&nbsp;<%=aDatosLineas(1)%>&nbsp;</td>
				</tr>
	<%		Next
		end if
	%>
	</table>
	<br><br>
	<table width="95%" cellspacing=0 cellpadding=0 border=1 align=center>
	<%
		if Len(NoProcesada) > 0 then
			NoDatos = Split(NoProcesada, "|") %>
			<tr class="FuenteCabeceraTabla">
				<td colspan=2>Nómina de <%=Lcase(Session("Title"))%> sin poder eliminar.</td>
			</tr>
			<tr class="FuenteCabeceraTabla">    
				<td align=left>&nbsp;Código&nbsp;</td>
				<td align=left>&nbsp;Nombre&nbsp;</td>
			</tr>
	<%		For j=0 to Ubound(NoDatos) - 1
				aNoDatosLineas = Split(NoDatos(j), ",")%>
				<tr class="FuenteInput">
					<td align=left width=15%>&nbsp;<%=aNoDatosLineas(0)%>&nbsp;</td>
					<td align=left width=65%>&nbsp;<%=aNoDatosLineas(1)%>&nbsp;</td>
				</tr>
	<%		Next
		end if%>

	</table>
	<br><br>
	<table width="95%" cellspacing=0 cellpadding=0 border=0 align=center>
		<tr>
			<td align=center><a class="FuenteBotonesLink" OnFocus="JavaScript:Limpia_BarraEstado()" OnMouseMove="JavaScript:Limpia_BarraEstado()" href="JavaScript:Aceptar()">&nbsp;Aceptar&nbsp;</a></td>
		</tr>
	</table>
</form>
</body>

</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
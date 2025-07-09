<!-- #include file="../../Scripts/Inc/Paginacion.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

	cSql = "Exec PLP_Productos_en_una_Lista_de_precios "
	cSql = cSql & "'" & Session("Empresa_usuario") & "', '" & Request("ListaPrecios") & "', "
	cSql = cSql & "'" & Request("SuperFamilia") & "', "
	cSql = cSql & "'" & Request("Familia")      & "', "
	cSql = cSql & "'" & Request("Subfamilia")   & "', "
	cSql = cSql & "'" & Request("Producto")     & "', "
	cSql = cSql & "'" & Request("Descripcion")  & "'"
		
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.EOf then
		Codigo_Catalogo	= Rs("Catalogo")
		Codigo			= Rs("Producto")		
		Descripcion 	= Rs("Descripcion")
		Precio			= Rs("Precio")
		StockReal		= Rs("StockReal")
		StockResto		= Rs("StockMinimo")
		StockTransito	= Rs("StockTransito")		
		StockDisponible	= cDbl("0" & StockReal ) - cDbl("0" & Rs("StockReservado") )
		Fotografia		= Rs("Vista_max_exterior")
		Codigo_Dun14	= Rs("DUN14")
	else
		Codigo_Catalogo	= ""
		Codigo			= ""
		Descripcion 	= ""
		Precio			= ""
		StockReal		= 0
		StockResto		= 0
		StockTransito	= 0
		Fotografia		= ""
		Codigo_Dun14	= ""
	end if
	Rs.Close
	Set Rs = Nothing
	
	Dim filesys, filetxt, getname, path
	Set filesys = Server.CreateObject("Scripting.FileSystemObject")
	path = Server.MapPath("../../../Imagenes/Productos/" & Fotografia)
	If filesys.FileExists(path) = False Then
	   Fotografia = "noimagen.gif"
	End If
%>

<html>

	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Script/Js/Caracteres.js"></script>
	</head>

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
	<form name="Formulario" method="post" action="Paso.asp" target="Paso">
		<table width=100% border=0 cellspacing=1 cellpadding=0 >
			<tr><td colspan=4 align=center class=FuenteTitulosFunciones><%=Descripcion%></td></tr>
			<tr>
				<td colspan=4 align=center class=FuenteInput><img src="/Imagenes/Productos/<%=Fotografia%>" width=210 height=155 border=1></img></td>
			</tr>
			<tr>
				<td width=10% nowrap class=FuenteCabeceraTabla >Cod.</td>
				<td width=10% nowrap class=FuenteInputEtiquetasDatos align=left ><%=Codigo%></td>
				<td width=05% nowrap class=FuenteCabeceraTabla >Cod.Catálogo</td>
				<td width=70% nowrap class=FuenteInputEtiquetasDatos align=left ><%=Codigo_Catalogo%></td>
			</tr>

			<tr>
				<td colspan=4 width=20% nowrap class=FuenteCabeceraTabla >
					<table width=100% border=0 cellspacing=0 cellpadding=0 >
						<tr>
							<td width=20% nowrap class=FuenteCabeceraTabla >Stk.: Real:</td>
							<td width=10% nowrap class=FuenteInputEtiquetasDatos align=right ><%=StockReal%></td>
							<td width=20% nowrap class=FuenteCabeceraTabla >Tráns.:</td>
							<td width=10% nowrap class=FuenteInputEtiquetasDatos align=right ><%=StockTransito%></td>
							<td width=20% nowrap class=FuenteCabeceraTabla >Disp.:</td>
							<td width=10% nowrap class=FuenteInputEtiquetasDatos align=right ><%=StockDisponible%></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td width=20% class=FuenteCabeceraTabla>Precio:</td>
				<td width=20% class=FuenteInputEtiquetasDatos align=right><%=FormatNumber(Precio,0)%></td>
			</tr>
	<%	for a=1 to 0%>
			<tr>
				<td width=40% class=FuenteInputEtiquetas >&nbsp;</td>
				<td width=60% class=FuenteInputEtiquetasDatos align=right >&nbsp;</td>
			</tr>
	<%	next%>
			<tr>
				<td align=center colspan=4 >
					<qinput type=button name="Volver" Value="Volver" Onclick="javascript:fVolver()">
					<a class=FuenteInput href="javascript:fVolver()">Volver</a>
				</td>
			</tr>
		</table>
	</form>


<script language="javascript">
	function fVolver()
	{
		this.history.back();
	}
</script>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

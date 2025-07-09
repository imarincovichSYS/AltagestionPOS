<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title>Ayuda de Vehiculo</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Listado">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>
	
<%
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	GastoInsumo = Request("GastoInsumo")
	Glosa		= Request("Glosa")

	cSql = "Exec ITG_ListaClasificacion_ItemGastos '" & Session("Empresa_Usuario") & "', '" & GastoInsumo & "', '" & Glosa & "',0" & Orden
	
         	
  ' Response.Write cSql
    
	Set Rs = Conn.Execute ( cSql )
	
	If Not Rs.eof then%>
	<table width=100% border=0>
		<tr class="FuenteCabeceraTabla">
			<td class="FuenteInput" align=left width=25%><b>Codigo</b></td>
			<td class="FuenteInput" width=50%><b>Glosa</b></td>
		</tr>
<%		i = 1
		Do While Not Rs.eof %>
			<tr>
				<td class="FuenteInput" width=25% align=left>
					<a name ='Link<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Codigo<%=i%>" ><%=Rs("Item_Gasto")%></DIV></a>
				</td>
				<td class="FuenteInput" width=25%>
					<a Id='dLink<%=i%>' href="JavaScript:ClipBoard( 'Listado', 'Link<%=i%>', '', 'c');window.blur()"><DIV ID="Glosa<%=i%>"><%=Rs("Glosa")%></DIV></a>
				</td>
			</tr>
<%			Rs.MoveNext
			i = i + 1
		Loop%>
	</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay codigo según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
</body>
</html>
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
</head>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Listado" method="post" action="List_OrdenUbicacion.asp" target="Listado">
			<table width=80% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Nº de recepción:</td>
					<td nowrap align=left>
						<input type=text size=7 maxlength=9 Class="FunteInputNumerico" name="NroRecep" value="" >
					</td>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Salida:</td>
					<td nowrap align=left>
						<Select class="FuenteInput" name="Salida" >
							<option value="P">Pantalla</option>
							<option value="I">Impresora</option>
						</Select>
					</td>
				</tr>    
			</table>
		</form>
	</body>
</html>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

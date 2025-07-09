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
	Conn.commandtimeout=3600
	
	SuperFamilia = Request("SuperFamilia")	
	if len(trim(SuperFamilia)) = 0 then SuperFamilia = "Null" Else SuperFamilia = "'" & SuperFamilia & "'"
	
	Familia		 = Request("Familia")
	if len(trim(Familia)) = 0 then Familia = "Null" Else Familia = "'" & Familia & "'"

	SubFamilia	 = Request("SubFamilia")
	if len(trim(SubFamilia)) = 0 then SubFamilia = "Null" Else SubFamilia = "'" & SubFamilia & "'"
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Código</td>
					<td align=left>
						<input class="FuenteInput" type=text name="Codigo" size=5 maxlength=6 value="<%=Request("Descripcion")%>">
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Descripción</td>
					<td align=left>
						<input class="FuenteInput" type=text name="Descripcion" size=7 maxlength=10 value="<%=Request("Descripcion")%>">
						<input type=hidden name="ListaPrecios" value="<%=Request("ListaPrecios")%>">
					</td>
				</tr>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Cod. Catálogo</td>
					<td colspan=2 align=left>
						<input class="FuenteInput" type=text name="Catalogo" size=5 maxlength=12 value="<%=Request("Descripcion")%>">
					</td>
					<td align=right>
						<input type=button class=FuenteInput name="btnBuscar" value="Buscar" OnClick="javascript:fBuscar()">
					</td>
				</tr>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Rubro</td>
					<td colspan=2 align=left>
				     <%	Sql = "Exec SPF_ListaSuperfamilias Null, Null, Null"
	                    SET Rs	=	Conn.Execute( SQL ) %>
						<select Class="FuenteInput" name="SuperFamilia" size="1">
						  <option value="">.: Todas :.</option>
						  <%do while not rs.eof%>
						       <option <% if Request("SuperFamilia") = rs("Superfamilia") Then Response.Write " Selected "%> value='<%=rs("Superfamilia")%>'><%=Rs("Nombre")%></option>
						       <%rs.movenext
						  loop
						  rs.close
						  set rs=nothing%>
						 </select>
					</td>
					<td align=right>
						<input type=button class=FuenteInput name="btnSalir" value=" Salir " OnClick="javascript:fSalir()">
					</td>
				</tr>
			</table>
		</form>
	</body>

	<script language="javascript">
		function fCarga()
		{
			document.Formulario.action = "Criterios.asp";
			document.Formulario.target = "Busqueda";
			document.Formulario.submit();
		}
		
		function fBuscar()
		{
			document.Formulario.action = "Listado.asp";
			document.Formulario.target = "Listado";
			document.Formulario.submit();
		}
		
		function fSalir()
		{
			document.Formulario.action = "../../Menu_Ipaq.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}
	</script>

</html>
<% conn.close() %>
<%else
	Response.Redirect "../../index.htm"
end if%>

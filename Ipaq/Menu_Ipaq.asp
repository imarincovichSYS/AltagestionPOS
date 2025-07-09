<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
	
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString")
	Conn.commandtimeout=3600
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="CSS/Estilos.css">
	</head>
	
	<body>
		<form name="Formulario" action="" method="Post" target=_top>
      <center>
			<table width=100% border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td class=FuenteTitulosFunciones>MODULO iPAQ - SUPERVISORES</td>
				</tr>

				<tr>
					<td><br><hr><br></td>
				</tr>

				<tr>
					<td nowrap>
						<input class=FuenteBotones type=button name="VentasInformados"	       value = "Elimina&nbsp;documentos&nbsp;de&nbsp;ventas"	Onclick="Javascript:fOpcion(1)" style="width:200">
					</td>
				</tr>
		
				<tr>
					<td nowrap>
						<input class=FuenteBotones type=button name="IngresoDocumentosNulos"	value = "Ingreso&nbsp;folio&nbsp;documentos&nbsp;nulos"	Onclick="Javascript:fOpcion(3)" style="width:200">
					</td>
				</tr>
		
				<tr>
					<td nowrap>
						<input class=FuenteBotones type=button name="DescuentoSupervisor"	    value = "Descuento Supervisor"	Onclick="Javascript:fOpcion(2)" style="width:200">
					</td>
				</tr>

				<tr>
					<td><br><br><hr><br></td>
				</tr>

				<tr>
					<td>
						<input type=button name="Salir"	value = "Cerrar Sessión"				Onclick="Javascript:fOpcion(9)">
					</td>
				</tr>

			</table>
      </center>
		</form>
	</body>
	
	<script language="javascript">
		function fOpcion(id)
		{
			if ( id == 1 ) 
			{
				document.Formulario.action = "Transacciones/VtasInformadas/Main_VtaInf.asp"
			}
			if ( id == 2 ) 
			{
				document.Formulario.action = "Transacciones/DescuentoSupervisor/Main_DescuentoSupervisor.asp"
			}
			if ( id == 3 ) 
			{
				document.Formulario.action = "Transacciones/DocumentosVtaNulos/Find_DocVtaNul.asp"
			}
			else if ( id == 9 ) 
			{
				document.Formulario.action = "InicioSession.asp"
			}
			document.Formulario.submit();
		}
	</script>
	
</html>

<%else
	Response.Redirect "index.htm"
end if%>

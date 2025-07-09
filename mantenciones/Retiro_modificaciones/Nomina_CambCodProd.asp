<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	
	JavaScript = "JavaScript:"

'    Nomina=request("Nomina")

'Const adUseClient = 3
'i=0

'Dim conn1

 ''  Sql = "Exec DOV_NominaDocumentos " &+_
 ''         "'"  & Nomina & "','@'" 
          
'Response.Write (sql)

'		conn1 = Session("DataConn_ConnectionString")
				
'		Set rs = Server.CreateObject("ADODB.Recordset")
		
'		rs.PageSize = Session("PageSize")
'		rs.CacheSize = 3
'		rs.CursorLocation = adUseClient

'		rs.Open sql , conn1, , , adCmdText 'mejor
		
'		ResultadoRegistros=rs.RecordCount
	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<form name="Listado" ACTION="Save_CambCodProd.asp">

				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr class="FuenteCabeceraTabla">
						<td  align=center colspan=6 >Doumentos cancelados</td>
					</tr>
					<tr class="FuenteCabeceraTabla">
						<td  nowrap  width= 35% >Cliente</td>
						<td  nowrap width= 10%  >Documento</td>
						<td  nowrap width= 10%  align=right NOWRAP >Número</td>
						<td  nowrap width= 10%  align=center NOWRAP >Emisión</td>
						<td  nowrap width= 10% align=Right  NOWRAP >Monto total</td>
						<td  nowrap width= 10% align=Right  NOWRAP >Monto cobrado</td>
					</tr>
			<%		i=0
					hay="n"
					do while Not rs.EOF%>
							<tr class="FuenteInput">
								<td nowrap ><%=rs("Nombre_cliente")%></td>
								<td nowrap align=center> <%=rs("Documento_valorizado")%></ td>
								<td nowrap align=right> <%=rs("Numero_documento_valorizado")%></td>
								<td nowrap align=center><%=mid(rs("Fecha_emision"),1,10)%></td>
								<td nowrap align=right> <%=formatnumber(rs("Monto_total_moneda_oficial"),0)%></td>
								<td nowrap align=right> <%=formatnumber(rs("Monto_cobrado_o_pagado_moneda_oficial"),0)%></td>
							</tr>
						<%	rs.MoveNext
						hay="s"
						i=i+1
					loop%>
				</table>
						
<%		rs.Close
		Set rs = Nothing
%>
</form>
</body>

<script language=javascript>
//		parent.top.frames[2].location.href = "Botones_CambCodProd.asp?nomina=S";
</script>

<%else
	Response.Redirect "../../index.htm"
end if%>

</html>

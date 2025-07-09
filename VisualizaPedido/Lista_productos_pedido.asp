<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
  Responsable = session("login")
	Cache
	FilaInsertada =0
%>
<html>
	<head>
		<title><%=Session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
		<script src="../../Scripts/Js/Fechas.js"></script>
		<script src="../../Scripts/Js/Ventanas.js"></script>
	</head>

<%
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	

%>
<body "  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			
			<tr class="FuenteEncabezados"> 
				<td width=100% class="FuenteTitulosFunciones" align=center><b><%=Session("title") & " " & "-" & "-" & " " & Now()%></td>
			</tr>
		</table>

			<Form name="Frm_Mantencion" method="post" action="Save_Despachos.asp" target="Trabajo">
	
	<table width=100% align=center><hr></table>
	
			<Table Name="ListaDetalles" Id="ListaDetalles" width=90% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteInput"> 
					<!--<td class="FuenteTitulosFunciones" width=2% valign=top align=center><b><font size=2>Nº</font></b></td>-->
					<td  width=1 align=left><b><font size=1>Prov</font></b></td>
					<td class="" align=left  ><b><font size=1>Producto</font></b></td>
					<td class="" align=left  ><b><font size=1>Descripcion</font></b></td>
					<td class="" align=right  ><b><font size=1>GPre</font></b></td>
					<td class="" align=right  ><b><font size=1>Temp.</font></b></td>
					<td class="" align=right  ><b><font size=1>CC</font></b></td>
					<td class="" align=right  ><b><font size=1>Bm7</font></b></td>
					<td class="" align=right  ><b><font size=1>Sm7</font></b></td>
					<td class="" align=right  ><b><font size=1>Pvta</font></b></td>
					<td class="" align=right  ><b><font size=1>StkMin</font></b></td>
					<td class="" align=right  ><b><font size=1>Pedido</font></b></td>
					<td class="" width=2% align=right  ><b><font size=1>Días</font></b></td>
					</tr> 
					<%
			FilaInsertada = 1
			Sql_D = "Exec MOP_pedido '" & Session("Login") & "'"
'Response.Write Sql_D
			SET RsDetalle	=	Conn.Execute( Sql_D )			
			Do While Not RsDetalle.eof  %>
				<tr class="FuenteInput"> 
					<!--<td class="FuenteEncabezados" width=2% valign=top align=center><font size=1><%=FilaInsertada%></font></td>-->
					<td class="" valign=top align=left  ><font size=1><%=RsDetalle("Prov")%></font></td>
					<td class="" valign=top align=left  ><font size=1><%=RsDetalle("Producto")%></font></td>
					<td class="" valign=top align=left  ><font size=1><%=RsDetalle("Descripcion")%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("GPre"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=(RsDetalle("temporada"))%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("CC"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("Bm7"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("Sm7"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("PVta"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("StkMin"),0)%></font></td>
					<td class="" valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("Pedido"),0)%></font></td>
					<%if((RsDetalle("counter") - 1)) < 0 then %>
              <td class="" width=2% valign=top align=right  ><font size=1><%=formatnumber(RsDetalle("counter"),0)%></font></td>
          <%else %>
              <td class="" width=2% valign=top align=right  ><font size=1><%=(RsDetalle("counter") -1)%></font></td></td>
          <% end if %>
				</tr>
	<%			RsDetalle.MoveNext
				FilaInsertada = FilaInsertada + 1
			Loop 'Do While Not RsDetalle.eof
			RsDetalle.Close 
			Set RsDetalle = Nothing
	%>			
			</Table>
			
		</Form>

		<script language="javascript">
			this.window.focus();
		</script>
   </body>
<%Conn.Close
Else
	Response.Redirect "../../index.htm"
End if%>
	<IFRAME Id="Paso" name="Paso" FRAMEBORDER=0 SCROLLING=NO SRC="../../Empty.asp" HEIGHT=0 width=100%></IFRAME>
</html>

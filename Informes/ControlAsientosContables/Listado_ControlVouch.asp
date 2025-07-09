<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
			SET Conn = Server.CreateObject("ADODB.Connection")
			Conn.Open Session("Dataconn_ConnectionString")
			Conn.commandtimeout=3600


desde  = year(request("fecha_desde")) & "/" & month(request("fecha_desde")) & "/" & day(request("fecha_desde"))
hasta  = year(request("fecha_hasta")) & "/" & month(request("fecha_hasta")) & "/" & day(request("fecha_hasta"))
				
  Sql = "Exec ACO_Control_Asientos_Contables_Emitidos " +_
          "'"  & session("empresa_usuario") & "','" & desde & "', " +_
          "'"  & hasta & "'"

'Response.Write(sql)
         set Rs = conn.Execute(sql)
%>
<html>
	<head>
		<title>AltaGestion</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
	<Form name="Formulario">
	<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
		<tr class=fuenteinput>
			<td width=30%>&nbsp;</td>
			<td width=50% class="FuenteTitulosFunciones" aalign=center>&nbsp;&nbsp;&nbsp;<a href="javascript:window.print()"><%=Session("title")%></a></td>
			<td nowrap width=10% class="FuenteInput" aalign=center>&nbsp;&nbsp;&nbsp;<%=now()%></td>
		</tr>
	</table>
	<hr>
	<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
		<tr valign=top class="FuenteBalance">
		<%row=1
		col=1
		j=1
		Ncol=0
		do while not rs.eof
			linea=split(rs("datos"),"|")
			for i = 0 to ubound(linea)-1
				salto=false
				if j=100 then
					j=1
					col=1
					%>
				<%end if
				if col=1 then
					col=0
					Ncol = CDBL(Ncol) +1
					if cdbl(Ncol) = 7 then
						salto=true
						'col=1
						Ncol=0%>
						
						</tr>
						<tr valign=top class="FuenteBalance">
					<%end if
					%>
					<td  <%if salto then Response.write("class=saltopagina") else Response.write("class=FuenteBalance") end if%> nowrap width=10%>
						<table width=20% aalign=center border=0 cellspacing=0 cellpadding=0 >
						<tr class=FuenteEncabezadosListado> 
							<td width=10% nowrap valign=top class="Fuentebalance" >Número</td>
							<td width=10% nowrap align=center class="Fuentebalance" >Fecha</td>
						</tr>
				<%end if
				datos = split(linea(i),"@")
				Numero=datos(0)
				Fecha= datos(1)
				Estado=datos(2)
			%>
				<tr class="FuenteBalance"> 
					<td nowrap  aclass="Fuenteinput" ><%=Numero%>&nbsp;</td>
					<td nowrap  aclass="Fuenteinput" ><%=Fecha%>&nbsp;</td>
				</tr>					 
		<%
				j=j+1
				if j = 100 then
					'col=1
					'ncol=0%>
					</table>					 
					</td>
				<%end if
			Next
		rs.movenext
		loop%>
	</tr>
	</table>					 
		
	</Form>
	</body>
<script language=javascript>
</script>
</html>
<%
conn.Close()
else
	Response.Redirect "../../index.htm"
end if%>
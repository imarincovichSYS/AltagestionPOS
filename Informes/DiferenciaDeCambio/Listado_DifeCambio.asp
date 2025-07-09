<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
			SET Conn = Server.CreateObject("ADODB.Connection")
			Conn.Open Session("Dataconn_ConnectionString")
			Conn.commandtimeout=3600

periodo = request("Anno") & request("mes")

				
   Sql = "Exec ACC_Informe_diferencia_de_cambio " +_
		 "'"  & periodo & "'," +_
         "'"  & session("empresa_usuario") & "'," +_
         "'"  & request("Cuenta") & "'," +_
         "'"  & request("centro_de_venta") & "'," +_
         "'"  & request("moneda") & "'," +_
				request("tipo_cambio")

'Response.Write(sql)
	on error resume next
	         set Rs = conn.Execute(sql)
	         error = err.Description
	if conn.Errors.count = 0 then
	%>
	<html>
		<head>
			<title>AltaGestion</title>
			<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
			<script src="../../Scripts/Js/Caracteres.js"></script>
		</head>
	<body aonload="window.print()" bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000">
		<Form name="Formulario">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class=fuenteinput>
				<td class="FuenteInput" width=30%>&nbsp;<%=Ucase(Session("Empresa_usuario"))%></td>
				<td width=50% class="FuenteTitulosFunciones" aalign=center>&nbsp;&nbsp;&nbsp;Informe diferencia de cambio</td>
				<td nowrap width=10% class="FuenteInput" aalign=center>&nbsp;&nbsp;&nbsp;<%=now()%></td>
			</tr>
		</table>
		<br>
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class=fuenteinput>
				<td class="FuenteEncabezados" width=10%>&nbsp;Período</td>
				<td class="FuenteInput" width=20%><%=request("mes") & "/" & request("anno")%></td>
				<td class="FuenteEncabezados" width=5%>Cuenta</td>
				<td class="FuenteInput" width=10%><%=request("Cuenta")%></td>
				<td class="FuenteEncabezados" width=5%>T.C.</td>
				<td class="FuenteInput" width=10%><%=request("Moneda")%>&nbsp;<%=request("Tipo_cambio")%></td>
				<td class="FuenteEncabezados" width=5%>Ccosto</td>
				<td class="FuenteInput" width=10%><%=request("centro_de_venta")%></td>
			</tr>
		</table>
		<hr>
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class="FuenteEncabezadosListado"> 
				<td width=10% class="FuenteEncabezados" >&nbsp;Fecha</td>
				<td width=10% class="FuenteEncabezados" >&nbsp;Comprobante</td>
				<td width=10% class="FuenteEncabezados" >&nbsp;Documento</td>
				<td width=10% class="FuenteEncabezados" >&nbsp;Vencimiento</td>
				<td width=10% align=right class="FuenteEncabezados" >Débitos&nbsp;</td>
				<td width=10% align=right class="FuenteEncabezados" >Créditos&nbsp;</td>
				<td width=10% align=right class="FuenteEncabezados" >Saldo&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td width=10% class="FuenteEncabezados" >&nbsp;Glosa&nbsp;&nbsp;</td>
				<td width=05% class="FuenteEncabezados" >&nbsp;Mn&nbsp;&nbsp;</td>
				<td width=05% align=right class="FuenteEncabezados" >&nbsp;T/C&nbsp;</td>
				<td width=20% align=right class="FuenteEncabezados" >&nbsp;Diferencia&nbsp;</td>
			</tr>
			<tr class="Fuenteinput"> 
				<td colspan=13 class="Fuenteinput" ><hr></td>
			</tr>
			
			<%Analisis = ""
			TotDebitos    = 0
			TotCreditos   =	0
			TotSaldo	  =	0
			TotDiferencia =	0
			SumDebitos    = 0
			SumCreditos   =	0
			SumSaldo	  =	0
			SumDiferencia =	0
			do while not rs.eof
				TotDebitos    = cdbl(TotDebitos)    + cdbl(rs("Debitos"))
				TotCreditos   = cdbl(TotCreditos)   + cdbl(rs("Creditos"))
				TotSaldo	  = cdbl(TotSaldo)	    + cdbl(rs("Saldo"))
				TotDiferencia = cdbl(TotDiferencia) + cdbl(rs("Diferencia"))
				if trim(Analisis) <> trim(rs("analisis")) then
					if trim(Analisis) <> trim(rs("Analisis")) and trim(Analisis) <> "" then%>
						<tr class="Fuenteinput"> 
							<td colspan=11 ><hr></td>
						</tr>
						<tr class="Fuenteinput"> 
							<td colspan=2 >&nbsp;Total análisis</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
							<td nowrap align=right ><%=formatnumber(SumDebitos,0)%>&nbsp;</td>
							<td nowrap align=right ><%=formatnumber(SumCreditos,0)%>&nbsp;</td>
							<td nowrap align=right ><%=formatnumber(SumSaldo,0)%>&nbsp;</td>
							<td nowrap >&nbsp;</td>
							<td nowrap >&nbsp;</td>
							<td nowrap >&nbsp;</td>
							<td nowrap align=right ><%=formatnumber(SumDiferencia,0)%>&nbsp;</td>
						</tr>					 
						<tr class="Fuenteinput"> 
							<td colspan=11 ><hr></td>
						</tr>
						<%SumDebitos    = 0
						SumCreditos   =	0
						SumSaldo	  =	0
						SumDiferencia =	0
						'Analisis = rs("analisis")
					end if
					Analisis = rs("analisis")			  %>
					<tr class="Fuenteinput"> 
						<td nowrap colspan=6 width=10%>&nbsp;<%=rs("Analisis")%>&nbsp;</td>
					</tr>					 
				<%
				end if
				SumDebitos    = cdbl(SumDebitos)    + cdbl(rs("Debitos"))
				SumCreditos   = cdbl(SumCreditos)   + cdbl(rs("Creditos"))
				SumSaldo	  = cdbl(SumSaldo)      + cdbl(rs("Saldo"))
				SumDiferencia = cdbl(SumDiferencia) + cdbl(rs("Diferencia"))
				%>
			<tr class="Fuenteinput"> 
				<td nowrap >&nbsp;<%=rs("fecha")%>&nbsp;</td>
				<td nowrap ><%=rs("Comprobante")%>&nbsp;</td>
				<td nowrap ><%=rs("Documento")%>&nbsp;</td>
				<td nowrap ><%=rs("FecVen")%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(rs("Debitos"),0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(rs("Creditos"),0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(rs("Saldo"),0)%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td nowrap ><%=rs("Glosa")%>&nbsp;&nbsp;</td>
				<td nowrap ><%=rs("Moneda")%>&nbsp;&nbsp;</td>
				<td nowrap align=right ><%=rs("TipCam")%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(rs("Diferencia"),0)%>&nbsp;</td>
			</tr>					 
					<%
					rs.movenext
			loop
			%>
			<tr class="Fuenteinput"> 
				<td colspan=11 ><hr></td>
			</tr>
			<tr class="Fuenteinput"> 
				<td colspan=2 >&nbsp;Total análisis</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(SumDebitos,0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(SumCreditos,0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(SumSaldo,0)%>&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(SumDiferencia,0)%>&nbsp;</td>
			</tr>					 
			<tr class="Fuenteinput"> 
				<td colspan=13 class="Fuenteinput" ><hr></td>
			</tr>
			<tr class="Fuenteinput"> 
				<td colspan=2 >&nbsp;TOTAL CUENTA</td>
				<td nowrap >&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(TotDebitos,0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(TotCreditos,0)%>&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(TotSaldo,0)%>&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap >&nbsp;</td>
				<td nowrap align=right ><%=formatnumber(TotDiferencia,0)%>&nbsp;</td>
			</tr>					 
			<tr class="Fuenteinput"> 
				<td colspan=13 class="Fuenteinput" ><hr></td>
			</tr>
		</table>					 
	<br>
	<br>
	<br>
		<table width=90% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class="FuenteInput"> 
				<td    class="FuenteInput" >&nbsp;</td>
			</tr>
			<tr class="FuenteInput"> 
				<td align=center  nowrap  class="FuenteInput" >________________</td>
			</tr>
			<tr class="FuenteInput"> 
				<td  align=center class="FuenteInput" >VºBº</td>
			</tr>
		</table>
	<br>
	<br>
	<br>
		<table width=90% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class="FuenteInput"> 
				<td align=center  nowrap  class="FuenteInput" ><a href="javascript:window.print()"> Imprimir</a></td>
				<td    class="FuenteInput" >&nbsp;</td>
				<td align=center  nowrap  class="FuenteInput" ><a href="javascript:window.close()"> Cerrar</a></td>
			</tr>
		</table>
		</Form>
		</body>
	</html>
	<%
	Else%>
		<script language=javascript>
			window.close();
			//parent.top.frames[1][1].location.href ="../../Empty.asp";
			window.opener.parent.top.frames[3].location.href="../../Mensajes.asp?msg=<%=mid(error,48)%>";
		</script>
	<%end if	
	conn.Close()
else
	Response.Redirect "../../index.htm"
end if%>
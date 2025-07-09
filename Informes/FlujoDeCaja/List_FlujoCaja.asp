<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	PanelDeControl = Request("PanelDeControl")

	Const adUseClient = 3

	function Repetir(q, valor)
		Dim t
		Dim cCad
		t=0
		cCad = ""
		for t=0 to q
			cCad = cCad + valor
		next
		Repetir = cCad
	end function

	function fFormatea(valor, a, b, Columnas)
		Dim cCad
		cCad = ""
		
		if b=0 then alinear = "class=FuenteInput align=Left"
		if b>0 then alinear = "class=FuenteInput align=right"
		if a=0 and b=0 then alinear = "class=FuenteCabeceraTabla align=Left"
		if a=0 and b>0 then alinear = "class=FuenteCabeceraTabla align=center"
		
		if (a=7 Or a=12 Or a=13) And b>0 then
			alinear = "class=FuenteEncabezados align=right"
		end if

		if a=03 then Documento = "FAV"
		if a=04 then Documento = "FAE"
		if a=05 then Documento = "CHI"
		if a=06 then Documento = "OTI"
		if a=09 then Documento = "FAC"
		if a=10 then Documento = "UFC"
		if a=11 then Documento = "OTE"

		if a=1 Or a=13 then
			color = " bgcolor='#c2d1b7' "
		else
			color = ""
		end if		
		if b=1 then 'centro de venta
			if a=3 Or a=4 Or a=5 Or a=6 Or a=9 Or a=10 Or a=11 then 'Saldo inicial-Total Ingresos-Total egresos-Saldo final
				cCad = "<td nowrap width=10% align=Left" & Color & cColsp & " " & alinear & "><b>" & CentroVenta & "&nbsp;</b></td>"
			else
				cCad = "<td nowrap width=10% align=Left" & Color & cColsp & " " & alinear & "><b>" & valor & "&nbsp;</b></td>"
			end if
		else
			if a>0 and b>0 then		
				if a=1 Or a=7 Or a=12 Or a=13 then 'Saldo inicial-Total Ingresos-Total egresos-Saldo final
					cCad = "<td nowrap " & Color & cColsp & " " & alinear & ">" & FormatNumber(valor,0) & "</td>"
				else
					cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fWndDet(" & chr(34) & Trim(Documento) & chr(34) & "," & chr(34) & Trim(MtxPrincipal(0,b)) & chr(34) & ")'>" & FormatNumber(valor,0) & "</a></td>"
				end if
			else
				if Instr(1,valor, "por cobrar") > 0 Or Instr(1,valor, "Otros ingresos") > 0 Or _
				   Instr(1,valor, "por pagar") > 0 Or Instr(1,valor, "Otros egresos") > 0 then
					cCad = "<td nowrap " & Color & cColsp & " " & alinear & ">" & Repetir(5,"&nbsp;") & valor & "</td>"
				else
					cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><b>" & valor & "</b></td>"
				end if
			end if
		end if
				
		fFormatea = cCad
	end function

Dim conn1
	if len(trim(request("Fecha_Desde"))) > 0 then
		Desde					= year(request("Fecha_Desde")) & "/" & month(request("Fecha_Desde")) & "/" & Day(request("Fecha_Desde"))
	else
		Desde=""
	end if
	if len(trim(request("Fecha_hasta"))) > 0 then
	    Hasta					= year(request("Fecha_hasta")) & "/" & month(request("Fecha_hasta")) & "/" & Day(request("Fecha_hasta"))
	else
	    Hasta					= ""
	end if

	Periodo = Request("Periodo")

	Centro_venta = Request("Centro_de_venta")
	if len(trim(Centro_venta)) = 0 then Centro_venta = "Null" Else Centro_venta = "'" & Centro_venta & "'"

	if Request("DetallePorCtoVta") = "on" then
		DetallePorCtoVta = "S"
	else
		DetallePorCtoVta = "N"
	end if

	SET Connec = Server.CreateObject("ADODB.Connection")
	Connec.Open Session("Dataconn_ConnectionString")
	Connec.commandtimeout = 3600

	cSql = "Exec DOV_Saldo_inicial_contable_flujo_caja '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "'"
	Set Rs = Connec.Execute ( cSql )
		if Not Rs.EOF then
			SaldoInicial = cDbl("0" & Rs("Saldo_contable") )
		else
			SaldoInicial = 0
		end if
	Rs.Close 
	Set Rs = Nothing

	cSql = "Exec DOV_Saldo_inicial_cheques_flujo_caja '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "'"
	Set Rs = Connec.Execute ( cSql )
		if Not Rs.EOF then
			ChequesEgresados = cDbl("0" & Rs("Saldo_cheques") )
		else
			ChequesEgresados = 0
		end if
	Rs.Close 
	Set Rs = Nothing

	mtx_SaldoInicial = SaldoInicial + ChequesEgresados
	Connec.Close

%>
<html>
<head>
	<title>Fujo de Caja</title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<%	If Session("Browser") = 1 Then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	Else%>
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
<%	End If%>
<%	if PanelDeControl <> "S" Then %>
		<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<%	else%>
		<body>
<%	end if%>
<form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
	<input type=hidden name="FechaInicial"	value="<%=Request("Fecha_Desde")%>">
	<input type=hidden name="CentroVenta"	value="<%=Request("Centro_de_venta")%>">
	<input type=hidden name="Periodo"		value="<%=Request("Periodo")%>">
<%	if PanelDeControl = "S" Then %>
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 ID="Table1">
			<tr height=50 valign=top>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:this.window.close()">FLUJO DE CAJA</a></td> 
			</tr>
		</table>
<%	end if%>

<%	Sql = "Exec DOV_Flujo_de_caja "			& +_
          "'"  & Desde						& "',"	& +_
          "'"  & Hasta						& "',"	& +_
          ""   & Centro_venta				& ", "	& +_
          "'"  & Periodo					& "',"	& +_
          "'"  & Session("Empresa_usuario")	& "'"

'Response.Write Sql

		conn1 = Session("DataConn_ConnectionString")
		Set rs = Server.CreateObject("ADODB.Recordset")
	
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open sql , conn1, , , adCmdText 'mejor

	If Not Rs.EOF Then 
		Filas = 15
		Columnas = Rs.RecordCount+2
		rs.PageSize = Rs.RecordCount
		Redim MtxPrincipal(Filas, Columnas)
		Rs.MoveFirst 
		Dim x, y
		y=2
		MtxPrincipal(0,0) 	= "Concepto"
		MtxPrincipal(1,0) 	= "Saldo Inicial"
		MtxPrincipal(2,0) 	= "Ingresos"
		MtxPrincipal(3,0) 	= "Facturas nacionales por cobrar"
		MtxPrincipal(4,0) 	= "Facturas exportación por cobrar"
		MtxPrincipal(5,0) 	= "Cheques por cobrar"
		MtxPrincipal(6,0) 	= "Otros ingresos"
		MtxPrincipal(7,0) 	= "Total ingresos"
		MtxPrincipal(8,0) 	= "Egresos"
		MtxPrincipal(9,0) 	= "Facturas nacionales por pagar"
		MtxPrincipal(10,0) 	= "Facturas importación por pagar"
		MtxPrincipal(11,0)	= "Otros egresos"
		MtxPrincipal(12,0)	= "Total egresos"
		MtxPrincipal(13,0)	= "Saldo Final"

		MtxPrincipal(0,1)	= "Ctro vta-cto"

		Do While Not Rs.EOF 
			MtxPrincipal(0,y) 	= Rs("Periodo")

			MtxPrincipal(1,y) 	= Cdbl(mtx_SaldoInicial)
			CentroVenta 		= Rs("Centro_de_Venta")

			MtxPrincipal(3,y) 	= Cdbl(Rs("Por_cobrar_FAV"))
			MtxPrincipal(4,y) 	= Cdbl(Rs("Por_cobrar_FAE"))
			MtxPrincipal(5,y) 	= Cdbl(Rs("Por_cobrar_CHI"))
			MtxPrincipal(6,y) 	= Cdbl(Rs("Por_cobrar_otros"))

			MtxPrincipal(7,y) 	= Cdbl("0" & MtxPrincipal(7,y)) + ( ( MtxPrincipal(3,y) + MtxPrincipal(4,y) + MtxPrincipal(5,y) + MtxPrincipal(6,y) ) )

			MtxPrincipal(9,y) 	= Cdbl(Rs("Por_pagar_FAC"))
			MtxPrincipal(10,y) 	= Cdbl(Rs("Por_pagar_UFC"))
			MtxPrincipal(11,y)	= Cdbl(Rs("Por_pagar_otros"))

			MtxPrincipal(12,y) 	= Cdbl("0" & MtxPrincipal(12,y)) + ( ( MtxPrincipal(9,y) + MtxPrincipal(10,y) + MtxPrincipal(11,y) ) )

			MtxPrincipal(13,y)	= ( MtxPrincipal(7,y) + mtx_SaldoInicial ) - MtxPrincipal(12,y)
			mtx_SaldoInicial	= MtxPrincipal(13,y)
			Rs.MoveNext 
			y = y + 1						
		Loop

'for a=0 to Filas-1
'	for b=0 to Columnas-1
'		Response.Write MtxPrincipal(a,b) & " ** " 
'	Next
'	Response.Write "////" 
'	Response.Write "<br>" 
'Next
%>
			<table width="99%" border=1 align=center cellpadding=2 cellspacing=0>
			<%	For a=0 To Filas-1
					Response.Write "<tr>"
					valor = MtxPrincipal(a,0)
					if (Instr(1, "INGRESOS", Ucase(Trim(valor)) ) > 0) Or _
					   (Instr(1, "EGRESOS", Ucase(Trim(valor)) ) > 0)  THEN
						Response.Write "<td class=FuenteInput colspan=" & Columnas & " align=left ><B>" & MtxPrincipal(a,0) & "</B></td>"
					else					
						For b=0 to Columnas-1
							Response.Write fFormatea(MtxPrincipal(a,b),a,b, Columnas)
						Next
					end if
					Response.Write "<tr>"
				Next
			%>
			</table>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
				</tr>
			</table>
		<%End If
						
		rs.Close
		Set rs = Nothing
%>
	<script language="JavaScript">
	<%	if PanelDeControl <> "S" Then %>
			eval("parent.top.frames[1][0].document.all('lblSaldoInicialContable').className = 'FuenteEncabezados'")
			eval("parent.top.frames[1][0].document.all('SaldoInicialContable').innerHTML = '<%=Replace(FormatNumber(SaldoInicial,0),",",".")%>'")

			eval("parent.top.frames[1][0].document.all('lblChequesEgresados').className = 'FuenteEncabezados'")
			eval("parent.top.frames[1][0].document.all('ChequesEgresados').innerHTML = '<%=Replace(FormatNumber(ChequesEgresados,0),",",".")%>'")
	<%	end if%>

		function fWndDet(Documento, Periodo)
		{
			var qry = "?Documento=" + Documento;
			var qry = qry + "&Periodo=" + Periodo;
	<%	if PanelDeControl <> "S" Then %>
			var qry = qry + "&Agrupacion=" + parent.top.frames[1][0].document.Listado.Periodo.value;
			var qry = qry + "&Centro_de_Venta=" + parent.top.frames[1][0].document.Listado.Centro_de_venta.value;
	<%	else%>
			var qry = qry + "&Agrupacion=S";
	<%	end if %>
			var winURL		 = "Detalle_FlujoCaja.asp" + qry;
			var winName		 = "Wnd_Detalle";
			var winFeatures  = "status=no," ; 
				winFeatures += "resizable=no," ;
				winFeatures += "toolbar=no," ;
				winFeatures += "location=no," ;
				winFeatures += "scrollbars=yes," ;
				winFeatures += "menubar=0," ;
				winFeatures += "width=650," ;
				winFeatures += "height=300," ;
				winFeatures += "top=30," ;
				winFeatures += "left=50" ;
				var wnd = window.open(winURL , winName , winFeatures , 'mainwindow')
		}
		
	</script>

</form>
</body>
</html>
<%Else
	Response.Redirect "../../index.htm"
end if%>
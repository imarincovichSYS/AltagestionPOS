<!-- #include file="../../Scripts/Asp/Conecciones.Asp" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"
	
On Error Resume Next

    Error = "N"
    MsgError = ""

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

	function fFormatea(valor, valorUS, a, b, Columnas, xPeriodo)
		Dim cCad, finLinea
		cCad = ""
		finLinea = chr(13) & chr(10)
		
		if b=0 then alinear = "class=FuenteInput align=Left"
		if b>0 then alinear = "class=FuenteInput align=right"
		if a=0 and b=0 then alinear = "class=FuenteCabeceraTabla align=Left"
		if a=0 and b>0 then alinear = "class=FuenteCabeceraTabla align=center"
		
		if (a=1 Or a=2 Or a=11 Or a=17 Or a=16 Or a=18 Or a=19) And b>0 then
			alinear = "class=FuenteEncabezados align=right"
		end if

		if a=04 then Documento = "FAV"
		if a=05 then Documento = "FAE"
		if a=06 then Documento = "CHI"
		if a=07 then Documento = "UCI"
		if a=08 then Documento = "OTI$"
		if a=09 then Documento = "OTIUS$"
		if a=13 then Documento = "FAC"
		if a=14 then Documento = "UFC"
		if a=15 then Documento = "OTE$"
		if a=16 then Documento = "OTEUS$"
         
		if a=1 Or a=2 Or a=19 Or a=20 then
			color = " bgcolor='#c2d1b7' "
		else
			color = ""
		end if
		if b=1 then 'centro de venta
			if a=1 Or a=2 Or a=4 Or a=5 Or a=6 Or a=7 Or a=8 Or a=9  Or a=10 Or a=13 Or a=14 Or a=15 Or a=16 Or a=17 then 'Saldo inicial-Total Ingresos-Total egresos-Saldo final
				cCad = "<td nowrap width=10% align=Left" & Color & cColsp & " " & alinear & "><b>" & CentroVenta & "&nbsp;</b></td>" & finLinea
			else
				cCad = "<td nowrap width=10% align=Left" & Color & cColsp & " " & alinear & "><b>" & valor & "&nbsp;</b></td>" & finLinea
			end if
		else
			if a>0 and b>0 then
'Response.Write a & " -- " & b & " = " & valor & chr(13)		
				if a=1 Or a=2 Or a=10 Or a=11 Or a=17 Or a=18 Or a=19 Or a=20 or b=2 then 'Saldo inicial-Total Ingresos-Total egresos-Saldo final
				    if IsNumeric(Valor) then
                        if xPeriodo = "D" And ( a=10 and b>2 ) then
                            cCad = "<td valing=top nowrap " & Color & cColsp & " " & alinear & "><input type=text class=FunteInputNumerico name='txtIngresoPresupuestado_" & a & "_" & b & "' value='" & valor & "' size=6 maxlength=9 onChange='javascript:fCalculaIngresoPresupuestado(" & a & "," & b & ")'><input type=hidden name='bakIngresoPresupuestado_" & a & "_" & b & "' value='" & valor & "'><input type=checkbox checked class=FuenteInput name='Check_" & a & "_" & b & "' onClick='Javascript:fIncluye(" & a & ", " & b & ")'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=1 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><span id='spanSaldoInicial_" & a & "_" & b & "' name='spanSaldoInicial_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(valor,0) & "</span><input type=hidden name='hSaldoInicial_" & a & "_" & b & "' value='" & valor & "'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=2 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><span id='spanSaldoInicialUS_" & a & "_" & b & "' name='spanSaldoInicialUS_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(valorUS,0) & "</span><input type=hidden name='hSaldoInicialUS_" & a & "_" & b & "' value='" & valorUS & "'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=17 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><input type=text class=FunteInputNumerico name='txtEgresoPresupuestado_" & a & "_" & b & "' value='" & valor & "' size=6 maxlength=9 onChange='javascript:fCalculaEgresoPresupuestado(" & a & "," & b & ")'><input type=hidden name='bakEgresoPresupuestado_" & a & "_" & b & "' value='" & valor & "'><input type=checkbox checked class=FuenteInput name='Check_" & a & "_" & b & "' onClick='Javascript:fIncluye(" & a & ", " & b & ")'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=11 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><span id='spanTotalIngresos_" & a & "_" & b & "' name='spanTotalIngresos_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(valor,0) & "</span>"
                            cCad = cCad & "<input type=hidden name='hTotalIngresos_" & a & "_" & b & "' value='" & valor & "'></td>" & finLinea
                            cCad = cCad & "<input type=hidden name='hTotalIngresosUS_" & a & "_" & b & "' value='" & valorUS & "'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=18 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><span id='spanTotalEgresos_" & a & "_" & b & "' name='spanTotalEgresos_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(cDbl(valor)+cDbl(valorUS),0) & "</span>"
                            cCad = cCad & "<input type=hidden name='nTotalEgresos_" & a & "_" & b & "' value='" & cDbl(valor) + cDbl(valorUS) & "'>"
                            cCad = cCad & "<input type=hidden name='hTotalEgresos_" & a & "_" & b & "' value='" & valor & "'>"
                            cCad = cCad & "<input type=hidden name='hTotalEgresosUS_" & a & "_" & b & "' value='" & valorUS & "'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=19 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><b><span id='spanSaldoFinal_" & a & "_" & b & "' name='spanSaldoFinal_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(valor,0) & "</span></b><input type=hidden name='hSaldoFinal_" & a & "_" & b & "' value='" & valor & "'></td>" & finLinea
                        elseif xPeriodo = "D" And ( a=20 and b>2 ) then
                            cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><b><span id='spanSaldoFinalUS_" & a & "_" & b & "' name='spanSaldoFinalUS_" & a & "_" & b & "' class=FunteInputNumerico >&nbsp;" & FormatNumber(valorUS,0) & "</span></b><input type=hidden name='hSaldoFinalUS_" & a & "_" & b & "' value='" & valorUS & "'></td>" & finLinea
                        else
                            if ( a=4 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(1)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=5 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(2)'>" & FormatNumber(valorUS,0) & "</a></td>" & finLinea
                            elseif ( a=6 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(3)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=7 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(8)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=8 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(4)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=9 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(9)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=13 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(5)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=14 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(6)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=15 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(7)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            elseif ( a=16 and b = 2 ) then
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fDetSaldosVencidos(10)'>" & FormatNumber(valor,0) & "</a></td>" & finLinea
                            else
                                cCad = "<td nowrap " & Color & cColsp & " " & alinear & ">&nbsp;<b>" & FormatNumber(cDbl(valor)+cDbl(valorUS),0) & "</b></td>" & finLinea
                            end if
                        end if
					else
                        cCad = "<td nowrap " & Color & cColsp & " " & alinear & ">&nbsp;" & valor & "</td>" & finLinea
					end if
				else
                    cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><a href='Javascript:fWndDet(" & chr(34) & Trim(Documento) & chr(34) & "," & chr(34) & Trim(MtxPrincipal(0,b)) & chr(34) & ")'>" & FormatNumber(Cdbl(valor)+Cdbl(valorUS),0) & "</a>&nbsp;"
                    if xPeriodo = "D" then
                        cCad = cCad & "<input type=checkbox checked class=FuenteInput name='Check_" & a & "_" & b & "' onClick='Javascript:fIncluye(" & a & ", " & b & ")'>"
                        cCad = cCad & "<input type=hidden name='hMonto_" & a & "_" & b & "' value='" & valor & "'>"
                        cCad = cCad & "<input type=hidden name='hMontoUS_" & a & "_" & b & "' value='" & valorUS & "'></td>" & finLinea
                    end if
				end if
			else
                if a=0 and b>2 then
                    cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><b>" & valor & "</b>&nbsp;" & finLinea
                    cCad = cCad & "<input type=hidden name='Fecha_" & a & "_" & b & "' value='" & valor & "'></td>" & finLinea
                else
    				if Instr(1,valor, "por cobrar") > 0 Or Instr(1,valor, "Otros ingresos") > 0 Or Instr(1,valor, "presupuestados") > 0 Or _
    				   Instr(1,valor, "por pagar") > 0 Or Instr(1,valor, "Otros egresos") > 0 Or Instr(1,valor, "presupuestados") > 0 then
    					cCad = "<td nowrap " & Color & cColsp & " " & alinear & ">" & Repetir(5,"&nbsp;") & valor & "</td>" & finLinea
    				else
    					cCad = "<td nowrap " & Color & cColsp & " " & alinear & "><b>" & valor & "</b>&nbsp;</td>" & finLinea
    				end if
    			end if
			end if
		end if
				
		fFormatea = cCad
	end function

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
    Paridad = Request("Paridad")
        if Len(trim(Paridad)) = 0 Then Paridad = "Null"  

	Centro_venta = Request("Centro_de_venta")
    	if len(trim(Centro_venta)) = 0 then Centro_venta = "Null" Else Centro_venta = "'" & Centro_venta & "'"

	if Request("DetallePorCtoVta") = "on" then
		DetallePorCtoVta = "S"
	else
		DetallePorCtoVta = "N"
	end if

	SET Connec = AbrirConexion ( Session("Dataconn_ConnectionString") )
    
    DepositosSinRespaldos   = 0
    CargosSinRespaldos      = 0
    DepositosSinRespaldosUS = 0
    CargosSinRespaldosUS    = 0

    cSql = "Exec DOV_Flujo_de_caja_depositos_y_cargos_sin_repaldo " & Centro_venta & ", "
    cSql = cSql & "'" & Session("Empresa_usuario") & "', " & Paridad
    Set Rs = Connec.Execute ( cSql )
    if Not Rs.Eof then
        DepositosSinRespaldos   = Rs("Depositos_sin_respaldo_$")
            if IsNull(DepositosSinRespaldos) then DepositosSinRespaldos = 0
        DepositosSinRespaldosUS = Rs("Depositos_sin_respaldo_US$")
            if IsNull(DepositosSinRespaldosUS) then DepositosSinRespaldosUS = 0

        CargosSinRespaldos      = Rs("Cargos_sin_respaldo_$")
            if IsNull(CargosSinRespaldos) then CargosSinRespaldos = 0
        CargosSinRespaldosUS    = Rs("Cargos_sin_respaldo_US$")
            if IsNull(CargosSinRespaldosUS) then CargosSinRespaldosUS = 0
    end if
    Rs.Close
    Set Rs = Nothing

    cSql = "Exec DOV_Flujo_de_caja_saldos_vencidos '" & Desde & "', " & Centro_venta & ", '" & Session("Empresa_usuario") & "', " & Paridad
    Set Rs = Connec.Execute ( cSql )
    If Not Rs.Eof then
        Saldo_por_cobrar_FAV    = Rs("Saldo_por_cobrar_FAV")
            if  IsNull(Saldo_por_cobrar_FAV) Then Saldo_por_cobrar_FAV = 0
        Saldo_por_cobrar_FAE    = Rs("Saldo_por_cobrar_FAE")
            if  IsNull(Saldo_por_cobrar_FAE) Then Saldo_por_cobrar_FAE = 0
        Saldo_por_cobrar_CHI    = Rs("Saldo_por_cobrar_CHI")
            if  IsNull(Saldo_por_cobrar_CHI) Then Saldo_por_cobrar_CHI = 0
        Saldo_por_cobrar_UCI    = Rs("Saldo_por_cobrar_UCI")
            if  IsNull(Saldo_por_cobrar_UCI) Then Saldo_por_cobrar_UCI = 0
        Saldo_por_cobrar_otros  = Rs("Saldo_por_cobrar_otros_$")
            if  IsNull(Saldo_por_cobrar_otros) Then Saldo_por_cobrar_otros = 0
        Saldo_por_cobrar_otrosUS  = Rs("Saldo_por_cobrar_otros_US$")
            if  IsNull(Saldo_por_cobrar_otrosUS) Then Saldo_por_cobrar_otrosUS = 0
        Saldo_por_pagar_FAC     = Rs("Saldo_por_pagar_FAC")
            if  IsNull(Saldo_por_pagar_FAC) Then Saldo_por_pagar_FAC = 0
        Saldo_por_pagar_UFC     = Rs("Saldo_por_pagar_UFC")
            if  IsNull(Saldo_por_pagar_UFC) Then Saldo_por_pagar_UFC = 0
        Saldo_por_pagar_otros   = Rs("Saldo_por_pagar_otros_$")
            if  IsNull(Saldo_por_pagar_otros) Then Saldo_por_pagar_otros = 0
        Saldo_por_pagar_otros_US= Rs("Saldo_por_pagar_otros_US$")
            if  IsNull(Saldo_por_pagar_otros_US) Then Saldo_por_pagar_otros_US = 0
    else
        Saldo_por_cobrar_FAV     = 0 
        Saldo_por_cobrar_FAE     = 0
        Saldo_por_cobrar_CHI     = 0
        Saldo_por_cobrar_UCI     = 0 
        Saldo_por_cobrar_otros   = 0
        Saldo_por_cobrar_otrosUS = 0
        Saldo_por_pagar_FAC      = 0
        Saldo_por_pagar_UFC      = 0
        Saldo_por_pagar_otros    = 0
        Saldo_por_pagar_otros_US = 0
    end if
    Rs.Close
    Set Rs = Nothing

	'cSql = "Exec DOV_Saldo_inicial_contable_flujo_caja '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "'"
	cSql = "Exec DOV_Flujo_caja_saldo_inicial_contable_$_y_US$ '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "'"
	Set Rs = Connec.Execute ( cSql )
	if Connec.Errors.Count = 0 then
		if Not Rs.EOF then
            if IsNull( Rs("Saldo_contable_$") ) Then SaldoInicial = 0 Else SaldoInicial = Rs("Saldo_contable_$")
            if IsNumeric(SaldoInicial) then SaldoInicial = cDbl( SaldoInicial )
            SaldoInicial = cDbl( Rs("Saldo_contable_$") )

            if IsNull( Rs("Saldo_contable_US$") ) Then SaldoInicialUS = 0 Else SaldoInicialUS = Rs("Saldo_contable_US$")
            if IsNumeric(SaldoInicialUS) then SaldoInicialUS = cDbl( SaldoInicialUS )
            SaldoInicialUS = cDbl( Rs("Saldo_contable_US$") )
		else
			SaldoInicial   = 0
			SaldoInicialUS = 0
		end if
	else
	   Error = "S"
	   MsgError = Err.Description
	end if
	Rs.Close 
	Set Rs = Nothing

	if Error = "N" then
        'cSql = "Exec DOV_Saldo_inicial_cheques_flujo_caja '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "'"
        cSql = "Exec DOV_Flujo_caja_saldo_inicial_CHE_UCH_no_conciliados '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "', " & Paridad
    	Set Rs = Connec.Execute ( cSql )
    		if Not Rs.EOF then
    			ChequesEgresados    = cDbl("0" & Rs("Saldo_cheques_no_conciliados_$") )
    			ChequesEgresados_US = cDbl("0" & Rs("Saldo_cheques_no_conciliados_US$") )
    		else
    			ChequesEgresados    = 0
    			ChequesEgresados_US = 0
    		end if
    	Rs.Close 
    	Set Rs = Nothing
    
    	mtx_SaldoInicial   = SaldoInicial   + ChequesEgresados
    	mtx_SaldoInicialUS = SaldoInicialUS + ChequesEgresados_US
    end if

	if Error = "N" then
        cSql = "Exec DOV_Flujo_caja_CHE_UCH_vencidos_no_conciliados '" & Desde & "', '" & Session("Empresa_usuario") & "', " & Centro_venta & ", '" & Periodo & "', " & Paridad
    	Set Rs = Connec.Execute ( cSql )
    		if Not Rs.EOF then
    			ChequesVencidosNoConciliados    = cDbl("0" & Rs("Saldo_cheques_vencidos_no_conciliados_$") )
    			ChequesVencidosNoConciliados_US = cDbl("0" & Rs("Saldo_cheques_vencidos_no_conciliados_US$") )
    		else
    			ChequesVencidosNoConciliados    = 0
    			ChequesVencidosNoConciliados_US = 0
    		end if
    	Rs.Close 
    	Set Rs = Nothing
    end if
    
	CerrarConexion ( Connec )

    MsgError = LimpiaError ( MsgError )

'Response.Write MsgError
'Response.End

%>
<html>
<head>
	<title>Fujo de Caja</title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/NumberFormat154.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>

<%	if PanelDeControl <> "S" Then %>
		<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<%	else%>
		<body>
<%	end if%>

<% if Error = "N" Then %>
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
    <form name="Listado" method=post action="Editar_Documento.asp" target="Trabajo">
    	<input type=hidden name="FechaInicial"	value="<%=Request("Fecha_Desde")%>">
    	<input type=hidden name="CentroVenta"	value="<%=Request("Centro_de_venta")%>">
    	<input type=hidden name="Periodo"		value="<%=Request("Periodo")%>">
    	<input type=hidden name="Paridad"		value="<%=Request("Paridad")%>">
    	<input type=hidden name="Recalcula_sin_cheques_ni_otros_ingresos" value="<%=Request("Recalcula_sin_cheques_ni_otros_ingresos")%>">

    <%	if PanelDeControl = "S" Then %>
    		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 ID="Table1">
    			<tr height=50 valign=top>
    				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:this.window.close()">FLUJO DE CAJA</a></td> 
    			</tr>
    		</table>
    <%	end if%>
    
    <%	Sql = "Exec DOV_Flujo_de_caja_$_y_US$ "			& +_
              "'"  & Desde						& "',"	& +_
              "'"  & Hasta						& "',"	& +_
              ""   & Centro_venta				& ", "	& +_
              "'"  & Periodo					& "',"	& +_
              "'"  & Session("Empresa_usuario")	& "', " & Paridad & ", '" & +_
                     Request("Recalcula_sin_cheques_ni_otros_ingresos") & +_
              "', 0" & Session.SessionID
   
    		Set Conn1 = AbrirConexion ( Session("DataConn_ConnectionString") )
    		Set rs = Server.CreateObject("ADODB.Recordset")
    	
    		rs.CacheSize = 3
    		rs.CursorLocation = adUseClient
    
    		rs.Open Sql, Conn1, , , adCmdText 'mejor
    
    	If Not Rs.EOF Then 
    		Filas = 21
    		Columnas = Rs.RecordCount+3
            rs.PageSize = Rs.RecordCount
    		Redim MtxPrincipal(Filas, Columnas)   'Almacena $
    		Redim MtxSecundaria(Filas, Columnas)  'Almacena US$
    		Rs.MoveFirst
    		Dim x, y
    		y=3
    		
    		MtxPrincipal(0,0) 	= "Concepto"
    		MtxPrincipal(1,0) 	= "Saldo Inicial $"
    		MtxPrincipal(2,0) 	= "Saldo Inicial U$"
    		MtxPrincipal(3,0) 	= "Ingresos"
    		MtxPrincipal(4,0) 	= "Facturas nacionales por cobrar"
    		MtxPrincipal(5,0) 	= "Facturas exportación por cobrar"
    		MtxPrincipal(6,0) 	= "Cheques por cobrar $"
    		MtxPrincipal(7,0) 	= "Cheques por cobrar US$"
    		MtxPrincipal(8,0) 	= "Otros ingresos $"
    		MtxPrincipal(9,0) 	= "Otros ingresos US$"
    		MtxPrincipal(10,0) 	= "Ingresos presupuestados"
    		MtxPrincipal(11,0) 	= "Total ingresos"
    		MtxPrincipal(12,0) 	= "Egresos"
    		MtxPrincipal(13,0) 	= "Facturas nacionales por pagar"
    		MtxPrincipal(14,0) 	= "Facturas importación por pagar"
    		MtxPrincipal(15,0)	= "Otros egresos $"
    		MtxPrincipal(16,0)	= "Otros egresos US$"
    		MtxPrincipal(17,0)	= "Egresos presupuestados"
    		MtxPrincipal(18,0)	= "Total egresos"
    		MtxPrincipal(19,0)	= "Saldo Final $"
    		MtxPrincipal(20,0)	= "Saldo Final U$"
    		
    		MtxPrincipal(0,1)	= "Ctro vta-cto"
    		MtxPrincipal(0,2)	= "Saldos<br>vencidos"
            			
            MtxPrincipal(4,2) 	= Cdbl(Saldo_por_cobrar_FAV)
			MtxPrincipal(5,2) 	= 0
			MtxPrincipal(6,2) 	= Cdbl(Saldo_por_cobrar_CHI)
			MtxPrincipal(7,2) 	= Cdbl(Saldo_por_cobrar_UCI)
			MtxPrincipal(8,2) 	= Cdbl(Saldo_por_cobrar_otros)
			MtxPrincipal(9,2) 	= 0
			MtxPrincipal(11,2) 	= MtxPrincipal(4,2) +  MtxPrincipal(5,2) +  MtxPrincipal(6,2) +  MtxPrincipal(7,2)
			MtxPrincipal(13,2) 	= Cdbl(Saldo_por_pagar_FAC)
			MtxPrincipal(14,2) 	= Cdbl(Saldo_por_pagar_UFC)
			MtxPrincipal(15,2)	= Cdbl(Saldo_por_pagar_otros)
			MtxPrincipal(16,2)	= 0
			MtxPrincipal(17,2) 	= 0
			MtxPrincipal(18,2) 	= ( ( MtxPrincipal(13,2) + MtxPrincipal(14,2) + MtxPrincipal(15,2) ) ) + MtxPrincipal(17,2)
			MtxPrincipal(19,2) 	= Cdbl(MtxPrincipal(11,2)) - Cdbl(MtxPrincipal(18,2)) 
			MtxPrincipal(20,2) 	= 0
            MtxPrincipal(1,2)   = ""

            MtxSecundaria(4,2) 	= 0
			MtxSecundaria(5,2) 	= Cdbl(Saldo_por_cobrar_FAE)
			MtxSecundaria(6,2) 	= 0
			MtxSecundaria(7,2) 	= 0
			MtxSecundaria(8,2) 	= 0
			MtxSecundaria(9,2) 	= cDbl(Saldo_por_cobrar_otrosUS)
			MtxSecundaria(11,2) = MtxSecundaria(4,2) + MtxSecundaria(5,2) + MtxSecundaria(6,2) + MtxSecundaria(7,2)
			MtxSecundaria(13,2)	= 0
			MtxSecundaria(14,2)	= 0 'Cdbl(Saldo_por_pagar_UFC)
			MtxSecundaria(15,2)	= 0
			MtxSecundaria(16,2)	= 0
			MtxSecundaria(18,2)	= cDbl(MtxSecundaria(12,2)) + cDbl(MtxSecundaria(13,2)) + cDbl(MtxSecundaria(14,2))
			MtxSecundaria(19,2)	= 0
            MtxSecundaria(20,2)	= Cdbl(MtxSecundaria(11,2)) - Cdbl(MtxSecundaria(18,2)) 
            MtxSecundaria(1,2)  = ""
            
    		Do While Not Rs.EOF 
    			'$
    			CentroVenta 		= Rs("Centro_de_Venta")    			

                MtxPrincipal(0,y) 	= Rs("Periodo")    
    			MtxPrincipal(1,y) 	= Cdbl(mtx_SaldoInicial)
    			MtxPrincipal(2,y) 	= 0
    			MtxPrincipal(4,y) 	= Cdbl(Rs("Por_cobrar_FAV"))
    			MtxPrincipal(5,y) 	= 0
    			MtxPrincipal(6,y) 	= Cdbl(Rs("Por_cobrar_CHI"))
    			MtxPrincipal(7,y) 	= 0
    			MtxPrincipal(8,y) 	= Cdbl(Rs("Por_cobrar_otros"))
    			MtxPrincipal(9,y) 	= 0
    			MtxPrincipal(10,y) 	= Cdbl(Rs("Por_ingresar_presupuestado"))    
    			MtxPrincipal(11,y) 	= Cdbl("0" & MtxPrincipal(11,y)) + ( ( MtxPrincipal(4,y) + MtxPrincipal(5,y) + MtxPrincipal(6,y) + MtxPrincipal(7,y) + MtxPrincipal(8,y) ) ) + MtxPrincipal(10,y)
    			MtxPrincipal(13,y) 	= Cdbl(Rs("Por_pagar_FAC"))
    			MtxPrincipal(14,y) 	= 0
    			MtxPrincipal(15,y)	= Cdbl(Rs("Por_pagar_otros"))
                MtxPrincipal(16,y)	= 0    			
                MtxPrincipal(17,y)	= Cdbl(Rs("Por_egresar_presupuestado"))                    
    			MtxPrincipal(18,y) 	= Cdbl("0" & MtxPrincipal(18,y)) + ( ( MtxPrincipal(13,y) + MtxPrincipal(14,y) + MtxPrincipal(15,y) ) ) + MtxPrincipal(17,y)
'Response.Write cDbl(MtxPrincipal(11,y)) & " + " & cDbl(mtx_SaldoInicial) & " - " & cDbl(MtxPrincipal(18,y)) & "<br>"
    			MtxPrincipal(19,y)	= ( cDbl(MtxPrincipal(11,y)) + cDbl(mtx_SaldoInicial) ) - cDbl(MtxPrincipal(18,y))
    			MtxPrincipal(20,y)	= 0
    			mtx_SaldoInicial	= MtxPrincipal(19,y)
    			
    			'US$
                MtxSecundaria(0,y) 	= Rs("Periodo")    
    			MtxSecundaria(1,y) 	= 0
    			MtxSecundaria(2,y) 	= Cdbl(mtx_SaldoInicialUS)
    			MtxSecundaria(4,y) 	= 0
    			MtxSecundaria(5,y) 	= Cdbl(Rs("Por_cobrar_FAE"))
    			MtxSecundaria(6,y) 	= 0
    			MtxSecundaria(7,y) 	= Cdbl(Rs("Por_cobrar_UCI"))
    			MtxSecundaria(8,y) 	= 0
    			MtxSecundaria(9,y) 	= Cdbl(Rs("Por_cobrar_otros_US$"))
    			MtxSecundaria(10,y) 	= 0    
    			MtxSecundaria(11,y) = Cdbl("0" & MtxSecundaria(11,y)) + ( ( MtxSecundaria(4,y) + MtxSecundaria(5,y) + MtxSecundaria(6,y) + MtxSecundaria(7,y) + MtxSecundaria(8,y) ) ) + MtxSecundaria(10,y)
    			MtxSecundaria(13,y)	= 0
    			MtxSecundaria(14,y)	= Cdbl(Rs("Por_pagar_UFC"))
    			MtxSecundaria(15,y)	= 0    			
                MtxSecundaria(16,y)	= Cdbl(Rs("Por_pagar_otros_US$"))
                MtxSecundaria(17,y)	= 0                    
    			'MtxSecundaria(18,y)	= Cdbl("0" & MtxSecundaria(18,y)) + ( ( MtxSecundaria(14,y) + MtxSecundaria(14,y) + MtxSecundaria(15,y) ) ) + MtxSecundaria(17,y)
    			MtxSecundaria(18,y)	= Cdbl("0" & MtxSecundaria(18,y)) + ( ( MtxSecundaria(14,y) + MtxSecundaria(16,y) ) ) + MtxSecundaria(17,y)
    			MtxSecundaria(19,y)	= 0
'Response.Write mtx_SaldoInicialUS & " --- " & MtxSecundaria(11,y) & " --- " & MtxSecundaria(18,y) & "<br>"
    			MtxSecundaria(20,y)	= ( mtx_SaldoInicialUS + MtxSecundaria(11,y) ) - MtxSecundaria(18,y)
    			mtx_SaldoInicialUS	= MtxSecundaria(20,y)

    			Rs.MoveNext 
    			y = y + 1						
    		Loop
%>
    			<table width="99%" border=1 align=center cellpadding=2 cellspacing=0>
    			<%	For a=0 To Filas-1
    					Response.Write "<tr>"
    					valor = MtxPrincipal(a,0)
    					if (Instr(1, "INGRESOS", Ucase(Trim(valor)) ) > 0) Or _
    					   (Instr(1, "EGRESOS", Ucase(Trim(valor)) ) > 0)  THEN
    						Response.Write "<td class=FuenteInput colspan=" & Columnas & " align=left ><B>" & MtxPrincipal(a,0) & "</B></td>"  & chr(13)
    					else
    						For b=0 to Columnas-1
    							Response.Write fFormatea( MtxPrincipal(a,b), MtxSecundaria(a,b), a, b, Columnas, Periodo)
    						Next
    					end if
    					Response.Write "</tr>" & chr(13)
    				Next
    			%>
    			</table>
                <script language="javascript">
                    parent.top.frames[2].location.href = "Botones_FlujoCaja.asp?SinRegistro=N&Periodo=<%=Request("Periodo")%>"
                </script>
    <%		Else
    			abspage = 0 %>
    			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
    			    <tr class="FuenteEncabezados">
    					<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
    				</tr>
    			</table>
                <script language="javascript">
                    parent.top.frames[2].location.href = "Botones_FlujoCaja.asp?SinRegistro=S"
                </script>
    		<%End If
    						
    		rs.Close
    		Set rs = Nothing
    %>
    	<script language="JavaScript">
    	<%	if PanelDeControl <> "S" Then %>
    			// $
                eval("parent.top.frames[1][0].document.all('lblSaldoInicialContable').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('SaldoInicialContable').innerHTML = '<%=Replace(FormatNumber(SaldoInicial,0),",",".")%>'")

    			eval("parent.top.frames[1][0].document.all('lblChequesEgresados').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('ChequesEgresados').innerHTML = '<%=Replace(FormatNumber(ChequesEgresados,0),",",".")%>'")

    			eval("parent.top.frames[1][0].document.all('lblDepositosSinRespaldos').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('DepositosSinRespaldos').innerHTML = '<%=Replace(FormatNumber(DepositosSinRespaldos,0),",",".")%>'")
    
    			eval("parent.top.frames[1][0].document.all('lblCargosSinRespaldos').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('CargosSinRespaldos').innerHTML    = '<%=Replace(FormatNumber(CargosSinRespaldos,0),",",".")%>'")

    			// US$
                eval("parent.top.frames[1][0].document.all('lblSaldoInicialContableUS').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('SaldoInicialContableUS').innerHTML    = '<%=Replace(FormatNumber(SaldoInicialUS,0),",",".")%>'")

    			eval("parent.top.frames[1][0].document.all('lblChequesEgresadosUS').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('ChequesEgresadosUS').innerHTML    = '<%=Replace(FormatNumber(ChequesEgresados_US,0),",",".")%>'")


                eval("parent.top.frames[1][0].document.all('lblDepositosSinRespaldosUS').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('DepositosSinRespaldosUS').innerHTML    = '<%=Replace(FormatNumber(DepositosSinRespaldosUS,0),",",".")%>'")

    			eval("parent.top.frames[1][0].document.all('lblCargosSinRespaldosUS').className = 'FuenteEncabezados'")
    			eval("parent.top.frames[1][0].document.all('CargosSinRespaldosUS').innerHTML    = '<%=Replace(FormatNumber(CargosSinRespaldosUS,0),",",".")%>'")
    

    	<%	end if%>
    
    		function fWndDet(Documento, Periodo)
    		{
    		    var Paridad = parent.top.frames[1][0].document.Listado.Paridad.value;
    			var qry = "?Documento=" + Documento;
    			var qry = qry + "&Periodo=" + Periodo;
    			var qry = qry + "&Paridad=" + Paridad;
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
    				winFeatures += "width=850," ;
    				winFeatures += "height=450," ;
    				winFeatures += "top=30," ;
    				winFeatures += "left=50" ;
    				var wnd = window.open(winURL , winName , winFeatures , 'mainwindow')
    		}

            function fDetSaldosVencidos( Id )
            {
                var FechaInicial = document.Listado.FechaInicial.value;
                var CentroVenta  = document.Listado.CentroVenta.value;
                var Periodo      = document.Listado.Periodo.value;
    	        var Paridad      = document.Listado.Paridad.value;

    			var qry = "?FechaInicial=" + FechaInicial;
    			var qry = qry + "&CentroVenta=" + CentroVenta;
    			var qry = qry + "&Periodo=" + Periodo;
    			var qry = qry + "&Paridad=" + Paridad;
    			var qry = qry + "&Id=" + Id;

    			var winURL		 = "Detalle_Saldos_vencidos.asp" + qry;
    			var winName		 = "Wnd_Detalle_Saldos_vencidos";
    			var winFeatures  = "status=no," ; 
    				winFeatures += "resizable=no," ;
    				winFeatures += "toolbar=no," ;
    				winFeatures += "location=no," ;
    				winFeatures += "scrollbars=yes," ;
    				winFeatures += "menubar=0," ;
    				winFeatures += "width=650," ;
    				winFeatures += "height=450," ;
    				winFeatures += "top=30," ;
    				winFeatures += "left=50" ;
    				var wnd = window.open(winURL , winName , winFeatures , 'mainwindow')
            }


            function fIncluye( a, b)
            {
//alert ( a + ' - ' + b )
                if ( a == 10 || a == 17 )
                {
                    if ( a == 10 )
                    {
                        var hMonto  = eval("document.Listado.txtIngresoPresupuestado_" + a + "_" + b )
                    }
                    else
                    {
                        var hMonto  = eval("document.Listado.txtEgresoPresupuestado_" + a + "_" + b )
                    }
                    var hMontoUS  = 0
                }
                else                
                {
                    var hMonto    = eval("document.Listado.hMonto_" + a + "_" + b )
                    var hMontoUS  = eval("document.Listado.hMontoUS_" + a + "_" + b + ".value")
                }

                var objCaja = eval("document.Listado.Check_" + a + "_" + b )
                
                if ( a < 11 )
                {
                    var hTotalIngresos          = eval("document.Listado.hTotalIngresos_11_" + b )
                    var spanTotalIngresos       = eval("document.all('spanTotalIngresos_11_" + b + "')")

                    var TotalIngresos           = 0;

                    if ( ! objCaja.checked )
                    {
                        TotalIngresos           = parseFloat(hTotalIngresos.value) - parseFloat(hMonto.value);
                    }
                    else
                    {
                        TotalIngresos           = parseFloat(hTotalIngresos.value) + parseFloat(hMonto.value);
                    }
                    hTotalIngresos.value            = TotalIngresos;
                    spanTotalIngresos.innerHTML     = TotalIngresos;
                }
                else
                {
                    var objhTotalEgresos       = eval("document.Listado.hTotalEgresos_18_" + b )
                    var objhTotalEgresosUS     = eval("document.Listado.hTotalEgresosUS_18_" + b )
                    
                    var spanTotalEgresos       = eval("document.all('spanTotalEgresos_18_" + b + "')")
                    var nTotalEgresos          = eval("document.all('nTotalEgresos_18_" + b + "')")

                    var TotalEgresos    = 0;
                    var TotalEgresosUS  = 0;
                    var TotalEgresosHTML    = 0;

                    if ( ! objCaja.checked )
                    {
                        TotalEgresos        = parseFloat(objhTotalEgresos.value) - ( parseFloat(hMonto.value) ); //+ parseFloat(hMontoUS) );
                        TotalEgresosUS      = parseFloat(objhTotalEgresosUS.value) - ( parseFloat(hMontoUS) );
                    }
                    else
                    {
                        TotalEgresos        = parseFloat(objhTotalEgresos.value) + ( parseFloat(hMonto.value) );
                        TotalEgresosUS      = parseFloat(objhTotalEgresosUS.value) + ( parseFloat(hMontoUS) );
                    }

                    objhTotalEgresos.value         = TotalEgresos;
                    spanTotalEgresos.innerHTML     = TotalEgresos;
                    nTotalEgresos.value            = TotalEgresos;
                    objhTotalEgresosUS.value       = TotalEgresosUS;
                }
                fCalculaSaldoFinal()
            }
            
            function fCalculaIngresoPresupuestado( a, b)
            {
                //Ingresos
                var bakIngresoPresupuestado = eval("document.Listado.bakIngresoPresupuestado_" + a + "_" + b )
                var IngresoPresupuestado    = eval("document.Listado.txtIngresoPresupuestado_" + a + "_" + b )
                if ( ! validEmpty(IngresoPresupuestado.value) )
                {
                    if ( ! validaNumeros(IngresoPresupuestado.value) )
                    {
                        IngresoPresupuestado.value = 0
                    }
                } 
                var spanTotalIngresos       = eval("document.all('spanTotalIngresos_11_" + b + "')")
                var hTotalIngresos          = eval("document.Listado.hTotalIngresos_11_" + b )
                
                var TotalIngresos = ( parseFloat(hTotalIngresos.value) - parseFloat(bakIngresoPresupuestado.value) ) + parseFloat(IngresoPresupuestado.value)
                 
                bakIngresoPresupuestado.value   = IngresoPresupuestado.value;
                hTotalIngresos.value            = TotalIngresos;
                spanTotalIngresos.innerHTML     = TotalIngresos;
                fCalculaSaldoFinal()
            }
            
            function fCalculaEgresoPresupuestado( a, b)
            {
                //Egresos
                var bakEgresoPresupuestado = eval("document.Listado.bakEgresoPresupuestado_" + a + "_" + b )
                var EgresoPresupuestado    = eval("document.Listado.txtEgresoPresupuestado_" + a + "_" + b )

                if ( ! validEmpty(EgresoPresupuestado.value) )
                {
                    if ( ! validaNumeros(EgresoPresupuestado.value) )
                    {
                        EgresoPresupuestado.value = 0
                    }
                } 
                var spanTotalEgresos       = eval("document.all('spanTotalEgresos_18_" + b + "')")
                var hTotalEgresos          = eval("document.Listado.hTotalEgresos_18_" + b )

//alert ( parseFloat(hTotalEgresos.value) + ' - ' + parseFloat(bakEgresoPresupuestado.value) + ' + ' + parseFloat(EgresoPresupuestado.value) )

                var TotalEgresos = ( parseFloat(hTotalEgresos.value) - parseFloat(bakEgresoPresupuestado.value) ) + parseFloat(EgresoPresupuestado.value)

                bakEgresoPresupuestado.value   = EgresoPresupuestado.value;
                hTotalEgresos.value            = TotalEgresos;
                spanTotalEgresos.innerHTML     = TotalEgresos;
                fCalculaSaldoFinal()
            }

            function fCalculaSaldoFinal()
            {
                var Columnas = document.Listado.Columnas.value;
//alert ( Columnas )
                for ( h=3; h<Columnas; h++ )
                {
                    //Ingreso
                    var hTotalIngresos          = eval("document.Listado.hTotalIngresos_11_" + h )
                    var hTotalIngresosUS        = eval("document.Listado.hTotalIngresosUS_11_" + h )

//alert ( hTotalIngresos.value + ' - ' + hTotalIngresosUS.value )

                    //Egreso
                    var hTotalEgresos           = eval("document.Listado.hTotalEgresos_18_" + h )
                    var hTotalEgresosUS         = eval("document.Listado.hTotalEgresosUS_18_" + h )

                    var hSaldoInicial           = eval("document.Listado.hSaldoInicial_1_" + h )
                    var spanSaldoInicial        = eval("document.all('spanSaldoInicial_1_" + h + "')")
                    var hSaldoInicialUS         = eval("document.Listado.hSaldoInicialUS_2_" + h )
                    var spanSaldoInicialUS      = eval("document.all('spanSaldoInicialUS_2_" + h + "')")
                    
                    var spanSaldoFinal          = eval("document.all('spanSaldoFinal_19_" + h + "')")
                    var spanSaldoFinalUS        = eval("document.all('spanSaldoFinalUS_20_" + h + "')")

if ( h == -1 )
{
    alert ( hSaldoInicial.value   + ' -- ' + hTotalIngresos.value   + ' -- ' + hTotalEgresos.value )
    alert ( hSaldoInicialUS.value + ' -- ' + hTotalIngresosUS.value + ' -- ' + hTotalEgresosUS.value )
}

                    var SaldoFinal              = parseFloat(hSaldoInicial.value) + ( parseFloat(hTotalIngresos.value) - parseFloat(hTotalEgresos.value) ) 

                    var SaldoFinalUS            = parseFloat(hSaldoInicialUS.value) + ( parseFloat(hTotalIngresosUS.value) - parseFloat(hTotalEgresosUS.value) )
                    //spanSaldoFinal.innerHTML    = FormatNumberV2( SaldoFinal, 0) ;
                    //spanSaldoFinalUS.innerHTML  = FormatNumberV2( SaldoFinalUS, 0);
                    //alert ( SaldoFinal )
                    spanSaldoFinal.innerHTML    = SaldoFinal;
                    spanSaldoFinalUS.innerHTML  = SaldoFinalUS;

                    if ( (h+1) < Columnas )
                    {
                        hSaldoInicial               = eval("document.Listado.hSaldoInicial_1_" + (h+1) )                    
                        spanSaldoInicial            = eval("document.all('spanSaldoInicial_1_" + (h+1) + "')")
                        hSaldoInicial.value         = SaldoFinal;
                        //spanSaldoInicial.innerHTML  = FormatNumberV2( SaldoFinal, 0) ; 
                        spanSaldoInicial.innerHTML  = SaldoFinal; 

                        hSaldoInicialUS               = eval("document.Listado.hSaldoInicialUS_2_" + (h+1) )                    
                        spanSaldoInicialUS            = eval("document.all('spanSaldoInicialUS_2_" + (h+1) + "')")
                        hSaldoInicialUS.value         = SaldoFinalUS;
                        //spanSaldoInicialUS.innerHTML  = FormatNumberV2( SaldoFinalUS, 0); 
                        spanSaldoInicialUS.innerHTML  = SaldoFinalUS; 
                    }
                }
            }
    		
    	</script>
<%else%>
    <script language="javascript">
        parent.top.frames[2].location.href = "Botones_FlujoCaja.asp?SinRegistro=S"
        parent.top.frames[3].location.href = "../../Mensajes.asp?Msg=<%=MsgError%>"
    </script>
<%end if%>
        <input type=hidden name="Columnas" value="<%=Columnas%>">
</form>
<iframe id="Paso" name="Paso" src="../../empty.asp" height=0 width=0></iframe>
</body>
</html>
<%Else
	Response.Redirect "../../index.htm"
end if%>

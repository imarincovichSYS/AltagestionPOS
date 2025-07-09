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

	fecha_desde = Right("00" & day(Now()),2) & "/" & Right("00" & Month(Now()),2) & "/" & Year(now())
	fecha_hasta = DateAdd("d",90,fecha_desde)

    cSql = "Exec VMN_ListaParidades 'US$', '" & Session("empresa_usuario") & "', Null"
    Set Rs = Conn.Execute ( cSql )
    If Not Rs.Eof then
        Paridad = Rs("Paridad_para_facturacion")
    else
        Paridad = 1
    end if
    Rs.Close
    Set Rs = Nothing


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

		<Form name="Listado" method="post" action="List_FlujoCaja.asp" target="Listado">
			<table width=80% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha desde</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_desde" size=7 maxlength=10 value="<%=fecha_desde%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_desde');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha hasta</td>
					<td width=20% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_hasta" size=7 maxlength=10 value="<%=fecha_hasta%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Listado.Fecha_hasta');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Centro de venta</td>
					<td width=20% align=left>
				     <% Sql = "Exec CDV_ListaCentrosVentas '','','" & session("empresa_usuario") & "',2"
                        SET Rs	=	Conn.Execute( SQL ) %>
                        <select Class="FuenteInput" style="width:150" name="Centro_de_venta">
                            <option value=""></option>
                       	<%  Do while not rs.eof%>
                                <option value='<%=rs("Centro_de_venta")%>'><%=rs("Nombre")%>&nbsp;(<%=rs("Centro_de_venta")%>)</option>
                        <%      rs.movenext
                        	Loop
                        	rs.close
                        	set rs=nothing
                        %>
                        </select>
					</td>
				</tr>
				
				<tr>
					<td nowrap class="FuenteEncabezados" width=15% align=left ><b>Período</b></td>
					<td width=20% align=left>
						<Select class="FuenteInput" name="Periodo">
							<option value="S">Semana</option>
							<option	value="D">Dia</option>
							<option	value="M">Mes</option>
						</Select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Paridad</td>
					<td width=15% align=left >
						<input Class="FuenteInput" type=Text name="Paridad" size=10 maxlength=9 value="<%=Paridad%>" >
					</td>
				</tr>
				
<!-- $ -->
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblSaldoInicialContable" name="lblSaldoInicialContable" >Saldo inicial contable $</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndSaldoContable()"><span id="SaldoInicialContable" name="SaldoInicialContable" ></span></a>&nbsp;
					</td>

					<td colspan=2 nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblChequesEgresados" name="lblChequesEgresados" >Cheques egresados contabilizados no conciliados</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<span class="FuenteEncabezados" id="ChequesEgresados" name="ChequesEgresados" ></span>&nbsp;
					</td>
				</tr>    

<!-- US$ -->
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblSaldoInicialContableUS" name="lblSaldoInicialContableUS" >Saldo inicial contable US$</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndSaldoContableUS()"><span id="SaldoInicialContableUS" name="SaldoInicialContableUS" ></span></a>&nbsp;
					</td>

					<td colspan=2 nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblChequesEgresadosUS" name="lblChequesEgresadosUS" >Cheques egresados contabilizados no conciliados US$</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<span class="FuenteEncabezados" id="ChequesEgresadosUS" name="ChequesEgresadosUS" ></span>&nbsp;
					</td>
				</tr>    

<!-- $ -->
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblDepositosSinRespaldos" name="lblDepositosSinRespaldos" >Depósitos sin respaldos</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndDetalle('Depositos$')"><span class="FuenteEncabezados" id="DepositosSinRespaldos" name="DepositosSinRespaldos" ></span></a>&nbsp;
					</td>

					<td colspan=2 nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblCargosSinRespaldos" name="lblCargosSinRespaldos" >Cargos sin respaldos</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndDetalle('Cargos$')"><span class="FuenteEncabezados" id="CargosSinRespaldos" name="CargosSinRespaldos" ></span></a>&nbsp;
					</td>
				</tr>    
<!-- US$ -->
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblDepositosSinRespaldosUS" name="lblDepositosSinRespaldosUS" >Depósitos sin respaldos US$</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndDetalle('DepositosUS')"><span class="FuenteEncabezados" id="DepositosSinRespaldosUS" name="DepositosSinRespaldosUS" ></span></a>&nbsp;
					</td>

					<td colspan=2 nowrap class="FuenteEncabezados" width=10% align=left ><span class="oculto" id="lblCargosSinRespaldosUS" name="lblCargosSinRespaldosUS" >Cargos sin respaldos US$</span></td>
					<td nowrap align=left>
					     &nbsp;&nbsp;<a class="FuenteEncabezados" href="javascript:fWndDetalle('CargosUS')"><span class="FuenteEncabezados" id="CargosSinRespaldosUS" name="CargosSinRespaldosUS" ></span></a>&nbsp;
					     <input type=hidden name="Recalcula_sin_cheques_ni_otros_ingresos" value="">
					</td>
				</tr>    

			</table>
		</form>
	</body>
</html>
<script language="javascript">
	function fWndSaldoContable()
	{
			var qry = "?Fecha=" + parent.top.frames[1][1].document.Listado.FechaInicial.value;
			var qry = qry + "&Periodo=" + parent.top.frames[1][1].document.Listado.Periodo.value;
			var qry = qry + "&Centro_de_Venta=" + parent.top.frames[1][1].document.Listado.CentroVenta.value;
			var qry = qry + "&Moneda=$";
			
			var winURL		 = "DetalleSaldoContable_FlujoCaja.asp" + qry;
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

	function fWndSaldoContableUS()
	{
			var qry = "?Fecha=" + parent.top.frames[1][1].document.Listado.FechaInicial.value;
			var qry = qry + "&Periodo=" + parent.top.frames[1][1].document.Listado.Periodo.value;
			var qry = qry + "&Centro_de_Venta=" + parent.top.frames[1][1].document.Listado.CentroVenta.value;
			
			var winURL		 = "DetalleSaldoContable_FlujoCaja.asp" + qry;
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

	function fWndDetalle( valor )
	{
			var qry = "?Paridad=" + parent.top.frames[1][1].document.Listado.Paridad.value;
			var qry = qry + "&Centro_de_Venta=" + parent.top.frames[1][1].document.Listado.CentroVenta.value;
			var qry = qry + "&Valor=" + valor;
			
			var winURL		 = "Detalle_DepositosCargos.asp" + qry;
			var winName		 = "Wnd_DetalleDC";
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
<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

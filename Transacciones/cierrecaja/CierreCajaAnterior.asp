<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

	Responsable		= Request("Responsable")
	if len(trim(Responsable)) = 0 then Responsable = "Null" Else Responsable = "'" & Responsable & "'"
	FechaDesde		= Request("Fecha_desde")
	if len(trim(FechaDesde)) = 0 then FechaDesde = "Null" Else FechaDesde = "'" & Cambia_fecha(Request("Fecha_desde")) & "'"
	FechaHasta		= Request("Fecha_hasta")
	if len(trim(FechaHasta)) = 0 then FechaHasta = "Null" Else FechaHasta = "'" & Cambia_fecha(Request("Fecha_hasta")) & "'"
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Ventanas.js"></script>
</head>
<%     
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
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
<%	end if

	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	empresa=session("empresa_usuario")
%>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:window.close();"><%=session("title")%></a></td> 
			</tr>
		</table>
		<Form name="Formulario" method="post" action="DetalleCobros_CierreCaja.asp" target="Trabajo">
			<table width=70% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Usuario</td>
					<td nowrap width=50% align=left >
						<input type=hidden name="anterior" value="<%=request("anterior")%>">
						<input name="login" value="<%=Request("Responsable")%>" size="12" type=text readonly class="datooutput" >
						<input name="Nombre_usuario" value="<%=Request("Nombre")%>" size=35 type=text readonly class="datooutput" >
					</td>
				</tr>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha y hora inicio cierre de caja</td>
					<td nowrap width=50% align=left >
						<input Class="DatoOutput" readonly type=Text name="Fecha_cierre_anterior" size=16 value="<%=Request("Fecha_desde")%>" >
					</td>
				</tr>    
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha y hora término cierre de caja</td>
					<td nowrap width=50% align=left >
						<input Class="DatoOutput" readonly type=Text name="Fecha_cierre_solicitado" size=16 value="<%=Request("Fecha_hasta")%>">
					</td>
				</tr>    
			</table>
			<br>
			<table Name="ListaDetalles" Id="ListaDetalles" width=50%  align=center border=1 cellspacing=0 cellpadding=0>
      			<tr class="FuenteCabeceraTabla">
     			     <td align=center nowrap width=10%>Tipo documento</td>
     			     <td align=center nowrap width=5%>Moneda</td>
     			     <td nowrap align=right width=10%>Monto $</td>
     			     <td nowrap align=right width=10%>Monto US$</td>
     			     <td nowrap align=right width=5%>Cantidad documentos</td>
	           </tr>
			<%	sql="DOV_Documentos_en_cierre '" & session("empresa_usuario") & "', " & trim(Responsable) & ", " & FechaDesde & ", " & FechaHasta
				set rs=conn.Execute(sql)
				i=0
				total_moneda=0
				total_monedaUS=0
				general_moneda=0
				general_monedaUS=0
				do while not rs.eof
					moneda=trim(rs("Moneda_documento"))
                    decimales = 0
                    if false then
					if trim(rs("Moneda_documento")) = "$" then
						monto=rs("MNL")
					    'total_moneda=clng(total_moneda) + clng(monto)
					else
						monto=rs("US$")
                        decimales = 2
					    'total_moneda=cdbl(total_moneda) + cdbl(monto)
					end if
                    end if

                    doc_valorizado = rs("Documento_valorizado")
                    if rs("Documento_valorizado") = "NCV" then
                        doc_valorizado = "Anticipo por NCV"
                    end if
                    if rs("Documento_valorizado") = "DEI" then
                        doc_valorizado = "Anticipo por DEI"
                    end if

					monto=rs("MNL")
					montoUS=rs("US$")
					total_moneda=cdbl(total_moneda) + cdbl(monto)
					total_monedaUS=cdbl(total_monedaUS) + cdbl(montoUS)
					general_moneda=cdbl(general_moneda) + cdbl(monto)
					general_monedaUS=cdbl(general_monedaUS) + cdbl(montoUS)
				%>
      			<tr class="FuenteEncabezados">
					<td align=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>"><%=doc_valorizado%></td>
					<td align=center><input type=hidden name="Moneda_documento<%=i%>" value="<%=rs("Moneda_documento")%>"><%=rs("Moneda_documento")%></td>
					<td align=right><input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(Monto,0)%></td>
                    <% if cDbl( MontoUS ) > 0 then %>
					<td align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>"><%=formatnumber(MontoUS,2)%></td>
                    <% else %>
					<td align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>">&nbsp;</td>
                    <% end if %>
					<td align=right><input type=hidden name="Documentos<%=i%>" value="<%=rs("Documentos")%>"><%=rs("Documentos")%></td>
				</tr>	
				<%	rs.movenext
					if not rs.eof then
						if moneda <>trim(rs("Moneda_documento")) then
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=2>Total</td>
      							<td align=right><%=formatnumber(total_moneda,0)%></td>
                                <% if cDbl( total_monedaUS ) > 0 then %>
      							<td align=right><%=formatnumber(total_monedaUS,2)%></td>
                                <% else %>
      							<td >&nbsp;</td>
                                <% end if %>
      							<td >&nbsp;</td>
							</tr>	
							<%
                               total_moneda=0
                               total_monedaUS=0
						end if
					else
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=2>Total</td>
      							<td align=right><%=formatnumber(total_moneda,0)%></td>
                                <% if cDbl( total_monedaUS ) > 0 then %>
      							<td align=right><%=formatnumber(total_monedaUS,2)%></td>
                                <% else %>
      							<td >&nbsp;</td>
                                <% end if %>
      							<td >&nbsp;</td>
							</tr>	
							<%
                                total_moneda=0
                                total_monedaUS=0
					end if
	           loop
	           rs.close
	           set rs=nothing%>
      			<tr class="FuenteCabeceraTabla">
      				<td colspan=2>General</td>
      				<td align=right><%=formatnumber(general_moneda,0)%></td>
                    <% if cDbl( general_monedaUS ) > 0 then %>
      				<td align=right><%=formatnumber(general_monedaUS,2)%></td>
                    <% else %>
      				<td >&nbsp;</td>
                    <% end if %>
      				<td >&nbsp;</td>
				</tr>	
			</table>

<!-- Inicio Detalle de cobros -->
			<table width=90% align=center border=1 cellspacing=0 cellpadding=0 >
				<tr>
					<td colspan=10 width=100% class="FuenteTitulosFunciones" align=left nowrap>Detalles de cobros</td> 
				</tr>
<!-- Inicio Detalle de cobros 
			</table>
			<table Name="ListaDetalles" Id="ListaDetalles" width=90%  align=center border=1 cellspacing=0 cellpadding=0>
-->

      			<tr class="FuenteCabeceraTabla">
      				 <td nowrap>&nbsp;Responsable</td>
     			     <td align=center nowrap>Documento</td>
     			     <td nowrap align=center>Nº</td>
     			     <td align=center nowrap>Moneda</td>
     			     <td nowrap align=right>Monto $</td>
     			     <td nowrap align=right>Monto US$</td>
     			     <td nowrap align=right>Paridad</td>
     			     <td nowrap>Cliente</td>
     			     <td nowrap align=center>Emisión</td>
     			     <td nowrap align=center>Vencimiento</td>
     			     <td nowrap>Banco</td>
     			     <td nowrap  align=right width=5%>Nº CIN&nbsp;</td>
	           </tr>
	           <%
				sql="DOV_Detalle_Documentos_en_cierre '" & session("empresa_usuario") & "', " & trim(Responsable)  & ", " & FechaDesde & ", " & FechaHasta
	           set rs=conn.Execute(sql)
	           'Response.Write(sql)
	           i=0
	           total_moneda=0
	           total_documento=0
	           total_monedaUS=0
	           total_documentoUS=0

	           general_moneda=0
	           general_documento=0
	           general_monedaUS=0
	           general_documentoUS=0
			if Not Rs.Eof then
	           do while not rs.eof
				moneda=trim(rs("Moneda_documento"))
				Documento_valorizado=trim(rs("Documento_valorizado"))
                momto = 0
                montoUs = 0
                if false then
                if trim(rs("Moneda_documento")) = "$" then
					monto=rs("MNL")
                    decimales = 0
  				    total_moneda=clng(total_moneda) + clng(monto)
	  			    total_documento=clng(total_documento) + clng(monto)
				else
					montoUS=rs("US$")
                    decimales = 2
		  		    total_monedaUS = cdbl(total_monedaUS) + cdbl(montoUS)
			  	    total_documentoUS = cdbl(total_documentoUS) + cdbl(montoUS)
				end if
                end if
				Paridad =rs("Paridad")

				monto=rs("MNL")
				montoUS=rs("US$")
  				total_moneda=clng(total_moneda) + clng(monto)
	  			total_documento=clng(total_documento) + clng(monto)
		  		total_monedaUS = cdbl(total_monedaUS) + cdbl(montoUS)
			  	total_documentoUS = cdbl(total_documentoUS) + cdbl(montoUS)

  				general_moneda=clng(general_moneda) + clng(monto)
	  			general_documento=clng(general_documento) + clng(monto)
		  		general_monedaUS = cdbl(general_monedaUS) + cdbl(montoUS)
			  	general_documentoUS = cdbl(general_documentoUS) + cdbl(montoUS)

				%>
      			<tr class="FuenteInput">
					<td nowrap>&nbsp;<%=rs("Responsable")%></td>
					<td nowrap align=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>"><%=rs("Documento_valorizado")%></td>
					<td nowrap align=right><input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=rs("Numero_documento_valorizado")%>"><%=rs("Numero_documento_valorizado")%></td>
					<td nowrap align=center><input type=hidden name="Moneda_documento<%=i%>" value="<%=rs("Moneda_documento")%>"><%=rs("Moneda_documento")%></td>
					<td nowrap align=right><input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(Monto,0)%></td>
                    <% if cDbl( MontoUS ) > 0 then %>
					<td nowrap align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>"><%=formatnumber(MontoUS,2)%></td>
                    <% else %>
					<td nowrap align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>">&nbsp;</td>
                    <% end if %>
                    <% if cDbl( Paridad ) > 1 then %>
					<td nowrap align=right><input type=hidden name="Paridad<%=i%>" value="<%=Paridad%>"><%=formatnumber(Paridad,2)%></td>
                    <% else %>
					<td nowrap align=right><input type=hidden name="Paridad<%=i%>" value="<%=Paridad%>">&nbsp;</td>
                    <% end if %>
					<td nowrap ><input type=hidden name="Cliente<%=i%>" value="<%=rs("Cliente")%>"><%=rs("Nombre_Cliente")%>&nbsp;</td>
					<td nowrap align=center><input type=hidden name="Emision<%=i%>" value="<%=rs("Emision")%>"><%if rs("Emision") <> "01/01/1900" then Response.Write(rs("Emision")) end if%>&nbsp;</td>
					<td nowrap align=center><input type=hidden name="Vencimiento<%=i%>" value="<%=rs("Vencimiento")%>"><%if rs("Vencimiento") <> "01/01/1900" then Response.Write(rs("Vencimiento")) end if%>&nbsp;</td>
					<td nowrap ><input type=hidden name="Banco<%=i%>" value="<%=rs("Banco")%>"><%=rs("Banco")%>&nbsp;</td>
					<td nowrap align=right><%=rs("Numero_comprobante_de_ingreso")%>&nbsp;</td>
				</tr>	
				<%	rs.movenext
					if not rs.eof then
						if Documento_valorizado <>trim(rs("Documento_valorizado")) then
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,0)%></td>
                                <% if cDbl( total_documentoUS ) > 0 then %>
      							<td align=right><%=formatnumber(total_documentoUS,2)%></td>
                                <% else %>
      							<td >&nbsp;</td>
                                <% end if %>
      							<td colspan=6>&nbsp;</td>
							</tr>	
							<%
                                total_documento=0
                                total_documentoUS=0
						end if
						if moneda <>trim(rs("Moneda_documento")) then
							%>
                            <!--
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total</td>
      							<td align=right><%=formatnumber(total_moneda,0)%></td>
                                <% if cDbl( total_monedaUS ) > 0 then %>
      							<td align=right><%=formatnumber(total_monedaUS,2)%></td>
                                <% else %>
      							<td >&nbsp;</td>
                                <% end if %>
      							<td colspan=6>&nbsp;<input type=hidden name="total$" value="<%=total_moneda%>"></td>
							</tr>	
                            -->
							<%
                                total_moneda=0
                                total_monedaUS=0
						end if
					else
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,0)%></td>
      							<td align=right><%=formatnumber(total_documentoUS,2)%></td>
      							<td colspan=6>&nbsp;</td>
							</tr>	
                            <!--
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total moneda</td>
      							<td align=right><%=formatnumber(total_moneda,0)%></td>
      							<td align=right><%=formatnumber(total_monedaUS,2)%></td>
      							<td colspan=6>&nbsp;<input type=hidden name="totalUS$" value="<%=total_moneda%>"></td>
							</tr>	
                            -->
							<%
							total_documento=0
							total_moneda=0
							total_documentoUS=0
							total_monedaUS=0
					end if
	           loop
	           rs.close
	           set rs=nothing %>
      			<tr class="FuenteCabeceraTabla">
      				<td colspan=4>Total general</td>
      				<td align=right><%=formatnumber(general_documento,0)%></td>
      				<td align=right><%=formatnumber(general_documentoUS,2)%></td>
      				<td colspan=6>&nbsp;</td>
				</tr>	
                <%
			else %>
      			<tr class="FuenteInput">
					<td colspan=9>No se encontraron detalles de cobros.&nbsp;</td>
				</tr>
		<%	end if %>
<!-- Termino Detalle de cobros 
			</table>
-->


<!-- Inicio Detalle de documentos de venta 
		<table width=90% align=center border=0 cellspacing=0 cellpadding=0 >
-->
			<tr>
				<td colspan=9 width=100% class="FuenteTitulosFunciones" align=left nowrap>Detalles documentos de ventas</td> 
			</tr>
<!-- Inicio Detalle de documentos de venta 
		</table>
			<table Name="ListaDetalles" Id="ListaDetalles" width=90%  align=center border=1 cellspacing=0 cellpadding=0>
-->
      			<tr class="FuenteCabeceraTabla">
					 <td nowrap>&nbsp;Responsable</td>
     			     <td align=center nowrap>Documento</td>
     			     <td nowrap align=center>Nº</td>
     			     <td align=center nowrap>Moneda</td>
     			     <td nowrap align=right>Monto</td>
     			     <td nowrap>Cliente</td>
     			     <td nowrap align=center>Emisión</td>
     			     <td nowrap align=center>Vencimiento</td>
     			     <td nowrap>Banco</td>
     			     <td nowrap colspan=3 align=right>Imp.Fiscal</td>
	           </tr>
	           <%
				sql="DOV_Detalle_Documentos_de_venta_en_cierre '" & session("empresa_usuario") & "', " & trim(Responsable)  & ", " & FechaDesde & ", " & FechaHasta
	           set rs=conn.Execute(sql)
	           'Response.Write(sql)
	           i=0
	           total_moneda=0
	           total_documento=0
	           total_monedaGRL=0
	           total_documentoGRL=0
			if Not Rs.Eof then
	           do while not rs.eof
				moneda=trim(rs("Moneda_documento"))
				Documento_valorizado=trim(rs("Documento_valorizado"))
				if trim(rs("Moneda_documento")) = "$" then
					monto=rs("MNL")
                    decimales = 0
				    total_moneda=clng(total_moneda) + clng(monto)
				    total_documento=clng(total_documento) + clng(monto)
				    total_monedaGRL=clng(total_monedaGRL) + clng(monto)
				    total_documentoGRL=clng(total_documentoGRL) + clng(monto)
				else
					monto=rs("US$")
                    decimales = 2
				    total_moneda=cdbl(total_moneda) + cdbl(monto)
				    total_documento=cdbl(total_documento) + cdbl(monto)
				    total_monedaGRL=clng(total_monedaGRL) + clng(monto)
				    total_documentoGRL=clng(total_documentoGRL) + clng(monto)
				end if


                ImpFiscal = ""
				if Ucase(Trim(rs("Documento_valorizado"))) = "BOV" then
				    ImpFiscal = Rs("ImpFiscal")
    				    if IsNull(ImpFiscal) then ImpFiscal = "Manual"
    				    if len(trim(ImpFiscal)) = 0 then ImpFiscal = "Manual"
				end if
				%>
      			<tr class="FuenteInput">
					<td nowrap>&nbsp;<%=rs("Responsable")%></td>
					<td nowrap align=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>"><%=rs("Documento_valorizado")%></td>
					<td nowrap align=center><input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=rs("Numero_documento_valorizado")%>"><%=rs("Numero_documento_valorizado")%></td>
					<td nowrap align=center><input type=hidden name="Moneda_documento<%=i%>" value="<%=rs("Moneda_documento")%>"><%=rs("Moneda_documento")%></td>
					<td nowrap align=right><input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(Monto,decimales)%></td>
					<td nowrap	><input type=hidden name="Cliente<%=i%>" value="<%=rs("Cliente")%>"><%=rs("Nombre_Cliente")%>&nbsp;</td>
					<td nowrap align=center><input type=hidden name="Emision<%=i%>" value="<%=rs("Emision")%>"><%if rs("Emision") <> "01/01/1900" then Response.Write(rs("Emision")) end if%>&nbsp;</td>
					<td nowrap align=center><input type=hidden name="Vencimiento<%=i%>" value="<%=rs("Vencimiento")%>"><%if rs("Vencimiento") <> "01/01/1900" then Response.Write(rs("Vencimiento")) end if%>&nbsp;</td>
					<td nowrap	><input type=hidden name="Banco<%=i%>" value="<%=rs("Banco")%>"><%=rs("Banco")%>&nbsp;</td>
					<td nowrap colspan=3 align=right><%=ImpFiscal%>&nbsp;</td>
				</tr>	
				<%	rs.movenext
					if not rs.eof then
						if Documento_valorizado <>trim(rs("Documento_valorizado")) then
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,decimales)%></td>
      							<td colspan=7>&nbsp;</td>
							</tr>	
                            <%if trim(rs("Documento_valorizado"))="NCV" then%>
          						<tr class="FuenteCabeceraTabla">
          							<td colspan=4>Total documentos venta sin NCV</td>
          							<td align=right><%=formatnumber(total_moneda,decimales)%></td>
          							<td colspan=7>&nbsp;</td>
    							</tr>	
                            <%end if%>
							<%total_documento=0
						end if
						if moneda <>trim(rs("Moneda_documento")) then
							%>
                            <!--
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total moneda</td>
      							<td align=right><%=formatnumber(total_moneda,decimales)%></td>
      							<td colspan=7>&nbsp;<input type=hidden name="total$" value="<%=total_moneda%>"></td>
							</tr>	
                            -->
							<%total_moneda=0
						end if
					else
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,decimales)%></td>
      							<td colspan=7>&nbsp;</td>
							</tr>	
                            <!--
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=4>Total moneda</td>
      							<td align=right><%=formatnumber(total_moneda,decimales)%></td>
      							<td colspan=7>&nbsp;<input type=hidden name="totalUS$" value="<%=total_moneda%>"></td>
							</tr>	
                            -->
							<%
							total_documento=0
							total_moneda=0
					end if
	           loop
	           rs.close
	           set rs=nothing
            %>
          		<tr class="FuenteCabeceraTabla">
          			<td colspan=4>Total general</td>
          			<td align=right><%=formatnumber(total_documentoGRL,0)%></td>
          			<td colspan=6>&nbsp;</td>
    			</tr>	
            <%
			else %>
      			<tr class="FuenteInput">
					<td colspan=9>No se encontraron detalles de documentos de ventas.&nbsp;</td>
				</tr>
		<%	end if %>
			</table>
<!-- Termino Detalle de documentos de venta -->
		</form>
	</body>
<%
	Conn.Close
	Set Conn = Nothing
%>
<%else
	Response.Redirect "../../index.htm"
end if%>
	<script language="JavaScript">
		maximizeWin()
	</script>
</html>

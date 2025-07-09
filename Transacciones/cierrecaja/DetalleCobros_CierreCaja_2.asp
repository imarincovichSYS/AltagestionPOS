<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap>Cierre de caja con detalle de cobros</td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="Save_CierreCaja.asp" target="Trabajo">
			<table width=70% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Usuario</td>
					<td nowrap width=50% align=left >
						<input type=hidden name="anterior" value="<%=request("anterior")%>">
						<input name="login" value="<%=session("login")%>" size="12" type=text readonly class="datooutput" >
						<input name="Nombre_usuario" value="<%=session("nombre_usuario")%>" size=35 type=text readonly class="datooutput" >
					</td>
				</tr>
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left ><%=Fecha_cierre_anterior%>Fecha y hora cierre caja anterior</td>
					<td nowrap width=50% align=left >
						<input Class="DatoOutput" readonly type=Text name="Fecha_cierre_anterior" size=16 value="<%=Fecha_cierre_anterior%>" >
					</td>
				</tr>    
				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha y hora cierre caja solicitado</td>
					<td nowrap width=50% align=left >
						<input Class="DatoOutput" readonly type=Text name="Fecha_cierre_solicitado" size=16 value="<%=Fecha_cierre_solicitado%>" >
					</td>
				</tr>    
			</table>
			<br>
			<table Name="ListaDetalles" Id="ListaDetalles" width=95%  align=center border=1 cellspacing=0 cellpadding=0>
      			<tr class="FuenteCabeceraTabla">
     			     <td align=center nowrap width=3%>Documento</td>
     			     <td nowrap align=right width=5%>Número&nbsp;</td>
     			     <td align=center nowrap width=3%>Moneda</td>
     			     <td nowrap align=right width=5%>Monto $&nbsp;</td>
     			     <td nowrap align=right width=5%>Monto US$&nbsp;</td>
     			     <td nowrap align=right width=5%>Dolar&nbsp;</td>
     			     <td nowrap  width=10%>&nbsp;Cliente</td>
     			     <td nowrap  width=5%>&nbsp;Vencimiento</td>
     			     <td nowrap  width=5%>&nbsp;Banco</td>
     			     <td nowrap  align=right width=5%>Nº CIN&nbsp;</td>
     			     <!--<td nowrap  width=5%>Última Bodega</td>-->
	           </tr>
	           <%
	           if request("anterior") <> "S" then
					sql="DOV_Detalle_Documentos_a_cerrar '" & session("empresa_usuario") & "','" & trim(session("login")) & "'"
				else
					sql="DOV_Detalle_Documentos_ultimo_cierre '" & session("empresa_usuario") & "','" & trim(session("login")) & "'"
				end if
	           'response.end
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
	           do while not rs.eof
	           decimales = 0
				moneda=trim(rs("Moneda_documento"))
				Documento_valorizado=trim(rs("Documento_valorizado"))
				if trim(rs("Moneda_documento")) = "$" then
					monto=rs("MNL")
				else
					montoUS=rs("US$")
					decimales = 2
				end if
				if rs("documento_valorizado") = "EFE" then
					monto = cdbl(monto) * (+1)
				end if
					monto=rs("MNL")
					montoUS=rs("US$")

				total_moneda=cdbl(total_moneda) + cdbl(monto)
				total_documento=cdbl(total_documento) + cdbl(monto)
				total_monedaUS=cdbl(total_monedaUS) + cdbl(montoUS)
				total_documentoUS=cdbl(total_documentoUS) + cdbl(montoUS)

				general_moneda=cdbl(general_moneda) + cdbl(monto)
				general_documento=cdbl(general_documento) + cdbl(monto)
				general_monedaUS=cdbl(general_monedaUS) + cdbl(montoUS)
				general_documentoUS=cdbl(general_documentoUS) + cdbl(montoUS)
				%>
      			<tr class="FuenteEncabezados">
					<td nowrap aalign=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>"><%=rs("Nombre")%>(<%=rs("Documento_valorizado")%>)</td>
					<td nowrap align=right><input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=rs("Numero_documento_valorizado")%>"><%=rs("Numero_documento_valorizado")%></td>
					<td nowrap align=center><input type=hidden name="Moneda_documento<%=i%>" value="<%=rs("Moneda_documento")%>"><%=rs("Moneda_documento")%></td>
					<td nowrap align=right><input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(Monto,0)%></td>
                    <% if cDbl(MontoUS) > 0 then %>
					<td nowrap align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>"><%=formatnumber(MontoUS,2)%></td>
                    <% else %>
					<td nowrap align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>">&nbsp;</td>
                    <% end if %>

                    <% if cDbl(rs("Paridad")) > 1 then %>
					<td nowrap align=right><input type=hidden name="Dolar<%=i%>" value="<%=Dolar%>"><%=formatnumber(rs("Paridad"),2)%></td>
                    <% else %>
					<td nowrap align=right><input type=hidden name="Dolar<%=i%>" value="<%=Dolar%>">&nbsp;</td>
                    <% end if %>
					<td nowrap ><input type=hidden name="Cliente<%=i%>" value="<%=rs("Cliente")%>"><%=rs("Nombre_Cliente")%>&nbsp;</td>
					<td nowrap ><input type=hidden name="Vencimiento<%=i%>" value="<%=rs("Vencimiento")%>"><%if rs("Vencimiento") <> "01/01/1900" then Response.Write(rs("Vencimiento")) end if%>&nbsp;</td>
					<td nowrap ><input type=hidden name="Banco<%=i%>" value="<%=rs("Banco")%>"><%=rs("Banco")%>&nbsp;</td>
					<td nowrap align=right><%=rs("Numero_comprobante_de_ingreso")%>&nbsp;</td>
					<!--<td nowrap ><input type=hidden name="Bodega<%=i%>" value="<%=rs("Bodega")%>"><%=rs("Bodega")%>&nbsp;</td>-->
				</tr>	
				<%	rs.movenext
					if not rs.eof then
						if Documento_valorizado <>trim(rs("Documento_valorizado")) then
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=3>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,0)%></td>
                                <% if cDbl(total_documentoUS) > 0 then %>
      							<td align=right><%=formatnumber(total_documentoUS,2)%></td>
                                <% else %>
      							<td>&nbsp;</td>
                                <% end if %>
      							<td colspan=6>&nbsp;</td>
							</tr>	
							<%
                               total_documento=0
                               total_documentoUS=0
						end if
						if moneda <>trim(rs("Moneda_documento")) then
							%>
							<%
                                total_moneda=0
                                total_monedaUS=0
						end if
					else
							%>
      						<tr class="FuenteCabeceraTabla">
      							<td colspan=3>Total documento</td>
      							<td align=right><%=formatnumber(total_documento,0)%></td>
      							<td align=right><%=formatnumber(total_documentoUS,2)%></td>
      							<td colspan=6>&nbsp;</td>
							</tr>	
							<%
							total_documento=0
							total_moneda=0
							total_documentoUS=0
							total_monedaUS=0
					end if
	           loop
	           rs.close
	           set rs=nothing%>
      			<tr class="FuenteCabeceraTabla">
      				<td colspan=3>Total</td>
      				<td align=right><%=formatnumber(general_documento,0)%></td>
      				<td align=right><%=formatnumber(general_documentoUS,2)%></td>
      				<td colspan=6>&nbsp;</td>
				</tr>	
			</table>
		</form>
	</body>
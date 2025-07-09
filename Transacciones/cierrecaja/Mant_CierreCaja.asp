<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
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
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

    Fecha_cierre_solicitado=now()
	sql="exec CIC_datos_ultimo_cierre '" & session("empresa_usuario") & "','" & session("login") & "'"
'	Response.Write(sql)
	set rs=conn.Execute(sql)
	if not rs.eof then
			if request("anterior")="S" then
					Fecha_cierre_anterior=rs("Fecha_cierre_anterior")
					Fecha_cierre_solicitado=rs("Fecha_cierre_actual")
			else
				Fecha_cierre_anterior=rs("Fecha_cierre_actual")
			end if
	else
		Fecha_cierre_anterior=""
	end if
	rs.close
	set rs=nothing
	empresa=session("empresa_usuario")
%>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="DetalleCobros_CierreCaja.asp" target="Trabajo">
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
					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha y hora cierre caja anterior</td>
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
			<table Name="ListaDetalles" Id="ListaDetalles" width=60%  align=center border=1 cellspacing=0 cellpadding=0>
      			<tr class="FuenteCabeceraTabla">
     			     <td align=center nowrap width=10%>Documento</td>
     			     <td align=center nowrap width=5%>Moneda</td>
     			     <td nowrap align=right width=10%>Monto $</td>
     			     <td nowrap align=right width=10%>Monto US$</td>
     			     <td nowrap align=right width=5%>Cantidad documentos</td>
	           </tr>
	           <%
	           if request("Anterior")= "S" then
				sql="DOV_Documentos_ultimo_cierre '" & session("empresa_usuario") & "','" & trim(session("login")) & "'"
	           else
				sql="DOV_Documentos_a_cerrar '" & session("empresa_usuario") & "','" & trim(session("login")) & "'"
	           end if
	           set rs=conn.Execute(sql)
	           'Response.Write(sql)
	           i=0
	           total_moneda=0
	           total_monedaUS=0
	           general_moneda=0
	           general_monedaUS=0
             EFE = 0
             DocsEfe = 0
             do while not rs.eof
                decimales = 0
				if rs("documento_valorizado") = "EFE" then
					EFE=cdbl(rs("MNL"))
				Else
					moneda=trim(rs("Moneda_documento"))
					if trim(rs("Moneda_documento")) = "$" then
						monto=rs("MNL")
					else
						monto=rs("US$")
                        deciales = 2
            'response.write monto & "<br>"
					end if
					if rs("documento_valorizado") = "EFI" then
						monto = cdbl(monto) + cdbl(EFE)
						documento = "Efectivo(EFI)"
						documentos = ""
                        EFE = 0
					else
						documento = rs("Nombre") & "(" & rs("Documento_valorizado") & ")"
						documentos = rs("Documentos")
					end if

					monto=rs("MNL")
					montoUS=rs("US$")

					total_moneda=cdBL(total_moneda) + cdBL(monto)
					total_monedaUS=cdBL(total_monedaUS) + cdBL(montoUS)
					general_moneda=cdBL(general_moneda) + cdBL(monto)
					general_monedaUS=cdBL(general_monedaUS) + cdBL(montoUS)
					%>
      				<tr class="FuenteEncabezados">
						<td nowrap aalign=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>"><%=documento%></td>
						<td align=center><input type=hidden name="Moneda_documento<%=i%>" value="<%=rs("Moneda_documento")%>"><%=rs("Moneda_documento")%></td>
						<td align=right><input type=hidden name="Monto<%=i%>" value="<%=Monto%>">
                            <%=formatnumber(Monto,0)%>
                        </td>
						<td align=right><input type=hidden name="MontoUS<%=i%>" value="<%=MontoUS%>">
                            <% if cDbl(MontoUS) > 0 then %>
                            <%=formatnumber(MontoUS,2)%>
                            <% else %>
                            &nbsp;
                            <% end if %>
                        </td>
						<td align=right><input type=hidden name="Documentos<%=i%>" value="<%=rs("Documentos")%>"><%=Documentos%>&nbsp;</td>
					</tr>	
				<%	
				End if
				rs.movenext
				if not rs.eof then
					if moneda <>trim(rs("Moneda_documento")) and EFE = 0 then
						%>
      					<tr class="FuenteCabeceraTabla">
      						<td colspan=2>Total moneda</td>
      						<td align=right><%=formatnumber(total_moneda,0)%></td>
                            <% if cDbl(total_monedaUS) > 0 then %>
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
      						<td colspan=2>Total moneda</td>
      						<td align=right><%=formatnumber(total_moneda,0)%></td>
      						<td align=right><%=formatnumber(total_monedaUS,2)%></td>
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
      				<td colspan=2>Total</td>
      				<td align=right><%=formatnumber(general_moneda,0)%></td>
      				<td align=right><%=formatnumber(general_monedaUS,2)%></td>
      				<td >&nbsp;</td>
				</tr>	
			</table>
		</form>
	</body>
	


<%
	Conn.Close
	Set Conn = Nothing
%>
<%else
	Response.Redirect "../../index.htm"
end if%>

</html>

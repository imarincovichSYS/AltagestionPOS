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
	Conn.commandtimeout = 3600

    Fecha_cierre_solicitado=request("Fecha_cierre_solicitado")
	Fecha_cierre_anterior=request("Fecha_cierre_anterior")
	empresa=session("empresa_usuario")
%>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap>Detalle documentos de venta</td> 
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
			<table Name="ListaDetalles" Id="ListaDetalles" width=95%  align=center border=1 cellspacing=0 cellpadding=0>
			<%
			Sql = "Exec DOV_Detalle_Documentos_de_venta_a_cerrar '" & session("empresa_usuario") & "','" & trim(session("login")) & "'"
			Set Rs = Conn.Execute( Sql )
			i=0
			total_moneda=0
			total_documento=0
			FolioDesde = 0 
			FolioHasta = 0 
			Do while Not Rs.eof
				J = 0
				MontoRango = 0

				Moneda               = trim(rs("Moneda_documento"))
				Nombre_Documento_valorizado = trim(rs("Nombre"))
				Cliente              = trim(rs("Cliente"))
				Nombre_cliente		 = trim(rs("Nombre_cliente"))
				Documento_valorizado = trim(rs("Documento_valorizado"))
				FolioDesde			 = cDbl( Rs("Numero_documento_valorizado") )
				FolioHasta			 = cDbl( Rs("Numero_documento_valorizado") )
				Bodega				 = Rs("Bodega")
				Vencimiento			 = Rs("Vencimiento")
Tipo_de_boleta = Rs("Tipo_de_boleta")
Numero_impresora_fiscal = Rs("Numero_impresora_fiscal")

				
				if i = 0 then %>
					<tr class="FuenteCabeceraTabla">
						<td align=center nowrap width=3%>Documento</td>
						<td nowrap align=right width=5% >Desde</td>
						<td nowrap align=right width=5% >Hasta</td>
						<td align=center nowrap width=3%>Moneda</td>
						<td nowrap align=right width=5% >Monto</td>
						<td nowrap  width=10%           >Cliente</td>
						<td nowrap  width=5%		    >Vencimiento</td>
						<td nowrap  width=5%	        >Bodega</td>
						<td nowrap  width=5%	        >Tipo&nbsp;boleta</td>
						<td nowrap  align=right width=5%	        >Imp.Fiscal</td>
					</tr>
			<%	end if %>
			<%	j = 0
				if Trim(Documento_valorizado) = "BOV" then
					Do While Trim(Documento_valorizado) = TRim(Rs("Documento_valorizado")) 
						if len(trim(Estado_para_SII_anterior)) = 0 then
							Estado_para_SII_anterior	= Rs("Estado_para_SII")
						else
							Estado_para_SII_anterior	= Estado_para_SII
						end if
						Estado_para_SII				= Rs("Estado_para_SII")
						if Estado_para_SII = "S" then
							FolioHasta		= cDbl(Rs("Numero_documento_valorizado"))
							if FolioDesde+j = FolioHasta then
								if Trim(rs("Moneda_documento")) = "$" then
									Monto = Rs("MNL")
								else
									Monto = Rs("US$")
								end if
								MontoRango = MontoRango + cDbl(Monto)
							else
								FolioHasta = FolioDesde+(j-1)
								exit do
							end if
							Rs.MoveNext
							j = j + 1
							if Rs.Eof then
								exit do
							end if
						else
							FolioNulo = cDbl(Rs("Numero_documento_valorizado"))
							Rs.MoveNext
							exit do
						end if
					Loop
				else
				    Estado_para_SII	= Rs("Estado_para_SII")
				    Estado_para_SII_anterior = Rs("Estado_para_SII")
                	if Trim(Estado_para_SII) = "S" then
						if Trim(rs("Moneda_documento")) = "$" then
							Monto = Rs("MNL")
						else
							Monto = Rs("US$")
						end if
						MontoRango = MontoRango + cDbl(Monto)
					else
    					FolioNulo = cDbl(Rs("Numero_documento_valorizado"))
					end if
					Rs.MoveNext					
				end if
				i = 0
				total_moneda    = cdbl(total_moneda) + cdbl(MontoRango)
				total_documento = cdbl(total_documento) + cdbl(MontoRango)

				
				if Trim(Estado_para_SII) = "S" Or Estado_para_SII_anterior = "S" then
                    if Documento_valorizado = "BOV" Then %>
          				<tr class="FuenteEncabezados">
    						<td nowrap aalign=center><input type=hidden name="Documento_valorizado<%=i%>" value="<%=Documento_valorizado%>"><%=Nombre_Documento_valorizado%>(<%=Documento_valorizado%>)</td>
    						<td nowrap align=right	>
    							<input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=FolioDesde%>">
    							<%=FolioDesde%>
    						</td>
    						<td nowrap align=right	>
    							<input type=hidden name="Hasta_Numero_documento_valorizado<%=i%>" value="<%=FolioHasta%>">
    							<%=FolioHasta%>
    						</td>
    						<td nowrap align=center	>
    							<input type=hidden name="Moneda_documento<%=i%>" value="<%=Moneda%>"><%=Moneda%>
    						</td>
    						<td nowrap align=right	>
    							<input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(MontoRango,0)%>
    						</td>
    						<td nowrap				>
    							<input type=hidden name="Cliente<%=i%>" value="<%=Cliente%>"><%=Nombre_Cliente%>&nbsp;
    						</td>
    						<td nowrap				>
    							<input type=hidden name="Vencimiento<%=i%>" value="<%=Vencimiento%>"><%if Vencimiento <> "01/01/1900" then Response.Write( Vencimiento ) end if%>&nbsp;
    						</td>
    						<td nowrap				>
    							<input type=hidden name="Bodega<%=i%>" value="<%=Bodega%>"><%=Bodega%>&nbsp;
    						</td>
    						<td nowrap align=center				><%=Tipo_de_boleta%></td>
    						<td nowrap align=right				><%=Numero_impresora_fiscal%></td>
    					</tr>	
    			<%	else%>
          				<tr class="FuenteEncabezados">
    						<td nowrap aalign=center>
    							<input type=hidden name="Documento_valorizado<%=i%>" value="<%=Documento_valorizado%>"><%=nombre_Documento_valorizado%> (<%=Documento_valorizado%>)
    						</td>
    						<td nowrap align=right>
    							<input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=FolioHasta%>"><%=FolioHasta%>
    						</td>
    						<td nowrap align=right>&nbsp;</td>
    						<td nowrap align=center>
    							<input type=hidden name="Moneda_documento<%=i%>" value="<%=Moneda%>"><%=Moneda%>
    						</td>
    						<td nowrap align=right>
    							<input type=hidden name="Monto<%=i%>" value="<%=Monto%>"><%=formatnumber(MontoRango,0)%>
    						</td>
    						<td nowrap >
    							<input type=hidden name="Cliente<%=i%>" value="<%=Cliente%>"><%=Nombre_Cliente%>&nbsp;
    						</td>
    						<td nowrap>
    							<input type=hidden name="Vencimiento<%=i%>" value="<%=Vencimiento%>"><%if Vencimiento <> "01/01/1900" then Response.Write( Vencimiento ) end if%>&nbsp;
    						</td>
    						<td nowrap>
    							<input type=hidden name="Bodega<%=i%>" value="<%=Bodega%>"><%=Bodega%>&nbsp;
    						</td>
    						<td nowrap align=center				><%=Tipo_de_boleta%></td>
    						<td nowrap align=right				><%=Numero_impresora_fiscal%></td>

    					</tr>	
    			<%	end if
                end if 
				if Trim(Estado_para_SII) = "N" then %>
      				<tr class="DatoOutputCenter">
						<td nowrap ><input type=hidden name="Documento_valorizado<%=i%>" value="<%=Documento_valorizado%>"><%=nombre_Documento_valorizado%> (<%=Documento_valorizado%>)</td>
						<td nowrap align=right><input type=hidden name="Numero_documento_valorizado<%=i%>" value="<%=FolioNulo%>"><%=FolioNulo%></td>
						<td colspan=8 nowrap align=center>&nbsp;-- DOCUMENTO NULO ---&nbsp;</td>
					</tr>	
			<%	end if
				i = i + 1

				If Not Rs.eof then
					if Documento_valorizado <> trim(rs("Documento_valorizado")) then %>
      					<tr class="FuenteCabeceraTabla">      						
      						<td colspan=4>Total documento</td>
      						<td align=right><%=formatnumber(total_documento,0)%></td>
      						<td colspan=5>&nbsp;</td>
						</tr>	
						<%total_documento=0
					end if
					if moneda <> trim(rs("Moneda_documento")) then %>
      					<tr class="FuenteCabeceraTabla">
      						<td colspan=4>Total moneda</td>
      						<td align=right><%=formatnumber(total_moneda,0)%></td>
      						<td colspan=5>&nbsp;<input type=hidden name="total$" value="<%=total_moneda%>"></td>
						</tr>	
						<%total_moneda=0
					end if
				else %>
      				<tr class="FuenteCabeceraTabla">
      					<td colspan=4>Total documento</td>
      					<td align=right><%=formatnumber(total_documento,0)%></td>
      					<td colspan=5>&nbsp;</td>
					</tr>	
      				<tr class="FuenteCabeceraTabla">
      					<td colspan=4>Total moneda</td>
      					<td align=right><%=formatnumber(total_moneda,0)%></td>
      					<td colspan=5>&nbsp;<input type=hidden name="totalUS$" value="<%=total_moneda%>"></td>
					</tr>	
					<%
					total_documento=0
					total_moneda=0
				end if
			 	if Rs.Eof Then
			 		exit do
				end if
	        Loop
	        rs.close
	        set rs=nothing%>
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

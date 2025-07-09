<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

Const adUseClient = 3

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

	empresa=Session("empresa_usuario")
	Cuenta_contable=request("Cuenta_contable")
	Estado=request("Estado")
	Numero=request("Numero")
	Usuario=request("Usuario")
	Cliente=request("Cliente")
	Centro_de_venta=request("Centro_de_venta")
	Empleado=request("Empleado")
	Proveedor=request("Proveedor")
	Bodega=request("Bodega")
	Documento_respaldo=request("Documento_respaldo")
	Numero_documento_respaldo=request("Numero_documento_respaldo")
   Sql = "Exec	 ACO_ListaMovimientosContables " &+_
          "'"  & empresa & "'," & +_
          "'"  & Cuenta_contable & "'," & +_
          "'"  & Desde & "'," & +_
          "'"  & Hasta & "'," & +_
          "'"  & Estado & "',0" & +_
          Numero & "," & +_
          "'"  & Usuario & "'," & +_
          "'"  & Cliente & "'," & +_
          "'"  & Centro_de_venta & "'," & +_
          "'"  & Empleado & "'," & +_
          "'"  & Proveedor & "'," & +_
          "'"  & Bodega & "'," & +_
          "'"  & Documento_respaldo & "',0" & +_
          Numero_documento_respaldo
          
	session("sql")=sql

'Response.Write (sql)


	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600
'Response.Write Sql
	SET Rs	=	Conn.Execute( SQL )

%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<body>
<form name="Listado">
			<%if Not Rs.Eof then %>
				<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
					<tr class="FuenteTitulosFunciones">
						<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()"><%=session("title")%></a>&nbsp;</td>
					</tr>
					<tr height=40 class="FuenteInput">
						<td colspan=6 align=left NOWRAP >Emitido por:&nbsp;&nbsp;<b><%=Session("Nombre_Usuario")%></b></td>
						<td class="FuenteInput" align=right NOWRAP >&nbsp;<b><%=left(Now(),16)%></b>&nbsp;</td>
					</tr>

					<%if len(trim(Request("fecha_desde")))+len(trim(Request("fecha_hasta")))+len(trim(Request("Estado"))) > 0 then %>
					<tr class="FuenteInput">
						<%if len(trim(Request("Fecha_desde"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Desde</td>
						<td width=30% align=left><b><%=Request("Fecha_desde")%></b></td>
						<%end if%>
						<%if len(trim(Request("Fecha_hasta"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Hasta</td>
						<td width=30% align=left><b><%=Request("Fecha_hasta")%></b></td>
						<%end if%>
						<%if len(trim(Request("Estado"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left>Estado</td>
						<td width=30% align=left><b><% if Request("Estado") = "S" then Response.Write "Autorizado" Else Repsonse.Write "No autorizado"%></b></td>
						<%end if%>
					</tr>
					<%end if%>

					<%if len(trim(Request("Numero")))+len(trim(Request("Cuenta_contable")))+len(trim(Request("Usuario"))) > 0 then %>
					<tr>
						<%if len(trim(Request("NUmero"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Número</td>
						<td width=30% align=left><b><%=Request("NUmero")%></b></td>
						<%end if%>
						<%if len(trim(Request("Cuenta_contable"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Cuenta contable</td>
						<td width=30% align=left><b><%=Request("Cuenta_contable")%></b></td>
						<%end if%>
						<%if len(trim(Request("Usuario"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Usuario</td>
						<td width=30% align=left><b><%=Request("Usuario")%></b></td>
						<%end if%>
					</tr>
					<%end if%>

					<%if len(trim(Request("Cliente")))+len(trim(Request("Centro_de_venta")))+len(trim(Request("Empleado"))) > 0 then %>
					<tr>
						<%if len(trim(Request("Cliente"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Cliente</td>
						<td width=30% align=left><b><%=Request("Cliente")%></b></td>
						<%end if%>
						<%if len(trim(Request("Centro_de_venta"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Centro de venta</td>
						<td width=30% align=left><b><%=Request("Centro_de_venta")%></b></td>
						<%end if%>
						<%if len(trim(Request("Empleado"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left >Empleado</td>
						<td width=30% align=left><b><%=Request("Empleado")%></b></td>
						<%end if%>
					</tr>
					<%end if%>

					<%if len(trim(Request("Proveedor")))+len(trim(Request("Bodega")))+len(trim(Request("Documento_respaldo"))) > 0 then %>
					<tr>
						<%if len(trim(Request("Proveedor"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left ><b>Proveedor</b></td>
						<td width=30% align=left><%=Request("Proveedor")%></td>
						<%end if%>
						<%if len(trim(Request("Bodega"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left ><b>Bodega</b></td>
						<td width=30% align=left><%=Request("Bodega")%></td>
						<%end if%>
						<%if len(trim(Request("Documento_respaldo"))) > 0 then%>
						<td nowrap class="FuenteInput" width=10% align=left ><b>Documento respaldo</b></td>
						<td width=30% align=left><%=Request("Documento_respaldo")%> - <%=Request("Numero_Documento_respaldo")%></td>
						<%end if%>
					</tr>
					<%end if%>

				</table>
				
				<table width="95%" border=1 align=center cellpadding=0 cellspacing=0><thead>
					<tr  class="FuenteEncabezados">
						<td  align=right width=5% NOWRAP >Número</td>
						<td  width=30% >Cta. cble.</td>
						<td  width=5% NOWRAP >Fecha</td>
						<td  align=center width=5%  NOWRAP >Estado</td>
						<td  width=5%  NOWRAP >Cliente</td>
						<td  width=5%  NOWRAP >Centro venta</td>
						<td  width=5%  NOWRAP >Proveedor</td>
						<td  width=5%  NOWRAP >Bodega</td>
						<td  width=5%  NOWRAP >Empleado</td>
						<td  width=5%  NOWRAP >Usuario</td>
						<td  width=5%  colspan=2 NOWRAP >Docto.respaldo</td>
						<td  width=10% NOWRAP align=right>Debe</td>
						<td  width=10% NOWRAP align=right>Haber</td>
					</tr>
			<%		i=0
					do while not rs.EOF
							%>
							<tr class="FuenteInput">
								<td valign=top NOWRAP align=right><%=rs("Numero_documento_no_valorizado")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Cuenta_contable")%><br><%=rs("Nombre_CuentaContable")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=mid(rs("Fecha_asiento"),1,10)%></td>
								<td valign=top NOWRAP align=center >
									<% if rs("Estado_autorizado_asiento") = "S" Then Response.Write "Autorizado" Else Response.Write "No Autorizado"%>
								</td>
								<td valign=top NOWRAP ><%=rs("Cliente")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Centro_de_venta")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Proveedor")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Bodega")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Empleado_responsable")%>&nbsp;</td>
								<td valign=top NOWRAP ><%=rs("Usuario_creacion")%>&nbsp;</td>
								<td valign=top NOWRAP align=center ><%=rs("Documento_respaldo")%>&nbsp;</td>
								<td valign=top NOWRAP align=right><%=rs("Numero_Documento_respaldo")%>&nbsp;</td>
								<td valign=top NOWRAP align=right><%=formatnumber(rs("Monto_debe"),0)%></td>
								<td valign=top NOWRAP align=right><%=formatnumber(rs("Monto_haber"),0)%></td>
							</tr>
						<%	rs.MoveNext
						i=i+1
					loop
					%>
				</table>

			<script language="JavaScript">
					this.window.focus();
					//printPage();
					function printPage()
					{
						if (window.print)
						{
							window.print();
						}
						else
						{
							Mensajes ("Este browser no soporta impresión en modo automático, solamente en modo manual CTRL+P.");
						}
					}
			</script>
				
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
</form>
</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
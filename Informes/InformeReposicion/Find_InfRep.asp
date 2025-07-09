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
	Conn.commandtimeout=600
%>

<html>

<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Listado" method="post" action="List_InfRep.asp" target="Listado">
			<table width=99% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteInput">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Empresa</td>
					<td align=left>
					     <select style="width:150" class="fuenteinput" name="Empresa">
						<%	Sql = "Exec EMP_ListaEmpresas '" & Session("empresa_usuario") & "', Null, Null"  
							SET Rs	=	Conn.Execute( SQL ) 
							if len(trim(Session("empresa_usuario"))) = 0 then  %>
								<option value=''></option>
						<%	end if %>
						<%	Do while not rs.eof%>
								<option value='<%=trim(rs("Empresa"))%>'><%=rs("Nombre")%></option>
						<%		Rs.movenext
							Loop
							rs.close
							set rs=nothing%>
					     </select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Salida</td>
					<td align=left>
					     <select style="width:150" class="fuenteinput" name="Salida">
							<option value="A">Archivo</option>
							<option value="I">Impresora</option>
							<option selected value="P">Pantalla</option>
					     </select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Medida</td>
					<td align=left>
					     <select style="width:150" class="fuenteinput" name="Medida">
							<option value=""></option>
							<option value="U">Unidades</option>
							<option value="C">Cajas</option>
					     </select>
					</td>
				</tr>
				
				<tr class="FuenteInput">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Bodega origen</td>
					<td align=left>
					     <select style="width:150" class="fuenteinput" name="BodegaOrigen">
					     <option value=""></option>
	                    	     <%Sql = "Exec HAB_ListaBodega '" & session("empresa_usuario") & "'"  
	                    	     SET Rs	=	Conn.Execute( SQL ) %>
	                    	     <%do while not rs.eof%>
	                    	          <option value='<%=trim(rs("Bodega"))%>'><%=rs("Descripcion_breve")%>&nbsp;(<%=trim(rs("Bodega"))%>)</option>
	                    	          <%rs.movenext
	                    	     loop
	                    	     rs.close
	                    	     set rs=nothing%>
					     </select>
					</td>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Bodega destino</td>
					<td align=left>
					     <select style="width:150" class="fuenteinput" name="BodegaDestino">
					     <option value=""></option>
	                    	     <%Sql = "Exec HAB_ListaBodega '" & session("empresa_usuario") & "'"  
	                    	     SET Rs	=	Conn.Execute( SQL ) %>
	                    	     <%do while not rs.eof%>
	                    	          <option value='<%=trim(rs("Bodega"))%>'><%=rs("Descripcion_breve")%>&nbsp;(<%=trim(rs("Bodega"))%>)</option>
	                    	          <%rs.movenext
	                    	     loop
	                    	     rs.close
	                    	     set rs=nothing%>
					     </select>
					</td>
				</tr>
			</table>
		</form>
		
		<iframe id="Paso" name="Paso" width=0 height=0 src="../../empty.asp"></iframe>
		
	</body>
</html>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

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

	cSql = "Exec PAR_ListaParametros 'PCTGEIVA'"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then	
		Iva = cDbl("0" & Rs("Valor_numerico"))
	else
		Iva = 19
	end if
	Rs.Close
	Set Rs = Nothing

	Bodega	= Request("Bodega")
	Cliente = Request("Cliente")
	
	NroOrdVta = Replace(Request("NroOrdVta"),"Nueva","")
	Total	  = 0
	TotalLineaIngresadas = 0
	if len(trim(NroOrdVta)) = 0 then 
		NroOrdVta = "Nueva"
		ProximoNroLinea = 1
	else	
		cProductos = "¬"		
		ProximoNroLinea = 1
		cSql = "Exec MOP_ListaMovimientosProductos Null, Null, '" & Session("Empresa_usuario") & "', 'OVT', " & NroOrdVta & ", Null, Null"
		Set Rs = Conn.Execute ( cSql )
		if Not Rs.Eof then
			Bodega = Rs("Bodega")
			Cliente = Rs("Cliente")
			Do While Not Rs.Eof
				cProductos = cProductos & Rs("Producto") & "¬"
				Total = Total + cDbl("0" & Rs("Total") )
				TotalLineaIngresadas = TotalLineaIngresadas + 1
				ProximoNroLinea = cDbl(Rs("Numero_de_linea")) + 1
				Rs.MoveNext
			Loop
		end if
		Rs.Close
		Set Rs = Nothing
	end if
	
	if len(trim(Cliente)) = 0 then 
		Nombrecliente = "Cliente de Boleta" 
	Else
		cSql = "Exec ECP_ListaClientes '" & Session("Empresa_usuario") & "', "
		cSql = cSql & "'" & Cliente & "', Null, Null, Null, Null, Null"
		Set Rs = Conn.Execute ( cSql )
		If Not Rs.Eof then	
			Nombrecliente = Trim(Rs("Nombre"))
		else
			Nombrecliente = "Cliente de Boleta" 
		end if
		Rs.Close
		Set Rs = Nothing
	end if
	
	cntLineas = 1
	
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=100% align=left border=0 cellspacing=0 cellpadding=0 >
				<tr CLASS=FuenteTitulosFunciones>
					<td>ORDEN DE VENTA - <%=NroOrdVta%></td>
				</tr>
				<tr CLASS=FuenteInputEtiquetasDatos><td>CLIENTE: <%=Nombrecliente%></td></tr>
				<tr CLASS=FuenteInput><td>&nbsp;</td></tr>
			</table>
			<table width=100% align=left border=0 cellspacing=0 cellpadding=0 >
				<tr class="FuenteCabeceraTabla">
					<td align=left  >&nbsp;Producto&nbsp;</td>
					<td align=center>&nbsp;Q&nbsp;</td>
					<td align=right >&nbsp;Precio&nbsp;</td>
					<td align=right >&nbsp;Stock&nbsp;</td>
					<td align=left  >&nbsp;Descripción&nbsp;
						<input type=hidden name="Lineas"		value="<%=cntLineas%>">
						<input type=hidden name="Cliente"		value="<%=Cliente%>">
						<input type=hidden name="Bodega"		value="<%=Bodega%>">
						<input type=hidden name="NuevoCliente"	value="<%=Request("NuevoCliente")%>">
						<input type=hidden name="NroOrdVta"		value="<%=NroOrdVta%>">						
						<input type=hidden name="Eliminar"		value="S">
						<input type=hidden name="TotalenOrden"	value="<%=Total%>">
						<input type=hidden name="ProximoNroLinea"	value="<%=ProximoNroLinea%>">
					</td>
				</tr>
			
		<%	For a = 1 to cntLineas
				Cantidad = Cdbl("0" & Request("Cantidad_" & a) )
				Stock	 = Cdbl("0" & Request("Stock_" & a) )
				Precio	 = Cdbl("0" & Request("Precio_" & a) )
				Precios	 = Request("Precios_" & a)
				if len(trim(Request("Descripcion_" & a))) = 0 then Descripcion = "Sin descripción" Else Descripcion = Request("Descripcion_" & a)
		%>
				<tr class="FuenteEncabezados">
					<td valign=top class="FuenteEncabezados" align=left >
						<input class="FuenteInput" type=text name="Producto_<%=a%>" size=4 maxlength=12 value="<%=Request("Producto_" & a)%>" onchange="javascript:fChequea(<%=a%>)">
						<input type=hidden name="ProdOculto_<%=a%>" value="<%=Request("Producto_" & a)%>">
						<input type=hidden name="txtNumIntMovProd_<%=a%>" value="<%=Request("txtNumIntMovProd_" & a)%>">
						<input type=hidden name="txtControl<%=a%>" value="<%=Request("txtControl" & a)%>">						
					</td>
					<td valign=top class="FuenteEncabezados" align=left >
						<input class="FunteInputNumerico" type=text name="Cantidad_<%=a%>" size=3 maxlength=5 value="<%=Cantidad%>" Onchange="Javscript:fCargaPrecio(<%=a%>);fCalcular()">
					</td>
					<td valign=top class="FuenteEncabezados" align=right >
						<Span id="sPrecio_<%=a%>" class=FuenteInput>&nbsp;</span>
						<input type=hidden name="Precio_<%=a%>"  value="<%=Precio%>" >						
						<input type=hidden name="Precios_<%=a%>" value="<%=Precios%>">
					</td>
					<td valign=top class="FuenteEncabezados" align=right><Span id="sStock_<%=a%>" class=FuenteInput>&nbsp;</span>&nbsp;</td>
					<td valign=top class="FuenteEncabezados" align=left >
						<Span id="sDescripcion_<%=a%>" class=FuenteInput>&nbsp;</span>
						<input type=hidden name="Descripcion_<%=a%>"		value="<%=Descripcion%>">
						<input type=hidden name="StockDisponible_<%=a%>"	value="<%=Request("StockDisponible_" & a)%>">
						<input type=hidden name="StockReal_<%=a%>"			value="<%=Request("StockReal_" & a)%>"		>
						<input type=hidden name="StockResto_<%=a%>"			value="<%=Request("StockResto_" & a)%>"		>
						<input type=hidden name="StockTransito_<%=a%>"		value="<%=Request("StockTransito_" & a)%>"	>
					</td>
				</tr>
		<%		TotalIva = TotalIva + ( ( Total ) * (1 + (Iva/100) ) )
			Next%>
			</table>
			
			<table width=100% align=center border=0 cellspacing=5 cellpadding=0>
				<tr >
					<td class=FuenteInputEtiquetas align=right>Total líneas&nbsp;<%=TotalLineaIngresadas%>&nbsp;</td>
				</tr>
				<tr >
					<td class=FuenteInputEtiquetas align=right>
						Total&nbsp;<Span id="sTotal" class=FuenteInputDatos>&nbsp;<%=Total%></span>
						<input type=hidden name="Total" value="<%=Total%>">
					</td>
				</tr>
				<tr >
					<td class=FuenteInputEtiquetas align=right>
						Total c/Iva&nbsp;<Span id="sTotalIva" class=FuenteInputDatos>&nbsp;<%=Round(TotalIva,0)%></span>
						<input type=hidden name="TotalIva" value="<%=Round(TotalIva,0)%>">
					</td>
				</tr>

				<tr class="FuenteEncabezados">
					<td class="FuenteInput" align=left>
						<!-- <input class=FuenteBotones type=button name="btnAgrega"		value = "Nva.Lin"	Onclick="Javascript:fAgregaLinea()"> -->
						<input class=FuenteBotones type=button name="btnGrabar"		value = "Nva.Lin"		Onclick="Javascript:fGrabar()">
				<%	if NroOrdVta <> "Nueva" then %>						
						<input class=FuenteBotones type=button name="btnDetalle"	value = "Ver Detalle"	Onclick="Javascript:fVerOVT()">
				<%	end if%>
						<input class=FuenteBotones type=button name="btnCancelar"	value = "Salir"			Onclick="Javascript:fCancelar()">
					</td>
				</tr>
			</table>
		</form>
	</body>

	<script language="javascript">
	
		function fCargaPrecioDescrip()
		{
			var Lineas = document.Formulario.Lineas.value;
			var a=0;
			for (a=1;a<=Lineas;a++)
			{				
				var Precio = 0;
				var Cantidad = eval('document.Formulario.Cantidad_' + a + '.value')
				var Descripcion = eval('document.Formulario.Descripcion_' + a + '.value')
					Descripcion = replaceSubstring(Descripcion,' ','_');					
					Descripcion = replaceSubstring(Descripcion,'-','_');					
					Descripcion = replaceSubstring(Descripcion,'/','_');					
					Descripcion = "<a class=FuenteDetalleLink href=javascript:fStock("+a+")>" + Descripcion + "</a>"
				var StockDisponible = eval('document.Formulario.StockDisponible_' + a + '.value')
				var StockReal = eval('document.Formulario.StockReal_' + a + '.value')
				var Precios  = eval('document.Formulario.Precios_' + a + '.value')
					aPrecios = Precios.split('¬')
				var aDet	 = "";

				for ( var b=0;b<=aPrecios.length;b++ )
				{
					aDet = aPrecios[b].split('|') // 0 = limite ; 1 = Precio				
					if ( parseFloat(Cantidad) > parseFloat(aDet[0]) )
					{					
					}
					else
					{
						if ( parseFloat(Cantidad) != parseFloat(aDet[0]) && b > 0 )
						{
							aDet = aPrecios[b-1].split('|') // 0 = limite ; 1 = Precio				
						}
						Precio = aDet[1];
						break;
					}
				}

				eval("document.Formulario.sPrecio_" + a + ".innerHTML		= Precio");
				eval("document.Formulario.Precio_" + a + ".value			= Precio");
				eval("document.Formulario.sDescripcion_" + a + ".innerHTML	= Descripcion ");
				eval("document.Formulario.sStock_" + a + ".innerHTML		= StockDisponible ");
			}
		}

		function fVerOVT()
		{
			document.Formulario.action = "ConsultaOrden.asp?Volver=2" 
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}

		function fCargaPrecio( a )
		{
			var Precio = 0;
			var Cantidad = eval('document.Formulario.Cantidad_' + a + '.value')
			var Precios  = eval('document.Formulario.Precios_' + a + '.value')
				aPrecios = Precios.split('¬')
			var aDet	 = "";
			var PrecioAnterior = 0;
			for ( var b=0;b<aPrecios.length;b++ )
			{
				aDet = aPrecios[b].split('|') // 0 = limite ; 1 = Precio
				if ( parseFloat(Cantidad) > parseFloat(aDet[0]) )
				{					
				}
				else
				{
					if ( parseFloat(Cantidad) != parseFloat(aDet[0]) && b > 0 )
					{
						aDet = aPrecios[b-1].split('|') // 0 = limite ; 1 = Precio				
					}
					Precio = aDet[1];
					break;
				}
			}

			eval("document.Formulario.sPrecio_" + a + ".innerHTML	= Precio");
			eval("document.Formulario.Precio_" + a + ".value		= Precio");
		}

		function fStock( id )
		{
			var StockDisponible	= parseFloat(eval("document.Formulario.StockDisponible_" + id + ".value")) + 0;
			var StockReal		= parseFloat(eval("document.Formulario.StockReal_" + id + ".value")) + 0;
			var StockTransito	= parseFloat(eval("document.Formulario.StockTransito_" + id + ".value")) + 0;
			var StockResto		= parseFloat(eval("document.Formulario.StockResto_" + id + ".value")) + 0;
			alert ( "Stocks\nReal:\t\t" + StockReal + "\nResto:\t\t" + StockResto + "\nTránsito:\t" + StockTransito )
		}

		function fChequea( id )
		{
			var ValorAntiguo = eval("document.Formulario.ProdOculto_" + id + ".value");
			var ValorNuevo   = eval("document.Formulario.Producto_" + id + ".value");
			var ProductoExisten = '<%=cProductos%>';
			if ( ProductoExisten.indexOf('¬'+ValorNuevo+'¬') == -1  )
			{
				if ( ValorNuevo != ValorAntiguo )
				{
					document.Formulario.action = "Procesar.asp?Id=" + id;
					document.Formulario.target = "_top"
					document.Formulario.submit();
				}
			}
			else
			{
				alert ( 'El producto ' + ValorNuevo + ', ya se encuentra ingresado.\nReviselo con el botón Ver.Detalle.' )
			}
		}		

		function fCalcular()
		{
			var Iva = <%=Iva%>
			var Lineas = document.Formulario.Lineas.value;
			var a = 0;			
			var TotalenOrden = parseFloat(document.Formulario.TotalenOrden.value);
			var Total = TotalenOrden;
			var TotalIva = 0;
			
			for (a=1;a<=Lineas;a++)
			{
				var Cantidad = 0;
				var Precio   = 0;				
				if ( ! validEmpty(eval("document.Formulario.Producto_" + a + ".value")) )
				{
					Cantidad = parseFloat( eval("document.Formulario.Cantidad_" + a + ".value") )
					Precio	 = parseFloat( eval("document.Formulario.Precio_" + a + ".value") )
					Total	 = Total + parseFloat( Precio * Cantidad )
					TotalIva = TotalIva + ( parseFloat( Total ) * (1 + parseFloat(Iva/100) ))
				}
			}
			
			document.Formulario.sTotal.innerHTML = Total;
			document.Formulario.Total.value  = Total;
			document.Formulario.sTotalIva.innerHTML = Math.round(TotalIva) ;
			document.Formulario.TotalIva.value  = Math.round(TotalIva);
		}
			
		function fGrabar()
		{
			var Lineas = document.Formulario.Lineas.value;
			var a = 0;
			var Error = "N";
			for (a=1;a<=Lineas;a++)
			{	
				var Producto = eval("document.Formulario.Producto_" + a + ".value")
				var Cantidad = eval("document.Formulario.Cantidad_" + a + ".value")
				if ( ! validEmpty(Producto) )
				{
					if ( validaCharNoPermitidos_Txt(Producto) )
					{
						alert ( 'El producto contiene caracteres no permitidos, revise por favor.' )
						eval("document.Formulario.Producto_" + a + ".focus();")
						Error = "S";
						break;
					}
				
					if ( ! validEmpty(Cantidad) )
					{
						if ( ! validNum(Cantidad) )
						{
							alert ( 'La cantidad ingresada debe ser numérica, revise por favor.' )
							eval("document.Formulario.Cantidad_" + a + ".focus();")
							Error = "S";
							break;
						}
						else
						{
							if ( parseFloat(Cantidad) <= 0 )
							{
								alert ( 'La cantidad ingresada debe ser mayor que cero, revise por favor.' )
								eval("document.Formulario.Cantidad_" + a + ".focus();")
								Error = "S";
								break;
							}
						}
					}
					else
					{
						alert ( 'Cantidad debe ser ingresada, revise por favor.' )
						eval("document.Formulario.Cantidad_" + a + ".focus();")
						Error = "S";
						break;
					}
				}
			}

			if ( Error == 'N' )
			{
				document.Formulario.action = "Grabar.asp"
				document.Formulario.target = "_top"
				document.Formulario.submit();
			}
		}
	
		function fSeguir()
		{
			var Cliente = document.Formulario.Cliente.value
			
			if ( validEmpty(Cliente) )
			{
				alert ( 'Debe ingresar el cliente ya que es una dato requerido.' )
			}
			else
			{
				document.Formulario.action = "Mant_OrdVta.asp";
				document.Formulario.target = "_top";
				document.Formulario.submit();
			}
		}
	
		function fCancelar()
		{
			document.Formulario.action = "Main_OrdVta.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}
		
		fCargaPrecioDescrip()
		
	</script>

</html>
<% conn.close() %>
<%else
	Response.Redirect "../../index.htm"
end if%>

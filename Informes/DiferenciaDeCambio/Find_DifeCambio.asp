<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
	</head>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="../../Empty.asp" atarget="Listado">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Mes y Año</td>
					<td width=20% align=left >
						<select class="fuenteinput" name="mes">
							<%for i=1 to 12
								if cdbl(i) < 10 then
									i="0" & i
								end if%>
								<option <%if i = month(date()) then Response.write("selected ") end if %>value="<%=i%>"><%=i%></option>
							<%next%>
						</select>
						<select class="fuenteinput" name="Anno">
							<%for i=year(date)-5 to year(date)%>
								<option <%if i = year(date()) then Response.write("selected ") end if %>value="<%=i%>"><%=i%></option>
							<%next%>
						</select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Cuenta</td>
					<td align=left>
					     <select class="fuenteinput" name="Cuenta">
					     <option value=""></option>
	                    	     <%Sql = "Exec CTB_Cuentas_contables_informe_dif_cambio"  
	                    	     SET Rs	=	Conn.Execute( SQL ) %>
	                    	     <%do while not rs.eof%>
	                    	          <option value='<%=trim(rs("Cuenta_contable"))%>'><%=rs("Cuenta_contable")%>&nbsp;-&nbsp;<%=trim(rs("Nombre_Cuenta_contable"))%></option>
	                    	          <%rs.movenext
	                    	     loop
	                    	     rs.close
	                    	     set rs=nothing%>
					     </select>
					<td class="FuenteEncabezados" nowrap>Centro de venta</td>
					<td class="Fuenteinput">
						<input class='Fuenteinput' type=text name="Centro_de_venta" size=12 maxlength=12 value="">
					</td>
					</td>
				</tr>    
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Moneda</td>
					<td class="fuenteinput" align=left>
					     <select class="fuenteinput" name="Moneda">
	                    	 <%Sql = "Exec MON_ListaMonedas '','',1"  
	                    	 SET Rs	=	Conn.Execute( SQL ) %>
	                    	 <%do while not rs.eof%>
	                    	      <option value='<%=trim(rs("Moneda"))%>'><%=rs("Nombre")%></option>
	                    	      <%rs.movenext
	                    	 loop
	                    	 rs.close
	                    	 set rs=nothing%>
					     </select>
					</td>
					<td class="FuenteEncabezados" nowrap>Tipo cambio</td>
					<td class="Fuenteinput">
						<input class='FunteinputNumerico' type=text name="Tipo_cambio" size=8 maxlength=8 value="">
					</td>
				</tr>    
			</table>
<script language="javascript">
	var newwin;
	function launchwin(winurl,winname,winfeatures,parentname)
	{		if (!document.images)		{
			newwin = null;
		}
		if (newwin == null || newwin.closed)
		{
			newwin = window.open(winurl,winname,winfeatures);			if (newwin.opener == null)
			{
				newwin.opener = window;
			}
			newwin.opener.name = parentname;
		}
		else
		{			if(newwin.opener.name != winname)			{				newwin = window.open(winurl,winname,winfeatures);				if (newwin.opener == null)
				{
					newwin.opener = window;
				}
				newwin.opener.name = parentname;
			}			else			{
				newwin.focus(); 			}
		}
	}

	function imprimir()
	{
		var anno		 = document.Formulario.Anno.value;
		var mes			 = document.Formulario.mes.value;
		var cuenta		 = document.Formulario.Cuenta.value;
		var centro_de_venta = document.Formulario.Centro_de_venta.value;
		var moneda		 = document.Formulario.Moneda.value;
		var tipo_cambio = document.Formulario.Tipo_cambio.value;
		var winURL		 = "Listado_DifeCambio.asp?Anno="+anno+"&mes="+mes+"&Cuenta="+cuenta+"&centro_de_venta="+centro_de_venta+"&Moneda="+moneda+"&tipo_cambio="+tipo_cambio;
		var winName		 = "Wnd_diferencia";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=yes," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=780," ;
			winFeatures += "height=580" ;
			winFeatures += "top=1," ;
			winFeatures += "left=1" ;
			launchwin(winURL , winName , winFeatures , 'mainwindow')
	}

</script>
		</form>
	</body>
</html>

<%else
	Response.Redirect "../../index.htm"
end if%>
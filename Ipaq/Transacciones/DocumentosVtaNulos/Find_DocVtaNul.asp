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

	cVendedores = "<option value=''></option>"
	cSql = "Exec ECP_ListaVendedores '" & Session("Empresa_Usuario") & "'"
	Set Rs = Conn.Execute(cSql)
	Do While Not Rs.EOF
		cVendedores = cVendedores & "<option value='" & Ucase(Rs("Entidad_comercial")) & "'>" & Rs("Nombre") & "</option>"
		Rs.MoveNext
	Loop
	Rs.close
	set Rs = nothing
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td COLSPAN=4 width=100% class="FuenteTitulosFunciones" align=left nowrap>INGRESO&nbsp;FOLIO&nbsp;DOCUMENTOS&nbsp;NULOS</td> 
				</tr>
				<tr class="FuenteEncabezados">
					<td valign=top colspan=4 align=right >
						<input type=button class=FuenteInput name="btnAnular" value="Procesar" OnClick="javascript:fProcesar()">
						<input type=button class=FuenteInput name="btnSalir"  value="Salir"  OnClick="javascript:fSalir()">
					</td>
				</tr>						 

				<tr class="FuenteEncabezados"><td>&nbsp;</td></tr>

				<tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=12% align=left ><b>Documento</b></td>
					<td width=25% align=left >
			               <select class="fuenteinput" astyle="width:150" name="Documento" OnChange="Javascript:fSel()">
	                           <option <% if Request("Documento") = "BOV" Then Response.Write " selected " %> value='BOV'>Boleta de venta</option>
	                           <option <% if Request("Documento") = "FAV" Then Response.Write " selected " %> value='FAV'>Factura venta</option>
	                           <option <% if Request("Documento") = "FAE" Then Response.Write " selected " %> value='FAE'>Factura US$</option>
	                           <option <% if Request("Documento") = "NCV" Then Response.Write " selected " %> value='NCV'>Nota crédito de venta</option>
				           </select>
					</td>
				</tr>
				
				<tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=07% align=left ><b>Tipo</b></td>
					<td width=10% align=left >
                        <select class="fuenteinput" astyle="width:100" name="Tipo" >
                        <%  if Request("Documento") = "BOV" then %>
                                <option <% if Request("Tipo") = "BO" Then Response.Write " selected " %> value='BO'>BO</option>
                        <%  elseif Request("Documento") = "FAV" then%>
                                <option <% if Request("Tipo") = "FA"  Then Response.Write " selected " %> value='FA'>FA</option>
                                <option <% if Request("Tipo") = "SRF" Then Response.Write " selected " %> value='SRF'>SRF</option>
						<%  elseif Request("Documento") = "FAE" then%>
                                <option <% if Request("Tipo") = "TU"  Then Response.Write " selected " %> value='TU'>TU</option>
                                <option <% if Request("Tipo") = "R"  Then Response.Write " selected " %> value='R'>R</option>
                        <%  elseif Request("Documento") = "NCV" then%>
                                <option <% if Request("Tipo") = "NC" Then Response.Write " selected " %> value='NC'>NC</option>
                        <%  else%>
                                <option selected value='BO'>BO</option>
                        <%  end if%>
                        </select>
					</td>
				</tr>
				
				<tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=10% align=left ><b>Folio nulo</b></td>
					<td class="FuenteEncabezados" width=10% align=left>
						<input type=text maxlength=9 size=9 Class="FunteInputNumerico" name="Folio_nulo" value="<%=Request("Folio_nulo")%>">
					</td>
				</tr>
				
				<tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=09% align=left ><b>Fecha</b></td>
					<td class="FuenteEncabezados" width=20% align=left>
						<input Class="FuenteInput" type="text" name="Fecha" size=7 maxlength=10 value="<%=Request("Fecha")%>" >
					</td>
				</tr>

				<tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=09% align=left ><b>Responsable</b></td>
					<td class="FuenteEncabezados" width=20% align=left>
						<select class="FuenteInput" name="Vendedor">
							<%	Response.Write Replace(cVendedores, "<option value='" & Ucase(Request("Vendedor")) & "'>", "<option selected value='" & Ucase(Request("Vendedor")) & "'>") %>
						</select>
					</td>
				</tr>
			</table>
		</form>
		<iframe Id="Paso" name="Paso" src="../../empty.asp" width=100% height=0></iframe>
	</body>

	<script language="javascript">
	    function fSel()
	    {
	       document.Formulario.action = "Find_DocVtaNul.asp"
	       document.Formulario.method = "post"
	       document.Formulario.target = "_top"
	       document.Formulario.submit()
        }
	
		function fProcesar()
		{
			var Folio        = document.Formulario.Folio_nulo;
			var Fecha        = document.Formulario.Fecha;
			var Vendedor	 = document.Formulario.Vendedor;

			if ( ! validEmpty(Folio.value) )
			{
				if ( ! validNum(Folio.value) )
				{
					alert ( 'El folio ingresado debe ser numérico, revise por favor.' )
					Folio.focus();
					return;
				}
			}
			else
			{
                alert ( 'Debe ingresar el folio del documento a ser anulado.' )
                Folio.focus();
                return;
            }

			if ( ! validEmpty(Fecha.value) )
			{
				if ( ! validaFecha(Fecha.value) )
				{
					alert ( 'La fecha ingresada no es válida.' )
					Fecha.focus();
					return;
				}
			}
			else
			{
                alert ( 'Debe ingresar la fecha de anulación.' )
                Fecha.focus();
                return;
            }
			
			if ( validEmpty(Vendedor.value) )
			{
				alert ( 'Debe seleccionar el responsable.' )
                Vendedor.focus();
                return;
			}
			
			document.Formulario.action = "Save_DocVtaNul.asp";
			document.Formulario.method = "post";
			document.Formulario.target = "Paso";
			document.Formulario.submit();
		}

		function fSalir()
		{
			document.Formulario.action = "../../Menu_Ipaq.asp";
			document.Formulario.target = "_top";
			document.Formulario.submit();
		}
	</script>

</html>
<% conn.close() %>
<%else
	Response.Redirect "../../index.htm"
end if%>


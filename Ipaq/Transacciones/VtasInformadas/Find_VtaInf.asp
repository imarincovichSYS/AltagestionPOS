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
	
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Criterios.asp" target="Busqueda">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td COLSPAN=4 width=100% class="FuenteTitulosFunciones" align=left nowrap>ELIMINA DOCUMENTOS DE VENTAS</td> 
				</tr>
				<tr class="FuenteEncabezados">
					<td colspan=4 align=right >
						<input type=button class=FuenteInput name="btnBuscar" value="Buscar" OnClick="javascript:fBuscar()">
						<input type=button class=FuenteInput name="btnAnular" value="Eliminar" OnClick="javascript:fAnular()">
						<input type=button class=FuenteInput name="btnSalir"  value="Salir"  OnClick="javascript:fSalir()">
					</td>
				</tr>						 

				<tr class="FuenteEncabezados">
					<td nowrap class="FuenteEncabezados" width=25% align=left >Documento</td>
					<td width=25% align=left>
						<Select class="FuenteInput" name="DocumentoVenta" OnChange="Javascript:fSel()">
							<option <% if Request("DocumentoVenta") = "BOV" Then Response.Write " selected " %> value='BOV'>Boleta de venta</option>
							<option <% if Request("DocumentoVenta") = "FAV" Then Response.Write " selected " %> value='FAV'>Factura venta</option>
							<option <% if Request("DocumentoVenta") = "FAE" Then Response.Write " selected " %> value='FAE'>Factura US$</option>
							<option <% if Request("DocumentoVenta") = "NCV" Then Response.Write " selected " %> value='NCV'>Nota crédito de venta</option>
						</Select>
					</td>

					<td class="FuenteEncabezados" width=07% align=left ><b>Tipo</b></td>
					<td width=10% align=left >
                        <select class="fuenteinput" astyle="width:100" name="Tipo" >
                        <%  if Request("DocumentoVenta") = "BOV" then %>
                                <option <% if Request("Tipo") = "BO" Then Response.Write " selected " %> value='BO'>BO</option>
                        <%  elseif Request("DocumentoVenta") = "FAV" then%>
                                <option <% if Request("Tipo") = "FA"  Then Response.Write " selected " %> value='FA'>FA</option>
                                <option <% if Request("Tipo") = "SRF" Then Response.Write " selected " %> value='SRF'>SRF</option>
						<%  elseif Request("DocumentoVenta") = "FAE" then%>
                                <option <% if Request("Tipo") = "TU"  Then Response.Write " selected " %> value='TU'>TU</option>
                                <option <% if Request("Tipo") = "R"  Then Response.Write " selected " %> value='R'>R</option>
                        <%  elseif Request("DocumentoVenta") = "NCV" then%>
                                <option <% if Request("Tipo") = "NC" Then Response.Write " selected " %> value='NC'>NC</option>
                        <%  else%>
                                <option selected value='BO'>BO</option>
                        <%  end if%>
                        </select>
					</td>
				</tr>
				
				<tr>
					<td nowrap class="FuenteEncabezados" width=25% align=left >Nº&nbsp;documento</td>
					<td width=25% align=left>
						<input class="FuenteInput" type=text name="NroOrdenVta" size=7 maxlength=9 value="<%=Request("NroOrdenVta")%>">
					</td>
				</tr>
			</table>
		</form>
	</body>

	<script language="javascript">
	    function fSel()
	    {
	       document.Formulario.action = "Find_VtaInf.asp"
	       document.Formulario.method = "post"
	       document.Formulario.target = "_self"
	       document.Formulario.submit()
        }
	
		function fBuscar()
		{
			var Documento    = document.Formulario.DocumentoVenta.value
			var NroDocumento = document.Formulario.NroOrdenVta.value
			var Error = "N"
			if ( ! validEmpty(NroDocumento) )
			{
				if ( ! validNum(NroDocumento) )
				{
					alert ( 'El nº del documento debe ser numérico, revise por favor.' )
					Error = "S"
				}
			}
			
			if ( Error == "N" )
			{
				document.Formulario.action = "List_VtaInf.asp";
				document.Formulario.target = "Listado";
				document.Formulario.submit();
			}
		}

		function fAnular()
		{
			var Error = "N"
			var Pagina = parent.top.frames[1].location.href
			var Afectados = 0;
			
			if ( Pagina.indexOf('List_VtaInf.asp') != -1 )
			{
				var nLineas = parent.top.frames[1].document.Formulario.Lineas.value;
				var Caja = "";
				for ( a=0; a<nLineas; a++ )
				{
					Caja = eval("parent.top.frames[1].document.Formulario.Sel_" + a)
					if ( Caja.checked )
					{	
						Afectados = 1					
						break;
					}
				}				
			}
			else
			{
				Error = "S"
				alert ( 'Primero debe buscar y luego seleccionar los documentos a ser eliminados.' )
			}
			
			
			if ( Error == "N" )
			{
				if ( Afectados == 0 )
				{
					alert ( 'No hay documentos seleccionados.' )
				}
				else
				{
					var Rsp = confirm( '¿ Esta seguro de eliminar los documentos seleccionados ?' )
					if ( Rsp )
					{
						parent.top.frames[1].document.Formulario.action = "Anular_VtaInf.asp";
						parent.top.frames[1].document.Formulario.target = "_top";
						parent.top.frames[1].document.Formulario.submit();
					}
				}
			}
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

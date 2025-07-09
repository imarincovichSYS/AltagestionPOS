<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	
%>
<html>
	<head>
		<title>Ayuda Codigo Gastos Insumos</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 

    function fBuscar()
    {
/*		var Codigo = document.FormularioAyuda.GastoInsumo.value;
		var Nombre = LTrim(RTrim(document.FormularioAyuda.Glosa.value));
		
		if ( validEmpty(Codigo) && validEmpty(Nombre) )
		{
			alert('Debe ingresar al menos un criterio de busqueda');
		}
		else
		{
			document.FormularioAyuda.submit()
		}
*/
			document.FormularioAyuda.submit()
    }
    
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaGastoInsumo.asp" target="wnd_abajo">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda Codigo Gastos Insumos</td>
		</tr>
		<tr>
			<td class="FuenteEncabezados" width=20% align=left ><b>Codigo</b></td>
			<td align=left>
				<input Class="FuenteInput" type=Text name="GastoInsumo" size=12 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
		</tr>
		<tr>	
			<td class="FuenteEncabezados" width=20% align=left ><b>Glosa</b></td>
			<td align=left>
				<input colspan=2 Class="FuenteInput" type=Text name="Glosa" size=50 maxlength=50 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
			<td class="FuenteInput" align=Right>
				<input class="FuenteEncabezados" size= 10 type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>
	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
</script>
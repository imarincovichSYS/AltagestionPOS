<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	
%>
<html>
	<head>
		<title>Ayuda Recepciones</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 

    function fBuscar()
    {
		document.FormularioAyuda.submit();
    }
    
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaRecepciones.asp" target="wnd_abajo">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda Recepciones</td>
		</tr>

		<tr>
			<td class="FuenteEncabezados" width=20% align=left ><b>Proveedor</b></td>
			<td align=left>
				<input Class="FuenteInput" type=Text name="Proveedor" size=12 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
			<td colspan=2 class="FuenteInput" align=Right>
				<input class="FuenteEncabezados" size= 10 type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>

		<tr>
			<td class="FuenteEncabezados" width=20% align=left ><b>Nº Recepción</b></td>
			<td align=left>
				<input Class="FuenteInput" type=Text name="NroRecepcion" size=12 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
			<td class="FuenteEncabezados" width=20% align=left ><b>Nº orden de compra</b></td>
			<td align=left>
				<input colspan=2 Class="FuenteInput" type=Text name="OrdenCompra" size=12 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
		</tr>
	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
</script>
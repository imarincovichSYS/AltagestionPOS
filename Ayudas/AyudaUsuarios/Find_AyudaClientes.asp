<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	Vendible = Request("Vendible")
%>
<html>
	<head>
		<title>Ayuda de entidades comerciales</title>
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

<Form name="FormularioAyuda" method="post" action="List_AyudaClientes.asp?tipo=<%=request("tipo")%>" target="wnd_abajo">
	<input type=hidden name="Vendible" value="<%=Vendible%>">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda de usuarios</td>
		</tr>
		<tr>
			<td class="FuenteEncabezados" width=10% align=left ><b>Código</b></td>
			<td align=left>
				<input Class="FuenteInput" type=Text name="Codigo" size=13 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
		</tr>
		<tr>
			<td nowrap class="FuenteEncabezados" width=10% align=left >Apellido persona o nombre empresa</td>
			<td  align=left >
				<input Class="FuenteInput" type=Text name="Nombre" size="50" maxlength=50 value="" aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
		
			<td class="FuenteInput" align=center>
				<input class="FuenteEncabezados" size= 10 type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>
	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
</script>
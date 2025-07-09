<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
%>
<html>
	<head>
		<title>Ayuda de Cuentas contables</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 
    function fBuscar()
    {
		var Codigo  = document.FormularioAyuda.Codigo.value 
		var Descrip = document.FormularioAyuda.Descripcion.value
		if ( parseInt(Codigo.length)+parseInt(Descrip.length) == 0 )
		{
			alert ( "Debe ingresar al menos el código y/o la descripción para realizar la búsqueda." )
		}
		else
		{
			document.FormularioAyuda.submit();
		}
    }
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaCtasCtbles.asp" target="wnd_abajo">
	<input type=hidden name="Vendible" value="<%=Vendible%>">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda de Cuentas contables</td>
		</tr>

		<tr>
			<td width=10% class="FuenteEncabezados" align=left nowrap>Código</td>
			<td width=34% colspan=3 align=left>
				<input type=text class="FuenteInput" name="Codigo" size=20 maxlength=12 value=""> 
			</td>
		</tr>

		<tr>
			<td width=10% class="FuenteEncabezados" align=left nowrap>Descripción</td>
			<td width=33% colspan=3 align=left>
				<input class="FuenteInput" type=text name="Descripcion" value="<%=Descripcion%>" size=80 maxlength=50>
			</td>
			
			<td class="FuenteTitulosFunciones" align=center>
				<input class="FuenteEncabezados" type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>
	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();

     function NuevoProveedor()
     {
		var hora = new Date() ;
		vHours  = hora.getHours() ;
		vMinute = hora.getMinutes() ;
		vSecond = hora.getSeconds() ;
		hora    = "H" + vHours + "" + vMinute + "" + vSecond ;
		
		var winURL  = "../../Mantenciones/EntidadesComerciales/Win_NuevoProveedor.asp?hora="+hora;
		var winName = "NuevoProveedor" ;

		var winFeatures  = "status=no," ; 
		    winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "target=top," ;
			winFeatures += "width=790," ;
			winFeatures += "height=300," ;
			winFeatures += "top=220," ;
			winFeatures += "left=0" ;

		var wclcl = window.open( winURL, winName, winFeatures ) ;
			wclcl.opener = self;		
     }
</script>
